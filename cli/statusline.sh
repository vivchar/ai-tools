#!/bin/bash
input=$(cat)

CWD=$(echo "$input" | jq -r '.cwd // ""')
GIT_BRANCH=$(git --git-dir="${CWD}/.git" --work-tree="${CWD}" branch --show-current 2>/dev/null)
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

RESET='\033[0m'
# Context color: <30% normal, 30-59% yellow, 60%+ red
if [ "$CTX" -ge 60 ]; then
  CTX_COLOR='\033[1;31m'
elif [ "$CTX" -ge 30 ]; then
  CTX_COLOR='\033[1;33m'
else
  CTX_COLOR='\033[0m'
fi

# Progress bar (10 chars)
FILLED=$((CTX * 10 / 100))
EMPTY=$((10 - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v F "%${FILLED}s" && BAR="${F// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v E "%${EMPTY}s" && BAR="${BAR}${E// /░}"

OLIVE='\033[38;2;125;160;60m'
PREFIX=""
BLUE='\033[34m'
DIR_DISPLAY=$(echo "$CWD" | sed "s|^$HOME|~|")
REPO_NAME=$(basename "$CWD")
[ -n "$GIT_BRANCH" ] && PREFIX="${OLIVE}${REPO_NAME}:${GIT_BRANCH}${RESET} | "

PINK='\033[1;35m'
printf "%b" "${PREFIX}${PINK}${MODEL}${RESET} | ${CTX_COLOR}${BAR} ${CTX}%${RESET}\n${BLUE}${DIR_DISPLAY}${RESET}"

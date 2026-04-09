#!/bin/bash
input=$(cat)

CWD=$(echo "$input" | jq -r '.cwd // ""')
GIT_BRANCH=$(git --git-dir="${CWD}/.git" --work-tree="${CWD}" branch --show-current 2>/dev/null)
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

RESET='\033[0m'
# Gradient color for a given percentage (0..100). Sets global CLR.
# green(90,190,80) → yellow(220,190,40) → red(220,50,50), saturated ≥60
grad_color() {
  local p=$1 r g b
  if [ "$p" -ge 60 ]; then
    r=220; g=50; b=50
  elif [ "$p" -le 10 ]; then
    r=90; g=190; b=80
  elif [ "$p" -le 35 ]; then
    local n=$((p - 10))
    r=$((90 + 130 * n / 25)); g=190; b=$((80 - 40 * n / 25))
  else
    local n=$((p - 35))
    r=220; g=$((190 - 140 * n / 25)); b=$((40 + 10 * n / 25))
  fi
  CLR="\033[1;38;2;${r};${g};${b}m"
}

grad_color "$CTX"
CTX_COLOR="$CLR"

# Progress bar (10 cells). Each cell i represents threshold (i+1)*10%.
# Filled cells use the gradient color of their own threshold so the bar
# itself visualises the green→yellow→red transition.
FILLED=$((CTX * 10 / 100))
DIM='\033[38;2;110;110;110m'
BAR=""
for i in 0 1 2 3 4 5 6 7 8 9; do
  if [ "$i" -lt "$FILLED" ]; then
    grad_color $(((i + 1) * 10))
    BAR="${BAR}${CLR}▓"
  else
    BAR="${BAR}${DIM}░"
  fi
done
BAR="${BAR}${RESET}"

ACCENT='\033[38;2;125;160;60m'
PREFIX=""
BLUE='\033[34m'
DIR_DISPLAY=$(echo "$CWD" | sed "s|^$HOME|~|")
REPO_NAME=$(basename "$CWD")
[ -n "$GIT_BRANCH" ] && PREFIX="${ACCENT} ${REPO_NAME}:${GIT_BRANCH}${RESET} | "

PINK='\033[1;35m'
printf "%b" "${PREFIX}${PINK}󰧑 ${MODEL}${RESET} | ${CTX_COLOR}󰓅${RESET} ${BAR} ${CTX_COLOR}${CTX}%${RESET}\n${BLUE}${DIR_DISPLAY}${RESET}"

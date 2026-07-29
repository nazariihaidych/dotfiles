#!/usr/bin/env bash

input=$(cat)

RESET=$'\033[0m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'
PURPLE=$'\033[35m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
GRAY=$'\033[90m'

# Icons as UTF-8 byte sequences (avoids file encoding issues)
ICO_MODEL=$(printf '\xef\x84\xb5')    # U+F135 nf-fa-rocket
ICO_CTX=$(printf '\xef\x82\x80')      # U+F080 nf-fa-bar-chart
ICO_BRANCH=$(printf '\xee\x82\xa0')   # U+E0A0 nf-pl-branch
ICO_5H=$(printf '\xef\x80\x97')       # U+F017 nf-fa-clock-o
ICO_7D=$(printf '\xef\x81\xb3')       # U+F073 nf-fa-calendar
ICO_SESSION=$(printf '\xef\x89\x94')  # U+F254 nf-fa-hourglass-half
ICO_FOLDER=$(printf '\xef\x81\xbb')   # U+F07B nf-fa-folder

SEP="${GRAY} │ ${RESET}"

parts=()

pct_color() {
  local pct=$1
  if   [ "$pct" -ge 80 ]; then printf '%s' "$RED"
  elif [ "$pct" -ge 50 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$GREEN"; fi
}

# 1. Model
model=$(echo "$input" | jq -r '.model.display_name // empty')
[ -n "$model" ] && parts+=("${CYAN}${ICO_MODEL} ${model}${RESET}")

# 2. Context used
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  parts+=("${YELLOW}${ICO_CTX} ctx: ${used_int}%${RESET}")
fi

# 3. Git branch
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
if [ -n "$current_dir" ]; then
  git_branch=$(git --git-dir="${current_dir}/.git" --work-tree="${current_dir}" \
    symbolic-ref --short HEAD 2>/dev/null)
  [ -n "$git_branch" ] && parts+=("${BLUE}${ICO_BRANCH} ${git_branch}${RESET}")
fi

# 4. 5h rate limit
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_pct" ]; then
  five_int=$(printf "%.0f" "$five_pct")
  color=$(pct_color "$five_int")
  parts+=("${color}${ICO_5H} 5h: ${five_int}%${RESET}")
fi

# 5. 7d quota
seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$seven_pct" ]; then
  seven_int=$(printf "%.0f" "$seven_pct")
  color=$(pct_color "$seven_int")
  parts+=("${color}${ICO_7D} 7d: ${seven_int}%${RESET}")
fi

# 6. Session length
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  created=$(stat -f "%B" "$transcript" 2>/dev/null)
  [ -z "$created" ] || [ "$created" = "0" ] && created=$(stat -f "%m" "$transcript" 2>/dev/null)
  if [ -n "$created" ]; then
    now=$(date +%s)
    elapsed=$(( now - created ))
    hours=$(( elapsed / 3600 ))
    mins=$(( (elapsed % 3600) / 60 ))
    if   [ "$hours" -gt 0 ]; then parts+=("${GRAY}${ICO_SESSION} ${hours}h ${mins}m${RESET}")
    elif [ "$mins"  -gt 0 ]; then parts+=("${GRAY}${ICO_SESSION} ${mins}m${RESET}")
    else                          parts+=("${GRAY}${ICO_SESSION} <1m${RESET}")
    fi
  fi
fi

# 7. Project/folder
repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty')
if [ -n "$repo_name" ]; then
  parts+=("${PURPLE}${ICO_FOLDER} ${repo_name}${RESET}")
else
  project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
  if [ -n "$project_dir" ]; then
    parts+=("${PURPLE}${ICO_FOLDER} $(basename "$project_dir")${RESET}")
  fi
fi

# Join with separator
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then result="$part"
  else result="${result}${SEP}${part}"; fi
done

printf "%s" "$result"

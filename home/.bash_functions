# AWS related
aws-connect() {
  if [ -z $1 ]
  then
      echo "One argument containing profile name is required"
      return 1
  fi
  export AWS_PROFILE="$1"
  export AWS_ROLE=$(aws configure get role)
  #gum spin --title="Connecting..." aws set-credentials-for-mfa
}

aws-reset() {
  aws configure set role ""
  aws configure set aws_session_token ""
  unset AWS_PROFILE AWS_ROLE
}

aws-assume-role() {
    echo "TODO: adicionar verificacao na role arn via regex"
    if [ -z $1 ]
    then
      echo "One argument containing role arn is required"
      return 1
    fi  
    if [ -z $AWS_PROFILE ]
    then
      echo "AWS_PROFILE is not configured"
      return 1
    fi  
    TOKEN=$(aws sts assume-role --role-arn $1 --role-session-name carlos-abade) && \
      aws configure set aws_access_key_id $(echo $TOKEN | jq -r .Credentials.AccessKeyId) --profile ${AWS_PROFILE} && \
      aws configure set aws_secret_access_key $(echo $TOKEN | jq -r .Credentials.SecretAccessKey) --profile ${AWS_PROFILE} && \
      aws configure set aws_session_token $(echo $TOKEN | jq -r .Credentials.SessionToken) --profile ${AWS_PROFILE} && \
      aws configure set role $(echo $1 | sed -e "s|.*role/\(.*\)|\1|") && \
      export AWS_ROLE="$1"
}

# GIT related
git_pull() {
  USER="carlos.abade.ext"
  PASS=$(pass pluxee/sodexo)
  URL=$(git remote -v | grep -m 1 -o -e 'https.*\.git' | sed -e 's|https://|https://'"$USER"':'"$PASS"@'|')
  CURRENT_BRANCH=$(git branch --show-current)
  git pull --ff-only "$URL" $CURRENT_BRANCH
}

git_push() {
  USER="carlos.abade.ext"
  PASS=$(pass pluxee/sodexo)
  URL=$(git remote -v | grep -m 1 -o -e 'https.*\.git' | sed -e 's|https://|https://'"$USER"':'"$PASS"@'|')
  CURRENT_BRANCH=$(git branch --show-current)
  git push "$URL" $CURRENT_BRANCH
}

gen_pass() {
  [[ $# -ge 1 ]] || { echo "Usage: gen_pass [-c] PASS-LENGTH" >&2; return; }
  [[ "$1" == "-c" ]] && { PASS_LENGTH="$2"; } || { PASS_LENGTH="$1"; }
  [[ $PASS_LENGTH =~ ^[0-9]+$ ]] || { echo "Error: PASS-LENGTH \"$PASS_LENGTH\" must be a number."; return; }
  [[ $PASS_LENGTH -gt 0 ]] || { echo "Error: PASS-LENGTH must be greater than zero."; return; }
  read -r -n $PASS_LENGTH GENERATED_PASSWORD < <(LC_ALL=C tr -dc "$PASSWORD_STORE_CHARACTER_SET" < /dev/urandom)
  [[ $1 == "-c" ]] && { echo -n $GENERATED_PASSWORD | xclip -selection clipboard; } || { echo -n $GENERATED_PASSWORD; }
}

load() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: load [file ...]"
    echo "  Each file passed as parameter should have env vars in the format KEY=VALUE"
    return
  fi

  set -o allexport
  source "$@"
  set +o allexport
}

unload() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: unload [file ...]"
    echo "  Each file passed as parameter should have env vars in the format KEY=VALUE"
    return
  fi

  for file in "$@"; do
    while IFS='=' read -r key _; do
      if [[ -n "$key" && "$key" != "#"* ]]; then
        unset "$key"
      fi
    done < "$file"
  done
}

# Others
watch() {
  ARGS="${@}"
  clear;
  while(true); do
    OUTPUT=`$ARGS`
    clear
    echo -e "Every 5.0s: $ARGS"
    echo ""
    echo -e "${OUTPUT[@]}"
    sleep 5
  done
}

bashrc() {
  nvim ~/.bashrc
}

rbashrc() {
  source ~/.bashrc
}

tasks() {
  cd "$(du ~/Documents/tasks/ | cut -f2 | fzf)"
}

gk() {
  git checkout "$(git branch | fzf | sed 's/\*\?[[:space:]]\+//')"
}

repos() {
  cd "$(du -d 2 ~/repos/ | cut -f2 | fzf)"
}

new-task() {
  if [[ "$1" == "" ]]; then
    echo "Missing task name"
    return
  fi

  NEW_TASK="$HOME/Documents/tasks/$1"
  mkdir -p "$NEW_TASK"
  cd "$NEW_TASK"
}

_snippets() {
  grep -A1 "$(grep '#' Documents/tasks/snippets | fzf)" Documents/tasks/snippets | tail -n1 | clip
}

say() {
    target_lang="$1"
    text="$2"
    encoded_text=$(printf "%s" "$text" | jq -sRr @uri)

    echo "$text"

    curl -sS -A "Mozilla/5.0" \
      "https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded_text&tl=$target_lang&client=tw-ob" \
      | mpv --really-quiet -
}

translate() {
    source_lang="$1"
    target_lang="$2"
    text="$3"
    encoded_text=$(printf "%s" "$text" | jq -sRr @uri)

    curl -sS -A "Mozilla/5.0" \
      "https://translate.googleapis.com/translate_a/single?client=gtx&sl=$source_lang&tl=$target_lang&dt=t&q=$encoded_text" \
      | jq -r '.[0][0][0]'
}

say-translate() {
    source_lang="$1"
    target_lang="$2"
    text="$3"
    translated_text=$(translate "$source_lang" "$target_lang" "$text")

    say "$target_lang" "$translated_text"
}

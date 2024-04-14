#!/usr/bin/env bash

function log_error() {
  local -r ERROR_TEXT="\033[0;31m"
  local -r NO_COLOR="\033[0m"
  echo -e "$(date --utc +%FT%T.%3NZ) ${ERROR_TEXT}$1${NO_COLOR}"
}

function log_warn() {
  local -r WARN_TEXT="\033[0;33m"
  local -r NO_COLOR="\033[0m"
  echo -e "$(date --utc +%FT%T.%3NZ) ${WARN_TEXT}$1${NO_COLOR}"
}

function log_info() {
  local -r BLUE_TEXT="\033[0;34m"
  local -r NO_COLOR="\033[0m"
  echo -e "$(date --utc +%FT%T.%3NZ) ${BLUE_TEXT}$1${NO_COLOR}"
}

function log_success() {
  local -r GREEN_TEXT="\033[0;32m"
  local -r NO_COLOR="\033[0m"
  echo -e "$(date --utc +%FT%T.%3NZ) ${GREEN_TEXT}$1${NO_COLOR}"
}

function catch_signal() {
    local -ir EXIT_CODE=$?
    if (( $EXIT_CODE != 0 ))
    then
        log_error "Error code: ${EXIT_CODE}" >&2
    else
        log_success "Completed"
        exit 0
    fi
    exit 1
}

function import_variables() {
    local -r SCRIPT_VARS="$(dirname $0)/${1:-env.rc}"
    [[ -r "${SCRIPT_VARS}" ]] || {
        log_error "Error: ${SCRIPT_VARS} does not exists or not readable"
        exit 1
    }
    source ${SCRIPT_VARS}

    log_success "Variables imported"
}

function read_secret_prompt() {
    local secret=""
    local prompt="$1"

    while IFS= read -p "$prompt" -r -s -n 1 char; do
        if [[ "$char" == $'\0' ]]; then
            break
        fi

        secret="${secret}${char}"
        prompt="*"
    done
    echo -n "${secret}"
}

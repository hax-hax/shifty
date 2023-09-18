set -euo pipefail

[ -t 1 ] && USE_COLOR=1
use-color?() {
    [ -n "${USE_COLOR:-}" ]
}

tput() {
    use-color? && command tput "$@"
}

# Helper function to get a value from command line arguments
get_from_args() {
    local arg_name="$1"
    local arg_value=""

    for arg in "${@:3}"; do
        if [[ "$arg" == "--$arg_name="* ]]; then
            arg_value="${arg#*=}"
            echo "$arg_value"
            return
        fi
    done

    echo ""  # Return an empty string if the argument is not found
}

# Helper function to get a value from command line arguments or use a default value
get_from_args_or_default() {
    local arg_name="$1"
    local default_value="$2"

    local arg_value=$(get_from_args "$@")

    if [ -n "$arg_value" ]; then
        echo "$arg_value"
    else
        echo "$default_value"
    fi
}

# Helper function to get a value from command line arguments or prompt the user with a default value
get_from_args_or_prompt_with_default() {
    local arg_name="$1"
    local default_value="$2"

    local arg_value=$(get_from_args "$@")

    if [ -n "$arg_value" ]; then
        echo "$arg_value"
    else
        read -p "What is your value for '--$arg_name' [$default_value]? " arg_value
        [ -z "$arg_value" ] && arg_value="$default_value"
        echo "$arg_value"
    fi
}

LOG_NUMBER=0
declare -A LOG_FILES
declare -A COMMANDS
try-command-async() {
    local log="/tmp/try-command.$$.$((LOG_NUMBER++)).log"
    truncate -s 0 "$log"

    ( "$@" ) &> "$log" &
    local child=$!

    LOG_FILES[$child]="$log"
    COMMANDS[$child]="$*"
}

try-command() {
    try-command-async "$@"
    await-commands
}

await-commands() {
    local failed=
    local pid

    while [ "${#COMMANDS[@]}" -gt 0 ]; do
        if ! wait -n -p pid; then
            error "command failed:" "${COMMANDS[$pid]}"
            cat "${LOG_FILES[$pid]}"
            failed=1
        fi

        rm -f "${LOG_FILES[$pid]}"
        unset COMMANDS[$pid]
        unset LOG_FILES[$pid]
    done

    if [ -n "$failed" ]; then
        error "some commands failed, exiting"
        exit 1
    fi
}

log() {
    echo "$(tput setaf 4 bold)---$(tput sgr0)$(tput setaf 7 bold)" "$@" "$(tput sgr0)"
}

error() {
    echo "$(tput setaf 1 bold)+++$(tput sgr0)$(tput setaf 7 bold)" "$@" "$(tput sgr0)"
}

success() {
    echo "$(tput setaf 2 bold)+++$(tput sgr0)$(tput setaf 7 bold)" "$@" "$(tput sgr0)"
}

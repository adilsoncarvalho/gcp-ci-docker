#!/bin/sh

### COLORS

# Reset
COLOR_OFF='\033[0m'       # Text Reset

# Regular Colors
COLOR_BLACK='\033[0;30m'        # Black
COLOR_RED='\033[0;31m'          # Red
COLOR_GREEN='\033[0;32m'        # Green
COLOR_YELLOW='\033[0;33m'       # Yellow
COLOR_BLUE='\033[0;34m'         # Blue
COLOR_PURPLE='\033[0;35m'       # Purple
COLOR_CYAN='\033[0;36m'         # Cyan
COLOR_WHITE='\033[0;37m'        # White

# Bold
COLOR_BBLACK='\033[1;30m'       # Black
COLOR_BRED='\033[1;31m'         # Red
COLOR_BGREEN='\033[1;32m'       # Green
COLOR_BYELLOW='\033[1;33m'      # Yellow
COLOR_BBLUE='\033[1;34m'        # Blue
COLOR_BPURPLE='\033[1;35m'      # Purple
COLOR_BCYAN='\033[1;36m'        # Cyan
COLOR_BWHITE='\033[1;37m'       # White

# Underline
COLOR_UBLACK='\033[4;30m'       # Black
COLOR_URED='\033[4;31m'         # Red
COLOR_UGREEN='\033[4;32m'       # Green
COLOR_UYELLOW='\033[4;33m'      # Yellow
COLOR_UBLUE='\033[4;34m'        # Blue
COLOR_UPURPLE='\033[4;35m'      # Purple
COLOR_UCYAN='\033[4;36m'        # Cyan
COLOR_UWHITE='\033[4;37m'       # White

# Background
COLOR_ON_BLACK='\033[40m'       # Black
COLOR_ON_RED='\033[41m'         # Red
COLOR_ON_GREEN='\033[42m'       # Green
COLOR_ON_YELLOW='\033[43m'      # Yellow
COLOR_ON_BLUE='\033[44m'        # Blue
COLOR_ON_PURPLE='\033[45m'      # Purple
COLOR_ON_CYAN='\033[46m'        # Cyan
COLOR_ON_WHITE='\033[47m'       # White

# High Intensity
COLOR_IBLACK='\033[0;90m'       # Black
COLOR_IRED='\033[0;91m'         # Red
COLOR_IGREEN='\033[0;92m'       # Green
COLOR_IYELLOW='\033[0;93m'      # Yellow
COLOR_IBLUE='\033[0;94m'        # Blue
COLOR_IPURPLE='\033[0;95m'      # Purple
COLOR_ICYAN='\033[0;96m'        # Cyan
COLOR_IWHITE='\033[0;97m'       # White

# Bold High Intensity
COLOR_BIBLACK='\033[1;90m'      # Black
COLOR_BIRED='\033[1;91m'        # Red
COLOR_BIGREEN='\033[1;92m'      # Green
COLOR_BIYELLOW='\033[1;93m'     # Yellow
COLOR_BIBLUE='\033[1;94m'       # Blue
COLOR_BIPURPLE='\033[1;95m'     # Purple
COLOR_BICYAN='\033[1;96m'       # Cyan
COLOR_BIWHITE='\033[1;97m'      # White

# High Intensity backgrounds
COLOR_ON_IBLACK='\033[0;100m'   # Black
COLOR_ON_IRED='\033[0;101m'     # Red
COLOR_ON_IGREEN='\033[0;102m'   # Green
COLOR_ON_IYELLOW='\033[0;103m'  # Yellow
COLOR_ON_IBLUE='\033[0;104m'    # Blue
COLOR_ON_IPURPLE='\033[0;105m'  # Purple
COLOR_ON_ICYAN='\033[0;106m'    # Cyan
COLOR_ON_IWHITE='\033[0;107m'   # White

function common_print {
  echo -e "[$(date '+%Y-%m-%d %T %Z')] $1"
}

function info {
  common_print "${COLOR_GREEN}$1${COLOR_OFF}"
}

function log {
  common_print "${COLOR_YELLOW}$1${COLOR_OFF}"
}

function error {
  common_print "${COLOR_RED}$1${COLOR_OFF}"
}

function debug {
  common_print "${COLOR_PURPLE}$1${COLOR_OFF}"
}

function log_and_run {
  log "==> $1"

  eval $1

  if [ $? -ne 0 ]; then
    error "ERROR when running ${COLOR_IRED}$1${COLOR_OFF}"
    exit 1
  fi
}

### ENVIRONMENT

function check_environment {
  info ' -> Checking environment for required variables'
  for VAR in $1;
  do
    VAL=$(eval echo \$$VAR)
    if [ -z $VAL ]; then
      error "    x $VAR=...missing..."
      MISSING_ENVS="$MISSING_ENVS $VAR"
    else
      info "    √ $VAR=$VAL"
    fi
  done

  if [ -z $MISSING_ENVS ]; then
    error ' -> All set on the environment'
  else
    error " -> Missing environment variables:$MISSING_ENVS"
    exit 1
  fi
}

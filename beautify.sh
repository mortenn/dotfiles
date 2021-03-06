#!/bin/bash
#
# File: .bash_beautify
# Author: Chris Albrecht, @ChrisAlbrecht
#
# Provides color and bash prompt customizations to integrate with SVN and GIT.
export DULL=0
export BRIGHT=1

export FG_BLACK=30
export FG_RED=31
export FG_GREEN=32
export FG_YELLOW=33
export FG_BLUE=34
export FG_VIOLET=35
export FG_CYAN=36
export FG_WHITE=37

export FG_NULL=00

export BG_BLACK=40
export BG_RED=41
export BG_GREEN=42
export BG_YELLOW=43
export BG_BLUE=44
export BG_VIOLET=45
export BG_CYAN=46
export BG_WHITE=47

export BG_NULL=00

##
# ANSI Escape Commands
##
export ESC="\001\e"
export NORMAL="$ESC[m\002"
export RESET="$ESC[${DULL};${FG_WHITE};${BG_NULL}m\002"

##
# Shortcuts for Colored Text ( Bright and FG Only )
##

# DULL TEXT
export BLACK="$ESC[${DULL};${FG_BLACK}m\002"
export RED="$ESC[${DULL};${FG_RED}m\002"
export GREEN="$ESC[${DULL};${FG_GREEN}m\002"
export YELLOW="$ESC[${DULL};${FG_YELLOW}m\002"
export BLUE="$ESC[${DULL};${FG_BLUE}m\002"
export VIOLET="$ESC[${DULL};${FG_VIOLET}m\002"
export CYAN="$ESC[${DULL};${FG_CYAN}m\002"
export WHITE="$ESC[${DULL};${FG_WHITE}m\002"

# BRIGHT TEXT
export BRIGHT_BLACK="$ESC[${BRIGHT};${FG_BLACK}m\002"
export BRIGHT_RED="$ESC[${BRIGHT};${FG_RED}m\002"
export BRIGHT_GREEN="$ESC[${BRIGHT};${FG_GREEN}m\002"
export BRIGHT_YELLOW="$ESC[${BRIGHT};${FG_YELLOW}m\002"
export BRIGHT_BLUE="$ESC[${BRIGHT};${FG_BLUE}m\002"
export BRIGHT_VIOLET="$ESC[${BRIGHT};${FG_VIOLET}m\002"
export BRIGHT_CYAN="$ESC[${BRIGHT};${FG_CYAN}m\002"
export BRIGHT_WHITE="$ESC[${BRIGHT};${FG_WHITE}m\002"

# REV TEXT as an example
export REV_CYAN="$ESC[${DULL};${BG_WHITE};${BG_CYAN}m\002"
export REV_RED="$ESC[${DULL};${FG_YELLOW}; ${BG_RED}m\002"

##
# Parse the GIT and SVN branches we may be on
##
function vcs_branch {
  local GIT=$(git_branch)
  local SVN=$(svn_branch)
  if [ -n "$GIT" ]; then
    local BRANCH="${GREEN}$GIT${WHITE}"
  fi
  if [ -n "$SVN" ]; then
    if [ -n "$GIT" ]; then
      BRANCH="$BRANCH|${YELLOW}$SVN${WHITE}"
    else
      BRANCH="${YELLOW}$SVN${WHITE}"
    fi
  fi
  if [ -n "$BRANCH" ]; then
    echo -e "($BRANCH${WHITE})"
  fi
}

##
# Get the current GIT branch
##
function git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  staged=$(git diff --cached --shortstat | awk '{print $1 " +" $4 " -" $6}')
  unstaged=$(git diff --shortstat | awk '{print $1 " +" $4 " -" $6}')
  echo -n ${ref#refs/heads/}
  if [ -n "$staged" ]; then
    echo -n "${GREEN} $staged"
  fi
  if [ -n "$unstaged" ]; then
    echo -n "${RED} $unstaged"
  fi
}

##
# Get the current SVN branch
##
function svn_branch {
  if [ ! -d .svn ]; then
    exit 1
  fi

  # Get the current URL of the SVN repo
  URL=`svn info --xml | fgrep "<url>"`

  # Strip the tags
  URL=${URL/<url>/}
  URL=${URL/<\/url>/}

  # Find the branches directory
  if [[ "$URL" == */trunk ]]; then
    DIR=${URL//\/trunk*/}
  fi
  if [[ "$URL" == */tags/* ]]; then
    DIR=${URL//\/tags*/}
  fi
  if [[ "$URL" == */branches/* ]]; then
    DIR=${URL//\/branches*\/*/}
  fi
  DIR="$DIR/branches"

  # Return the branch name
  if [[ "$URL" == */trunk* ]]; then
    echo 'trunk'
  elif [[ "$URL" == */branches/* ]]; then
    echo $URL | sed -e 's#^'"$DIR/"'##g' | sed -e 's#/.*$##g' | awk '{print ""$1"" }'
  fi
}

# Set the prompt pattern
export PS1="${BRIGHT_CYAN}[${CYAN}\u${BRIGHT_WHITE}@${CYAN}\h${WHITE}\$(vcs_branch)${WHITE}: \w${BRIGHT_CYAN}]${NORMAL}\\$ ${RESET}"

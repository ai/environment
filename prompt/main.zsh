#!/usr/bin/zsh

# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

prompt_ai_clear_screen() {
  # enable output to terminal
  zle -I
  # clear screen and move cursor to (0, 0)
  print -n '\e[2J\e[0;0H'
  # print preprompt
  prompt_ai_preprompt_render precmd
}

prompt_ai_check_git_stash() {
  # reset git arrows
  prompt_ai_git_stash=

  local stash_count

  # check git
  stash_count="$(command git stash list 2>/dev/null | wc -l)"
  # exit if the command failed
  (( !$? )) || return

  if [ "$stash_count" != "0" ]; then
    prompt_ai_git_stash=" (stash $stash_count)"
  fi
}

prompt_ai_check_git_arrows() {
  # reset git arrows
  prompt_ai_git_arrows=

  # check if there is an upstream configured for this branch
  command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

  local arrow_status
  # check git left and right arrow_status
  arrow_status="$(command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)"
  # exit if the command failed
  (( !$? )) || return

  # left and right are tab-separated, split on tab and store as array
  arrow_status=(${(ps:\t:)arrow_status})
  local arrows left=${arrow_status[1]} right=${arrow_status[2]}

  (( ${right:-0} > 0 )) && arrows+="↓"
  (( ${left:-0} > 0 )) && arrows+="↑"

  [[ -n $arrows ]] && prompt_ai_git_arrows=" ${arrows}"
}

prompt_ai_set_title() {
  # emacs terminal does not support settings the title
  (( ${+EMACS} )) && return

  # tell the terminal we are setting the title
  print -n '\e]0;'
  # show hostname if connected through ssh
  [[ -n $SSH_CONNECTION ]] && print -Pn '(%m) '
  case $1 in
    expand-prompt)
      print -Pn $2;;
    ignore-escape)
      print -rn $2;;
  esac
  # end set title
  print -n '\a'
}

prompt_ai_preexec() {
  # attempt to detect and prevent prompt_ai_async_git_fetch from interfering with user initiated git or hub fetch
  [[ $2 =~ (git|hub)\ .*(pull|fetch) ]] && async_flush_jobs 'prompt_ai'

  prompt_ai_cmd_timestamp=$EPOCHSECONDS

  # shows the current dir and executed command in the title while a process is active
  prompt_ai_set_title 'ignore-escape' "$PWD:t: $2"
}

# string length ignoring ansi escapes
prompt_ai_string_length_to_var() {
  local str=$1 var=$2 length
  # perform expansion on str and check length
  length=$(( ${#${(S%%)str//(\%([KF1]|)\{*\}|\%[Bbkf])}} ))

  # store string length in variable as specified by caller
  typeset -g "${var}"="${length}"
}

prompt_ai_preprompt_render() {
  # store the current prompt_subst setting so that it can be restored later
  local prompt_subst_status=$options[prompt_subst]

  # make sure prompt_subst is unset to prevent parameter expansion in preprompt
  setopt local_options no_prompt_subst

  # construct preprompt, beginning with path
  local prompt_dir="`echo "$PWD" | sed -r "s|^/home/$USER|~|g"`"
  prompt_dir="`echo "$prompt_dir" | sed -r "s|^~/Dev/||g"`"

  local preprompt=""

  # username and machine if applicable
  preprompt+=$prompt_ai_username
  # current dir
  preprompt+="%F{green}$prompt_dir"
  # git info
  if [ "$vcs_info_msg_0_" != ' master' ]; then
    preprompt+=$vcs_info_msg_0_
  fi
  # git stash
  preprompt+="%F{yellow}${prompt_ai_git_stash}%f"
  # git dirtys
  preprompt+=$prompt_ai_git_dirty
  # git pull/push arrows
  preprompt+="%F{yellow}${prompt_ai_git_arrows}%f"

  # make sure prompt_ai_last_preprompt is a global array
  typeset -g -a prompt_ai_last_preprompt

  # if executing through precmd, do not perform fancy terminal editing
  if [[ "$1" == "precmd" ]]; then
    print -P "\n${preprompt}"
  else
    # only redraw if the expanded preprompt has changed
    [[ "${prompt_ai_last_preprompt[2]}" != "${(S%%)preprompt}" ]] || return

    # calculate length of preprompt and store it locally in preprompt_length
    integer preprompt_length lines
    prompt_ai_string_length_to_var "${preprompt}" "preprompt_length"

    # calculate number of preprompt lines for redraw purposes
    (( lines = ( preprompt_length - 1 ) / COLUMNS + 1 ))

    # calculate previous preprompt lines to figure out how the new preprompt should behave
    integer last_preprompt_length last_lines
    prompt_ai_string_length_to_var "${prompt_ai_last_preprompt[1]}" "last_preprompt_length"
    (( last_lines = ( last_preprompt_length - 1 ) / COLUMNS + 1 ))

    # clr_prev_preprompt erases visual artifacts from previous preprompt
    local clr_prev_preprompt
    if (( last_lines > lines )); then
      # move cursor up by last_lines, clear the line and move it down by one line
      clr_prev_preprompt="\e[${last_lines}A\e[2K\e[1B"
      while (( last_lines - lines > 1 )); do
        # clear the line and move cursor down by one
        clr_prev_preprompt+='\e[2K\e[1B'
        (( last_lines-- ))
      done

      # move cursor into correct position for preprompt update
      clr_prev_preprompt+="\e[${lines}B"
    # create more space for preprompt if new preprompt has more lines than last
    elif (( last_lines < lines )); then
      # move cursor using newlines because ansi cursor movement can't push the cursor beyond the last line
      printf $'\n'%.0s {1..$(( lines - last_lines ))}
    fi

    # disable clearing of line if last char of preprompt is last column of terminal
    local clr='\e[K'
    (( COLUMNS * lines == preprompt_length )) && clr=

    # modify previous preprompt
    print -Pn "${clr_prev_preprompt}\e[${lines}A\e[${COLUMNS}D${preprompt}${clr}\n"

    if [[ $prompt_subst_status = 'on' ]]; then
      # re-eanble prompt_subst for expansion on PS1
      setopt prompt_subst
    fi

    # redraw prompt (also resets cursor position)
    zle && zle .reset-prompt
  fi

  # store both unexpanded and expanded preprompt for comparison
  prompt_ai_last_preprompt=("$preprompt" "${(S%%)preprompt}")
}

prompt_ai_precmd() {
  # check for git arrows
  prompt_ai_check_git_arrows

  # check for git stash
  prompt_ai_check_git_stash

  # shows the full path in the title
  prompt_ai_set_title 'expand-prompt' '%~'

  # get vcs info
  vcs_info

  # preform async git dirty check and fetch
  prompt_ai_async_tasks

  # print the preprompt
  prompt_ai_preprompt_render "precmd"

  # remove the prompt_ai_cmd_timestamp, indicating that precmd has completed
  unset prompt_ai_cmd_timestamp
}

# fastest possible way to check if repo is dirty
prompt_ai_async_git_dirty() {
  local untracked_dirty=$1; shift

  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q "$*"

  if [[ "$untracked_dirty" == "0" ]]; then
    command git diff --no-ext-diff --quiet --exit-code
  else
    test -z "$(command git status --porcelain --ignore-submodules -unormal)"
  fi

  (( $? )) && echo " %F{yellow}⚡%f"
}

prompt_ai_async_git_fetch() {
  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q "$*"

  # set GIT_TERMINAL_PROMPT=0 to disable auth prompting for git fetch (git 2.3+)
  GIT_TERMINAL_PROMPT=0 command git -c gc.auto=0 fetch
}

prompt_ai_async_tasks() {
  # initialize async worker
  ((!${prompt_ai_async_init:-0})) && {
    async_start_worker "prompt_ai" -u -n
    async_register_callback "prompt_ai" prompt_ai_async_callback
    prompt_ai_async_init=1
  }

  # store working_tree without the "x" prefix
  local working_tree="${vcs_info_msg_1_#x}"

  # check if the working tree changed (prompt_ai_current_working_tree is prefixed by "x")
  if [[ ${prompt_ai_current_working_tree#x} != $working_tree ]]; then
    # stop any running async jobs
    async_flush_jobs "prompt_ai"

    # reset git preprompt variables, switching working tree
    unset prompt_ai_git_dirty
    unset prompt_ai_git_last_dirty_check_timestamp

    # set the new working tree and prefix with "x" to prevent the creation of a named path by AUTO_NAME_DIRS
    prompt_ai_current_working_tree="x${working_tree}"
  fi

  # only perform tasks inside git working tree
  [[ -n $working_tree ]] || return

  # do not preform git fetch if it is disabled or working_tree == HOME
  if (( ${PURE_GIT_PULL:-1} )) && [[ $working_tree != $HOME ]]; then
    # tell worker to do a git fetch
    async_job "prompt_ai" prompt_ai_async_git_fetch "${working_tree}"
  fi

  # if dirty checking is sufficiently fast, tell worker to check it again, or wait for timeout
  integer time_since_last_dirty_check=$(( EPOCHSECONDS - ${prompt_ai_git_last_dirty_check_timestamp:-0} ))
  if (( time_since_last_dirty_check > ${PURE_GIT_DELAY_DIRTY_CHECK:-1800} )); then
    unset prompt_ai_git_last_dirty_check_timestamp
    # check check if there is anything to pull
    async_job "prompt_ai" prompt_ai_async_git_dirty "${PURE_GIT_UNTRACKED_DIRTY:-1}" "${working_tree}"
  fi
}

prompt_ai_async_callback() {
  local job=$1
  local output=$3
  local exec_time=$4

  case "${job}" in
    prompt_ai_async_git_dirty)
      prompt_ai_git_dirty=$output
      prompt_ai_preprompt_render

      # When prompt_ai_git_last_dirty_check_timestamp is set, the git info is displayed in a different color.
      # To distinguish between a "fresh" and a "cached" result, the preprompt is rendered before setting this
      # variable. Thus, only upon next rendering of the preprompt will the result appear in a different color.
      (( $exec_time > 2 )) && prompt_ai_git_last_dirty_check_timestamp=$EPOCHSECONDS
      ;;
    prompt_ai_async_git_fetch)
      prompt_ai_check_git_arrows
      prompt_ai_check_git_stash
      prompt_ai_preprompt_render
      ;;
  esac
}

prompt_ai_setup() {
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  prompt_opts=(subst percent)

  zmodload zsh/datetime
  zmodload zsh/zle
  zmodload zsh/parameter

  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info
  autoload -Uz async && async

  add-zsh-hook precmd prompt_ai_precmd
  add-zsh-hook preexec prompt_ai_preexec

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' use-simple true
  # only export two msg variables from vcs_info
  zstyle ':vcs_info:*' max-exports 2
  # vcs_info_msg_0_ = ' %b' (for branch)
  # vcs_info_msg_1_ = 'x%R' git top level (%R), x-prefix prevents creation of a named path (AUTO_NAME_DIRS)
  zstyle ':vcs_info:git*' formats ' %b' 'x%R'
  zstyle ':vcs_info:git*' actionformats ' %b|%a' 'x%R'

  # if the user has not registered a custom zle widget for clear-screen,
  # override the builtin one so that the preprompt is displayed correctly when
  # ^L is issued.
  if [[ $widgets[clear-screen] == 'builtin' ]]; then
    zle -N clear-screen prompt_ai_clear_screen
  fi

  # show username@host if logged in through SSH
  [[ "$SSH_CONNECTION" != '' ]] && prompt_ai_username='%F{242}%n@%m%f '

  # show username if root, with username in white
  [[ $UID -eq 0 ]] && prompt_ai_username='%F{white}%B%n%b%f '

  # prompt turns red if the previous command didn't exit with 0
  PROMPT="%F{green}➤%f "
}

prompt_ai_setup "$@"

#!/usr/bin/zsh
# Prompt for zsh

prompt_git_progress() {
    local prompt_git_dir="$(git rev-parse --git-dir 2> /dev/null)"

    if [[ -f "$prompt_git_dir/MERGE_HEAD" ]]; then
        local prompt_process="merge"
    elif [[ -d "$prompt_git_dir/rebase-apply" ]]; then
        if [[ -f "$prompt_git_dir/rebase-apply/applying" ]]; then
            local prompt_process="am"
        else
            local prompt_process="rebase"
        fi
    elif [[ -d "$prompt_git_dir/rebase-merge" ]]; then
        local prompt_process="rebase"
    elif [[ -f "$prompt_git_dir/CHERRY_PICK_HEAD" ]]; then
        local prompt_process="cherry-pick"
    fi
    if [[ -f "$prompt_git_dir/BISECT_LOG" ]]; then
        local prompt_process="bisect"
    fi
    if [[ -f "$prompt_git_dir/REVERT_HEAD" ]]; then
        local prompt_process="revert"
    fi

    if [ "$prompt_process" ]; then
        echo " %{$fg[red]%}[$prompt_process]%{$reset_color%}"
    fi
}

prompt_git() {
    if [ -x "$(which git 2> /dev/null)" ]; then
        local prompt_s="`git current-branch 2> /dev/null`"
        local prompt_git_status="`git status --porcelain -b 2> /dev/null`"

        if [ "$prompt_s" -a "$prompt_s" = 'master' ]; then
            prompt_s=""
        else
            prompt_s=" $prompt_s"
        fi

        local prompt_mod=""
        if $(echo "$prompt_git_status" | grep '^## .*behind' &> /dev/null); then
            prompt_mod="$prompt_mod↓"
        fi
        if $(echo "$prompt_git_status" | grep '^## .*ahead' &> /dev/null); then
            prompt_mod="$prompt_mod↑"
        fi
        if $(echo "$prompt_git_status" | grep '^[? ][^#]' &> /dev/null); then
            prompt_mod="$prompt_mod⚡"
        elif $(echo "$prompt_git_status" | grep '^\w' &> /dev/null); then
            local prompt_add="⚡"
        fi
        if [ "$prompt_mod" ]; then
            prompt_s="$prompt_s %{$fg[yellow]%}$prompt_mod%{$reset_color%}"
            prompt_s="$prompt_s%{$fg[green]%}$prompt_add%{$reset_color%}"
        elif [ "$prompt_add" ]; then
            prompt_s="$prompt_s %{$fg[green]%}$prompt_add%{$reset_color%}"
        fi

        local prompt_count="`git stash list 2> /dev/null | wc -l`"
        if [ "$prompt_count" != "0" ]; then
            local prompt_stash="(stash $prompt_count)"
            prompt_stash="%{$fg[yellow]%}$prompt_stash%{$reset_color%}"
            prompt_s="$prompt_s $prompt_stash"
        fi

        echo "$prompt_s$(prompt_git_progress)"
    fi
}

prompt_gen() {
    local prompt_exit=$?

    local prompt_error=""
    if [ ! $prompt_exit -eq 0 ]; then
        local prompt_exit_name;

        # is this a signal name (error code = signal + 128) ?
        case $prompt_exit in
            -1)   prompt_exit_name=FATAL ;;
            1)    prompt_exit_name=WARN ;;
            2)    prompt_exit_name=BUILTINMISUSE ;;
            19)   prompt_exit_name=STOP ;;
            20)   prompt_exit_name=TSTP ;;
            21)   prompt_exit_name=TTIN ;;
            22)   prompt_exit_name=TTOU ;;
            126)  prompt_exit_name=CCANNOTINVOKE ;;
            127)  prompt_exit_name=CNOTFOUND ;;
            129)  prompt_exit_name=HUP ;;
            130)  prompt_exit_name=INT ;;
            131)  prompt_exit_name=QUIT ;;
            132)  prompt_exit_name=ILL ;;
            134)  prompt_exit_name=ABRT ;;
            136)  prompt_exit_name=FPE ;;
            137)  prompt_exit_name=KILL ;;
            139)  prompt_exit_name=SEGV ;;
            141)  prompt_exit_name=PIPE ;;
            143)  prompt_exit_name=TERM ;;

        esac

        prompt_error="%{$fg[red]%}✖ $prompt_exit_name%{$reset_color%}
"
    fi

    local prompt_dir=`echo "$PWD" | sed -r "s|^/home/$USER|~|g"`
    prompt_dir=`echo "$prompt_dir" | sed -r "s|^~/Dev/||g"`

    echo "$prompt_error
%{$fg[green]%}$prompt_dir%{$reset_color%}$(prompt_git)
%{$fg[green]%}➤%{$reset_color%} "
}

PROMPT='$(prompt_gen)'

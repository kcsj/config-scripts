## FILE: /home/chu/.conf-scripts/bash-dir/functions.sh
## AUTHOR: Matthew Ball (copyleft 2012, 2013)

function start_stumpwm {
    startx &
    screen
}

function init_dist_variables { # initialise package manager variables for distribution
    DIST_TYPE=`/usr/bin/lsb_release -i` # $DIST_TYPE is 16 characters into the output of /usr/bin/lsb_release -i
    DIST_NAME=${DIST_TYPE:16}

    if [ $DIST_NAME = "Debian" ] || [ $DIST_NAME = "Ubuntu" ]; then # set debian/ubuntu package manager variables
	PM_SEARCH="apt-cache search";    PM_SHOW="apt-cache show";
	PM_UPDATE="sudo apt-get update"; PM_UPGRADE="sudo apt-get upgrade"; PM_INSTALL="sudo apt-get install"; PM_REMOVE="sudo apt-get remove"; PM_PURGE="sudo apt-get purge";
    elif [ $DIST_NAME = "Arch" ]; then # set arch package manager variables
	PM_SEARCH="pacman"; PM_SHOW="pacman"; PM_UPDATE="pacman"; PM_UPGRADE="pacman"; PM_INSTALL="pacman"; PM_REMOVE="pacman"; PM_PURGE="pacman";
    else
	return
    fi
}

function package_manager_command_run { # run package manager command
    PACKAGE_MANAGER_COMMAND="$1 $2" # set command string
    $PACKAGE_MANAGER_COMMAND        # run command string
}

function package_manager_search { # search package manager archives
    if [ -z $PM_SEARCH ]; then # if $PM_SEARCH is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_SEARCH $1"
}

function package_manager_show { # show package details
    if [ -z $PM_SHOW ]; then # if $PM_SHOW is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_SHOW $1"
}

function package_manager_update { # update package archives
    if [ -z $PM_UPDATE ]; then # if $PM_UPDATE is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_UPDATE $1"
}

function package_manager_upgrade { # upgrade from package archives
    if [ -z $PM_UPGRADE ]; then # if $PM_UPGRADE is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_UPGRADE $1"
}

function package_manager_dist_upgrade { # distribution upgrade from package archives
    if [ -z $PM_DIST_UPGRADE ]; then # if $PM_DIST_UPGRADE is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_DIST_UPGRADE $1"
}

function package_manager_install { # install package from package archives
    if [ -z $PM_INSTALL ]; then # if $PM_INSTALL is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_INSTALL $1"
}

function package_manager_remove { # remove package from computer
    if [ -z $PM_REMOVE ]; then # if $PM_REMOVE is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_REMOVE $1"
}

function package_manager_purge { # purge package from computer
    if [ -z $PM_PURGE ]; then # if $PM_PURGE is empty initialise variables
	init_dist_variables
    fi

    package_manager_command_run "$PM_PURGE $1"
}

function mcd { # make directory and cd into it
    mkdir "$1"
    cd "$1"
}

function lister { # feeds file and directory filtered listers
    ls -l `if [ "$1" == '' ]; then echo '.'; else echo "$1"; fi`
}

function lsdirs { # list only directories
    lister $1 | egrep '^d'
}

function lsfiles { # list only files
    lister $1 | egrep -v '^d'
}

function grip { # search all files in current directory
    # this is my emacs-dir show structure function ...
    # grep -ir "$1" "$PWD"
    grep -RnisI "$1" "$PWD"
}

function show-full-path { # show full file path
    for file in $(ls "$@"); do
        echo -n $(pwd)
        [[ $(pwd) != "/" ]] && echo -n /
        echo $file
    done
}

function lsnet { # list network connections
    # TODO: this function does not do what I think it does
    lsof -i  | awk '{printf("%-14s%-20s%s\n", $10, $1, $9)}' | sort
}

function sizeof { # return sizeof array
    array=( $@ ) # $@ expands to all parameters
    echo ${#array[@]}
}

function extract-from-archive { # extract files from an archive
    if [ -f $1 ]; then
	case $1 in
            *.tar.bz2) tar xvjf $1                     ;;
            *.tar.gz)  tar xvzf $1    		       ;;
            *.bz2)     bunzip2 $1     		       ;;
            *.rar)     unrar x $1     		       ;;
            *.gz)      gunzip $1      		       ;;
            *.tar)     tar xvf $1     		       ;;
            *.xz)      tar Jxf $1     		       ;;
            *.tbz2)    tar xvjf $1    		       ;;
            *.tgz)     tar xvzf $1    		       ;;
            *.zip)     unzip $1       		       ;;
            *.Z)       uncompress $1  		       ;;
            *.7z)      7z x $1        		       ;;
            *)         echo "can not extract '$1' ..." ;;
	esac
    else
	echo "'$1' is not a valid file ..."
    fi
}

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " ("${ref#refs/heads/}")"
}

function start_agent { # start the ssh-agent
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}

function test_identities { # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        if [ $? -eq 2 ]; then # $SSH_AUTH_SOCK broken so we start a new proper agent
            start_agent
        fi
    fi
}

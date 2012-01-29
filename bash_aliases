# ========================
# Custom alias definitions
# ========================

alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable --group-directories-first' # fancy ls
alias lsr='ls -R' # recursive directory listing
alias grep='grep --color=auto'

# TODO: clean this up
alias emacs-file='emacsclient -n' # open file in the current emacs session

alias search='apt-cache search' # search apt-cache for packages
alias show='apt-cache show' # show package details from apt-cache
alias temp='acpi -t' # show battery status details
alias screenshot='import -window root' # capture screenshot
alias resume='screen -r' # resume screen session
alias connect='nmcli con up id' # connect to network

alias update='sudo apt-get update' # update apt package
alias upgrade='sudo apt-get upgrade' # upgrade available apt packages
alias dist_upgrade='sudo apt-get dist-upgrade' # upgrade apt packages
alias install='sudo apt-get install' # install package via apt-get
alias remove='sudo apt-get remove' # remove apt package
alias purge='sudo apt-get purge' # purge apt package
alias hibernate='sudo pm-hibernate'

# jump to the current emacs directory
alias jem='cd $(emacsclient -e "(with-current-buffer (window-buffer (frame-selected-window)) (expand-file-name default-directory))" | '"sed -E 's/(^\")|(\"$)//g')"

# if [ ! -n "$EMACS" ]; then # add colour for directory listings and grep
#     alias ls='ls --color=auto'

#     alias grep='grep --color=auto'
# fi







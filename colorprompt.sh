#= colorprompt/colorprompt.sh
#
/usr/bin/logger "Starting colorprompt/colorprompt.sh as user '$USER'"
#
# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
green='\e[0;32m'
GREEN='\e[1;32m'
yellow='\e[0;33m'
YELLOW='\e[1;33m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NOCOLOR='\e[0m'              # No Color
# --&#62; Nice. Has the same effect as using "ansi.sys" in DOS.
#
# - - -: PATH
export PATH=$HOME/colorprompt/bin:$PATH
#
# - - -: ENV 
# Timeout - seconds after BASH shell will exit (for serial consoles)
# seconds   time
# 900	      15 min
# 1800      30 min
# 3600      1 hour
# 14400     4 hours
# 28800     8 hours
# 43200     12 hours
# 86400     1 day (24 hours)
# 172800    2 day  (48 hours)
#
#TMOUT=43200
TMOUT=172800
#
# -i causes Less to search '/' with case-insensitive
# -S chop long-lines
# -F exit if one-screen
LESS='-i -S'
#
# - - -: Alias
#
alias o='less -iS'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'
alias hig='history | grep'
alias ng='f(){ lsof -i -n -P +c0 | egrep "PID|$1" ; unset -f f; }; f'
alias ng_sudo='f(){ sudo lsof -i -n -P +c0 | egrep "PID|$1" ; unset -f f; }; f'
alias psg='ps aux | grep'
alias psg_sudo='sudo ps aux | grep'
alias fm='/usr/bin/find . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) | sort -n | tail'
#
#alias ifc='echo "# ip addr show | egrep -i \"mtu|ether|inet\" .." && ip addr show | egrep -i "mtu|ether|inet"'
#alias ifcm='ifconfig | egrep "mtu|ether|inet"'
# [ "$(uname -s)" == "Darwin" ] && ...
# [ "$(uname -s)" == "Linux" ] && ...
[ "$(uname -s)" == "Linux" ] && alias ifconfig='ip addr show' && alias ifc='echo "# ip addr show | egrep -i \"mtu|ether|inet\" .." && ip addr show | egrep -i "mtu|ether|inet"'
[ "$(uname -s)" == "Darwin" ] && alias ifc='echo "# ifconfig | egrep -i \"mtu|ether|inet\" .." && ifconfig | egrep -i "mtu|ether|inet"'
#
alias cdp='echo "change dir to: `pwd -P` ..";cd "`pwd -P`"'
alias dusort='find . -maxdepth 1 -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
alias dusort2='f_dusort2(){ sudo du -hxd 1 $1 | sort -h ; unset -f f_dusort2; }; f_dusort2'
alias duasort='find . -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
alias dusortm="du -skx * | $HOME/colorprompt/mac/bin/convertsize.mac.pl | sort"
alias duasortm='find . -type d -exec du -sx "{}" \;  | $HOME/colorprompt/mac/bin/convertsize.mac.pl  | append_slash.pl | sort'
alias fmm='gfind . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) 
| sort -n | tail'
alias fusort=' find . -maxdepth 1 -type f -size +1024k -printf "%s\t%p\n" | convertsize.pl | sort'
alias fuasort='find . -type f -size +1024k -printf "%s\t%p\n" | convertsize.pl | sort'
alias pt='perltidy -b -i=3 --cuddled-else'
alias lsofg="lsof | egrep '(REG|DIR)' | grep"
alias route6="route -A inet6 -n"
alias du='du -h'
alias df='df -kh'
alias lt='ls -altr -hp'                # sort by date-reverse (youngest at bottom)
alias ltt='ls -altr -hp | tail -n30'   # lt with tail
alias ltd='find . -type d -maxdepth 1 -printf "%4m %3n %8u %8g %5s %t %f/\n"'
alias lsp='ls -d -1 $PWD/*'            # ls with full path
[ -f "/usr/bin/vim" ] && alias vi="/usr/bin/vim"
alias curl-cat="curl -fsL"
alias curl-save="curl -fsLO"
# https://superuser.com/questions/1251360/messed-layout-in-htop
# "I solved this problem by adding an alias for htop in ~/.bashrc: alias htop='TERM=xterm-color htop' "
alias htop='TERM=xterm-color htop'
#
# - - -: Function
ff ()   { echo "# bash-function, see 'type ff':";  /usr/bin/find . -iname '*'$1'*'; }
ff2 ()  { echo "# bash-function, see 'type ff2':"; /usr/bin/find . ! -ipath '*.svn*' -iname '*'$1'*'; }
fif ()  { echo "# bash-function, see 'type fif':"; /usr/bin/find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
fif2 () { echo "# bash-function, see 'type fif2':"; /usr/bin/find . -xtype f ! -ipath '*.svn*' -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
ffm ()   { echo "# bash-function, see 'type ffm':"; gfind . -iname '*'$1'*'; }
# fifm on basis of brew: > brew install findutils
fifm ()  { echo "# bash-function, see 'type fifm':"; gfind . -xtype f -iname '*'$2'*' -print0 | gxargs -0i grep -sinH "$1" "{}"; }
# alt:
# > brew install ffind
# > brew install rargs
fifm2 ()  { echo "# bash-function, see 'type fifm':"; ffind . -xtype f -iname '*'$2'*' -print0 | rargs -0 egrep -sinH "$1" "{}"; }
fifm3 () { egrep -sinH "$1" "$2"; }
#
tarbase64 () { tar czf - "$@" | openssl base64 ; }
untarbase64 () { cat | openssl base64 -d | tar xvzf - ; }
#
multiline2line () { cat | perl -pe "s/\s+/ /" ; }
#
openssl_show_crt () { /usr/bin/openssl x509 -text -noout -in "$@" ; }
#.

# - - -: DISTRO info
if [ -r $HOME/colorprompt/bin/write_distro_file.sh ]; then
  $HOME/colorprompt/bin/write_distro_file.sh silent
fi
DISTROFILE="$HOME/colorprompt/distro.info"
[[ -f $DISTROFILE ]] && source $DISTROFILE
[[ -z $DISTRO_TYPE ]] && DISTRO_TYPE="Unknown-Distro"
export DISTRO_TYPE=$DISTRO_TYPE
#
# - - -: Shell prompt
# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/index.html
# idea from: https://david.newgas.net/return_code/
export PROMPT_COMMAND='ret=$?; if [ $ret -ne 0 ] ; then echo -e "\n#( bash[PROMPT_COMMAND]: prev.cmd returned non-zero code: \033[01;31m$ret\033[00;00m )"; else echo; fi'
#
# git completion and prompt:
[ -r $HOME/colorprompt/bin/git-completion.sh ] && source $HOME/colorprompt/bin/git-completion.sh
[ -f $HOME/colorprompt/bin/git-prompt.sh ] && source $HOME/colorprompt/bin/git-prompt.sh
#
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; CYAN='\e[1;36m' ; NOCOLOR='\e[0m'
nothingnessssssssxssssssssssssss=""
#
[   -f $HOME/colorprompt/bin/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${YELLOW}"'$(__git_ps1 "(git:%s)")'"${CYAN}]--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
[ ! -f $HOME/colorprompt/bin/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${CYAN}]${$nothingnessssssssxssssssssssssss}--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
#
test 1 -eq 1
#-eof


# most basic env variables
set -gx EDITOR nvim
set -gx BROWSER firefox-developer-edition

set -gx TERM screen-256color

# start X server on login
if test (tty) = "/dev/tty1"
	startx
end

# PATH
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/scripts
set -gx PATH $PATH $HOME/go/bin

###########
# XDG rules
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

## CONFIG
set -gx CCACHE_CONFIGPATH   $XDG_CONFIG_HOME/ccache/ccache.conf
set -gx TS3_CONFIG_DIR      $XDG_CONFIG_HOME/ts3client
set -gx WGETRC              $XDG_CONFIG_HOME/wgetrc
## CACHE
set -gx CUDA_CACHE_PATH     $XDG_CACHE_HOME/nv
## DATA
set -gx CARGO_HOME          $XDG_DATA_HOME/cargo
set -gx GRADLE_USER_HOME    $XDG_DATA_HOME/gradle
set -gx PASSWORD_STORE_DIR  $XDG_DATA_HOME/pass
set -gx GOPATH              $XDG_DATA_HOME/go
set -gx NODE_REPL_HISTORY   $XDG_DATA_HOME/node_repl_history
set -gx MYSQL_HISTFILE      $XDG_DATA_HOME/mysql_history
## STATE
set -gx PSQL_HISTORY        $XDG_STATE_HOME/psql_history
## MISC
alias irssi="irssi --config=$XDG_CONFIG_HOME/irssi/config --home=$XDG_DATA_HOME/irssi"

# black theme compatibility options for qt5ct or something
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx QT_PLATFORMTHEME qt5ct
set -gx QT_PLATFORM_PLUGIN qt5ct
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 0
set -gx QT_SCALE_FACTOR 1

# other env variables
#set -gx CHATTERINO2_RECENT_MESSAGES_URL https://recent-messages.zneix.eu/api/v2/recent-messages/%1
set -gx QT_MESSAGE_PATTERN "[0;33;40m[%{time hh:mm:ss.zzz}][0m [0;32;40m%{function}[0m %{message}"

alias firefox=firefox-developer-edition
alias vim=nvim
alias r=ranger
alias v=nvim
alias ayy=yay
alias pagman=pacman
alias :q=exit

alias tmpdir="cd (mktemp -d)"
alias cpu='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias myip="curl https://api.my-ip.io/ip"
alias validate="curl -s https://id.twitch.tv/oauth2/validate -H \"Authorization: OAuth $argv[1]\" | jq"
alias mirrorupdate="sudo reflector -c PL --age 12 --latest 5 --sort rate --save /etc/pacman.d/mirrorlist"
alias c2pnsl="XDG_DATA_HOME=~/.local/share/c2pnsl chatterino"
#alias take="echo mkdir -p $argv[1] && cd $argv[1]"
alias objxd="echo -n ￼ | xsel --clipboard"

# validate provided Twitch OAuth / Bearer token
function validate
    curl -s https://id.twitch.tv/oauth2/validate -H "Authorization: OAuth $argv[1]" | jq
end

# xd
function userid
    tcurl "https://api.twitch.tv/helix/users?login=$argv[1]" | jq .data[].id -j | xclip -selection c
end

# get my Twitch token and store it inside TOKEN variable
function tcurl
    set CLIENT_ID (grep -A3 "\"username\": \"zneix\","  ~/.local/share/chatterino/Settings/settings.json | grep clientID | sed -r 's/.+: "(.{30})",?/\1/g')
    set TOKEN (grep -A3 "\"username\": \"zneix\","  ~/.local/share/chatterino/Settings/settings.json | grep oauthToken | sed -r 's/.+: "(.{30})",?/\1/g')
    curl -s -H "Client-ID: $CLIENT_ID" -H "Authorization: Bearer $TOKEN" $argv
end

# create a new folder and cd to it
function take
    mkdir -p $argv[1]
    cd $argv[1]
end

# password for school content
function leszek
    echo "ONl!ne20_3TI\$" | xsel --clipboard
end

# update chatterino with latest code from github
function update-chatterino
    set OLDWD $PWD

    cd /opt/chatterino2
    git pull
    git submodule update
    rm -rf build
    mkdir -p build && cd build
    cmake -DCMAKE_BUILD_TYPE=Debug .. 1>/dev/null
    make -j12 1>/dev/null && echo nightly >> bin/modes && echo "Done KKona" || echo "Something went wrong!!!"

    cd "$OLDWD"
end

# changing among us region
function impostor
    cp ~/Downloads/zneix.dat ~/.steam/steam/steamapps/compatdata/945360/pfx/drive_c/users/steamuser/AppData/LocalLow/Innersloth/Among\ Us/regionInfo.dat
    echo AlienPls
end

# Advent of Code input getter
function inp
    echo $argv[1]
    curl -sH "Cookie: session=53616c7465645f5f74b979d9786a0cbf18538499880cb73741aeb0197f34278860c4aeac2dcf13bb50427ad51d3f87c9" "https://adventofcode.com/2020/day/$argv[1]/input" -o "i$argv[1]"
end

# time-to-first-byte wrapper
function ttfb
    curl -so nul -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total: %{time_total} \n" $argv
end

# compile and run one-file cpp projects (mostly used for school)
function gpp
    mkdir -p bin
    g++ $argv[1].cpp -o bin/$argv[1] && echo Compiled $argv[1].cpp, starting $argv[1]... && ./bin/$argv[1]
end

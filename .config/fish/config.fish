# most basic env variables
set -gx EDITOR nvim
set -gx BROWSER firefox

set -gx TERM screen-256color

# start X server on login
if test (tty) = "/dev/tty1"
	startx
end

# PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $PATH $HOME/scripts
set -gx PATH $PATH $HOME/go/bin

# black theme compatibility options for qt5ct or something
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx QT_PLATFORMTHEME qt5ct
set -gx QT_PLATFORM_PLUGIN qt5ct
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 0
set -gx QT_SCALE_FACTOR 1

# other env variables
set -gx CCACHE_CONFIGPATH $HOME/.config/ccache/ccache.conf
set -gx CHATTERINO2_RECENT_MESSAGES_URL https://recent-messages.zneix.eu/api/v2/recent-messages/%1
set -gx QT_MESSAGE_PATTERN "[0;33;40m[%{time hh:mm:ss.zzz}][0m [0;32;40m%{function}[0m %{message}"

alias firefox=firefox-developer-edition
alias vim=nvim
alias r=ranger
alias v=nvim
alias ayy=yay

alias tmpdir="cd (mktemp -d)"
alias cpu='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
#alias take="echo mkdir -p $argv[1] && cd $argv[1]"

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
    qmake CONFIG+=debug .. 2>/dev/null
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
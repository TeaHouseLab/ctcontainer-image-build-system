#!/usr/bin/env fish

#!/usr/bin/env fish
function logger-warn
  set_color magenta
  echo "$prefix [Warn] $argv[1..-1]"
  set_color normal
end
function logger-error
  set_color red
  echo "$prefix [Error] $argv[1..-1]"
  set_color normal
end
function logger-info
  set_color normal
  echo "$prefix [Info] $argv[1..-1]"
  set_color normal
end
function logger-debug
  set_color yellow
  echo "$prefix [Debug] $argv[1..-1]"
  set_color normal
end
function logger-success
  set_color green
  echo "$prefix [Successed] $argv[1..-1]"
  set_color normal
end
function logger -d "a lib to print msg quickly"
switch $argv[1]
case 0
  logger-info $argv[2..-1]
case 1
  logger-success $argv[2..-1]
case 2
  logger-debug $argv[2..-1]
case 3
  logger-warn $argv[2..-1]
case 4
  logger-error $argv[2..-1]
end
end

function help_echo
  echo "==========Help Documentation=========="
  set_color green
  echo "(./)app argv[1]"
  set_color normal
  echo " -argv[1]:the command to execute"
  echo "  -Available:
      debian_based >>> Build debian_based distro,use -a to build them all
      arch_based {archlinux,manjarolinux} >>> build archbased distro
      voidlinux >>> build voidlinux
      downloadable >>> build all downloadable image"
  echo "======================================"
end

function arch_based
    switch $argv[1]
        case archlinux
            cd /ctcontainer_share
            if test -d archlinux
            else
                mkdir archlinux
            end
            pacstrap archlinux base
            cd archlinux
            tar zcf archlinux.tar.gz .
            cd ..
            mv archlinux/archlinux.tar.gz .
        case manjarolinux
            if test -d manjarolinux
            else
                mkdir manjarolinux
            end
            cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
            echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/manjaro/stable/$repo/$arch' > /etc/pacman.d/mirrorlist
            cd /ctcontainer_share
            pacstrap manjarolinux base pamac-gtk pamac-cli
            cd manjarolinux
            tar zcf manjarolinux.tar.gz .
            cd ..
            mv manjarolinux/manjarolinux.tar.gz .
            mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
        case arcolinux
            cd /ctcontainer_share
            pacstrap arcolinux base
        case v h '*'
            logger 4 "Unexpected Input,abort"
            exit
    end

end

function downloadable
    if curl --progress-bar -L -o built/alpinelinux.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-minirootfs-3.15.0-x86_64.tar.gz
        logger 1 "Alpinelinux rootfs Downloaded"
    echo alpinelinux >> built/available
    else
        logger 4 "Failed to download Alpinelinux rootfs"
    end
end

function debian_based
    if test -d built
    else
        sudo mkdir built
    end
    if [ "$argv[1]" = -a ]
        logger 0 "Building All"
        set distro debian-stable debian-testing debian-unstable deepin-stable parrothome-stable mxlinux-stable kali-rolling ubuntu-stable
    else
        if test -n "$argv[1]"
            set distro $argv
        else
            logger 0 "avaiable rootfs
debian-stable
debian-testing
debian-unstable
deepin-stable
parrotsec-testing
kali-rolling
ubuntu-stable"
            logger 0 "Type them below,use space for multiple images"
            read -P "$prefix >>> " distro
        end
    end
        for now_distro in $distro
            switch $now_distro
                case debian-stable debian-testing debian-unstable
                    set branch stable
                    set now_source http://deb.debian.org/debian/
                case debian-testing
                    set branch testing
                    set now_source http://deb.debian.org/debian/
                case debian-unstable
                    set branch unstable
                    set now_source http://deb.debian.org/debian/
                case deepin-stable
                    set no_check_gpg true
                    set branch stable
                    set now_source http://packages.deepin.com/deepin/
                case parrotsec-testing
                    set no_check_gpg true
                    set branch testing
                    set now_source http://deb.parrotsec.org/parrot
                case kali-rolling
                    set no_check_gpg true
                    set branch kali-rolling
                    set now_source http://http.kali.org/kali
                case ubuntu-stable
                    set no_check_gpg true
                    set branch impish
                    set now_source http://archive.ubuntu.com/ubuntu/
            end
            if [ "$now_source" = "" ]
                logger 4 "No distro to build,abort"
                exit
            end
            if [ "$no_check_gpg" = true ]
                sudo env http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 DEBIAN_FRONTEND=noninteractive debootstrap --no-check-gpg $branch $now_distro $now_source
                cd $now_distro
                tar zcf $now_distro.tar.gz .
                cd ..
                sudo mv $now_distro/$now_distro.tar.gz built/
                echo $now_distro >> built/available
                logger 1 "Built,rootfs at $now_distro.tar.gz"
            else
                sudo env http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 DEBIAN_FRONTEND=noninteractive debootstrap $branch $now_distro $now_source
                cd $now_distro
                tar zcf $now_distro.tar.gz .
                cd ..
                sudo mv $now_distro/$now_distro.tar.gz built/
                echo $now_distro >> built/available
                logger 1 "Built,rootfs at $now_distro.tar.gz"
            end
        end
    end

function voidlinux
    cd /ctcontainer_share
    if test -d voidlinux
    else
        mkdir voidlinux
    end
    XBPS_ARCH=x86_64 HTTP_PROXY=http://127.0.0.1:7890/ xbps-install -S -r /mnt -R "https://alpha.de.repo.voidlinux.org/current" base-minimal fish-shell bash ncurses
    cd voidlinux
    tar zcf voidlinux.tar.gz .
    cd ..
    mv voidlinux/voidlinux.tar.gz .
end

echo Build_Time_UTC=2022-01-18_04:35:38
set -lx prefix [ctc-rootfs-build-system]
switch $argv[1]
case debian_based
    debian_based $argv[2..-1]
case arch_based
    arch_based $argv[2..-1]
case downloadable
    downloadable
case voidlinux
    voidlinux
case v version
    logger 0 "FrostFlower@build0"
case help h '*'
    help_echo
end
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
      debian_based >>> Build debian_based distro,use -a to build them all"
  echo "======================================"
end
function debian_based
    if test -d built
    else
        sudo mkdir built
    end
    if [ "$argv[1]" = -a ]
        logger 0 "Building All"
        set distro debian-stable debian-testing debian-unstable deepin-stable parrothome-stable mxlinux-stable kali-rolling ubuntu-stable elementary-stable mint-stable
    else
        logger 0 "avaiable rootfs
debian-stable
debian-testing
debian-unstable
deepin-stable
parrotsec-testing
mxlinux-stable
kali-rolling
ubuntu-stable
elementary-stable
mint-stable"
        logger 0 "Type them below,use space for multiple images"
        read -P "$prefix >>> " distro
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
                set branch lts
                set now_source http://deb.parrotsec.org/parrot
            case mxlinux-stable
                set no_check_gpg true
                set branch bullseye
                set now_source http://mxrepo.com/mx/repo/
            case kali-rolling
                set no_check_gpg true
                set branch kali-rolling
                set now_source http://http.kali.org/kali
            case ubuntu-stable
                set branch impish
                set now_source http://archive.ubuntu.com/ubuntu/
        end
        if [ "$now_source" = "" ]
            logger 4 "No distro to build,abort"
            exit
        end
        if [ "$no_check_gpg" = true ]
            if sudo env http_proxy=http://127.0.0.1:7890 DEBIAN_FRONTEND=noninteractive debootstrap --no-check-gpg $branch $now_distro $now_source
                sudo fish -c "cd $now_distro && tar zcf . $now_distro.tar.gz && mv $now_distro.tar.gz ../built/ && cd .."
                sudo rm -rf $now_distro
                echo $now_distro >> built/avaiable
                logger 1 "Build,rootfs at $now_distro.tar.gz"
            else
                sudo rm -rf $now_distro
                logger 4 "Something went wrong,abort,craft table cleaned"
            end
        else
            if sudo env http_proxy=http://127.0.0.1:7890 DEBIAN_FRONTEND=noninteractive debootstrap $branch $now_distro $now_source
                sudo fish -c "cd $now_distro && tar zcf . $now_distro.tar.gz && mv $now_distro.tar.gz ../built/ && cd .."
                sudo rm -rf $now_distro
                echo $now_distro >> built/avaiable
                logger 1 "Build,rootfs at $now_distro.tar.gz"
            else
                sudo rm -rf $now_distro
                logger 4 "Something went wrong,abort,craft table cleaned"
            end
        end
    end
end
echo Build_Time_UTC=2021-12-25_06:02:24
set -lx prefix [ctc-rootfs-build-system]
switch $argv[1]
case debian_based
    debian_based $argv[2..-1]
case arch_based
    arch_based $argv[2..-1]
case v version
    logger 0 "FrostFlower@build0"
case help h '*'
    help_echo
end
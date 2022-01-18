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

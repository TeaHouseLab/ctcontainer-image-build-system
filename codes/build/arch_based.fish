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

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

function debian
    logger 3 "Building debian-stable amd64"
    if sudo distrobuilder build-lxc ./files/debian.yaml -o image.architecture=amd64 -o image.release=bullseye -o image.variant=default -o source.url="http://mirrors.bfsu.edu.cn/debian"
        rm meta.tar.xz && mv rootfs.tar.xz debian-stable
    else
        logger 4 "error when building debian-stable amd64"
    end
    logger 3 "Building debian-stable arm64"
    if sudo distrobuilder build-lxc ./files/debian.yaml -o image.architecture=arm64 -o image.release=bullseye -o image.variant=default -o source.url="http://mirrors.bfsu.edu.cn/debian"
        rm meta.tar.xz && mv rootfs.tar.xz debian-stablearm64
    else
        logger 4 "error when building debian-stable arm64"
    end
end

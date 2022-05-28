function archlinux
    logger "Building archlinux amd64"
    if sudo distrobuilder build-lxc ./files/archlinux.yaml -o image.architecture=x86_64 -o image.variant=default
        rm meta.tar.xz && mv rootfs.tar.xz archlinux
    else
        logger 4 "error when building archlinux amd64"
    end
    logger "Building archlinux arm64"
    if sudo distrobuilder build-lxc archlinux.yaml -o image.architecture=aarch64 -o image.variant=default
        rm meta.tar.xz && mv rootfs.tar.xz archlinuxarm64
    else
        logger 4 "error when building archlinux arm64"
    end
end

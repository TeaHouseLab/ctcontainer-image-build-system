function alpinelinux
    logger "Building alpinelinux edge amd64"
    if sudo distrobuilder build-lxc ./files/alpinelinux.yaml -o image.architecture=x86_64 -o image.release=edge -o image.variant=default
        rm meta.tar.xz && mv rootfs.tar.xz alpinelinux
    else
        logger 4 "error when building alpinelinux edge amd64"
    end
    logger "Building alpinelinux edge arm64"
    if sudo distrobuilder build-lxc alpinelinux.yaml -o image.architecture=aarch64 -o image.release=edge -o image.variant=default
        rm meta.tar.xz && mv rootfs.tar.xz alpinelinuxarm64
    else
        logger 4 "error when building alpinelinux edge arm64"
    end
end

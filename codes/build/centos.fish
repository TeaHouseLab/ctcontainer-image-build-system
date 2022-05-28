function centos
    logger 3 "Building centos7 amd64"
    if sudo distrobuilder build-lxc ./files/centos.yaml -o image.architecture=x86_64 -o image.release=7 -o image.variant=default -o source.url=http://mirrors.nju.edu.cn/centos/ -o source.skip_verification=true
        rm meta.tar.xz && mv rootfs.tar.xz centos7
    else
        logger 4 "error when building centos7 amd64"
    end
    logger 3 "Building centos7 arm64"
    if sudo distrobuilder build-lxc ./files/centos.yaml -o image.architecture=aarch64 -o image.release=7 -o image.variant=default -o source.url=http://mirrors.nju.edu.cn/centos-altarch/ -o source.skip_verification=true
        rm meta.tar.xz && mv rootfs.tar.xz centos7arm64
    else
        logger 4 "error when building centos7 arm64"
    end


    logger 3 "Building centos8 amd64"
    if sudo distrobuilder build-lxc ./files/centos.yaml -o image.architecture=x86_64 -o image.release=8-Stream -o image.variant=default -o source.url=http://mirrors.nju.edu.cn/centos/ -o source.skip_verification=true
        rm meta.tar.xz && mv rootfs.tar.xz centos8
    else
        logger 4 "error when building centos8 amd64"
    end
    logger 3 "Building centos8 arm64"
    if sudo distrobuilder build-lxc ./files/centos.yaml -o image.architecture=aarch64 -o image.release=8-Stream -o image.variant=default -o source.url=http://mirrors.nju.edu.cn/centos-altarch/ -o source.skip_verification=true
        rm meta.tar.xz && mv rootfs.tar.xz centos8arm64
    else
        logger 4 "error when building centos8 arm64"
    end
end
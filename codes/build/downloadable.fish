function downloadable
    if curl -s -L -o built/alpinelinux.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-minirootfs-3.15.0-x86_64.tar.gz
        logger 1 "Alpinelinux rootfs Downloaded"
    echo alpinelinux >> built/available
    else
        logger 4 "Failed to download Alpinelinux rootfs"
    end
end

set -lx prefix [ctc-rootfs-build-system]
switch $argv[1]
case debian
    debian
case archlinux
    archlinux
case centos
    centos
case alpinelinux
    alpinelinux
case voidlinux
    voidlinux
case v version
    logger 0 "Quicksand@build1"
case help h '*'
    help_echo
end
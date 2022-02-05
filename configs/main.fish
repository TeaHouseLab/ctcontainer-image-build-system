set -lx prefix [ctc-rootfs-build-system]
switch $argv[1]
case debian_based
    debian_based $argv[2..-1]
case arch_based
    arch_based $argv[2..-1]
case alpinelinux
    alpinelinux
case voidlinux
    voidlinux
case v version
    logger 0 "BlackDeath@build1"
case help h '*'
    help_echo
end
function alpinelinux
    cd /ctcontainer_share
    if test -d alpinelinux
    else
        mkdir alpinelinux
    end
    env apk --arch x86_64 -X https://dl-cdn.alpinelinux.org/alpine/edge/main/ -U --allow-untrusted --root /ctcontainer_share/alpinelinux --initdb add alpine-base bash fish coreutils
    cd alpinelinux
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community" >etc/apk/repositories
    tar zcf alpinelinux.tar.gz .
    cd ..
    mv alpinelinux/alpinelinux.tar.gz .
end

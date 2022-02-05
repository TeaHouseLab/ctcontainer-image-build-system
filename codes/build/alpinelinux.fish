function alpinelinux
    cd /ctcontainer_share
    if test -d alpinelinux
    else
        mkdir alpinelinux
    end
    env http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 apk --arch x86_64 -X https://dl-cdn.alpinelinux.org/alpine/edge/main/ -U --allow-untrusted --root /ctcontainer_share/alpinelinux --initdb add alpine-base bash fish
    cd alpinelinux
    tar zcf alpinelinux.tar.gz .
    cd ..
    mv alpinelinux/alpinelinux.tar.gz .
end

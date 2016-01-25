FROM alpine:latest

RUN apk update \
    && export ALPINE_GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/" \
    && export GLIBC_PKG="glibc-2.21-r2.apk" \
    && export GLIBC_BIN_PKG="glibc-bin-2.21-r2.apk" \
    && apk add openssl \
    && cd /tmp \
    && wget ${ALPINE_GLIBC_URL}${GLIBC_PKG} ${ALPINE_GLIBC_URL}${GLIBC_BIN_PKG} \
    && apk add --allow-untrusted ${GLIBC_PKG} ${GLIBC_BIN_PKG} \
    && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && rm /tmp/* /var/cache/apk/*

COPY .goxc.json /tmp/

RUN apk update \
    && apk add jq \
    && export VERSION=$(jq -r '.PackageVersion' /tmp/.goxc.json) \
    && echo "version=$VERSION" \
    && wget -c -P /tmp https://github.com/cgeoffroy/basic_bcrypt_server/releases/download/v${VERSION}/basic_bcrypt_server_${VERSION}-master.snapshot.b1_linux_amd64.tar.gz \
    && tar -C /tmp -xzvf /tmp/basic_bcrypt_server*.tar.gz \
    && find /tmp -type 'f' -perm +111 -name '*basic_bcrypt_server' -exec mv {} /usr/local/bin/ \; \
    && basic_bcrypt_server -version \
    && apk del --purge jq \
    && rm -rf /tmp/* /var/cache/apk/*

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/basic_bcrypt_server"]

CMD ["--help"]

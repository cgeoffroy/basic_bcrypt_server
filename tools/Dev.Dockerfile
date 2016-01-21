FROM golang:1.5

RUN go get -u -v github.com/nsf/gocode \
      github.com/rogpeppe/godef \
      golang.org/x/tools/cmd/oracle \
      golang.org/x/tools/cmd/gorename \
      github.com/laher/goxc \
      golang.org/x/crypto/bcrypt \
    # && apt-get update && apt-get install -y dropbear sudo
    && echo 'Done'

COPY tools/dev-entrypoint.sh /var/opt/

# Setup User to match Host User, and give superuser permissions
ARG USER_ID=1000
ARG USER_GROUP=1000
RUN groupadd -g "${USER_GROUP}" code_executor \
    && useradd code_executor --create-home -u "${USER_ID}" -g "${USER_GROUP}" -G 'sudo,root' \
    && echo "Defaults env_keep += \"GOPATH\"\nDefaults secure_path=\"${PATH}\"\ncode_executor ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir /home/code_executor/.ssh \
    && chown 'code_executor:code_executor' /home/code_executor/.ssh
USER ${USER_ID}

WORKDIR /go/src/github.com/cgeoffroy/basic_bcrypt_server

ENTRYPOINT ["/var/opt/dev-entrypoint.sh"]

# 22
EXPOSE 8080

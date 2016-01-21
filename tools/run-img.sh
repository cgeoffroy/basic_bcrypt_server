#! /bin/bash -e

docker run -it --rm="true" -p "8080:8080" -v "${HOME}/.ssh/id_rsa.pub:/home/code_executor/.ssh/keys/id_rsa.pub" -v "$(pwd):/go/src/github.com/cgeoffroy/basic_bcrypt_server" --name "basic_bcrypt_server" basic_bcrypt_server $*

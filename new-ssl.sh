#!/bin/bash

function die() {
echo ERROR: $*
exit 1
}

function prereq() {
sudo yum install -y epel-release || die "Install EPEL Repo"
sudo yum install -y git make libtool perl-core wget zlib-devel autoconf cmake3 unzip || die "Install soft"
sudo ln -s /usr/bin/cmake3 /usr/bin/cmake || dies "Links to cmake3"
}

function download() {
sudo mkdir -p distr
sudo wget -O distr/openssl.zip -c https://codeload.github.com/openssl/openssl/zip/OpenSSL_1_1_1-stable || die "download openssl"
sudo wget -O distr/gost-engine.zip -c https://codeload.github.com/gost-engine/engine/zip/1b374532c2d494710c39371e83c197d08c65e8bc || die "download gost-engine"
}

function unpack() {
cd distr
unzip openssl.zip || die "Unzip openssl"
unzip gost-engine.zip || die "Unzip Gost-Engine"
ln -s engine-1b374532c2d494710c39371e83c197d08c65e8bc engine || die "ln gost-engine"
cd ..
}
function mk_openssl() {
cd distr/openssl-OpenSSL_1_1_1-stable
#./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib || die "config openssl"
./config || die "config openssl"
make     || die "make openssl"
sudo make install || die "install openssl"
cd ../..
}

function mk_ln() {
cd distr/openssl-OpenSSL_1_1_1-stable
sudo ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
sudo ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
cd ../..
}

function mk_gost() {
export OPENSSL_ROOT_DIR=$(pwd)/distr/openssl-OpenSSL_1_1_1-stable
echo OPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR
cd distr/engine
mkdir build
cd build
cmake .. -DOPENSSL_ENGINES_DIR=/usr/local/lib64/engines-1.1
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
sudo make install
cd ../../..
sudo cp newssl/new-cfg.txt /usr/local/ssl/openssl.cnf
#sudo cp newssl/new-cfg.txt /etc/pki/tls/openssl.cnf
sudo cp /usr/local/src/distr/engine/build/bin/gost.so /usr/lib64/openssl/engines/gost.so
sudo cp /usr/local/src/distr/engine/build/bin/gost12sum /usr/lib64/openssl/engines/gost12sum
sudo cp /usr/local/src/distr/engine/build/bin/gostsum /usr/lib64/openssl/engines/gostsum
sudo cp /usr/local/src/distr/engine/build/bin/sign /usr/lib64/openssl/engines/sign
sudo openssl ciphers|tr ':' '\n'|grep GOST
}

prereq
download
unpack
mk_openssl
mk_ln
mk_gost


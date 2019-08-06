#!/bin/sh

cp distr/engine/build/bin/gost.so libgost.so
gcc -o get-cpcert -Idistr/engine get-cpcert.c \
  -Ldistr/openssl-OpenSSL_1_1_1-stable -lssl -lcrypto \
  -Ldistr/engine/build -lgost_core -L. -lgost \
  -lpthread -ldl -Xlinker '-rpath=.'

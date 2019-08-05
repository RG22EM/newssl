#!/bin/sh

cp ../distr/engine/build/bin/gost.so libgost.so
gcc -o get-cpcert -I../distr/engine get-cpcert.c \
  -L../distr/openssl-OpenSSL_1_1_1-stable -lssl -lcrypto \
  -L../distr/engine/build -lgost_core -L. -lgost \
  -lpthread -ldl -Xlinker '-rpath=.'

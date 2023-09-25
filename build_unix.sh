#!/bin/bash

# https://github.com/passepartoutvpn/openssl-apple/blob/master/build-libssl.sh

set -e

SSL="openssl-1.1.1w"

rm -rf ${SSL}
mkdir ${SSL}

curl https://www.openssl.org/source/${SSL}.tar.gz | tar xz -

LOG="$PWD/build-$(date +'%Y%m%d').txt"

if [ -z "$CPUTYPE" ]; then
  CPUTYPE="$HOSTTYPE"
fi

LOCAL_CONFIG_OPTIONS="--prefix=$PWD/openssl-dist/${CPUTYPE}"

pushd ${SSL}
./config ${LOCAL_CONFIG_OPTIONS} no-tests no-shared| tee -a "$LOG"
make install | tee -a "$LOG"
popd

PLAT="$(uname)-$(uname -m)"

if [ "${PLAT}" == 'Darwin-arm64' ]; then
  arch -x86_64 $0 build-only
  rm -rf openssl-dist/lib
  mkdir -p openssl-dist/lib
  lipo -create openssl-dist/arm64/lib/libcrypto.a openssl-dist/x86_64/lib/libcrypto.a -output openssl-dist/lib/libcrypto.a
  lipo -create openssl-dist/arm64/lib/libssl.a openssl-dist/x86_64/lib/libssl.a -output openssl-dist/lib/libssl.a
fi

echo "Cleanup .."
rm -rf ${SSL}

if [ -z "$1" ]; then
  make ARCH=$CPUTYPE clean all
fi

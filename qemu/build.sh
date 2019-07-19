#!/bin/sh -xe

BASE_DIR=/tmp/base/
NAME=$1
VERSION=$2
OS_RELEASE=$3
RELEASE=0
WORK_DIR=/tmp/work
PKG_DIR=$WORK_DIR/pkg
DEB_DIR=$PKG_DIR/DEBIAN

mkdir -p $DEB_DIR
cd $WORK_DIR

apt-get update
apt-get install -y pkg-config zlib1g-dev librdmacm-dev libibverbs-dev libvde-dev libvdeplug-dev \
                   libcap-ng-dev libglib2.0-dev libpixman-1-dev libaio-dev libnuma-dev \
                   libjemalloc-dev libiscsi-dev libibumad-dev

wget http://download.qemu-project.org/qemu-${VERSION}.tar.xz
tar xf qemu-${VERSION}.tar.xz
cd qemu-${VERSION}
./configure --enable-pie --enable-vnc --enable-kvm --enable-rdma --enable-vde --enable-linux-aio --enable-cap-ng --enable-vhost-net --enable-libiscsi --enable-coroutine-pool --enable-tpm --enable-numa --enable-jemalloc --prefix=/usr
make -j16
make install DESTDIR=${PKG_DIR}


# make control
cat << EOS > ${DEB_DIR}/control
Package: ${NAME}
Maintainer: Kitada Shyunya <syun.kitada@gmail.com>
Architecture: amd64
Version: ${VERSION}-${RELEASE}
Description: ${NAME}
EOS


# build deb
cd $WORK_DIR
fakeroot dpkg-deb --build $PKG_DIR .

cp *.deb /opt/aptrepo/ubuntu/${OS_RELEASE}/amd64/pool

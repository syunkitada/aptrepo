#!/bin/sh -xe

BASE_DIR=/tmp/base/
NAME=$1
VERSION=$2
RELEASE=0
WORK_DIR=/tmp/work
PKG_DIR=$WORK_DIR/pkg
DEB_DIR=$PKG_DIR/DEBIAN

mkdir -p $DEB_DIR
cd $WORK_DIR

apt-get update
apt-get install -y libnetcf-dev libdbus-1-dev libdevmapper-dev libgcc-5-dev libgnutls-dev \
                   libnl-3-dev libnl-cli-3-dev libnl-genl-3-dev libnl-idiag-3-dev libnl-nf-3-dev libnl-route-3-dev \
                   libnl-xfrm-3-dev libnlopt-dev libnuma-dev libsasl2-dev libssh2-1-dev libxml2-dev libxml2-utils \
                   libsystemd-dev libyajl-dev libpciaccess-dev libsystemd-dev python-dev autopoint gettext \
                   xsltproc libavahi-client-dev libcap-ng-dev libiscsi-dev open-iscsi parted libparted-dev lvm2 \
                   policykit-1 libpolkit-agent-1-dev libmatepolkit-dev libpolkit-qt5-1-dev

wget https://libvirt.org/sources/libvirt-${VERSION}.tar.xz
tar xf libvirt-${VERSION}.tar.xz
cd libvirt-${VERSION}
./autogen.sh
./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
            --with-qemu \
            --with-sasl \
            --with-avahi \
            --with-polkit \
            --with-libvirtd \
            --without-xenapi \
            --without-vz \
            --without-bhyve \
            --with-interface \
            --with-network \
            --with-storage-fs \
            --with-storage-lvm \
            --with-storage-iscsi \
            --with-storage-scsi \
            --with-storage-disk \
            --with-storage-mpath \
            --without-storage-vstorage \
            --with-numactl \
            --with-capng \
            --with-netcf \
            --without-selinux \
            --without-apparmor \
            --without-hal \
            --with-udev \
            --with-init-script=systemd \
make -j16 V=1
make install DESTDIR=/tmp/work/pkg SYSTEMD_UNIT_DIR=/lib/systemd/system/ V=1
make -C examples distclean V=1

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

cp *.deb /opt/aptrepo/ubuntu/16/amd64/pool

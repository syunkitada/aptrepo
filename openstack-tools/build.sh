#!/bin/sh -xe

BASE_DIR=/tmp/base/
NAME=$1
VERSION_NAME=$2
VERSION=$3
RELEASE=`date +"%Y%m%d"`
WORK_DIR=/tmp/work
PKG_DIR=$WORK_DIR/pkg
DEB_DIR=$PKG_DIR/DEBIAN

mkdir -p $DEB_DIR
mkdir -p $PKG_DIR/var/lib/${NAME}
mkdir -p $PKG_DIR/var/log/${NAME}
cd $WORK_DIR

virtualenv $PKG_DIR/opt/$NAME
$PKG_DIR/opt/${NAME}/bin/pip install -r $BASE_DIR/pike-requirements.txt

cd $PKG_DIR/opt/${NAME}
find ./ -name '*.pyc' | xargs rm -f || echo 'no *.pyc'
sed -i "s/\/tmp\/work\/pkg//g" bin/*


mkdir -p $PKG_DIR/usr/bin/
cd $PKG_DIR/usr/bin/
ln -s ../../opt/bin/openstack
ln -s ../../opt/bin/uwsgi


cat << EOS > $DEB_DIR/control
Package: ${NAME}
Maintainer: Kitada Shyunya <syun.kitada@gmail.com>
Architecture: amd64
Version: ${VERSION}-${RELEASE}
Description: ${NAME}
EOS

cd $WORK_DIR
fakeroot dpkg-deb --build $PKG_DIR .

cp *.deb /opt/aptrepo/ubuntu/16/amd64/pool

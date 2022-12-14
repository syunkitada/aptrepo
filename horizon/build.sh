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


# make /opt/$NAME
virtualenv ${PKG_DIR}/opt/${NAME}
${PKG_DIR}/opt/${NAME}/bin/pip install -r ${BASE_DIR}/pike-requirements.txt

wget https://github.com/openstack/${NAME}/archive/${VERSION}.tar.gz
tar -xf ${VERSION}.tar.gz
cd ${NAME}-${VERSION}
git config --global user.name "nobody"
git config --global user.email "nobody@example.com"
git init
git add .
git commit -m ${VERSION}
git tag -a ${VERSION} -m ${VERSION}
${PKG_DIR}/opt/${NAME}/bin/python setup.py install

mkdir -p ${PKG_DIR}/opt/${NAME}/share/horizon
cp -r openstack_dashboard ${PKG_DIR}/opt/${NAME}/share/horizon/
cp -r manage.py ${PKG_DIR}/opt/${NAME}/share/horizon/

cd ${PKG_DIR}/opt/${NAME}/share/horizon/
${PKG_DIR}/opt/${NAME}/bin/python manage.py collectstatic --noinput
${PKG_DIR}/opt/${NAME}/bin/python manage.py compress --force
cd ${PKG_DIR}/opt/${NAME}/share/horizon/openstack_dashboard/local/
ln -s ../../../../../../etc/horizon/local_settings.py local_settings.py

cd ${PKG_DIR}/opt/${NAME}
find ./ -name '*.pyc' | xargs rm -f || echo 'no *.pyc'
sed -i "s/\/tmp\/work\/pkg//g" bin/*


# make system
mkdir -p ${PKG_DIR}/lib/systemd
cp -r ${BASE_DIR}/system ${PKG_DIR}/lib/systemd


# make etc and conffiles
mkdir -p ${PKG_DIR}/etc/${NAME}
cp -r ${BASE_DIR}/etc/* ${PKG_DIR}/etc/${NAME}
cp -r ${WORK_DIR}/${NAME}-${VERSION}/openstack_dashboard/local/local_settings.py.example ${PKG_DIR}/etc/${NAME}/local_settings.py

for file in `find ${PKG_DIR}/etc/${NAME} -type f | awk -F "${PKG_DIR}" '{print $2}'`; do echo "${file}" >> ${DEB_DIR}/conffiles; done
cat ${DEB_DIR}/conffiles


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

cp *.deb /opt/aptrepo/ubuntu/16/amd64/pool

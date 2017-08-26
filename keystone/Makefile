pike:
	sudo docker run \
	-v ${PWD}:/tmp/base -v /opt/aptrepo/ubuntu/16/amd64/pool:/opt/aptrepo/ubuntu/16/amd64/pool \
	syunkitada/ubuntu16-deb-builder:latest /tmp/base/build.sh keystone pike 12.0.0.0rc2
	cp /opt/aptrepo/ubuntu/16/amd64/pool/keystone_12.0.0.0* ../ubuntu/16/amd64/pool
	apt-ftparchive packages ../ubuntu/16/amd64/pool | gzip | sudo dd of=../ubuntu/16/amd64/Packages.gz bs=1M

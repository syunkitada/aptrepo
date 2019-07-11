4.1.0:
	sudo docker run \
	-v ${PWD}:/tmp/base -v /opt/aptrepo/ubuntu/16/amd64/pool:/opt/aptrepo/ubuntu/16/amd64/pool \
	syunkitada/ubuntu16-deb-builder:latest /tmp/base/build.sh libvirt 4.1.0
	cp /opt/aptrepo/ubuntu/16/amd64/pool/libvirt_4.1.0* ../ubuntu/16/amd64/pool
	cd ../ubuntu/16/amd64/ && apt-ftparchive packages pool | gzip | dd of=Packages.gz bs=1M

5.5.0:
	sudo docker run \
	-v ${PWD}:/tmp/base -v /opt/aptrepo/ubuntu/16/amd64/pool:/opt/aptrepo/ubuntu/16/amd64/pool \
	syunkitada/ubuntu16-deb-builder:latest /tmp/base/build.sh libvirt 5.5.0
	cp /opt/aptrepo/ubuntu/16/amd64/pool/libvirt_5.5.0* ../ubuntu/16/amd64/pool
	cd ../ubuntu/16/amd64/ && apt-ftparchive packages pool | gzip | dd of=Packages.gz bs=1M

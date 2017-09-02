pike:
	sudo docker run \
	-v ${PWD}:/tmp/base -v /opt/aptrepo/ubuntu/16/amd64/pool:/opt/aptrepo/ubuntu/16/amd64/pool \
	syunkitada/ubuntu16-deb-builder:latest /tmp/base/build.sh cinder pike 11.0.0
	cp /opt/aptrepo/ubuntu/16/amd64/pool/cinder_11.0.0* ../ubuntu/16/amd64/pool
	cd ../ubuntu/16/amd64/ && apt-ftparchive packages pool | gzip | dd of=Packages.gz bs=1M

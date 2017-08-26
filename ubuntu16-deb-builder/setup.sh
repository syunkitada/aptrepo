#!/bin/bash -xe

apt-get update
apt-get install -y build-essential devscripts git wget
apt-get install -y libssl-dev libxml2-dev libxslt-dev libffi-dev liberasurecode-dev
apt-get install -y python libpython-dev python-pip

pip install virtualenv

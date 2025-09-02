#!/bin/bash

tar_name=$1
version=$2
architecture=$3

source_code=$(basename "$PWD")

chmod +x CI/install_libiio.sh && ./CI/install_libiio.sh
sudo mkdir /usr/share/desktop-directories/
sudo apt update
sudo apt install -y build-essential make devscripts debhelper python3-gi-cairo

#Replace placeholders inside the debian template files
sed -i "s/@VERSION@/$version/" packaging/debian/changelog
sed -i "s/@DATE@/$(date -R)/" packaging/debian/changelog
sed -i "s/@ARCHITECTURE@/$architecture/" packaging/debian/control

cp -r packaging/debian .
chmod +x debian/rules

pushd ..
tar czf $tar_name $source_code

popd
debuild

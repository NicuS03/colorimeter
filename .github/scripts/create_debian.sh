#!/bin/bash

version=$1
architecture=$2

source_code=$(basename "$PWD")

sudo apt update
sudo apt install -y build-essential make devscripts debhelper pybuild-plugin-pyproject

#Replace placeholders inside the debian template files
sed -i "s/@VERSION@/$version-1/" packaging/debian/changelog
sed -i "s/@DATE@/$(date -R)/" packaging/debian/changelog
sed -i "s/@ARCHITECTURE@/$architecture/" packaging/debian/control

cp -r packaging/debian .
chmod +x debian/rules

pushd ..
tar czf $source_code\_$version.orig.tar.gz $source_code

popd
debuild

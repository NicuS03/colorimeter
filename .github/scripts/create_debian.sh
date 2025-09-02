#!/bin/bash

version=$1
architecture=$2

source_code=$(basename "$PWD")

sudo apt update
sudo apt install -y build-essential make devscripts debhelper pybuild-plugin-pyproject python3 python3-gi-cairo libaio1 policykit-1 libserialport0

#Replace placeholders inside the debian template files
sed -i "s/@VERSION@/$version-1/" packaging/debian/changelog
sed -i "s/@DATE@/$(date -R)/" packaging/debian/changelog
sed -i "s/@ARCHITECTURE@/$architecture/" packaging/debian/control

cp -r packaging/debian .
chmod +x debian/rules

pushd ..
tar czf $source_code\_$version.orig.tar.gz $source_code
wget -qO- "https://api.github.com/repos/analogdevicesinc/libiio/releases/latest"   | grep "browser_download_url" | grep -Eo '"https.*(Ubuntu-22|arm).*deb"$' | xargs -n 1 wget -q
for file in *.deb; do
    dpkg -I $file | grep -q "Architecture: $architecture" && echo "Installing libiio $file" && sudo dpkg -i $file && break
done
popd

debuild

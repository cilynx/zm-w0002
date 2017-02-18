#!/bin/bash

# Mostly "borrowed" from http://nemon.org/ipcam-ipr1631x/#SDK

if [ ! -f Hi3518_SDK_V1.0.7.0.tgz ]
then
   echo "Download SDK from https://mega.co.nz/#!69tXHCAD!spJmcKzH3WUmOOyTMVxIc07N4m6Bu8m3ziDhURaKjgM then rerun this script."
   exit
fi

# Extract the archive
tar xzf Hi3518_SDK_V1.0.7.0.tgz

# Specify bash as many modern systems default to dash, which doesn't work
sed -i 's/bin\/sh/bin\/bash/' Hi3518_SDK_V1.0.7.0/sdk.unpack

# Unpack the SDK
cd Hi3518_SDK_V1.0.7.0 && ./sdk.unpack

# Install the toolchain
cd osdrv/toolchain/arm-hisiv100nptl-linux && chmod +x cross.install && ./cross.install

# Add the toolchain to $PATH
echo "export PATH=/opt/hisi-linux-nptl/arm-hisiv100-linux/target/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

# Test the toolchain
cd ../../../mpp2/sample/ && make

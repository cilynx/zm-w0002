#!/bin/bash

if ! command -v arm-hisiv100nptl-linux-gcc > /dev/null
then
   echo "Please install arm-hisiv100nptl-linux toolchain, then re-run this script."
fi

if [ ! -f dropbear-2016.74.tar.bz2 ]
then
   wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2016.74.tar.bz2
fi

if [ ! -d dropbear-2016.74 ]
then
   bzip2 -cd dropbear-2016.74.tar.bz2 | tar xvf -
fi

cd dropbear-2016.74/ && ./configure --host=arm-hisiv100nptl-linux --prefix=/ --disable-zlib CC=arm-hisiv100nptl-linux-gcc LD=arm-hisiv100nptl-linux-ld && make PROGRAMS="dropbear dbclient scp" MULTI=1

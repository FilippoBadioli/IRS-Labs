#!/bin/bash

set -e

echo "=== UPDATE ==="
sudo apt update

echo "=== INSTALL BASE DEPENDENCIES ==="
sudo apt install -y \
  build-essential \
  cmake \
  automake \
  libtool \
  pkg-config \
  git \
  g++ \
  python3 \
  python3-pip \
  python-is-python3

echo "=== INSTALL LIBRARIES ==="
sudo apt install -y \
  libgmp-dev \
  libboost-all-dev \
  libevent-dev \
  libssl-dev \
  libpcap-dev \
  libgc-dev \
  libjudy-dev \
  libfl-dev \
  flex \
  bison \
  libnanomsg-dev

echo "=== INSTALL MININET ==="
sudo apt install -y mininet python3-mininet xterm

echo "=== INSTALL PYTHON MODULES ==="
sudo pip3 install psutil thrift

echo "=== INSTALL THRIFT (C++ LIBS) ==="
cd ~
if [ ! -d "thrift" ]; then
  git clone https://github.com/apache/thrift.git
fi
cd thrift
git checkout 0.17.0

./bootstrap.sh
./configure
make -j$(nproc)
sudo make install
sudo ldconfig

echo "=== INSTALL P4C ==="
cd ~
if [ ! -d "p4c" ]; then
  git clone https://github.com/p4lang/p4c.git
fi
cd p4c
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install

echo "=== INSTALL BMv2 ==="
cd ~
if [ ! -d "behavioral-model" ]; then
  git clone https://github.com/p4lang/behavioral-model.git
fi
cd behavioral-model

./autogen.sh
./configure
make -j$(nproc)
sudo make install

echo "=== FIX LIBRARY PATH ==="
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/p4.conf
sudo ldconfig

echo "=== INSTALL COMPLETE ==="

echo "Check commands:"
p4c-bm2-ss --version
simple_switch --version
mn --version

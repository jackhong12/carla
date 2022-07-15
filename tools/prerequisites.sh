sudo apt-get update &&
sudo apt install gpg-agent -y &&
sudo apt-get install wget software-properties-common -y &&
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y &&
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - &&
sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main" &&
sudo apt-get update

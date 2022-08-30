#!/bin/bash

echo "=================================================="
echo "    / \  | |   |  ___/ _ \| \ | |/ _ \ \   / / \    ";
echo "   / _ \ | |   | |_ | | | |  \| | | | \ \ / / _ \   ";
echo "  / ___ \| |___|  _|| |_| | |\  | |_| |\ V / ___ \  ";
echo " /_/   \_\_____|_|   \___/|_| \_|\___/  \_/_/   \_\ ";
echo -e "\e[0m"
echo "==================================================" 

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing libssl dan cmake... \e[0m" && sleep 1
# packages
sudo apt-get install libssl-dev
sudo apt install cmake -y
sudo apt-get install build-essential gdb -y

echo -e "\e[1m\e[32m3. Installing Rupstup... \e[0m" && sleep 1
# Instal Rupstup
. <(wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/rust.sh)
source "$HOME/.cargo/env"

echo -e "\e[1m\e[32m4. Clone Repositori... \e[0m" && sleep 1
# download binary
git clone https://github.com/zeeka-network/bazuka && cd bazuka
git pull origin master
cargo install --path .



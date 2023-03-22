#!/bin/bash
#!/bin/bash
merah="\e[31m"
kuning="\e[33m"
hijau="\e[32m"
biru="\e[34m"
UL="\e[4m"
bold="\e[1m"
italic="\e[3m"
reset="\e[m"
echo -e "$bold$italic$biru"
 echo " █████╗ ██╗     ███████╗ ██████╗ ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗  "
echo " ██╔══██╗██║     ██╔════╝██╔═══██╗████╗  ██║██╔═══██╗██║   ██║██╔══██╗ "
echo " ███████║██║     █████╗  ██║   ██║██╔██╗ ██║██║   ██║██║   ██║███████║ "
echo " ██╔══██║██║     ██╔══╝  ██║   ██║██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║ "
echo " ██║  ██║███████╗██║     ╚██████╔╝██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║ "
echo " ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝ "
echo -e "$reset$bold$merah====================>>($hijau https://github.com/Alfonova-Node $merah)<<===================$reset\n"

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export CHAIN_ID=ununifi-beta-v1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "moniker : \e[1m\e[32m$NODENAME\e[0m"
echo -e "wallet  : \e[1m\e[32m$WALLET\e[0m"
echo -e "chain-id: \e[1m\e[32m$BONUS_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
ver="1.19.5" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
git clone https://github.com/UnUniFi/chain ununifi
cd ununifi
git checkout v1.0.0-beta.4
make install

# config
ununifid config chain-id $CHAIN_ID
bonus-blockd config keyring-backend test

# init
ununifid init $NODENAME --chain-id $CHAIN_ID

# download genesis and addrbook
curl https://anode.team/UnUniFi/main/genesis.json > ~/.ununifi/config/genesis.json
curl https://anode.team/UnUniFi/main/addrbook.json > ~/.ununifi/config/addrbook.json

# set peers and seeds
SEEDS="fa38d2a851de43d34d9602956cd907eb3942ae89@a.ununifi.cauchye.net:26656,404ea79bd31b1734caacced7a057d78ae5b60348@b.ununifi.cauchye.net:26656,1357ac5cd92b215b05253b25d78cf485dd899d55@[2600:1f1c:534:8f02:7bf:6b31:3702:2265]:26656,25006d6b85daeac2234bcb94dafaa73861b43ee3@[2600:1f1c:534:8f02:a407:b1c6:e8f5:94b]:26656,caf792ed396dd7e737574a030ae8eabe19ecdf5c@[2600:1f1c:534:8f02:b0a4:dbf6:e50b:d64e]:26656,796c62bb2af411c140cf24ddc409dff76d9d61cf@[2600:1f1c:534:8f02:ca0e:14e9:8e60:989e]:26656,cea8d05b6e01188cf6481c55b7d1bc2f31de0eed@[2600:1f1c:534:8f02:ba43:1f69:e23a:df6b]:26656"
PEERS=""
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ununifi/config/config.toml

# set minimum gas price and timeout commit
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uguu\"/" $HOME/.ununifi/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.ununifi/config/config.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/ununifid.service > /dev/null <<EOF
[Unit]
Description=UnUniFi
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ununifid) start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload && sudo systemctl enable ununifid
sudo systemctl restart ununifid && journalctl -fu ununifid -o cat

echo '=============== SETUP FINISHED ==================='

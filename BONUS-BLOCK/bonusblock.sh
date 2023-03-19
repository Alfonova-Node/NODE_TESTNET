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
echo "export BONUS_CHAIN_ID=blocktopia-01" >> $HOME/.bash_profile
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
cd $HOME
git clone https://github.com/BBlockLabs/BonusBlock-chain
cd BonusBlock-chain
make build

# config
bonus-blockd config chain-id blocktopia-01
bonus-blockd config keyring-backend test

# init
bonus-blockd init $NODENAME --chain-id blocktopia-01

# download genesis and addrbook
rm ~/.bonusblock/config/genesis.json
curl https://bonusblock-testnet.alter.network/genesis? | jq '.result.genesis' > ~/.bonusblock/config/genesis.json

# set peers and seeds
PEERS="$(curl -sS https://rpc-bonusblock.sxlzptprjkt.xyz/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.bonusblock/config/config.toml


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bonusblock/config/app.toml

# set minimum gas price and timeout commit
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ubonus\"/" $HOME/.bonusblock/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.bonusblock/config/config.toml

# reset


echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/bonus-blockd.service > /dev/null <<EOF
[Unit]
Description=bonus
After=network-online.target

[Service]
User=$USER
ExecStart=$(which bonus-blockd) start --home $HOME/.bonusblock
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable bonus-blockd
sudo systemctl restart bonus-blockd
sudo journalctl -fu bonus-blockd -o cat

echo '=============== SETUP FINISHED ==================='

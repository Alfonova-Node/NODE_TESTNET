
<p align="center">
  <img height="200" height="auto" src="https://user-images.githubusercontent.com/50621007/192454529-b8070948-6592-4022-96d9-b2adf7169243.png">
</p>

# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export NOIS_CHAIN_ID=nois-testnet-002" >> $HOME/.bash_profile
echo "export NOIS_PORT=${NOIS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

## Download and build binaries
```
cd $HOME
git clone https://github.com/noislabs/full-node.git 
cd full-node/full-node/
./setup.sh
mv out/noisd $HOME/go/bin/
```

## Config app
```
noisd config chain-id $NOIS_CHAIN_ID
noisd config keyring-backend test
noisd config node tcp://localhost:${NOIS_PORT}657
```

## Init app
```
noisd init $NODENAME --chain-id $NOIS_CHAIN_ID
```

## Download genesis and addrbook
```
wget -qO $HOME/.noisd/config/genesis.json "https://raw.githubusercontent.com/noislabs/testnets/main/nois-testnet-002/genesis.json"
```

## Set seeds and peers
```
SEEDS=""
PEERS="a1222dfb8641e0cb55615b75e0122d5695be1f35@node-0.noisdlabs.com:26656,cf16671c00eec9a9a047a5c6aa8510cb681b64b8@node-3.noisdlabs.com:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.noisd/config/config.toml
```

## Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noisd/config/app.toml
```

## Set minimum gas price and timeout commit
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unois\"/" $HOME/.noisd/config/app.toml
```

## Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.noisd/config/config.toml
```

## Reset chain data
```
noisd tendermint unsafe-reset-all --home $HOME/.noisd
```

## Create service
```
sudo tee /etc/systemd/system/noisd.service > /dev/null <<EOF
[Unit]
Description=nois
After=network-online.target

[Service]
User=$USER
ExecStart=$(which noisd) start --home $HOME/.noisd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable noisd
sudo systemctl restart noisd && sudo journalctl -u noisd -f -o cat
```

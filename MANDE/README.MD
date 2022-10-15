<p align="center">
  <img height="300" height="auto" src="https://user-images.githubusercontent.com/44331529/195984832-4b59ffcb-4253-40ee-9168-edc7bfa7425f.png">
</p>

# Auto Install
```bash
wget -O mande.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/MANDE/mande.sh && chmod +x mande.sh && ./mande.sh
```
# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```bash
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```bash
MANDE_PORT=31
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export MANDE_CHAIN_ID=mande-testnet-1" >> $HOME/.bash_profile
echo "export MANDE_PORT=${MANDE_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```bash
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```bash
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
```bash
cd ~
curl -OL https://github.com/mande-labs/testnet-1/raw/main/mande-chaind
mv mande-chaind /$HOME/go/bin/
chmod 744 /$HOME/go/bin/mande-chaind
```
## Create/recover wallet
> Create Wallet
```bash
mande-chaind keys add $WALLET
```
> Recover Wallet
```bash
mande-chaind keys add $WALLET --recover
```

## Config app
```bash
mande-chaind config chain-id $MANDE_CHAIN_ID
mande-chaind config keyring-backend test
mande-chaind config node tcp://localhost:${MANDE_PORT}657
```

## Init app
```bash
mande-chaind init $NODENAME --chain-id $MANDE_CHAIN_ID
```

## Download genesis 
```bash
wget -O $HOME/.mande-chain/config/genesis.json "https://raw.githubusercontent.com/mande-labs/testnet-1/main/genesis.json"
```

## Set up the minimum gas price and Peers/Seeds/Filter peers/MaxPeers
```bash
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0mand\"/;" ~/.mande-chain/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.mande-chain/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.mande-chain/config/config.toml
peers="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656,6780b2648bd2eb6adca2ca92a03a25b216d4f36b@34.170.16.69:26656,a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mande-chain/config/config.toml
seeds="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.mande-chain/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.mande-chain/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.mande-chain/config/config.toml

```

## Set custom ports
```bash
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${MANDE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${MANDE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${MANDE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${MANDE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${MANDE_PORT}660\"%" $HOME/.mande-chain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${MANDE_PORT}317\"%; s%^address = \":8080\"%address = \":${MANDE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${MANDE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${MANDE_PORT}091\"%" $HOME/.mande-chain/config/app.toml
```

## Config pruning
```bash
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.mande-chain/config/app.toml
```
## Indexer
```bash
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mande-chain/config/config.toml
```
## Download addrbook
```bash
wget -O $HOME/.mande-chain/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Mande%20Chain/addrbook.json"
```

## Create service
```bash
sudo tee /etc/systemd/system/mande-chaind.service > /dev/null <<EOF
[Unit]
Description=mande-chaind
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mande-chaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Start Service
```bash
sudo systemctl daemon-reload
sudo systemctl enable mande-chaind
sudo systemctl restart mande-chaind && sudo journalctl -u mande-chaind -f -o cat
```
## StateSync
```bash
SNAP_RPC=http://38.242.199.93:24657
peers="a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.mande-chain/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.mande-chain/config/config.toml

mande-chaind tendermint unsafe-reset-all --home /root/.mande-chain --keep-addr-book
systemctl restart mande-chaind && journalctl -u mande-chaind -f -o cat
```
## Get Faucet
```bash
curl -d '{"address":"YOUR_ADDRESS"}' -H 'Content-Type: application/json' http://35.224.207.121:8080/request
```
## Create Validator
```bash
mande-chaind tx staking create-validator \
  --chain-id $MANDE_CHAIN_ID \
  --amount 0cred \
  --pubkey "$(mande-chaind tendermint show-validator)" \
  --from $WALLET \
  --identity="" \
  --website="" \
  --details="" \
  --moniker $NODENAME \
  --fees 1000mand
  ```
## Node info
Synchronization info
```
mande-chaind status 2>&1 | jq .SyncInfo
```
Validator info
```
mande-chaind status 2>&1 | jq .ValidatorInfo
```
Node info
```
mande-chaind status 2>&1 | jq .NodeInfo
```
Show node id
```
mande-chaind tendermint show-node-id
```
## Delete Node
```bash
sudo systemctl stop mande-chaind && \
sudo systemctl disable mande-chaind && \
rm /etc/systemd/system/mande-chaind.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .mande-chain && \
rm -rf $(which mande-chaind)
```

<p align="center">
  <img height="200" height="auto" src="https://user-images.githubusercontent.com/50621007/169664551-39020c2e-fa95-483b-916b-c52ce4cb907c.png">
</p>

# Sei Node Setup for Testnet — atlantic-1

Dokumen Official :
>- [Validator Setup](https://docs.seinetwork.io/nodes-and-validators/seinami-incentivized-testnet/joining-incentivized-testnet)

Explorer :
>- [Explorer](http://20.42.111.34/))

### Minimum Hardware Requirements
- 3x CPUs; the faster clock speed the better
- 4GB RAM
- 80GB Disk
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 8GB RAM
- 200GB of storage (SSD or NVME)
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set Sei Fullnode
## Auto Install (Option 1)
```
wget -O sei.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/SEI/sei.sh && chmod +x sei.sh && ./sei.sh
```
## Manual Installation (Option 2)
### Server preparation
Updating the repositories
```
sudo apt update && sudo apt upgrade -y
```
Installing the necessary utilities
```
sudo apt install curl build-essential git wget jq make gcc tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```
Build GO (one command)
```
 ver="1.18.1" && \
 wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
 sudo rm -rf /usr/local/go && \
 sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
 rm "go$ver.linux-amd64.tar.gz" && \
 echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
 source $HOME/.bash_profile && \
 go version
 ```
 ### Node installation
 IMPORTANT - currently 1.1.1beta needs to be loaded using snapshot or statesync
 Installing the binaries (18.08.22)
 ```
 git clone https://github.com/sei-protocol/sei-chain.git
cd sei-chain
git checkout master && git pull
git checkout 1.1.1beta
make install
```
```seid version --long | head```
- version: 1.1.1beta
- commit: 9764e4d7b0fdbfacfca446c1a12a75df1693cd02

Initializing the node to create the necessary configuration files
```
seid init <moniker name> --chain-id atlantic-1
```
Downloading Genesis
```
wget -O $HOME/.sei/config/genesis.json "https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-incentivized-testnet/genesis.json"
```
Let's check the genesis
```sha256sum ~/.sei/config/genesis.json```
- 4ae7193446b53d78bb77cab1693a6ddf6c1fe58c9693ed151e71f43956fdb3f7

### Set up Node Configuration
set the minimum price for gas in app.toml
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0usei\"/;" ~/.sei/config/app.toml
```
add seeds/peers to config.toml
```
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.sei/config/config.toml
peers="a37d65086e78865929ccb7388146fb93664223f7@18.144.13.149:26656,8ff4bd654d7b892f33af5a30ada7d8239d6f467b@91.223.3.190:51656,c4e8c9b1005fe6459a922f232dd9988f93c71222@65.108.227.133:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sei/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sei/config/config.toml
```
(OPTIONAL) Set up pruning with one command in app.toml
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.sei/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.sei/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.sei/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.sei/config/app.toml
```
(OPTIONAL) Turn off indexing in config.toml
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.sei/config/config.toml
```
### Create a service file
```
sudo tee /etc/systemd/system/seid.service > /dev/null <<EOF
[Unit]
Description=seid
After=network-online.target
    
[Service]
User=$USER
ExecStart=$(which seid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Download addrbook
```
wget -O $HOME/.agoric/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Sei_Network/addrbook.json"
```
### State Sync
```
SNAP_RPC="https://sei-testnet.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

peers="4b5fb7390e9c64bc96f048816f472f4559fafd94@sei-testnet.nodejumper.io:28656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.sei/config/config.toml

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sei/config/config.toml
seid tendermint unsafe-reset-all --home /root/.sei --keep-addr-book
```
### START SERVICE
```
sudo systemctl daemon-reload && \
sudo systemctl enable seid && \
sudo systemctl restart seid && sudo journalctl -u seid -f -o cat
```
### Create Wallet or Restore Wallet
```
seid keys add <wallet name>
  or
seid keys add <wallet name> --recover
```
### Check Set Wallet
```
seid debug addr <wallet address>
```
Get Faucet Token On Discord 
>- [Discord Official Sei](https://discord.gg/sei)

### Create Validator
```
seid tx staking create-validator \
--chain-id atlantic-1 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.1 \
--min-self-delegation 1 \
--amount 1000000usei \
--pubkey $(seid tendermint show-validator) \
--moniker "<moniker name>" \
--from <wallet name> \
--fees 5550usei
```
### Get list of validators
- For Active Validators
```
seid q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```
seid q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```
journalctl -fu seid -o cat
```
Start service
```
sudo systemctl start seid
```
Stop service
```
sudo systemctl stop seid
```
Restart service
```
sudo systemctl restart seid
```
## Node info
Synchronization info
```
seid status 2>&1 | jq .SyncInfo
```
Validator info
```
seid status 2>&1 | jq .ValidatorInfo
```
Node info
```
seid status 2>&1 | jq .NodeInfo
```
Show node id
```
seid tendermint show-node-id
```
### Wallet operations
List of wallets
```
seid keys list
```
Recover wallet
```
seid keys add <wallet name> --recover
```
Delete wallet
```
seid keys delete <wallet name>
```
Backup Private Key
```
seid keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```
seid query bank balances <wallet address>
```
Transfer funds
```
seid tx bank send <wallet address> <to sei wallet address> 10000000usei
```
Voting
```
seid tx gov vote 1 yes --from <wallet name> --chain-id=atlantic-1
```
### Staking, Delegation and Rewards
Delegate stake
```
seid tx staking delegate <valoper address> 10000000usei --from=<waller name> --chain-id=atlantic-1 --gas=auto
```
Redelegate stake from validator to another validator
```
seid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usei --from=<wallet name> --chain-id=atlantic-1 --gas=auto
```
Withdraw all rewards
```
seid tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=atlantic-1 --gas=auto
```
Withdraw rewards with commision
```
seid tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=atlantic-1
```

### Validator Management
Edit validator
```
seid tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=atlantic-1 \
  --from=<wallet name>
 ```
Unjail validator
```
seid tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=atlantic-1 \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop seid
sudo systemctl disable seid
sudo rm /etc/systemd/system/sei* -rf
sudo rm $(which seid) -rf
sudo rm $HOME/.sei -rf
sudo rm $HOME/sei-chain -rf
sed -i '/SEI_/d' ~/.bash_profile
```


 


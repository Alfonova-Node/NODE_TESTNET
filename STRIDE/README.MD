![stride](https://user-images.githubusercontent.com/44331529/180614293-57dff376-2d34-4480-803a-e8262bf37fdd.png)
[Website](https://stride.zone/)

# stride node setup for testnet — STRIDE-TESTNET-4

Dokumen Official :
>- [Validator Setup](https://github.com/Stride-Labs/testnet)

Explorer :
>- [Explorer Nodes Guru](https://stride.explorers.guru/)

### Minimum Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 8GB RAM
- 80GB Disk
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 32GB RAM
- 200GB of storage (SSD or NVME)
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set Stride Fullnode
## Auto Install (Option 1)
```console
wget -O stride.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/STRIDE/stride.sh && chmod +x stride.sh && ./stride.sh
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
 ver="1.18.3" && \
 wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
 sudo rm -rf /usr/local/go && \
 sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
 rm "go$ver.linux-amd64.tar.gz" && \
 echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
 source $HOME/.bash_profile && \
 go version
 ```
 ### Node installation
Installing the binaries (23.08.22)
 ```console 
git clone https://github.com/Stride-Labs/stride.git && cd stride
git checkout 90859d68d39b53333c303809ee0765add2e59dab
make build
mkdir -p $HOME/go/bin
sudo mv build/strided /root/go/bin/
```
`strided version --long | head`
+ version: v0.4.1

Initializing the node to create the necessary configuration files
```console
strided  init <moniker name> --chain-id STRIDE-TESTNET-4
```
Downloading Genesis
```console
wget -O $HOME/.stride/config/genesis.json "https://raw.githubusercontent.com/Stride-Labs/testnet/main/poolparty/genesis.json"
```
Let's check the genesis
`sha256sum ~/.stride/config/genesis.json`
- a1f56de30c4f88de2fe2fbff1a019583bfc57e9c2c297294ce2c7ec243e46a4e  /root/.stride/config/genesis.json

### Pruning (optional)
```console
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
``` 
### Indexer (optional)
```console
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.stride/config/config.toml
```
### Set up the minimum gas price and Peers/Seeds/Filter peers
```console
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0ustrd\"/;" ~/.stride/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.stride/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.stride/config/config.toml

peers="54a11c47658ebd5dcbd70eb3c62197b439482d3f@116.202.236.115:21016"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stride/config/config.toml

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.stride/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.stride/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.stride/config/config.toml
```
## Download addrbook
```console
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Stride/addrbook.json"
```
# Create a service file
```console
sudo tee /etc/systemd/system/strided.service > /dev/null <<EOF
[Unit]
Description=strided
After=network-online.target

[Service]
User=$USER
ExecStart=$(which strided) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
# StateSync STRIDE
```bash
peers="cf4e629008be3417081395f4ab6f591a74124d90@141.95.124.151:20086"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stride/config/config.toml

SNAP_RPC=141.95.124.151:20087
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
strided tendermint unsafe-reset-all --home $HOME/.stride --keep-addr-book
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
# StateSync GAIA
```console
sudo systemctl stop gaiad
PEERS="f42f1908713b97a2106a0872c7a6dbf64b274a77@141.95.124.151:23656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
SNAP_RPC="141.95.124.151:23657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.gaia/config/config.toml
gaiad tendermint unsafe-reset-all --home $HOME/.gaia --keep-addr-book
sudo systemctl restart gaiad && journalctl -u gaiad -f -o cat
```
# Start node (one command)
```console
sudo systemctl daemon-reload && \
sudo systemctl enable strided && \
sudo systemctl restart strided && \
sudo journalctl -u strided -f -o cat
```
### Create Wallet or Restore Wallet
```
strided keys add <wallet name>
  or
strided keys add <wallet name> --recover
```
### Check Set Wallet
```
strided debug addr <wallet address>
```
Get Faucet Token On Discord 
>- [Discord Official Sei](https://discord.com/invite/GnKmheRDPV)

### Create Validator
 ```console
 strided tx staking create-validator \
 --amount=1000000ustrd \
 --pubkey=$(strided tendermint show-validator) \
 --moniker=<moniker> \
 --chain-id=STRIDE-TESTNET-4 \
 --commission-rate="0.10" \
 --commission-max-rate="0.20" \
 --commission-max-change-rate="0.1" \
 --min-self-delegation="1" \
 --fees=500ustrd \
 --from=<walletName> \
 --identity="" \
 --website="" \
 --details="" \
 -y
```
### Get list of validators
- For Active Validators
```strided q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```
strided q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```
journalctl -fu strided -o cat
```
Start service
```
sudo systemctl start strided
```
Stop service
```
sudo systemctl stop seid
```
Restart service
```
sudo systemctl restart strided
```
## Node info
Synchronization info
```
strided status 2>&1 | jq .SyncInfo
```
Validator info
```
strided status 2>&1 | jq .ValidatorInfo
```
Node info
```
strided status 2>&1 | jq .NodeInfo
```
Show node id
```
strided tendermint show-node-id
```
### Wallet operations
List of wallets
```
strided keys list
```
Recover wallet
```
seid keys add <wallet name> --recover
```
Delete wallet
```
strided keys delete <wallet name>
```
Backup Private Key
```
strided keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```
strided query bank balances <wallet address>
```
Transfer funds
```
strided tx bank send <wallet address> <to sei wallet address> 10000000usei
```
Voting
```
strided tx gov vote 1 yes --from <wallet name> --chain-id=STRIDE-TESTNET-4
```
### Staking, Delegation and Rewards
Delegate stake
```
strided tx staking delegate <valoper address> 10000000ustrd --from=<waller name> --chain-id=STRIDE-TESTNET-4 --gas=auto
```
Redelegate stake from validator to another validator
```
strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=<wallet name> --chain-id=STRIDE-TESTNET-4 --gas=auto
```
Withdraw all rewards
```
strided tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=STRIDE-TESTNET-4 --gas=auto
```
Withdraw rewards with commision
```
strided tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=STRIDE-TESTNET-4
```

### Validator Management
Edit validator
```console
strided tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=atlantic-1 \
  --from=<wallet name>
 ```
Unjail validator
```console
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=atlantic-1 \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```console
sudo systemctl stop strided && \
sudo systemctl disable strided && \
rm /etc/systemd/system/strided.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .stride && \
rm -rf stride && \
rm -rf $(which strided)
```


 


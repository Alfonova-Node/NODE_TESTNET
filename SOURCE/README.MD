>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
  <img height="100" height="auto" src="https://exp.nodeist.net/logos/src.png">
</p>

Dokumen Official :
>- [Validator Setup](https://docs.sourceprotocol.io/smart-contracts-and-sourced-development/source-chain-testnet-setup)

Explorer :
>- [Explorer](http://20.42.111.34/)

### Minimum Hardware Requirements
- 2x CPUs; the faster clock speed the better
- 8GB RAM
- 80GB Disk
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 16GB RAM
- 200GB of storage (SSD or NVME)
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set Source Fullnode
## Auto Install (Option 1)
```
wget -O source.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/SOURCE/source.sh && chmod +x source.sh && ./source.sh
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
 Installing the binaries (01.08.22)
 ```console
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git
cd ~/source
make install
```
`sourced version --long | head`
- version: v1.0.0-2-ge06b810
- commit: e06b810e842e57ec8f5432c9cdd57883a69b3cee

Initializing the node to create the necessary configuration files
```
sourced init <moniker-name> --chain-id=sourcechain-testnet
```
Downloading Genesis
```
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/testnets/master/sourcechain-testnet/genesis.json > ~/.source/config/genesis.json
```
Let's check the genesis
`sha256sum $HOME/.source/config/genesis.json`
- 2bf556b50a2094f252e0aac75c8018a9d6c0a77ba64ce39811945087f6a5165d genesis.json

### Set up Node Configuration
Pruning (optional) one command
```console
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
```
Indexer (optional) one command
```console
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.source/config/config.toml
```
### Set up the minimum gas price and Peers/Seeds/Filter peers
```console
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0usource\"/;" ~/.source/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.source/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.source/config/config.toml

peers="6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.source/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.source/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.source/config/config.toml
```
### Download addrbook
```
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Source/addrbook.json"
```
### Create a service file
```console
sudo tee /etc/systemd/system/sourced.service > /dev/null <<EOF
[Unit]
Description=source
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sourced) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### SnapShot 31.08.22 (0.1 GB) block height --> 2139699
```console
# install the node as standard, but do not launch. Then we delete the .data directory and create an empty directory
sudo systemctl stop sourced
rm -rf $HOME/.source/data/
mkdir $HOME/.source/data/

# download archive
cd $HOME
wget http://116.202.236.115:8000/sourcedata.tar.gz

# unpack the archive
tar -C $HOME/ -zxvf sourcedata.tar.gz --strip-components 1
# !! IMPORTANT POINT. If the validator was created earlier. Need to reset priv_validator_state.json  !!
wget -O $HOME/.source/data/priv_validator_state.json "https://raw.githubusercontent.com/obajay/StateSync-snapshots/main/priv_validator_state.json"
cd && cat .source/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}

# after unpacking, run the node
# don't forget to delete the archive to save space
cd $HOME
rm sourcedata.tar.gz
# start the node
sudo systemctl daemon-reload && \
sudo systemctl enable sourced && \
sudo systemctl restart sourced && \
sudo journalctl -u sourced -f -o cat
```
### START SERVICE
```
sudo systemctl daemon-reload && \
sudo systemctl enable sourced && \
sudo systemctl restart sourced && \
sudo journalctl -u sourced -f -o cat
```
### Create Wallet or Restore Wallet
```
sourced keys add <wallet name>
  or
sourced keys add <wallet name> --recover
```
### Check Set Wallet
```
sourced debug addr <wallet address>
```
Get Faucet Token On Discord 
>- [Discord Official Source](https://discord.gg/9Ne9PGzw)

### Create Validator
```console
sourced tx staking create-validator \
--amount=1000000usource \
--pubkey=$(sourced tendermint show-validator) \
--moniker=<moniker> \
--chain-id=sourcechain-testnet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--fees=100usource \
--from=<walletName> \
--identity="" \
--website="" \
--details="" \
-y
```
### Get list of validators
- For Active Validators
```
sourced q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```
sourced q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```
journalctl -fu sourced -o cat
```
Start service
```
sudo systemctl start sourced
```
Stop service
```
sudo systemctl stop sourced
```
Restart service
```
sudo systemctl restart sourced
```
## Node info
Synchronization info
```
sourced status 2>&1 | jq .SyncInfo
```
Validator info
```
seid status 2>&1 | jq .ValidatorInfo
```
Node info
```
sourced status 2>&1 | jq .NodeInfo
```
Show node id
```
sourced tendermint show-node-id
```
### Wallet operations
List of wallets
```
sourced keys list
```
Recover wallet
```
sourced keys add <wallet name> --recover
```
Delete wallet
```
sourced keys delete <wallet name>
```
Backup Private Key
```
sourced keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```
sourced query bank balances <wallet address>
```
Transfer funds
```
sourced tx bank send <wallet address> <to sei wallet address> 10000000usource
```
Voting
```
sourced tx gov vote 1 yes --from <wallet name> --chain-id=sourcechain-testnet
```
### Staking, Delegation and Rewards
Delegate stake
```
sourced tx staking delegate <valoper address> 10000000usource --from=<waller name> --chain-id=sourcechain-testnet --gas=auto
```
Redelegate stake from validator to another validator
```
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=<wallet name> --chain-id=sourcechain-testnet --gas=auto
```
Withdraw all rewards
```
sourced tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=sourcechain-testnet1 --gas=auto
```
Withdraw rewards with commision
```
sourced tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=sourcechain-testnet
```

### Validator Management
Edit validator
```
sourced tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=sourcechain-testnet \
  --from=<wallet name>
 ```
Unjail validator
```
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=sourcechain-testnet \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```console
sudo systemctl stop sourced && \
sudo systemctl disable sourced && \
rm /etc/systemd/system/sourced.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf source.sh \
rm -rf $(which sourced)
```


 


>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
  <img height="100" height="auto" src="https://exp.nodeist.net/logos/tori.jpg">
</p>


Dokumen Official :
>- [Website](https://github.com/TERITORI/teritori-chain/blob/main/testnet/teritori-testnet-v2/README.md)

Explorer :
>- [Explorer](https://teritori.explorers.guru/)

### Minimum Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 4GB RAM
- 100GB Disk
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements
- 8x CPUs; the faster clock speed the better
- 16GB RAM
- 200GB of storage (SSD or NVME)
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set Teritori Fullnode
## Auto Install (Option 1)
```
wget -O teri.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/TERITORI/teri.sh && chmod +x teri.sh && ./teri.sh
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
 Installing the binaries (11.07.22)
 ```
git clone https://github.com/TERITORI/teritori-chain
cd teritori-chain
git checkout teritori-testnet-v2
make install
```
### Teritori Version
```
teritorid version
```
teritori-testnet-v2-0f4e5cb1d529fa18971664891a9e8e4c114456c6

### Initializing the node to create the necessary configuration files
```
teritorid init <moniker-name> --chain-id=teritori-testnet-v2
```
Downloading Genesis
```
wget https://raw.githubusercontent.com/TERITORI/teritori-chain/teritori-testnet-v2/genesis/genesis.json -O $HOME/.teritorid/config/genesis.json
```
### Pruning (optional) one command
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.teritorid/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.teritorid/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.teritorid/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.teritorid/config/app.toml
```
Indexer (optional) one command
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.teritorid/config/config.toml
```
### Set up the minimum gas price and Peers/Seeds/Filter peers
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0utori\"/;" ~/.teritorid/config/app.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.teritorid/config/config.toml

peers="0dde2ae55624d822eeea57d1b5e1223b6019a531@176.9.149.15:26656,4d2ea61e6195ee4e449c1e6132cabce98f7d94e1@5.9.40.222:26656,bceb776975aab62bcfd501969c0e1a2734ed7c2e@176.9.19.162:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.teritorid/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.teritorid/config/config.toml
```
### Download addrbook
```
wget -O $HOME/.teritorid/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Teritori/addrbook.json"
```
### Create a service file
```
sudo tee /etc/systemd/system/teritorid.service > /dev/null <<EOF
[Unit]
Description=Teritorid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which teritorid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### START SERVICE
```
sudo systemctl daemon-reload
sudo systemctl enable teritorid
sudo systemctl restart teritorid
sudo journalctl -u teritorid -f -o cat
```
### Create Wallet or Restore Wallet
```
teritorid keys add <walletname>
teritorid keys add <walletname> --recover
```
### Check Set Wallet
```
teritorid debug addr <wallet address>
```
Get Faucet Token 
>- [Teritori Faucet](https://discord.gg/zzJEmR8nhr)

### Create Validator
```
teritorid tx staking create-validator \
--amount=1000000utori \
--pubkey=$(teritorid tendermint show-validator) \
--moniker="<moniker>" \
--identity="" \
--details="" \
--website="" \
--chain-id="teritori-testnet-v2" \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--fees 500utori \
--from=<walletname> -y
```
### Get list of validators
- For Active Validators
```
teritorid q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```
teritorid q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```
journalctl -fu teritorid -o cat
```
Start service
```
sudo systemctl start teritorid
```
Stop service
```
sudo systemctl stop teritorid
```
Restart service
```
sudo systemctl restart teritorid
```
## Node info
Synchronization info
```
teritorid status 2>&1 | jq .SyncInfo
```
Validator info
```
teritorid status 2>&1 | jq .ValidatorInfo
```
Node info
```
teritorid status 2>&1 | jq .NodeInfo
```
Show node id
```
teritorid tendermint show-node-id
```
### Wallet operations
List of wallets
```
teritorid keys list
```
Recover wallet
```
teritorid keys add <wallet name> --recover
```
Delete wallet
```
teritorid keys delete <wallet name>
```
Backup Private Key
```
teritorid keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```
teritorid query bank balances <wallet address>
```
Transfer funds
```
teritorid tx bank send <wallet address> <to teritori wallet address> 10000000utori
```
Voting
```
teritorid tx gov vote 1 yes --from <wallet name> --chain-id=teritori-testnet-v2
```
### Staking, Delegation and Rewards
Delegate stake
```
teritorid tx staking delegate <valoper address> 10000000utori --from=<waller name> --chain-id=teritori-testnet-v2 --gas=auto
```
Redelegate stake from validator to another validator
```
teritorid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utori --from=<wallet name> --chain-id=teritori-testnet-v2 --gas=auto
```
Withdraw all rewards
```
teritorid tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=teritori-testnet-v2 --gas=auto
```
Withdraw rewards with commision
```
teritorid tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=teritori-testnet-v2
```

### Validator Management
Edit validator
```
teritorid tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=teritori-testnet-v2 \
  --from=<wallet name>
 ```
Unjail validator
```
teritorid tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=teritori-testnet-v2 \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop teritorid && \
sudo systemctl disable teritorid && \
rm /etc/systemd/system/teritorid.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .teritorid && \
rm -rf teritori-chain && \
rm -rf $(which teritorid)
rm -rf teri.sh
```


 


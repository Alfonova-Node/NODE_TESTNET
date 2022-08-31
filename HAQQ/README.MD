<p align="center">
  <img height="200" height="auto" src="https://user-images.githubusercontent.com/44331529/185350224-62b92bc1-bd4e-4ce7-a56b-0abfc631c95c.png">
</p>


Dokumen Official :
>- [Website](https://islamiccoin.net/)

Explorer :
>- [Explorer](https://explorer.nodestake.top/haqq-testedge/staking)

### Minimum Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 4GB RAM
- 80GB Disk
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements
- 4x CPUs; the faster clock speed the better
- 8GB RAM
- 200GB of storage (SSD or NVME)
- Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set Haqq Fullnode
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
 cd $HOME && \
git clone -b v1.0.3 https://github.com/haqq-network/haqq && \
cd haqq && \
make install
```
`haqqd -v`
- version: 1.0.3
- commit: 58215364d5be4c9ab2b17b2a80cf89f10f6de38a

Initializing the node to create the necessary configuration files
```
haqqd init <moniker-name> --chain-id=haqq_53211-1
```
Downloading Genesis
```
curl -OL https://storage.googleapis.com/haqq-testedge-snapshots/genesis.json
mv genesis.json $HOME/.haqqd/config/genesis.json
```
Let's check the genesis
`sha256sum $HOME/.haqqd/config/genesis.json`
- 9a7746dd6d4cc1e29f8a67759d90ef37af8bc78a7be3dd94538e94f42bc1f646 genesis.json

### Pruning (optional) one command
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.haqqd/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.haqqd/config/app.toml
```
Indexer (optional) one command
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.haqqd/config/config.toml
```
### Set up the minimum gas price and Peers/Seeds/Filter peers
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/;" ~/.haqqd/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.haqqd/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.haqqd/config/config.toml

peers="e15e1867f68011f80f2763e6691c89c923bf2f24@78.46.16.236:41656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.haqqd/config/config.toml

seeds="74d8f92c37ffe4c6393b3718ca531da8f0bf0594@seed1.haqqd.services:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.haqqd/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.haqqd/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.haqqd/config/config.toml
```
### Download addrbook
```
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/haqq/addrbook.json"
```
### Create a service file
```
sudo tee /etc/systemd/system/haqqd.service > /dev/null <<EOF
[Unit]
Description=haqqd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which haqqd) start
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

### START SERVICE
```
sudo systemctl daemon-reload && \
sudo systemctl enable haqqd && \
sudo systemctl restart haqqd && \
sudo journalctl -u haqqd -f -o cat
```
### Create Wallet or Restore Wallet
```
haqqd keys add <wallet name>
  or
haqqd keys add <wallet name> --recover
```
### Check Set Wallet
```
haqqd debug addr <wallet address>
```
Get Faucet Token 
>- [ISLM Testnet Faucet](https://testedge.haqq.network/)

### Create Validator
```
haqqd tx staking create-validator \
--amount 1000000000000000000aISLM \
--from <walletName> \
--commission-max-change-rate "0.10" \
--commission-max-rate "0.20" \
--commission-rate "0.10" \
--min-self-delegation "1" \
--identity="" \
--details="" \
--website="" \
--pubkey $(haqqd tendermint show-validator) \
--moniker <Moniker> \
--chain-id haqq_53211-1 \
-y
```
### Get list of validators
- For Active Validators
```
haqqd q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```
haqqd q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```
journalctl -fu haqqd -o cat
```
Start service
```
sudo systemctl start haqqd
```
Stop service
```
sudo systemctl stop haqqd
```
Restart service
```
sudo systemctl restart haqqd
```
## Node info
Synchronization info
```
haqqd status 2>&1 | jq .SyncInfo
```
Validator info
```
haqqd status 2>&1 | jq .ValidatorInfo
```
Node info
```
haqqd status 2>&1 | jq .NodeInfo
```
Show node id
```
haqqd tendermint show-node-id
```
### Wallet operations
List of wallets
```
haqqd keys list
```
Recover wallet
```
haqqd keys add <wallet name> --recover
```
Delete wallet
```
haqqd keys delete <wallet name>
```
Backup Private Key
```
haqqd keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```
haqqd query bank balances <wallet address>
```
Transfer funds
```
haqqd tx bank send <wallet address> <to sei wallet address> 10000000aISLM
```
Voting
```
haqqd tx gov vote 1 yes --from <wallet name> --chain-id=haqq_53211-1
```
### Staking, Delegation and Rewards
Delegate stake
```
haqqd tx staking delegate <valoper address> 10000000aISLM --from=<waller name> --chain-id=haqq_53211-1--gas=auto
```
Redelegate stake from validator to another validator
```
haqqd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000aISLM --from=<wallet name> --chain-id=haqq_53211-1 --gas=auto
```
Withdraw all rewards
```
haqqd tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=haqq_53211-1 --gas=auto
```
Withdraw rewards with commision
```
haqqd tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=haqq_53211-1
```

### Validator Management
Edit validator
```
haqqd tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=haqq_53211-1 \
  --from=<wallet name>
 ```
Unjail validator
```
haqqd tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=haqq_53211-1 \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop haqqd && \
sudo systemctl disable haqqd && \
rm /etc/systemd/system/haqqd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .haqqd && \
rm -rf haqq && \
rm -rf haqq.sh \
rm -rf $(which haqqd)
```


 


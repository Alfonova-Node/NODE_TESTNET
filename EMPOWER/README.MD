<p align="center">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/44331529/193969092-38e7ec7f-bca0-4bd9-a31d-5ba52b71ec81.png">
</p>

# Empower testnet node setup — altruistic-1

Official documentation:
>- [Validator setup instructions](https://github.com/obajay/nodes-Guides/tree/main/Empower)

Explorer:
>-  https://testnet.ping.pub/empower

## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 3x CPUs; the faster clock speed the better
 - 4GB RAM
 - 100GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 1TB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your nois fullnode
### Option 1 (automatic)
You can setup your nois fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
N/A
```

### Option 2 (manual)
You can follow [manual guide](https://github.com/Agus1224/NODE_TESTNET/blob/main/NOIS/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```bash
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```bash
empowerd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```bash
SNAP_RPC="https://empower-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.empowerchain/config/config.toml
empowerd unsafe-reset-all
systemctl restart empowerd && journalctl -fu empowerd -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```bash
empowerd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```bash
empowerd keys add $WALLET --recover
```

To get current list of wallets
```bash
empowerd keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```bash
EMPOWER_WALLET_ADDRESS=$(empowerd keys show $WALLET -a)
EMPOWER_VALOPER_ADDRESS=$(empowerd keys show $WALLET --bech val -a)
echo 'export NOIS_WALLET_ADDRESS='${EMPOWER_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export EMPOWER_VALOPER_ADDRESS='${EMPOWER_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
To top up your wallet join Empowerchain discord server and navigate to:
- **#faucet** for MPWR tokens

To request a faucet grant:
```
$request <YOUR_WALLET_ADDRESS> altruistic-1
```
### Create validator
Before creating validator please make sure that you have at least 1 mpwr (1 mpwr is equal to 1000000 umpwr) and your node is synchronized

To check your wallet balance:
```
empowerd query bank balances $EMPOWER_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```bash
empowerd tx staking create-validator \
  --amount 100000000umpwr \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(empowerd tendermint show-validator) \
  --moniker $NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id $EMPOWER_CHAIN_ID
```

### Check your validator key
```bash
[[ $(empowerd q staking validator $EMPOWER_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(noisd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```bash
empowerd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu empowerd -o cat
```

Start service
```
sudo systemctl start empowerd
```

Stop service
```
sudo systemctl stop empowerd
```

Restart service
```
sudo systemctl restart empowerd
```

### Node info
Synchronization info
```
empowerd status 2>&1 | jq .SyncInfo
```

Validator info
```
empowerd status 2>&1 | jq .ValidatorInfo
```

Node info
```
empowerd status 2>&1 | jq .NodeInfo
```

Show node id
```
empowerd tendermint show-node-id
```

### Wallet operations
List of wallets
```
empowerd keys list
```

Recover wallet
```
empowerd keys add $WALLET --recover
```

Delete wallet
```
empowerd keys delete $WALLET
```

Get wallet balance
```
empowerd query bank balances $EMPOWER_WALLET_ADDRESS
```

Transfer funds
```
empowerd tx bank send $EMPOWER_WALLET_ADDRESS <TO_EMPOWER_WALLET_ADDRESS> 10000000umpwr
```

### Voting
```bash
empowerd tx gov vote 1 yes --from $WALLET --chain-id=$EMPOWER_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```bash
empowerd tx staking delegate $EMPOWER_VALOPER_ADDRESS 10000000umpwr --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```bash
empowerd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000umpwr --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
empowerd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$EMPOWER_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
empowerd tx distribution withdraw-rewards $EMPOWER_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$EMPOWER_CHAIN_ID
```

### Validator management
Unjail validator
```bash
empowerd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$EMPOWER_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```bash
sudo systemctl stop empowerd && \
sudo systemctl disable empowerd && \
rm /etc/systemd/system/empowerd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .empowerchain && \
rm -rf empowerchain && \
rm -rf $(which empowerd)
```

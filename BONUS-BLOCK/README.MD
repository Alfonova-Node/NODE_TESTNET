
<p align="center">
  <img width="270" height="auto" src="https://user-images.githubusercontent.com/118625308/226153202-b7326561-bb14-4e70-940a-c17eda7702b7.svg">
</p>

### Spesifikasi Hardware :
NODE  | CPU     | RAM      | SSD     |
| ------------- | ------------- | ------------- | -------- |
| Testnet | 4          | 8         | 120  |


### Install otomatis
```
wget -O bonusblock.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/BONUS-BLOCK/bonusblock.sh && chmod +x bonusblock.sh && ./bonusblock.sh
```
### Load variable ke system
```
source $HOME/.bash_profile
```
### SNAPSHOT SETIAP 10 JAM !!!
```bash
sudo apt install lz4 -y
sudo systemctl stop bonus-blockd
cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
rm -rf $HOME/.bonusblock/data
```
```
curl -L https://snapshot.bonusblock.alfonova.app/bonusblock/bonusblock-snapshot-20230320.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.bonusblock
mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json
sudo systemctl restart bonus-blockd && sudo journalctl -fu bonus-blockd -o cat

```

### STATESYNC
```bash
sudo systemctl stop bonus-blockd
cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
bonus-blockd tendermint unsafe-reset-all --home $HOME/.bonusblock --keep-addr-book
```

```bash
SNAP_RPC="https://rpc.bonusblock.alfonova.app:443"
STATESYNC_PEERS="270a59ef701bf0072eaf8e3d537d01773e4f2b8f@206.189.207.57:26656"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.bonusblock/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$STATESYNC_PEERS\"|" $HOME/.bonusblock/config/config.toml

mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json

sudo systemctl restart bonus-blockd && sudo journalctl -fu bonus-blockd -o cat
```

### Informasi node

* cek sync node
```
bonus-blockd status 2>&1 | jq .SyncInfo
```
* cek log node
```
journalctl -fu bonus-blockd -o cat
```
* cek node info
```
bonus-blockd status 2>&1 | jq .NodeInfo
```
* cek validator info
```
bonus-blockd status 2>&1 | jq .ValidatorInfo
```
* cek node id
```
bonus-blockd tendermint show-node-id
```
### Membuat wallet
* wallet baru
```
bonus-blockd keys add $WALLET
```
* recover wallet
```
bonus-blockd keys add $WALLET --recover
```
* list wallet
```
bonus-blockd keys list
```
* hapus wallet
```
bonus-blockd keys delete $WALLET
```
### Simpan informasi wallet
```
BONUS_WALLET_ADDRESS=$(bonus-blockd keys show $WALLET -a)
BONUS_VALOPER_ADDRESS=$(bonus-blockd keys show $WALLET --bech val -a)
echo 'export BONUS_WALLET_ADDRESS='${BONUS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export BONUS_VALOPER_ADDRESS='${BONUS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Membuat validator
* cek balance
```
bonus-blockd query bank balances $BONUS_WALLET_ADDRESS
```
* membuat validator
```
bonus-blockd tx staking create-validator \
  --amount 100000ubonus \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --identity= "" \
  --website= ""\
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(bonus-blockd tendermint show-validator) \
  --moniker $NODENAME \
  --gas=auto \
  --gas-adjustment=1.2 \
  --gas-prices=0.025ubonus \
  --chain-id $BONUS_CHAIN_ID
```
* edit validator
```
bonus-blockd tx staking edit-validator \
  --identity="<your_keybase_id>" \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$BONUS_CHAIN_ID \
  --gas=auto \
  --fees=260000000ubonus \
  --gas-adjustment=1.2 \
```
* unjail validator
```
bonus-blockd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id $BONUS_CHAIN_ID \
  --fees=200000000ubonus \
  --gas-adjustment=1.2 \
  --gas=auto
```
### Voting
```
bonus-blockd tx gov vote 1 yes --from $WALLET --chain-id=$BONUS_CHAIN_ID --gas=auto --fees=2500000ubonus
```
### Delegasi dan Rewards
* delegasi
```
bonus-blockd tx staking delegate $BONUS_VALOPER_ADDRESS 1000000000000ubonus --from=$WALLET --chain-id=$BONUS_CHAIN_ID --gas=auto --fees=250000ubonus
```
* withdraw reward
```
bonus-blockd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$BONUS_CHAIN_ID --gas=auto --fees=2500000ubonus
```
* withdraw reward beserta komisi
```
bonus-blockd tx distribution withdraw-rewards $BONUS_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$BONUS_CHAIN_ID --gas=auto --fees=2500000ubonus
```

### Hapus node
```
sudo systemctl stop bonus-blockd && \
sudo systemctl disable bonus-blockd && \
rm -rf /etc/systemd/system/bonus-blockd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf BonusBlock-chain && \
rm -rf bonus.sh && \
rm -rf .bonusblock && \
rm -rf $(which bonus-blockd)
```

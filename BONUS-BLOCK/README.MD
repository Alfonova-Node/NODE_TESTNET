
<p align="center">
  <img width="270" height="auto" src="https://user-images.githubusercontent.com/118625308/226153202-b7326561-bb14-4e70-940a-c17eda7702b7.svg">
</p>

### Spesifikasi Hardware :
NODE  | CPU     | RAM      | SSD     |
| ------------- | ------------- | ------------- | -------- |
| Testnet | 4          | 8         | 120  |


### Install otomatis
```
wget -O bonus.sh https://raw.githubusercontent.com/dwentz-inc/node-testnet/main/bonus-block/bonus.sh && chmod +x bonus.sh && ./bonus.sh
```
### Load variable ke system
```
source $HOME/.bash_profile
```
### Statesync
```
N/A
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
  --identity "F57A71944DDA8C4B" \
  --website https://dwentz.xyz \
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
  --new-moniker="nama-node" \
  --identity="<your_keybase_id>" \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$BONUS_CHAIN_ID \
  --gas=auto \
  --fees=260000000ubonus \
  --gas-adjustment=1.2 \
  --from=$WALLET
```
* unjail validator
```
bonus-blockd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$BONUS_CHAIN_ID \
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

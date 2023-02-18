<p align="center">
  <img width="340" height="auto" src="https://user-images.githubusercontent.com/108969749/208448900-1cd072da-d0cd-4d3b-b24c-11ae9db0ac76.png">
</p>



### Spesifikasi Hardware :
NODE  | CPU     | RAM      | SSD     |
| ------------- | ------------- | ------------- | -------- |
| Mainnet | 4          | 32         | 1TB  |

### [EXPLORER](https://explorer.alfonova.online/planq)
### Install otomatis
```bash
wget -O planq.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/PLANQ/planq.sh && chmod +x planq.sh && ./planq.sh
```
### Load variable ke system
```
source $HOME/.bash_profile
```
### SNAPSHOT
```bash
sudo systemctl stop planqd
cp $HOME/.planqd/data/priv_validator_state.json $HOME/.planqd/priv_validator_state.json.backup
rm -rf $HOME/.planqd/data

curl -L https://snapshot-planq.alfonova.online/planq/planq-snapshot-20230218.tar.lz4  | lz4 -dc - | tar -xf - -C $HOME/.planqd
mv $HOME/.planqd/priv_validator_state.json.backup $HOME/.planqd/data/priv_validator_state.json

sudo systemctl restart planqd && journalctl -u planqd -f --no-hostname -o cat
```
### Informasi node

   * cek sync node
```
planqd status 2>&1 | jq .SyncInfo
```
   * cek log node
```
journalctl -fu planqd -o cat
```
   * cek node info
```
planqd status 2>&1 | jq .NodeInfo
```
   * cek validator info
```
planqd status 2>&1 | jq .ValidatorInfo
```
  * cek node id
```
planqd tendermint show-node-id
```

### Membuat wallet
   * wallet baru
```
planqd keys add $WALLET
```
   * recover wallet
```
planqd keys add $WALLET --recover
```
   * list wallet
```
planqd keys list
```
   * hapus wallet
```
planqd keys delete $WALLET
```
### Simpan informasi wallet
```
PLANQ_WALLET_ADDRESS=$(planqd keys show $WALLET -a)
```
```
PLANQ_VALOPER_ADDRESS=$(planqd keys show $WALLET --bech val -a)
```
```bash
echo 'export PLANQ_WALLET_ADDRESS='${PLANQ_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export PLANQ_VALOPER_ADDRESS='${PLANQ_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Membuat validator
 * cek balance
```bash
planqd query bank balances $PLANQ_WALLET_ADDRESS
```
 * membuat validator
```bash
planqd tx staking create-validator \
  --amount=1000000000000aplanq \
  --pubkey=$(planqd tendermint show-validator) \
  --moniker=$NODENAME \
  --chain-id=planq_7070-2 \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.05" \
  --min-self-delegation="1000000" \
  --gas="1000000" \
  --gas-prices="30000000000aplanq" \
  --gas-adjustment="1.15" \
  --from=$WALLET
  
```
 * edit validator
```bash
planqd tx staking edit-validator \
  --new-moniker="nama-node" \
  --identity="<your_keybase_id>" \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=planq_7070-2 \
  --gas="1000000" \
  --gas-prices="30000000000aplanq" \
  --identity="" \
  --website="" \
  --details="t"
  --from=$WALLET
```
 ° unjail validator
```bash
planqd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=planq_7070-2 \
  --gas="1000000" \
  --gas-prices="30000000000aplanq"
```
### Voting
```bash
planqd tx gov vote 1 yes --from $WALLET --chain-id=planq_7070-2 --gas=1000000 --gas-prices=30000000000aplanq
```
### Delegasi dan Rewards
  * delegasi
```bash
planqd tx staking delegate $PLANQ_VALOPER_ADDRESS  200000000000000000000aplanq --from=$WALLET --chain-id=planq_7070-2 --gas=1000000 --gas-prices=30000000000aplanq
```
  * withdraw reward
```bash
planqd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=planq_7070-2 --gas=1000000 --gas-prices=30000000000aplanq
```
  * withdraw reward beserta komisi
```bash
planqd tx distribution withdraw-rewards $PLANQ_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=planq_7070-2 --gas=1000000 --gas-prices=30000000000aplanq
```

### Hapus node
```bash
sudo systemctl stop planqd && \
sudo systemctl disable planqd && \
rm /etc/systemd/system/planqd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf planq && \
rm -rf planq.sh && \
rm -rf .planqd && \
rm -rf $(which planqd)

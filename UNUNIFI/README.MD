## Auto Install
```
wget -O ununifi.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/UNUNIFI/ununifi.sh && chmod +x ununifi.sh && ./ununifi.sh
```
## Load variable ke system
```
source $HOME/.bash_profile
```

 ## State-Sync
```bash
sudo systemctl stop ununifid
cp $HOME/.ununifi/data/priv_validator_state.json $HOME/.ununifi/priv_validator_state.json.backup
ununifid tendermint unsafe-reset-all --home $HOME/.ununifi --keep-addr-book
```
```bash
SNAP_RPC="https://rpc.ununifi.alfonova.app:443"
STATESYNC_PEERS="35c8edb779e976b1049659e797389aa70113f219@139.59.226.146:26656"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.ununifi/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$STATESYNC_PEERS\"|" $HOME/.ununifi/config/config.toml

mv $HOME/.ununifi/priv_validator_state.json.backup $HOME/.ununifi/data/priv_validator_state.json

sudo systemctl restart ununifid && sudo journalctl -fu ununifid -o cat
```

## SnapShot (2 times a day)
```bash
sudo systemctl stop ununifid && \
cp $HOME/.ununifi/data/priv_validator_state.json $HOME/.ununifi/priv_validator_state.json.backup && \
rm -rf $HOME/.ununifi/data/
```
```bash
curl -L https://snapshot.ununifi.alfonova.app/ununifi/ununifi-snapshot-20230322.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.ununifi
```
```bash
mv $HOME/.ununifi/priv_validator_state.json.backup $HOME/.ununifi/data/priv_validator_state.json && \
sudo systemctl restart ununifid && journalctl -fu ununifid -o cat
```
##  Informasi Node
### cek sync node
```
ununifid status 2>&1 | jq .SyncInfo
```
### cek log node
```
journalctl -fu ununifid -o cat
```
### cek node info
```
ununifid status 2>&1 | jq .NodeInfo
```
### cek validator info
```
ununifid status 2>&1 | jq .ValidatorInfo
```
### cek node id
```
ununifid tendermint show-node-id
```
## Make Wallet
### New Wallet
```
ununifid keys add $WALLET
```
## Recover Wallet
```
ununifid keys add $WALLET --recover
```
### List Wallet
```
ununifid keys list
```
## Delete Wallet
```
ununifid keys delete $WALLET
```
## Save Information Wallet
```bash
WALLET_ADDRESS=$(ununifid keys show $WALLET -a)
ALOPER_ADDRESS=$(ununifid keys show $WALLET --bech val -a)
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Make Validator

### Check Balance
```
ununifid query bank balances $WALLET_ADDRESS
```
### Create Validator
```bash
ununifid tx staking create-validator \
  --amount=1000000uguu \
  --pubkey=$(ununifid tendermint show-validator) \
  --moniker $NODENAME \
  --identity="<identity>" \
  --website="<website>" \
  --details="<details>" \
  --security-contact="<contact>" \
  --chain-id $CHAIN_ID \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --fees="500uguu" \
  --from $WALLET
  ```
### Edit Validator
```bash
ununifid tx staking edit-validator \
  --identity="<your_keybase_id>" \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id CHAIN_ID \
  --gas=auto \
  --fees="500uguu" \
  --gas-adjustment=1.2 \
  ```
### Unjail Validator
```bash
ununifid tx slashing unjail \
  --broadcast-mode=block \
  --from $WALLET \
  --chain-id HAIN_ID \
  --fees="500uguu" \
  --gas-adjustment=1.2 \
  --gas=auto
  ```
## Remove Node
```bash
sudo systemctl stop ununifid && \
sudo systemctl disable ununifid && \
rm -rf /etc/systemd/system/ununifid.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf BonusBlock-chain && \
rm -rf ununifi.sh && \
rm -rf .ununifi && \
rm -rf $(which ununifid)
```

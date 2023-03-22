## Auto Install
```
wget -O ununifi.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/UNUNIFI/ununifi.sh && chmod +x ununifi.sh && ./ununifi.sh
```

## Install last binary

```bash
git clone https://github.com/UnUniFi/chain ununifi
cd ununifi
git checkout v1.0.0-beta.4
make install

```
## Init the config files

```bash
ununifid init <moniker> --chain-id ununifi-beta-v1
ununifid config chain-id ununifi-beta-v1
```
## Create a wallet and import
```
ununifid keys add <wallet_name>
```
```
ununifid keys add <wallet_name> --recover
```
## Download genesis and addrbook
```bash
curl https://anode.team/UnUniFi/main/genesis.json > ~/.ununifi/config/genesis.json
curl https://anode.team/UnUniFi/main/addrbook.json > ~/.ununifi/config/addrbook.json
```
## Add peers, seed
```bash
SEEDS="fa38d2a851de43d34d9602956cd907eb3942ae89@a.ununifi.cauchye.net:26656,404ea79bd31b1734caacced7a057d78ae5b60348@b.ununifi.cauchye.net:26656,1357ac5cd92b215b05253b25d78cf485dd899d55@[2600:1f1c:534:8f02:7bf:6b31:3702:2265]:26656,25006d6b85daeac2234bcb94dafaa73861b43ee3@[2600:1f1c:534:8f02:a407:b1c6:e8f5:94b]:26656,caf792ed396dd7e737574a030ae8eabe19ecdf5c@[2600:1f1c:534:8f02:b0a4:dbf6:e50b:d64e]:26656,796c62bb2af411c140cf24ddc409dff76d9d61cf@[2600:1f1c:534:8f02:ca0e:14e9:8e60:989e]:26656,cea8d05b6e01188cf6481c55b7d1bc2f31de0eed@[2600:1f1c:534:8f02:ba43:1f69:e23a:df6b]:26656"
PEERS=""
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ununifi/config/config.toml
```
## Add min gas
```bash
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uguu\"/" $HOME/.ununifi/config/app.toml
```
## Create the service file
```bash
sudo tee /etc/systemd/system/ununifid.service > /dev/null <<EOF
[Unit]
Description=UnUniFi
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ununifid) start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

## Load service and start
```bash
sudo systemctl daemon-reload && sudo systemctl enable ununifid
sudo systemctl restart ununifid && journalctl -fu ununifid -o cat
```
## Create Validator
```bash
ununifid tx staking create-validator \
  --amount=1000000uguu \
  --pubkey=$(ununifid tendermint show-validator) \
  --moniker="<moniker>" \
  --identity="<identity>" \
  --website="<website>" \
  --details="<details>" \
  --security-contact="<contact>" \
  --chain-id="ununifi-beta-v1" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --fees="500uguu" \
  --from=<wallet_name>
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

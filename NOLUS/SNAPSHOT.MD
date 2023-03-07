# Snapshot
Catch the latest block faster by using our daily snapshots.



# Instructions

```bash
Stop the service and reset the data
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
```


# Download latest snapshot

```bash
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
```

```bash
curl -L https://snapshot.nolus.alfonova.app/nolus/nolus-snapshot-20230307.tar.lz4  | lz4 -dc - | tar -xf - -C $HOME/.nolus
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl restart nolus && journalctl -u nolusd -f --no-hostname -o cat
```

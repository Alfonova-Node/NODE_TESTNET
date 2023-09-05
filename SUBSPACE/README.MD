>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">

## Hardware requirements
The following requirements are recommended for running :

## 4 or more physical CPU cores
At least 200GB of SSD disk storage
At least 8GB of memory (RAM)
SWAP: 4 GB (RAM)
At least 100mbps network bandwidth

# Create Polkadot.js wallet
To create polkadot wallet:

>- Download and install > [Browser Extension](https://polkadot.js.org/extension)
Navigate to Subspace Explorer and press Add account button
Save mnemonic and create wallet
This will generate wallet address that you will have to use later. Example of wallet address: st7QseTESMmUYcT5aftRJZ3jg357MsaAa93CFQL5UKsyGEk53
NODE
Package
```
sudo apt update && sudo apt install curl -y
sudo apt update && sudo apt install ocl-icd-opencl-dev libopencl-clang-dev libgomp1 -y
```


## Vars Input Your_Nodename & Wallet_address
```
NODENAME=<YOUR_NODENAME>
WALLET_ADDRESS=<YOUR_WALLET_ADDRESS>
PLOT_SIZE=100G
```


## Import

```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET_ADDRESS=$WALLET_ADDRESS" >> $HOME/.bash_profile
echo "export PLOT_SIZE=$PLOT_SIZE" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

Binary
```cd $HOME
rm -rf subspace-*
wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-3f-2023-aug-31/subspace-node-ubuntu-x86_64-skylake-gemini-3f-2023-aug-31
chmod +x subspace-*
mv subspace-* /usr/local/bin/
```

# Service Subspace Node

```
tee $HOME/subspaced.service > /dev/null <<EOF
[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain gemini-3f --execution wasm --state-pruning archive --validator --name $NODENAME
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
mv $HOME/subspaced.service /etc/systemd/system/
```

# Start
```
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced
sudo systemctl restart subspaced
```

# Cek Node status
```
service subspaced status
```
Cek Logs
```
journalctl -u subspaced -f -o cat
```
## FARMER
Strong Hardware - High Reward
Binary

```wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-3f-2023-aug-31/subspace-farmer-ubuntu-x86_64-skylake-gemini-3f-2023-aug-31
chmod +x subspace-*
```

# Install screen
```
sudo apt-get install screen
screen -S subspace
```
# Start ( Change address_reward with ur address)
```
./subspace-farmer farm --reward-address <address_reward> path=/root/.local/share/subspace-farmer,size=100G
```
Exit screen use `ctrl A+D`

# Delete Node
```
sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced subspaced-farmer
rm -rf ~/.local/share/subspace*
rm -rf /etc/systemd/system/subspaced*
rm -rf /usr/local/bin/subspace*
```

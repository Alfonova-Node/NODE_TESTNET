<p align="center">
  <img height="100" height="auto" src="https://avatars.githubusercontent.com/u/96166029?s=200&v=4">
</p>

## Install Auto

```
. <(wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/zk.sh)
```
## Install Manual
### Update packages
```
sudo apt update && sudo apt upgrade -y
```
### Install required packages
```
sudo  apt  install  wget jq git libssl-dev cmake -y
```
### Install Rust
```
. <(wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/rust.sh)
```
```
source "$HOME/.cargo/env"
```

### Clone the repository with the node
```
git clone https://github.com/zeeka-network/bazuka
```

### Go to the bazuka folder
```
cd bazuka
```
### Install necessary dependencies
```
cargo build
```
```
cargo install --path .
```
### Initialize the node
```
bazuka init --seed 'your seed phrase' --network debug --node 127.0.0.1:8765
```

### Create service file
```
sudo tee <<EOF >/dev/null /etc/systemd/system/zeeka.service
[Unit]
Description=Zeeka node
After=network.target

[Service]
User=$USER
ExecStart=`RUST_LOG=info which bazuka` node --listen 0.0.0.0:8765 --external "YOUR IP":8765 --network debug --db ~/.bazuka-debug --bootstrap 5.161.152.123:8765 --bootstrap 65.108.201.41:8765 --bootstrap 185.213.25.229:8765 --bootstrap 45.88.106.199:8765 --bootstrap 148.251.1.124:8765 --bootstrap 195.54.41.115:8765 --bootstrap 195.54.41.130:8765 --discord-handle "YOUR DISCORD"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
Replace "YOUR IP" with your IP VPS, and replace the discord-handle "YOUR DISCORD" with your discord user.

### Update Path
```
cd bazuka
git pull origin master
cargo install --path .
```

### Start the service
```
 sudo systemctl daemon-reload
 sudo systemctl enable zeeka
 sudo systemctl restart zeeka
 ```
 ### Add a command to view the node log to the system as a variable
 ```
 . <(wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/insert_variable.sh) -n zeeka_log -v "sudo journalctl -fn 100 -u zeeka" -a
 ```
 ### View logs

```
zeeka_log
```
### Delete Node
```
rustup self uninstall -y
rm -rf bazuka
rm -rf zk.sh
```

# GOOD LUCK

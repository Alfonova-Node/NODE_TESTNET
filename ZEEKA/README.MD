### Update packages
```sudo apt update && sudo apt upgrade -y
```
### Install required packages
```sudo  apt  install  wget jq git libssl-dev cmake -y
```
### Install Rust
```. <(wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/rust.sh)
```

### Clone the repository with the node
```git clone https://github.com/zeeka-network/bazuka
```

### Go to the bazuka folder
```cd bazuka
```
### Install necessary dependencies
```cargo build
```
```cargo install --path .
```
### Initialize the node
```bazuka init --seed 'your seed phrase' --network debug --node 127.0 .0.1:8765
```

⠀### Create service file
``` sudo  tee  << EOF > /dev/null /etc/systemd/system/zeeka.service 
[Unit] 
Description=Zeeka node 
After=network.target 
[Service] 
User= $USER 
ExecStart= ` RUST_LOG = info which bazuka ` node - -listen 0.0.0.0:8765 --external [your ip]:8765 --network debug --db ~/.bazuka-debug --bootstrap 5.161.152.123:8765 --bootstrap 65.108.201.41:8765 --bootstrap 185.213. 25.229:8765 --bootstrap 45.88.106.199:8765 --bootstrap 148.251.1.124:8765 --bootstrap 195.54.41.115:8765 --bootstrap 195.54.41.130:8765 
Restart 
=on-failure 
RestartSec= 
35 LimitNOFILE 


WantedBy=multi-user.target 
EOF 
```

### Start the service
```
 sudo systemctl daemon-reload
 sudo systemctl enable zeeka
 sudo systemctl restart zeeka
 ```
 ### Add a command to view the node log to the system as a variable
 ```
 .  < ( wget -qO- https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/ZEEKA/insert_variable.sh ) -n zeeka_log -v "sudo journalctl -fn 100 -u zeeka" -a
 ```
 ### View logs

```zeeka_log```


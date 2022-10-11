>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
 
<p align="center">
  <img height="150" height="auto" src="https://docs.lambda.im/lambda-logo.png">
</p>

# Lambda Network Testnet

## [Official Guide](https://docs.lambda.im/validators/overview.html)
## [Visit Lambda](https://www.lambda.im/)


## Minimum Requirements
 - 4 or more physical CPU cores
 - At least 500GB of SSD disk storage
 - At least 32GB of memory (RAM)
 - At least 100mbps network bandwidth

# Auto Install (Option 1)
```bash
wget -O lambda.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/LAMBDA/lambda.sh && chmod +x lambda.sh && ./lambda.sh
```
# Manual Installation (Option 2)
## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER>
```
Change : `<YOUR_MONIKER>` To your node moniker whatever u like


Save and import variables into system
```bash
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export LAMBDA_CHAIN_ID=lambdatest_92000-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```bash
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

## Download and build binaries
```bash
git clone https://github.com/LambdaIM/lambdavm.git
cd lambdavm
make install
```
## Config app
```bash
lambdavm config chain-id $LAMBDA_CHAIN_ID
lambdavm config keyring-backend file
```

## Init app
```bash
lambdavm init $NODENAME --chain-id $LAMBDA_CHAIN_ID
```

## Download genesis
```bash
wget https://raw.githubusercontent.com/LambdaIM/mainnet/main/lambda_92000-1/genesis.json
mv genesis.json ~/.lambdavm/config/
```

## Set Peers
```bash
peers="2c4f8e193fd10ab3a2bc919b484fd1c78eceffb3@13.213.214.88:26656,b772a0a8a8ee52c12ff0995ebb670a17db930489@54.225.36.85:26656,277b04415ee88113c304cc3970c88542d6d8f5d3@51.79.91.32:26656,a4ad9857ac5efdd75ec94875b19dd2f0bf562bde@47.75.111.113:26656,13e0e58efbb50df4dc5d39263bda1e432fe204f7@13.229.162.168:26656,ed4fd7dafd7df21f7152d38ee729ec33f505793d@54.254.224.222:26656,53e1c5f1783e839b1b1b51ae57ed2f05b9cdb4f3@13.229.27.15:26656,829503936e022119ce5e9cebf23c8e3a694c70f7@34.159.41.156:26656,d475be798a3b8d9eceb56b5cb276ff75d515cb7b@38.242.215.240:26656,d5bc2c509d730b5211f1e2f4cc95ffbbb6eb6944@194.163.164.52:26656,975afec2ce27ef21eea9d512f68eac8487680b09@135.181.72.187:12123,5a7e747884d496aec70495a767431410edb02167@149.102.139.69:26656,7f07d54901170270d7e7568481867535a363a1d5@65.108.129.104:26656,b029580f30c612176c81df200cf724836bba93c5@49.235.92.21:26656,b2cfe9fa02d93f3fa27cdb45272b5dcf3a075985@138.201.141.76:04656,bdeb4b00fe23900b323a3040a30b81e3c8f82803@23.88.69.167:26989"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.lambdavm/config/config.toml
```

## Set minimum gas price and timeout commit
```bash
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.01ulamb\"/;" $HOME/.lambdavm/config/app.toml
```

## Create Service
```bash
sudo tee /etc/systemd/system/lambdavm.service > /dev/null <<EOF
[Unit]
Description=lambdavm
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lambdavm) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```bash
sudo systemctl daemon-reload
sudo systemctl enable lambdavm
sudo systemctl restart lambdavm && sudo journalctl -u lambdavm -f -o cat
```

## After install please Load Variable! (Post Installation)
```bash
source $HOME/.bash_profile
```

### Check info Sync
Note : You have to synced to the lastest block , check the sync status with this command
```bash
lambdavm status 2>&1 | jq .SyncInfo
```

## Create Wallet
Create validator wallet using this command, Dont forget to save the Mnemonic! 

`NOTE : it is recommended to use wallet you fill in the form`
```bash
lambdavm keys add $WALLET
```
(OPTIONAL) To recover using your previous saved wallet
```bash
lambdavm keys add $WALLET --recover
```
To get current list of wallet
```bash
lambdavm keys list --keyring-backend file
```
To get private key of validator wallet (SAVE IT SOMEWHERE SAFE!)
```bash
lambdavm keys export $WALLET --unarmored-hex --unsafe
```
## Safe wallet Info
```bash
LAMBDA_WALLET_ADDRESS=$(lambdavm keys show $WALLET -a)
LAMBDA_VALOPER_ADDRESS=$(lambdavm keys show $WALLET --bech val -a)
echo 'export LAMBDA_WALLET_ADDRESS='${LAMBDA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export LAMBDA_VALOPER_ADDRESS='${LAMBDA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Create Validator
Before creating validator please make sure you have the funds already in your wallet
To check wallet balance :
```bash
lambdavm query bank balances $LAMBDA_WALLET_ADDRESS
```
To create a validator with 1 LAMB delegation use this command below :
```bash
lambdavm tx staking create-validator \
  --amount=2000000000000000000ulamb \
  --pubkey=$(lambdavm tendermint show-validator) \
  --moniker=$NODENAME \
  --chain-id=$LAMBDA_CHAIN_ID \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="300000" \
  --gas-prices="0.025ulamb" \
  --from=$WALLET \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --broadcast-mode block
```

## ETC
To unjail your validator use this command
```bash
lambdavm tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$LAMBDA_CHAIN_ID \
  --fees=5000ulamb \
  --gas=500000
```
## Staking, Delegation and Rewards
- Delegate stake
```bash
lambdavm tx staking delegate $LAMBDA_VALOPER_ADDRESS 10000000ulamb --from=$WALLET --chain-id=$LAMBDA_CHAIN_ID --gas=auto
```
- Redelegate stake from validator to another validator
```bash
lambdavm tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ulamb --from=$WALLET --chain-id=$LAMBDA_CHAIN_ID --gas=auto
```
- Withdraw all rewards
```bash
lambdavm tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$LAMBDA_CHAIN_ID --gas=auto
```
- Withdraw rewards with commision
```bash
lambdavm tx distribution withdraw-rewards $LAMBDA_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$LAMBDA_CHAIN_ID
```
## Monitoring your validator

Check TX HASH ( Which <txhash> is your txhash from the transaction
```bash
lambdavm query tx <txhash>
```
If the transaction was correct you should instantly become part of the validators set. Check your pubkey first:
```bash
lambdavm tendermint show-validator
```
You will see a key there, you can identify your node among other validators using that key:
```bash
lambdavm query tendermint-validator-set
```
Check your validator key
```bash
[[ $(lambdavm q staking validator $LAMBDA_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(hid-noded status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
## Get list of validators
- For Active Validators
```bash
lambdavm q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```bash
lambdavm q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Useful Commands
Check Logs
```bash
journalctl -fu lambdavm -o cat
```
Start Service
```bash
sudo systemctl start lambdavm
```
Stop Service
```bash
sudo systemctl stop lambdavm
```
Restart Service
```bash
sudo systemctl restart lambdavm
```
## Node Info
Synchronization info
```bash
lambdavm status 2>&1 | jq .SyncInfo
```
Validator Info
```bash
lambdavm status 2>&1 | jq .ValidatorInfo
```
Node Info
```bash
lambdavm status 2>&1 | jq .NodeInfo
```
  
## Delete Node Permanently (Backup your Private key first if you wanna migrate !!)
```bash
sudo systemctl stop lambdavm
sudo systemctl disable lambdavm
sudo rm /etc/systemd/system/lambdavm* -rf
sudo rm $(which lambdavm) -rf
sudo rm $HOME/.lambdavm* -rf
sudo rm $HOME/lambdavm -rf
sed -i '/LAMBDAVM_/d' ~/.bash_profile

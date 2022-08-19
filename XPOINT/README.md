<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/38981255/185550018-bf5220fa-7858-4353-905c-9bbd5b256c30.jpg">
</p>

## Supported OS
- darwin/arm64
- darwin/x86_64
- linux/arm64
- linux/x86_64
- windows/x86_64

## Minimum Requirements
To run mainnet or testnet validator nodes, you will need a machine with the following minimum hardware requirements:
```
- 4 or more physical CPU cores
- At least 500GB of SSD disk storage
- At least 32GB of memory (RAM)
- At least 100mbps network bandwidth
```

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export EVMOS_CHAIN_ID=point_10721-1" >> $HOME/.bash_profile
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
```
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
```
cd $HOME
git clone https://github.com/pointnetwork/point-chain && cd point-chain
git checkout xnet-triton
make install
```

## Install Node
```
evmosd config chain-id $EVMOS_CHAIN_ID
evmosd config keyring-backend file
```
## Init App
```
evmosd init $NODENAME --chain-id $EVMOS_CHAIN_ID
```
## Download genesis and addrbook
```
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/config.toml
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/genesis.json
mv config.toml genesis.json ~/.evmosd/config/
```
## Validate
```
evmosd validate-genesis
```
## Create service
```
sudo tee /etc/systemd/system/evmosd.service > /dev/null <<EOF
[Unit]
Description=evmos
After=network-online.target

[Service]
User=$USER
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable evmosd
sudo systemctl restart evmosd && sudo journalctl -u evmosd -f -o cat
```
## Make Wallet
To create a new wallet you can use the command below Enter your Pharse Metamask and Don't forget to save the mnemonic Validator
```
evmosd keys add $WALLET
```
(OPTIONAL) To recover your wallet using the seed phrase
```
evmosd keys add $WALLET --recover
```
To get a list of current wallets
```
evmosd keys list
```
## Save wallet info
Add wallet and valoper address into variables
```
EVMOS_WALLET_ADDRESS=$(evmosd keys show $WALLET -a)
EVMOS_VALOPER_ADDRESS=$(evmosd keys show $WALLET --bech val -a)
echo 'export EVMOS_WALLET_ADDRESS='${EVMOS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export EVMOS_VALOPER_ADDRESS='${EVMOS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Request a Faucet Using Metamask Address
- Fill out the form: https://pointnetwork.io/testnet-form (Wait 24 hours will get an email and coin test into Metamask)
- Add RPC in Metamask (To ensure there is already a landing faucet)
```
Network Title: Point XNet Triton
RPC URL: https://xnet-triton-1.point.space/
Chain ID: 10721
SYMBOL: XPOINT
```
## Add a wallet with your 1024 XPOINT
Remember that wallet you sent us to fund? In the form? It now has 1024 XPOINT.
Import a wallet with private keys into your wallet (e.g. Metamask), and you will see the 1024 XPOINT there. But this is your funded wallet, not the validator wallet.

## Find out which address is your validator wallet
Evmos has two wallet formats: the Cosmos format, and the Ethereum format. The Cosmos format starts with the prefix `evmos`, and the Ethereum format starts with 0x. Most people don't need to know about the Cosmos format, but validators should have a way to convert from one to the other.

Run `evmosd keys list`, and you'll see a list of keys attached to your node. Look at the ones that have `your Validator` name, and make a note of the address (it should be in Cosmos format and start with evmos prefix).

(In most cases it's not needed, but in case something goes wrong and if you want to import your validator wallet in your Metamask, you need a private key. You can get it with this command: ```evmosd keys unsafe-export-eth-key validatorkey --keyring-backend file```)

Use this tool to convert it to Ethereum format: https://evmos.me/utils/tools

This is the address of your validator in Ethereum format.

## Funding Validators
Finally, use the wallet to send as much as you need from your fund address to the validator address (you can send all 1024 or choose a different strategy).

## Bet XPOINT and Join as a Validator
Now you have to wait for the node to be fully synchronized, because otherwise it won't find you.

Once the node is fully synchronized, and you have some XPOINT to stake, check your balance on the node, you will see your balance in Metamask or you can check your balance with this command:
``` evmosd query bank balances $EVMOS_WALLET_ADDRESS ```

## Create a Validator (Make sure the status is False and the balance is there)

### Check Status (If it is False and the Token has been Landing then Create Validator)
``` evmosd status 2>&1 | jq .SyncInfo ```
### Check Ballances
``` evmosd query bank balances $POINT_WALLET_ADDRESS ```
If the above Command Error Change `$EVMOS_WALLET_ADDRESS` to `your Address`

## Create Validator
```
evmosd tx staking create-validator \
  --amount 1000000000000000000000apoint \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1000000000000000000000" \
  --pubkey  $(evmosd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $EVMOS_CHAIN_ID
  ```
  ## Staking, Delegation and Rewards
  Delegate stake
  ```
  evmosd tx staking delegate $EVMOS_VALOPER_ADDRESS 10000000apoint --from=$WALLET --chain-id=$EVMOS_CHAIN_ID --gas=auto
  ```
  Redelegate stake from validator to another validator
  ```
  evmosd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000apoint --from=$WALLET --chain-id=$EVMOS_CHAIN_ID --gas=auto
  ```
  Withdraw all rewards
  ```
  evmosd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$EVMOS_CHAIN_ID --gas=auto
  ```
  Withdraw rewards with commision
  ```
  evmosd tx distribution withdraw-rewards $EVMOS_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$EVMOS_CHAIN_ID
  ```
 ## Edit validator
 ```
 strided tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$EVMOS_CHAIN_ID \
  --from=$WALLET
  ```
  
  ## Unjail validator
  ```
  evmosd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$EVMOS_CHAIN_ID \
  --gas=auto
  ```
  
 ## Delete Node (Permanent)
  ```
  sudo systemctl stop evmosd
  sudo systemctl disable evmosd
  sudo rm /etc/systemd/system/evmos* -rf
  sudo rm $(which evmosd) -rf
  sudo rm $HOME/.evmosd -rf
  sudo rm $HOME/point-chain -rf
  ```
  ## Node info
  Validator info
  ``` evmosd status 2>&1 | jq .ValidatorInfo ```
  Node info
  ``` evmosd status 2>&1 | jq .NodeInfo ```
  Show node id
  ``` evmosd tendermint show-node-id ```
 
 ## Service Management
 Check logs
 ``` journalctl -fu evmosd -o cat ```
 Start service
 ``` sudo systemctl start strided ```
 Stop service
 ``` sudo systemctl stop strided ```
 Restart service
 ```sudo systemctl restart strided ```


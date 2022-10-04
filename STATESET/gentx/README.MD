>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
  <img height="300" height="auto" src="https://user-images.githubusercontent.com/50621007/192461695-f16f92ac-7f9c-4181-9dbe-ed2267f30f35.png">
</p>


# Generate stateset testnet gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```bash
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```bash
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=stateset-1-testnet" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```bash
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```bash
sudo apt-get install make build-essential gcc git jq chrony -y
```

## Install go
```bash
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

## Install starport
```bash
curl https://get.starport.network/starport! | bash
```

## Download and install binaries
```bash
cd $HOME
git clone https://github.com/stateset/core
cd core
starport chain build
```

## Config app
```bash
statesetd config chain-id $CHAIN_ID
statesetd config keyring-backend test
```

## Init node
```bash
statesetd init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for testnet
Option 1 - generate new wallet
```bash
statesetd keys add $WALLET
```

Option 2 - recover existing wallet
```bash
statesetd keys add $WALLET --recover
```

## Add genesis account
```bash
WALLET_ADDRESS=$(statesetd keys show $WALLET -a)
statesetd add-genesis-account $WALLET_ADDRESS 10000000000ustate
```

## Generate gentx
```bash
statesetd gentx $WALLET 9000000000ustate \
--chain-id $CHAIN_ID \
--moniker=$NODENAME \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.05 \
--identity="" \
--website="" \
--details="" \
--min-self-delegation=100000000000
```

## Things you have to backup
- `24 word mnemonic` of your generated wallet
- contents of `$HOME/.stateset/config/*`

## Submit PR with Gentx
1. Copy the contents of ${HOME}/.stateset/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/stateset/networks
3. Create a file `gentx-<VALIDATOR_NAME>.json` under the `testnets/stateset-1-testnet/gentx/` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Await further instructions!

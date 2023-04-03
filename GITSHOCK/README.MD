# THIS IS TUTORIAL FOR GETH - LIGHTHOUSE

## Installing Prerequisites


```
sudo apt update && sudo apt upgrade -y && sudo apt install micro curl tar wget screen clang pkg-config libssl-dev jq unzip build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

# Install Geth
```
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt update -y
sudo apt install ethereum -y
```

# Install lighthouse
```
wget https://github.com/sigp/lighthouse/releases/download/v4.0.1/lighthouse-v4.0.1-x86_64-unknown-linux-gnu-portable.tar.gz
tar -xzf lighthouse-v4.0.1-x86_64-unknown-linux-gnu-portable.tar.gz
rm lighthouse-v4.0.1-x86_64-unknown-linux-gnu-portable.tar.gz
mv lighthouse /usr/local/bin
```

# Install Go
```
ver="1.19"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go install github.com/protolambda/eth2-testnet-genesis@latest
go install github.com/protolambda/eth2-val-tools@latest
```
# Initial Setup

## Create Folder
```
mkdir testnet
mkdir testnet/data
mkdir testnet/beacon-1
mkdir testnet/beacon-2
mkdir testnet/logs
cd testnet
```
## Download Repository
```
wget https://github.com/gitshock-labs/testnet-list/releases/download/Iteration-70.a/cartenz-iteration-70.a.zip
unzip cartenz-iteration-70.a.zip
```
## Create Jwt Secret
```
openssl rand -hex 32 | tr -d "\n" > "jwt.hex"
```
## Create Geth Account
```
geth account new --datadir "data"
```
## Write custom genesis block
```
geth --datadir $HOME/testnet/data init $HOME/testnet/execution/genesis.json
```

# Write custom genesis block

## It is recommended to use Screen for running the Execution Layer and Consensus Layer.

```
screen -S EVM
```
Please edit value of --identity as you wish
example --identity "ALFONOVA"

```nohup geth \
--datadir "$HOME/testnet/data" \
--http --http.api="engine,eth,web3,net,admin" \
--ws --ws.api="engine,eth,web3,net" \
--http.port 8545 \
--http.addr 0.0.0.0 \
--http.corsdomain "*" \
--identity "CHANGE-ME" \
--networkid=1881 \
--syncmode=full \
--authrpc.jwtsecret="$HOME/testnet/jwt.hex" \
--authrpc.port 8551 \
--bootnodes "enode://0e2b41699b95e8c915f4f5d18962c0d2db35dc22d3abbebbd25fc48221d1039943240ad37a6e9d853c0b4ea45da7b6b5203a7127b5858c946fc040cace8d2d63@147.75.71.217:30303,enode://45b4fff6ab970e1e490deea8a5f960d806522fafdb33c8eaa38bc0ae970efc2256fc5746f0ecfec770af24c44864a3e6772a64f2e9f031f96fd4af7fd0483110@147.75.71.217:30304" \
> $HOME/testnet/logs/geth_1.log &
```
CTRL + C

# Running Consensus Layer
Please edit <YOUR-ADDRESS> and <YOUR-NAME>
example "0xB0F9575AC688Ed5C37f50B3aF0d125664c2EA123" and "ALFONOVA"
  
 ```
  nohup lighthouse beacon \
--eth1 \
--http \
--testnet-dir $HOME/testnet/consensus \
--datadir "$HOME/testnet/beacon-1" \
--http-allow-sync-stalled \
--execution-endpoints http://127.0.0.1:8551 \
--http-port=5052 \
--enr-udp-port=9000 \
--enr-tcp-port=9000 \
--discovery-port=9000 \
--graffiti "<YOUR-NAME>" \
--execution-jwt "$HOME/testnet/jwt.hex" \
--suggested-fee-recipient="<YOUR-ADDRESS>" \
> $HOME/testnet/logs/beacon_1.log &
  
  ```
  
 ## Getting ENR KEY
  SAVE YOUR ENR KEY !!
  ```
  curl http://localhost:5052/eth/v1/node/identity | jq .data.enr
  ```
  
## Running Other Consensus Layer
 ```
  nohup lighthouse \
--testnet-dir $HOME/testnet/consensus \
bn \
--datadir $HOME/testnet/beacon-2 \
--eth1 \
--http \
--http-allow-sync-stalled \
--execution-endpoints "http://127.0.0.1:8551" \
--eth1-endpoints "http://127.0.0.1:8545" \
--http-address 0.0.0.0 \
--http-port 5053 \
--http-allow-origin="*" \
--listen-address 0.0.0.0 \
--enr-udp-port 9001 \
--enr-tcp-port 9001 \
--port 9001 \
--enr-address <YOUR-IP>
--execution-jwt "$HOME/testnet/jwt.hex" \
--suggested-fee-recipient="<YOUR-ADDRESS>" \
--boot-nodes="<YOUR-ENR>,enr:-MS4QHXShZPtKwtexK2p9yCxMxDwQ-EvdH_VemoxyVyweuaBLOC_8cmOzyx7Gy-q6-X8KGT1d_rhAn_ekXnhpCkA_REHh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBMfxReAmd2k___________gmlkgnY0gmlwhJNLR9mJc2VjcDI1NmsxoQJB10N42nK6rr7Q_NIJNkJFi2uo6itMTOQlPZDcCy09T4hzeW5jbmV0c4gAAAAAAAAAAIN0Y3CCIyiDdWRwgiMo,enr:-MS4QEw_RpORuoXgJ0279QuVLLFAiXevNdYtU7vR8S1CY7X9CS6tceMbaxdIIJYRmHN43ClqHtE2b0H0maSb18cm9D0Hh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBMfxReAmd2k___________gmlkgnY0gmlwhJNLR9mJc2VjcDI1NmsxoQOkQIyCVHLbLjIFMjqNSJEUsbYMe4Tsv9blUWvN6Rsft4hzeW5jbmV0c4gAAAAAAAAAAIN0Y3CCIymDdWRwgiMp,enr:-LS4QExQqM_G3y2CfedjrGEbapN5Vprdy7Iq2gzfylwLW8PQf4Tf82XnQxLg9PbH8QLwsMaoWwYjTo7xHQ4oy4eCn7kBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBMfxReAmd2k___________gmlkgnY0iXNlY3AyNTZrMaEDec2pARmw1GLJHiXIDaG-6J74gZ1SyDcF_CuVUzRsmX2Ic3luY25ldHMAg3RjcIIjKoN1ZHCCIyo" \
> /root/testnet/logs/beacon_2.log &
  ```
  
  # Staking
  ```
  Wait for next update
  ```

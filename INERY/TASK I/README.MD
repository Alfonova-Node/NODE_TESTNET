>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
  
<p align="center">
  <img height="350" height="auto" src="https://cdn.publish0x.com/prod/fs/images/21f6c476e6fccb01abf557a109243f936e510a98d9ede212958a377d95b7ed0f.png">
</p>

Dokumen Official :
> [Node Lite & Master](https://docs.inery.io/docs/category/lite--master-nodes)

Explorer :
> [Explorer Inary](https://explorer.inery.io/ "Explorer Inary")

## Hardware Devices
|  Component  | Minimum Requirements |
| ------------ | ------------ |
| CPU  | Intel Core i7-8700 Hexa-Core  |
| RAM | DDR4 64 GB  |
| Storage  | 2x1 TB NVMe SSD |
| Connection | Port 1 Gbit/dtk |

## Software Devices
|Component | Minimum Requirements  |
| ------------ | ------------ |
| OS |  Ubuntu 18.04 or Higher | 

## Register Inery
Register Inery Testnet Dashboard on https://testnet.inery.io/

Simply click Sign-Up and fill out the forms.

### I am using Azure VPS
I suggest opening all azure ports to make it easier.

![Screenshot_1](https://i.ibb.co/XYPFPZP/photo-6167900902430716670-x.jpg)


IP Address use your server IP.
Account Name use any name you want (max 12 char).
Password use a secure password and don't lose it :)
After registering you'll see secret phrase backup, make sure you're back up your phrase!

![Screenshot_2](https://cdn.publish0x.com/prod/fs/cachedimages/1791573717-ae84a5bd0ff341b80bd05ea96a14d41a43676aff48838213813cfe8419be996f.webp)

If you're deploying Master Nodes, make sure to claim 50.000 INR Test Token From Faucet. For Lite Nodes it's no need to claim the token.

![Screenshot_3](https://cdn.publish0x.com/prod/fs/cachedimages/1462263756-3cd6a8283feff9f1126d61ab4def521dbf9531c6346258a9fe85070b93ce779a.webp)

also save all data from left side, Account Name, Server Name, Server IP, Public Key, Private Key.

![Screenshot_4](https://cdn.publish0x.com/prod/fs/cachedimages/2054345917-f23c0c5261aa399d4b4c43b7521c4b23734a5dc3a66aa79c26f37480cf9cbd72.webp)

## Install all apps and tools needed
```bash
sudo apt-get update && sudo apt install git && sudo apt install screen -y
```
```bash
sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```
## Installing Nodes
- Clone Inery Nodes data from github
```bash
git clone https://github.com/inery-blockchain/inery-node
```
- Go to inery setup folder
```bash
cd inery-node/inery.setup
```
- change app permission
```bash
chmod +x ine.py
```
- export path to local os environment for inery binaries
```bash
./ine.py --export
```
- refresh path variable
```bash
cd; source .bashrc; cd -
```
- Edit the configuration
```bash
sudo nano tools/config.json
```
scroll down to MASTER ACCOUNT and replace placeholders
```bash
"MASTER_ACCOUNT":
{
    "NAME": "AccountName",
    "PUBLIC_KEY": "PublicKey",
    "PRIVATE_KEY": "PrivateKey",
    "PEER_ADDRESS": "IP:9010",
    "HTTP_ADDRESS": "0.0.0.0:8888",
    "HOST_ADDRESS": "0.0.0.0:9010"
}
```
Make sure you change AccountName, PublicKey,PrivateKey and IP based on your Inery Testnet Dashboard.
PEER_ADDREES Use IP PRIVATE

`hostname -i`

`(ctrl+X)` and Press `y`to `Exit`

- Create New Screen
```bash
screen -R inery
```
- Run Master Nodes
```bash
./ine.py --master
```
- CTRL+A+D to exit screen.
```
cd ~/inery-node/inery.setup/master.node
chmod +x start.sh
./start.sh
```
After everything is setup, you have to register and after approve it your account as producer
========= PLEASE SYNC FIRST BEFORE RUN THIS COMMAND BELOW ============

- Create Wallet
```bash
cd;  cline wallet create --file defaultWallet.txt
```
- If your wallet has password, you need to unlock it first
```bash
cline wallet unlock --password YOUR_WALLET_PASSWORD
```
- import key 
```bash
cline wallet import --private-key MASTER_PRIVATE_KEY
```
- change MASTER_PRIVATE_KEY with your privatekey on Dashboard.

Register as producer by executing command:
```bash
cline system regproducer ACCOUNT_NAME ACCOUNT_PUBLIC_KEY 0.0.0.0:9010
```
Approve your account as producer by executing command:
```bash
cline system makeprod approve ACCOUNT_NAME ACCOUNT_NAME
```
Check your Master Nodes Status on Inery Explorer https://explorer.inery.io/

Your master nodes should be seen produced blocks after your nodes synced.

Check Wallet balance using this command:
```bash
cline get currency balance inery.token ACCOUNT_NAME
```
For removing nodes (uninstall) go to `inery.setup/inery.node/` and execute `./stop.sh` script

To resume blockchain protocol execute `start.sh` script

To remove blockchain with all data from local machine go to `inery.setup/inery.node/` and execute `./clean.sh` script


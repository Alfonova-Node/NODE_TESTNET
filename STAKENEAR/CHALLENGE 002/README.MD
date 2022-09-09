# Setup Wallet dan Run Validator ( Challenge 002)

Before running the validator, you must first Setup your Wallet so that you can make transactions and make sure your VPS specifications meet the minimum requirements so that it can run smoothly.

1. Cek Spesifikasi (Supported/Not Supported)
```bash
lscpu | grep -P '(?=.*avx )(?=.*sse4.2 )(?=.*cx16 )(?=.*popcnt )' > /dev/null \
&& echo "Supported" \
|| echo "Not supported"
```
![Screenshot_1](https://user-images.githubusercontent.com/35837931/180378418-393a50ae-11a1-405b-91df-4da90ec3abbf.png)

If it appears `Supported`, then your VPS can run the validator later. However, if it is `Not Supported`, then you must change your VPS specifications even higher (in accordance with the Minimum Specifications mentioned on the initial page).

2. Install Developer Tools
Used to execute the many commands needed during the validator run.
```console
sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo
```
3. Install Python pip
```console
sudo apt install python3-pip
```
4. Set Configuration
```bash
USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"
```
![Screenshot 2](https://user-images.githubusercontent.com/35837931/180378705-477d4ef2-1be7-462c-a969-ad8ca61bf8be.png)

5.Install Building Environment
```console
sudo apt install clang build-essential make
```
6. Install Rust dan Cargo
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
![Screenshot 3](https://user-images.githubusercontent.com/35837931/180378810-7c04f981-80bb-4054-8425-cc9bbc9e0ae8.png)

press `y` and `Enter`

![Screenshot 4](https://user-images.githubusercontent.com/35837931/180378912-a25707e0-a17e-4192-8435-0fb56773d50e.png)

Press `1` and `Enter`

7. Source the Environment

```bash
source $HOME/.cargo/env
```
![Screenshot 4](https://user-images.githubusercontent.com/35837931/180379058-1d8db148-e1ce-40fe-b676-67d96d635ca6.png)

## Clone nearcore Project
Clone nearcore repository to run the validator later.
1. Clone Repository
``` bash
git clone https://github.com/near/nearcore
cd nearcore
git fetch
```
2. Checkout Commit
``` bash
git checkout 1897d5144a7068e4c0d5764d8c9180563db2fe43
```
3. Compile `nearcore` Binary
```bash
cargo build -p neard --release --features shardnet
```
This process takes a long time, so you need to be patient. The estimate is approximately 23 minutes (like the photo above) but each VPS has different performance
4. Inisialisasi Working Directory
Lakukan ini agar NEAR Node kalian bekerja dengan lancar dan tidak ada kendala.

- Delete old `genesis.json`
```bash
rm ~/.near/genesis.json
```
- Download new `genesis.json`
```bash
./target/release/neard --home ~/.near init --chain-id shardnet --download-genesis
```
- Using Snapshots (Optional)
Install `AWS-CLI`
```
sudo apt-get install awscli -y
```
Download Snapshot
```bash
cd ~/.near
# download
aws s3 --no-sign-request cp s3://build.openshards.io/stakewars/shardnet/data.tar.gz . 
# tar 
tar -xzvf data.tar.gz
# Delete Data
rm -rf data.tar.gz
```
5. Replace `config.json`
```bash
rm ~/.near/config.json
wget -O ~/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
```
6. Run Node
In this section you must wait for the headers download to 100% and then just synchronize the block. Do not close the tab before it is finished, then an error will occur. So if you want to close the tab, make sure to stop the node first by` CTRL + C` so that no errors occur when running the service later. Because at this stage it is only running in the terminal and not yet at the stage of creating a service to run on the system.

```bash
cd ~/nearcore
./target/release/neard --home ~/.near run
```
After the download headers and download blocks reach 100%, in this section `EpochId`(111111111111111111111111111111) changes to a different writing, then you can stop first by `CTRL + C`.

7. Create Service
```bash
sudo tee /etc/systemd/system/neard.service > /dev/null <<EOF 
[Unit] 
Description=NEARd Daemon Service 
[Service] 
Type=simple 
User=$USER
#Group=near 
WorkingDirectory=$HOME/.near
ExecStart=$HOME/nearcore/target/release/neard run 
Restart=on-failure 
RestartSec=30 
KillSignal=SIGINT 
TimeoutStopSec=45 
KillMode=mixed 
[Install] 
WantedBy=multi-user.target 
EOF
```
8. Enable Service
```bash
sudo systemctl daemon-reload
sudo systemctl enable neard
sudo systemctl start neard
```
If you are having problems with `neard.service` you can do the following command:
```bash
sudo systemctl stop neard
sudo systemctl daemon-reload
sudo systemctl start neard
```
9. Cek Log
```
journalctl -n 100 -f -u neard
```
If you want the logs to look colored, you can install `ccze` with the command below.
```
sudo apt install ccze
```
Then use the command below to see your logs more colorfully.
```
journalctl -n 100 -f -u neard | ccze -A
```
## Connecting Wallet to NEAR-CLI and Generate Validator Key
In this section you must enter your shardnet wallet to run the validator, you can follow the method below.
1. Wallet Authorization

```
near login
```
2. Copy Link untuk Autorisasi ke Browser kalian

![Screenshot 5](https://user-images.githubusercontent.com/35837931/180382353-112ce348-3dec-4797-9c90-f61c366049bb.png)

3. Create Wallet

![Screenshot 6](https://user-images.githubusercontent.com/35837931/180382415-39074162-f7d6-4a9a-b0d7-6c49e275281d.png)

4. Enter the wallet name (Photo is just an example)

![Screenshot 7](https://user-images.githubusercontent.com/35837931/180382499-14ad4da7-eb4b-43cd-b3ef-6a256e6efbbb.png)

5. Save Phrase and Verify Phrase

![Screenshot 8](https://user-images.githubusercontent.com/35837931/180382608-4226d270-c647-49b9-a045-71dc262d8b6b.png)

6. Then enter the Phrase that was saved earlier
7. Click Next and Grant access to `NEAR-CLI` by clicking `connect`.
 
![Screenshot 9](https://user-images.githubusercontent.com/35837931/180382741-51def2a8-53c7-401b-8541-1810c7cd5392.png)

8. Then enter your `Account ID` and click confirm (example: tester01.shardnet.near). `tester01` can be replaced with your wallet name.
 
![Screenshot 10](https://user-images.githubusercontent.com/35837931/180383051-b3dc6683-2280-4bbf-a680-f095c874dc3a.png)

9. After granting access, you will see the following image.
 
![Screenshot 11](https://user-images.githubusercontent.com/35837931/180382929-a7947e62-a9c8-49a3-a764-c003512807ae.png)

Don't worry, if the image appears, then you have given your wallet access to `NEAR-CLI`.

10. Return to the VPS and enter the Account ID that you created earlier and press enter

![Screenshot 12](https://user-images.githubusercontent.com/35837931/180383275-81e12280-348a-4e9f-b3fe-9e57f403795d.png)

11. Generate Key for `validator_key.json`
Replace xx with your wallet name (Example: `tester01` which I created earlier without `shardnet.near`).
```bash
near generate-key xx.factory.shardnet.near
```
12. Then move the `validator_key.json` file to the .near folder
Replace xx with your wallet name as before.
```bash
cp ~/.near-credentials/shardnet/xx.factory.shardnet.near.json ~/.near/validator_key.json
```
13. Then change the word `private_key` to secret_key in the `validator_key.json` file.
```bash
nano ~/.near/validator_key.json
```
After changing, then press `CTRL + O` and `CTRL + X`

14. Save your `node_key.json` and `validator_key.json` files to your PC so that in the future if your VPS dies there is still a backup of the files used to the new VPS so that you can run your previous validator again.
- Copy the contents of the `node_key.json` file and save it to notepad.
```bash
nano ~/.near/node_key.json
```
- Copy the contents of the `validator_key.json` file and save it to notepad.
```bash
nano ~/.near/validator_key.json
```
## Become a Validator
To become a validator and enter the set of active validators, you must at least meet the success criteria.
- Nodes must be in full synchronization.
- `validator_key.json` must be correctly placed.
- The validator contract must match the public_key in `validator_key.json`
- `account_id` must be set to the contract id of the staking pool.
- There must be enough delegates to fulfill the minimum number of seats. See the number of seats [here](https://explorer.shardnet.near.org/nodes/validators)
- Proposals must have been submitted by pinging your validator contract.
- Once the proposal is accepted validators must wait 2-3 epochs to become active validators
- After becoming a validator, validators must produce more than 90% of their assigned blocks.
- 
Check the running status of the validator node. If the Validator appears, then the pool has been selected in the current validators list.

## Continue to Challenge 003
[Mount Staking Pool](https://github.com/Agus1224/NODE_TESTNET/tree/main/STAKENEAR/CHALLENGE%20003)






<p align="center">
  <img height="300" height="auto" src="https://pbs.twimg.com/profile_images/1610231138018017281/VJTt2BJy_400x400.jpg">
</p>

## Recommended Requirements
A server with 4 GB of RAM, dual-core CPU, 20GB of storage space

To join ALICE, one should follow the instructions below. There are two stages:
# Running the Node
Before installing a Muon node, one needs to have Docker and Git  installed on the system. 
```bash
sudo apt autoremove docker* container* -y
sudo apt install jq curl wget tar zip unzip -y
curl -sSL https://get.docker.com | bash -
sudo curl -SL https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo systemctl restart docker.service
```

>- The first step is to clone Muon’s repository hosted on Github. This is done through the following git command: 
```bash
git clone https://github.com/muon-protocol/muon-node-js.git --recurse-submodules --branch testnet
```
>- The next step is to build Muon node using the following command:
```bash
cd muon-node-js
docker-compose build
docker-compose up -d
```
If this is run successfully, the node's status can be viewed by opening the following address in your browser: 
```bash
http://<server-ip>:8000/status
```
The result should look like this:
```bash
{"address":"0x06A85356DCb5b307096726FB86A78c59D38e08ee","peerId":"Qma3GsJmB47xYuyahPZPSadh1avvxfyYQwk8R3UnFrQ6aP","managerContract":{"network":"bsctest","address":"0x2efB53c11FC935f6114B3fC37AaFa6a76B263a4E"},"shield":{"enable":false,"apps":[]},"addedToNetwork":false}
```
# Adding the Node to the Network 
To join ALICE, one needs to stake ALICE token. This dashboard is used for staking ALICE test token, and adding the node to the Testnet. Here is a step-by-step description:
As ALICE's node manager is deployed on BSC Testnet, this network should be added to your wallet before you can start adding the node. The "SWITCH NETWORK" button can be used to add and switch to this network.

![Screenshoot 1](https://user-images.githubusercontent.com/85473027/213611801-fbabd7ca-2c25-4f87-a2d4-4fd02a3e9590.png)

Just as the network is switched to BSC, the following message appears if one does not have the gas tokens. Use the linked faucet to claim the required amount.

![Screenshoot 2](https://user-images.githubusercontent.com/85473027/213611906-e580bcd4-7b66-48cb-8030-248c43c41e4d.png)

After one has claimed the gas tokens, the first step is to mint the minimum required amount of ALICE token to run a node, which is 1000 tokens. 

![image](https://user-images.githubusercontent.com/85473027/213611965-5fa49de1-5609-4660-aaad-efb46ad16b85.png)

The node owner should then approve the staking contract to use the tokens.

![image](https://user-images.githubusercontent.com/85473027/213612009-0fda13b4-2f24-467b-a7c5-ec9afbef974b.png)

Finally, the tokens are staked and the node is added to the network. 

![image](https://user-images.githubusercontent.com/85473027/213612058-f575d180-542e-4caf-aadd-b85056901e90.png)

The fields Node Address and Peer Id are obtained from the node's status as explained above in "Running the Node". 
To test whether or not your node has successfully been added to the network, open the following link in your browser.

```bash
http://<server-ip>:8000/v1/?app=tss&method=test
```

If it is added correctly, you should receive a json response whose `success` is `true`.
```bash
{"success":true,"result":{"confirmed":true, ... }}
```




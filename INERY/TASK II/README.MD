>- [Visit My Website](https://alfonova.app)<p><img height="40" src="https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/arpgr-1srhe-001.ico"></p>
<p align="center">
  
<p align="center">
  <img height="350" height="auto" src="https://cdn.publish0x.com/prod/fs/images/21f6c476e6fccb01abf557a109243f936e510a98d9ede212958a377d95b7ed0f.png">
</p>

# Create/Deploy a token on INERY and transfer to other accounts.

Inery is layer-1 blockchain designed to offer the solution of decentralized database management with the vision to enable a new paradigm for data. It lays the foundation for web3 by seamlessly connecting with systems, applications, and layer-1 networks.

The task number 2 is `Make your own currency and transfer to someone` , Task 2 of the Inery testnet faucet requires that [Task 1](https://github.com/Agus1224/NODE_TESTNET/tree/main/INERY/TASK%20I) was successfully done. Now your challenge is to create your own cryptocurrency on Inery testnet blockchain. You will be able to create currency by setting inery.token contract to your account. Choose the original symbol name and maximum supply for currency and execute create action. After that, you will have to issue some amount with your account to activate that tokens. Your tokens should be ready for transfer, send some tokens to 10 different accounts.

- Unlock your wallet first
```bash
cline wallet unlock -n YourWalletName
```
change `YourWalletName` to your `wallet name` (it may default or wallet or something like that), and than `YourAccountName` on below with your `account name`

- Getting token abi and wasm file
```bash
cline get code inery.token -c token.wasm -a token.abi --wasm
```
this generate 2 file on `/root` folder, `token.wasm` and `token.abi`

- Set wasm code to your account
```bash
cline set code -j YourAccountName token.wasm
```
- Set abi code to your account
```bash
cline set abi YourAccountName token.abi
```
- Create New Token
```bash
cline push action inery.token create '["YourAccountName", "Supply CurrencyCode"], "token description/memo"' -p YourAccountName

------ example:
cline push action inery.token create '["YourAccountName", "50000.0000 TEST" , "creating my first tokens"]' -p YourAccountName
```
- Issue Your New Token
```bash
cline push action inery.token issue '["YourAccountName", "Supply CurrencyCode", "detail"]' -p YourAccountName

---------- example:
cline push action inery.token issue '["YourAccountName", "5000.0000 TEST", "Issuing some TEST token"]' -p YourAccountName
```
- Transfer to another account
```bash
cline push action inery.token transfer '["YourAccountName", "DestinationWalletName", "Amount CurrencyCode", "Here you go 1 TEST for free :) "]' -p YourWalletName

-------- example: send some tokens to 10 different accounts.
```
```bash
cline push action inery.token transfer '["YourAccountName", "inery", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "alfonova", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "pramonoutomo", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "jambul.inery", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "arief", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "armz", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "asphxwzrd", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "away", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "bintangnl", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
cline push action inery.token transfer '["YourAccountName", "blacktokyoo", "1.0000 TEST", "Here Is 1 TEST for you bro "]' -p YourAccountName
```
## don't forget to send your token to me to show your love :) my account: `alfonova`


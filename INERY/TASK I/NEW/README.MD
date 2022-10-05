# Inery testnet master node guide installation

## Official Links
- [Official Docs](https://docs.inery.io/)
- [Inery Official Website](https://inery.io/)
- [Inery testnet dashboard](https://testnet.inery.io/dashboard)
- [Inery testnet explorer](https://explorer.inery.io)

## Auto installation 
```
wget -O inery.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/INERY/TASK%20I/NEW/inery.sh && bash inery.sh
```

### Post installation
```
source $HOME/.bash_profile
```
### Check your logs
```
tail -f $inerylog | ccze -A
```
- First your master node will start fully synchronizing blocks. you will see like this

![img](https://github.com/jambulmerah/guide-testnet/raw/main/inery/img/sync_true.jpg)

- If the block is fully synced you will see something like this

![img](https://github.com/jambulmerah/guide-testnet/raw/main/inery/img/sync_false.jpg)

## Reg master node as producer block
After the block is fully synced, continue to register as a block producer
- Start master node
command:
```
start.sh
```
>NOTE don't do this before the block is fully synced

- Unlock wallet
command:
```
cline wallet unlock -n $IneryAccname --password $(cat $IneryAccname.txt)
```
- Reg producer
```
cline system regproducer $IneryAccname $IneryPubkey 0.0.0.0:9010
```
- Approve as producer
```
cline system makeprod approve $IneryAccname $IneryAccname
```
After the reg producer transaction is successful, now your node starts to get a share of producing blocks
- Check logs again
```
tail -f $inerylog | ccze -A | grep $IneryAcc
```
after a few minutes you will see logs like this

![img](https://github.com/jambulmerah/guide-testnet/raw/main/inery/img/block_produced.jpg)

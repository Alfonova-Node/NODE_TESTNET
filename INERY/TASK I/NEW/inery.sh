#!/bin/bash
clear
merah="\e[31m"
kuning="\e[33m"
hijau="\e[32m"
biru="\e[34m"
UL="\e[4m"
bold="\e[1m"
italic="\e[3m"
reset="\e[m"
# logo
curl -s https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/script/logo.sh | bash
sleep 2
# Set account
echo -e "$bold$hijau 1. Set account... $reset"
sleep 1
# Set account name
accname=""$bold""$hijau"account name"$reset""
accID="Enter your $accname: $reset"
invalid_input=""$bold""$merah"Invalid input. Please select yes or no\n"$reset""
invalid_format=""$bold""$merah"Format is not correct$reset\n"
format=""$bold""$UL""$hijau""
bline="======================================================================="
while true; do
echo "$bline"
read -p "$(printf "$accID""$reset")" name
echo -e "$bline\n"
    if [[ ! "$name" =~ [.a-z1-5][a-z1-5]$ ]] || [[ ${#name} -ge 13 ]] || [[ ${#name} -le 3 ]];then
        echo -e ""$invalid_format""$bold""$merah"Name can have maxiumum of 12 charachters ASCII lowercase a-z, 1-5 and dot character "." but dot can't be at the end of string\n"$reset""
	accID="Please enter your correct $accname: "
    else
	while true; do
        echo -e -n "Is this $accname "$format""$name""$reset" correct? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; ACC=true; break;;
            [Nn]* ) printf "\n"; ACC=false; break;;
            * ) echo -e "$invalid_input"; echo -e "$bline\n";;
        esac
        done
        if [[ $ACC = true ]]; then
            break
        fi
            if [[ $ACC = false ]]; then
                accID="Please enter your $accname again: "
		continue
	fi
    fi
done

# Set pubkey

pubkeyname="$bold""$hijau"public-key"$reset"
publickey="Enter your "$pubkeyname": $reset"
while true; do
echo $bline
read -p "$(printf "$publickey""$reset")" pubkey
echo -e "$bline\n"
    if [[ ${#pubkey} -ne 53 ]] || [[ ${pubkey:0:3} != "INE" ]]; then
        echo -e "$pubkeyname" "$invalid_format"
        publickey="Please enter your correct $pubkeyname: $reset"
    else
	while true; do
        echo -e -n "Is this $pubkeyname "$format""$pubkey"$reset correct? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; PUB=true; break;;
            [Nn]* ) printf "\n"; PUB=false; break;;
            * ) echo -e "$invalid_input";;
        esac
        done
        if [ $PUB = true ]; then
	    break
        fi
            if [[ $PUB = false ]]; then
	        publickey="Enter your $pubkeyname again: "
                continue
            fi
    fi
done

# Set privkey
privkeyname="$bold""$hijau"private-key"$reset"
privatekey="Enter your"$hijau" $privkeyname: "
while true; do
echo -e "$bline"
read -p "$(printf "$privatekey""$reset")" privkey
echo -e "$bline\n"
    if [[ ${#privkey} -ne 51 ]] || [[ ${privkey:0:1} != "5" ]]; then
        echo -e "$privkeyname" "$invalid_format"
        privatekey="Please enter your correct $privkeyname: $reset"
    else
	while true; do
        echo -e -n "Is this $privkeyname "$format""$privkey"$reset correct? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; PRIV=true; break;;
            [Nn]* ) printf "\n"; PRIV=false; break;;
            * ) echo -e "$invalid_input";;
        esac
        done
        if [[ $PRIV = true ]]; then
            break
        fi
            if [[ $PRIV = false ]]; then
	        privatekey="Enter your $privkeyname again: "
                continue
            fi
    fi
done
echo -e "$bline"
echo -e "Your $accname is: $bold$hijau$name$reset"
echo -e "Your $pubkeyname is: $bold$hijau$pubkey$reset"
echo -e "Your $privkeyname is: $bold$hijau$privkey$reset"
echo -e "$bline\n"

# Update upgrade
echo -e "$bold$hijau 2. Updating packages... $reset"
sleep 1
sudo apt update && sudo apt upgrade -y

# Install dep
echo -e "$bold$hijau 3. Installing dependencies... $reset"
sleep 1
sudo apt install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5 ccze git

echo -e "$bold$hijau 4. Installing node... $reset"
sleep 1
# Clone repo
cd $HOME
rm -rf inery-*
git clone https://github.com/inery-blockchain/inery-node

# Edit permission and set vars
echo -e "export PATH="$PATH":"$HOME"/inery-node/inery/bin:"$HOME"/inery-node/inery.setup/master.node" >> $HOME/.bash_profile
echo -e "export IneryAccname="$name"" >> $HOME/.bash_profile
echo -e "export IneryPubkey="$pubkey"" >> $HOME/.bash_profile
echo -e "export inerylog="$HOME"/inery-node/inery.setup/master.node/blockchain/nodine.log" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set config
peers="$(hostname -i):9010"
sed -i "s/accountName/$name/g;s/publicKey/$pubkey/g;s/privateKey/$privkey/g;s/IP:9010/$peers/g" $HOME/inery-node/inery.setup/tools/config.json

echo -e "$bold$hijau 5. Running master node... $reset"
sleep 1
chmod 777 $HOME/inery-node/inery.setup/ine.py
sudo tee $HOME/temporary > /dev/null <<EOF
#!/bin/bash
cd $HOME/inery-node/inery.setup/
./ine.py --master \\
>> tempo.log 2>&1 & \\
echo $! > tempo.pid
EOF
bash $HOME/temporary
rm -rf $HOME/temporary
rm -rf $HOME/inery-node/inery.setup/tempo*

# create wallet
echo -e "$bold$hijau 6. Import wallet to local machine... $reset"
cd; cline wallet create -n $name --file $name.txt
cline wallet import -n $name --private-key $privkey
sleep 1

echo -e "$bold$hijau 7. Enable firewall... $reset"
sleep 1
# Enable firewall
sudo ufw allow 8888,9010/tcp
sudo ufw allow ssh
sudo ufw limit ssh
sudo ufw enable

echo -e "\n========================$bold$biru SETUP FINISHED$reset ============================"
echo -e "Source vars environment:$bold$hijau source \$HOME/.bash_profile $reset"
echo -e "Check your account name env vars:$bold$hijau echo \$IneryAccname $reset"
echo -e "Check your public-key env vars:$bold$hijau echo \$IneryPubkey $reset"
echo -e "Your wallet password save to:$bold$hijau $HOME/$IneryAccname.txt $reset"
echo -e "Check logs with command:$bold$hijau tail -f \$inerylog | ccze -A $reset"
echo -e "========================$bold$biru SETUP FINISHED$reset ============================\n"

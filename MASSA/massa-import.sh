#!/bin/bash
echo "================================================================================"
echo -e "\033[0;35m"
echo " :::       :::   :::::::::       :::           :::::::::      ::::::::::    ";
echo " ::: +   + :::   :::     ::::    :::          ::::    :::    :::       ::   ";
echo " :+: ++ ++ :+:   :+:     :+::+   ::+          +::      ::+   :+:            ";
echo " +:+  +:+  +:+   ++:      ++:+   +:+         :++       ++:   :+:+#######  ";
echo " +#+       +#+   +++      #+++   #++         +#+       +#+   +#+      ###   ";
echo " ###       ###   ###    #####    #########    ###     ###    ###      ###   ";
echo " ###       ###   ### ######      #########      #######       ##########   ";
echo -e "\e[0m"
echo "================================================================================="

sleep 1

# set vars
if [ ! $IP_SERVER ]; then
read -p "Input IP Server Kamu: " IP_SERVER
echo 'export IP_SERVER='\"${IP_SERVER}\" >> $HOME/.bash_profile
read -p "Input Password Kamu: " PASSWORD
echo 'export PASSWORD='\"${PASSWORD}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile

echo -e "IP Server Kamu: \e[1m\e[32m${IP_SERVER}\e[0m"
echo -e "Password Kamu: \e[1m\e[32m${PASSWORD}\e[0m"
echo '================================================='
sleep 1

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt-get update
sudo apt-get install clang -y
sudo apt-get -y install librocksdb-dev -y
sudo apt-get install screen -y
sudo apt-get install libssl-dev -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1

# packages
sudo apt install pkg-config curl git build-essential libssl-dev libclang-dev -y
sudo apt-get install librocksdb-dev build-essential -y

echo -e "\e[1m\e[32m3. Downloading and building massa binary... \e[0m" && sleep 1

# download binary dan ekstrak
cd $HOME
wget https://github.com/massalabs/massa/releases/download/TEST.18.0/massa_TEST.18.0_release_linux.tar.gz
tar xvzf massa_TEST.18.0_release_linux.tar.gz

cd $HOME
cd massa/massa-node/config
wget https://raw.githubusercontent.com/mdlog/testnet-mdlog/main/massa/config.toml
sed -i -e "s/^routable_ip *=.*/routable_ip = \"$IP_SERVER\"/" $HOME/massa/massa-node/config/config.toml

sudo tee /root/massa/massa-node/run.sh > /dev/null <<EOF
#!/bin/bash
cd ~/massa/massa-node/
./massa-node -p $PASSWORD |& tee logs.txt
EOF

sudo tee /etc/systemd/system/massad.service > /dev/null <<EOF
[Unit]
Description=Massa Node
After=network-online.target
[Service]
Environment="RUST_BACKTRACE=full"
User=$USER
ExecStart=/root/massa/massa-node/run.sh
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF

chmod +x /root/massa/massa-node/run.sh
systemctl daemon-reload 
systemctl enable massad 
systemctl restart massad


#!/bin/bash
if [ ! $PRIVKEY ]; then
read -p "Input Secret Key Kamu: " PRIVKEY
echo 'export PRIVKEY='\"${PRIVKEY}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile

echo -e "Private Key Kamu: \e[1m\e[32m${PRIVKEY}\e[0m"
echo '================================================='
PASSWORDKU=$PASSWORD
KEY=$PRIVKEY
sleep 1

# Generate New Wallet 
clear
cd ~
chmod +x $HOME/massa/massa-client/massa-client
cd $HOME/massa/massa-client && wallet_pss=$(./massa-client -p $PASSWORDKU | grep Address )
cd $HOME/massa/massa-client && wallet_priv_key=$(./massa-client wallet_add_secret_keys $KEY -p $PASSWORDKU | grep "Secret key" )
# cd $HOME/massa/massa-client && generate_address=$(./massa-client wallet_add_secret_keys $PRIVKEY -p $PASSWORDKU | grep "Secret Key" | awk '{ print $2 }')
sleep 60
clear

cd $HOME
wget -O buyrolls.sh https://raw.githubusercontent.com/mdlog/testnet-mdlog/main/massa/buyrolls.sh && chmod +x buyrolls.sh && screen -xR -S buyrolls ./buyrolls.sh

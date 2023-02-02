# Cara deploy pingpub expoler + reverse proxy nginx
## Yang di butuhkan
- **Domain explorer dan vps webserver untuk hosting explorernya**
- **Subdoaamin rpc dan api nya**
- **Nginx buat reverse proxy**
- **Repo ping pub buat deploy explorernya**

## Di node API nya jadiin true
![img](./img/api.jpg)
- **Kalo udah di truein restart nodenya**
## Install paket yang di butihkan
```
sudo apt autoremove nodejs -y
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx nodejs git yarn -y 

```


## reverse proxy nginx + install ssl

##### 1. Config API
- `API` Domain
```
API_DOMAIN="<ISI_NAMA_DOMAIN_API>"
```

- `API` IP Port
```
API_IP_PORT="<IP:PORT>" #ISI IP PORT API
```

- `RPC` Domain
```
RPC_DOMAIN="<ISI_NAMA_DOMAIN_RPC>"
```

- `RPC` IP port
```
RPC_IP_PORT="<IP:PORT>" #ISI IP PORT RPC
```

- `Explorer` Domain
```
EXPLORER_DOMAIN="<NAMA_DOMAIN_EXPLORER>" #ISI NAMA EXPLORER DOMAIN
```
- ** `ISI SEMUA VARIABLE DI ATAS` **


##### 2. Copy Konfigurasi `API` dan pastekan di terminal
```
sudo cat <<EOF > /etc/nginx/sites-enabled/${API_DOMAIN}.conf
server {
    server_name $API_DOMAIN;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;

        proxy_pass http://$API_IP_PORT;

    }
}
EOF

```


##### 4. Copy konfigurasi `RPC` dan pastekan di terminal
```
sudo cat <<EOF > /etc/nginx/sites-enabled/${RPC_DOMAIN}.conf
server {
    server_name $RPC_DOMAIN;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;
	
	proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_pass http://$RPC_IP_PORT;

    }
}
EOF

```
##### 5. configurasi expolrer**

```
wget https://raw.githubusercontent.com/ping-pub/explorer/master/ping.conf -O /etc/nginx/sites-enabled/${EXPLORER_DOMAIN}.conf
```

```
sudo sed -i "s|server_name  _|server_name $EXPLORER_DOMAIN|"  /etc/nginx/sites-enabled/${EXPLORER_DOMAIN}.conf
```

##### Test configurasi
```
sudo pkill nginx
nginx -t 
```

- ** Jika konfigurasinya benar seperti ini**
`nginx: the configuration file /etc/nginx/nginx.conf syntax is ok`
`nginx: configuration file /etc/nginx/nginx.conf test is successful`

##### Install ssl sertifikat
```
sudo certbot --nginx --register-unsafely-without-email
sudo certbot --nginx --redirect -d ${API_DOMAIN},${RPC_DOMAIN},${EXPLORER_DOMAIN}

```

## Deploy explorer 
##### 1. Clone repo
```
cd ~
git clone https://github.com/ping-pub/explorer

```
##### 3. Tambahkan konfig sendiri
```7
nano ~/explorer/src/chains/mainnet/<CHAIN_NAME>.json
```
- **Contoh konfig punya saya **
```
{
    "chain_name": "neutron-testnet",
    "coingecko": "",
    "api": ["https://neutron-testnet-api.jambulmerah.dev"],
    "rpc": ["https://neutron-testnet-rpc.jambulmerah.dev"],
    "sdk_version": "0.42.4",
    "addr_prefix": "neutron",
    "logo": "/logos/neutron.jpg",
    "assets": [{
        "base": "untrn",
        "symbol": "NTRN",
        "exponent": "6",
        "coingecko_id": "",
        "logo": "/logos/neutron.jpg"
    }]
}
```
- **>NOTE: Yang paling berpengaruh di sini api jika configurasi api sisanya optional ngasal juga gapapa wkwk, cuman untuk nilai `exponent` itu di ambil jumlah 0 dari base denomnya contoh `1 NTRN = untrn1000000` 0nya ada 6** 
##### 4. Build
```
cd ~/explorer
yarn && yarn build

```
##### 5. Hosting
```
cp -r $HOME/explorer/dist/* /usr/share/nginx/html
nginx -s reload
```
###### Special thanks to
**ping.pub** https://github.com/ping-pub/explorer

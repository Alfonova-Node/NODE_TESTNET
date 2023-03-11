# Tutorial Praktis Testnet Berinsentif Massa! Episode 20

<p align="center">
  <img width="340" height="auto" src="https://pbs.twimg.com/profile_images/1580151744901824512/W_MD85bU_400x400.jpg">
</p>

## Persyaratan Minimum Perangkat Keras

 - 4CORE
 - 8GB RAM
 - 200GB Disk

## Masuk sebagai root dan open port Massa
Jika belum masuk sebagai root ikuti command berikut:
`sudo -i`
## Open Port
```bash
ufw allow 31244
ufw allow 31245
ufw allow ssh
ufw enable
```

# UPDATE NODE MASSA 19.3
```bash
wget -O update-node.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/MASSA%20LABS/update-node.sh && chmod +x update-node.sh && ./update-node.sh
```
##  Instalasi Massa dengan menggunakan script otomatis dibawa:
```bash
wget -O massa-testnet.sh https://raw.githubusercontent.com/Alfonova-Node/NODE_TESTNET/main/MASSA%20LABS/massa-testnet.sh && chmod +x massa-testnet.sh && ./massa-testnet.sh
```

## Dalam proses instalasi teman-teman akan diminta untuk memasukkan beberapa hal, diantaranya:

a. IP address atau server anda

b. Password (sesuai selera)

c. Tekan Y untuk melanjutkan proses instalasi (sebanyak 2 kali)

d. Setelah proses instalasi selesai, CTRL + C

Dengan catatan yang tampil atau muncul bukan redaksi sleep
Tetapi jika redaksi sleep…….sleep tersebut muncul ikuti perintah berikut: Ctrl + A+D atau langsung close terminal.

# Staking Node dengan cara:
```bash
cd massa/massa-client
./massa-client
```
### Masukkan password yang sudah dibuat sebelumnya
## Jika teman-teman merupakan pengguna baru atau baru pertama kali berpartisipasi di testnet Massa, anda harus membuat Wallet Massa terlebih dahulu dengan cara:

`wallet_generate_secret_key`
`wallet_info`

### Jangan lupa untuk menyimpan atau back up secret key, publik key dan addressnya.

## Jika teman-teman telah berpartisipasi di testnet Massa sebelumnya, anda cukup import walletnya dengan cara:
`wallet_add_secret_keys <your_secret_key>`
`wallet_info`

### Setelah informasi wallet address muncul, salin addressteman-teman dan kirimkan ke channel #testnet-faucet yang ada di discord Massa, untuk mendapatkan koin MAS.

![image](https://miro.medium.com/v2/resize:fit:720/format:webp/1*BNiGhv8K9Xiccfmh-hZVUw.jpeg)

Untuk mengecek balance MAS: wallet_info
Kemudian tunggu sampai Final Balance, script otomatis diatas tadi akan mengeksekusi/ Buy Roll secara otomatis, jadi teman-teman tidak perlu melakukan buy roll lagi.
Jika tidak ingin menunggu, teman-teman bisa juga langsung Buy Roll manual dengan cara:

`buy_rolls <address> <roll count> <fee>`
contoh:

`buy_rolls A1uEaLK1z4dYcjBrw9TPrYXAR7EFyLx7XwkMdmRPQhPJmTfoe5j 1 0`

### Supaya Node tahu bahwa teman-teman sudah melakukan staking dengan buy roll, eksekusi perintah berikut:
`node_start_staking <your_address>`

contoh:

`node_start_staking A1uEaLK1z4dYcjBrw9TPrYXAR7EFyLx7XwkMdmRPQhPJmTfoe5j`

Sebagai catatan bahwa untuk testnet insentif episode 19 kali ini, sedikit berbeda dengan episode sebelumnya dengan pertimbangan privasi, jika sebelumnya kita memakai perintah `node_add_staking_secret_keys <your_secret_key>`, di episode terbaru ini (episode 19) kita menggunakan `node_start_staking <your_address>` sebagaimana yang dicontohkan diatas.
Untuk mendapatkan `roll aktif`, teman-teman harus menunggu 1 jam 45 menit.
Ketika roll sudah aktif, berarti teman-teman sudah dalam proses staking, perlu dicatat bahwa satu roll sudah cukup. Testnet massa tidak dinilai dengan banyak roll yang dimiliki, akan tetapi seberapa andal node teman-teman.
Teman-teman juga bisa memantau faucetnya atau rollsnya aktif atau tidak di space wallet yang saat ini support di Android, dengan menginstallya melalui link https://github.com/bacanlabs/spacewallet/releases/tag/1.0.2

# Validasi Node

## Untuk memvalidasi partisipasi teman-teman dalam program hadiah massa testnet, teman-teman wajib terdaftar di akun Discord Massa dengan cara:

Jadi member discord Massa dan telah terverfikasi
Masuk di channel `#testnet-rewards-registration`
Tulis atau klik salah satu emoji di channel tersebut `(#testnet-rewards-registration).`

![image](https://miro.medium.com/v2/resize:fit:640/format:webp/1*csLEd6DDb4lv3dMPnoowOQ.jpeg)

## Cek pesan massa bot

![image](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ziCV4jzQDAw5r1LcwyN_pw.jpeg)

Setelah itu masukkan perintah ini di massa-client:

```
node_testnet_rewards_program_ownership_proof your_staking_address discord ID
```
contoh:

```
node_testnet_rewards_program_ownership_proof A1uEaLK1z4dYcjBrw9TPrYXAR7EFyLx7XwkMdmRPQhPJmTfoe5j 826903150316748891
```

### Akan ada Balasan setelah teman-teman memasukkan perintah tersebut. kemudian Balasan tersebut di copy dengan benar (Copas di word/ notepad & pastikan juga tidak ada spasi) kemudian di paste di `Massa Bot`.
![image](https://miro.medium.com/v2/resize:fit:720/format:webp/1*SZAvzkzV100XyijSJn07cg.jpeg)

### Input IP address VPS di Massa Bot

![image](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ga_izDwMAiKOZcNiMjY--g.jpeg)

### Untuk memeriksa detail skoring Massa silahkan ketik “info” di `Massa Bot.`

![image](https://miro.medium.com/v2/resize:fit:720/format:webp/1*m-aECHjzpcGQfp3y9khRqA.jpeg)

Sebagai catatan: Untuk jumlah skor per episode berjalan terdapat pada redaksi `“Your current skor……….is …..”`

# Routabilitas

a. Kenapa Routabilitas penting ?, karena node di jaringan Massa perlu membangun koneksi di antara mereka untuk berkomunikasi, menyebarkan blok dan operasi, serta mempertahankan konsensus dan sinkronisasi secara bersamaan. Dan hal ini juga tentu mempengaruhi skor yang akan kita dapatkan di program reward testnet disetiap episodenya. Di tahap ini teman-teman tidak perlu lagi setting di config karena script secara otomatis mengeksekusi perintah tesebut.

b. Ditahap ini juga teman-teman tidak juga diperlu melakukannya lagi karena sebelumnya anda telah melakukannya diatas.

c. Cek portnya apakah sudah open atau tidak, hal ini sebagai bukti bahwa node yang anda jalankan sudah routable. Dengan Cara:

Klik https://www.yougetsignal.com/tools/open-ports/
Masukkan IP Address vps dan `PORT MASSA`: `31244 & 31245`

d. Jika port Massa belum OPEN, sebaiknya anda mengulangi langkah tersebut dengan benar atau membuka PORT di Panel VPS

### Jika nodenya tiba-tiba mengalami error silahkan jalankan perintah berikut untuk merestart node dengan cara:

```bash
systemctl stop massad
systemctl restart massad
systemctl status massad
sudo tail -f /root/massa/massa-node/logs.txt
```

## CEK NODE YANG SEDANG BERJALAN
```bash
sudo tail -f /root/massa/massa-node/logs.txt
```
## HAPUS NODE MASSA
```bash
sudo systemctl stop massad
sudo systemctl disable massad
rm /etc/systemd/system/massad.service
rm -rf massa
rm -rf massa-test.sh
rm -rf massa-testnet.sh
rm -rf massa_TEST.19.3_release_linux.tar.gz
```

# Tutorial Praktis Testnet Berinsentif Massa! Episode 19

<p align="center">
  <img width="340" height="auto" src="https://pbs.twimg.com/profile_images/1580151744901824512/W_MD85bU_400x400.jpg">
</p>

## Persyaratan Minimum Perangkat Keras

 - 4CORE
 - 8GB RAM
 - 200GB Disk

 # Set Up Massa Node Secara Manual (OPSI 1)
Dokumentasi Ofisial:
>-[Instruksi Set Up Node](https://massa.readthedocs.io/en/latest/testnet/install.html)

Dokumentasi Komunitas (Versi Binary)
>-[Instruksi Set Up Node](https://medium.com/@massacaptain/tutorial-massa-testnet-binary-version-d7e10847e4c0)

Explorer:
>-[Explorer from Massa.Net](https://massa.net/testnet/)

# Set Up Massa Node Secara Otomatis (OPSI 2)

Anda dapat mengatur node Anda dalam beberapa menit dengan menggunakan skrip otomatis di bawah ini. Ini akan meminta Anda untuk memasukan IP Server yang anda gunakan sehingga anda tidak perlu lagi membuat file ```config.toml``` di ```~/massa/massa-node/config``` ! 

> ## Gunakan perintah dibawah ini jika anda belum memiliki ```Wallet Address``` Massa.

```bash
wget -O massa-testnet.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/MASSA%20LABS/massa-testnet.sh && chmod +x massa-testnet.sh && ./massa-testnet.sh
```
> ## Gunakan perintah dibawah ini jika anda sudah memiliki ```Wallet Address``` Massa dan ingin mengimport ```Secret Key```.

```bash
wget -O massa-import.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/MASSA%20LABS/massa-import.sh && chmod +x massa-import.sh && ./massa-import.sh
```

Setelah proses instalasi binary dari massa selesai, dan di terminal anda muncul ```sleep......``` anda bisa menekan ```CTRL + A + D``` di keyboard anda. Selanjutnya masuk kedalam folder ```massa-client``` letaknya ada di ```cd massa/massa-client``` setelah berada di folder ```massa-client``` jalankan perintah berikut ```./massa-client -p <passsword>```, ganti ```<password>``` dengan password massa-client yang sudah anda buat saat tahap instalasi. Selanjutnya jika sudah berada di terminal client massa silahkan jalankan perintah berikut di command line, perintah ini untuk melihat data Wallet Address anda.

```
wallet_info
```

Setelah informasi wallet address anda muncul salin ```alamat address``` anda dan kirimkan kechannel #testnet-faucet yang ada di discord Massa, untuk mendapatkan balance.


Cek Node yang sedang berjalan
```bash
sudo tail -f /root/massa/massa-node/logs.txt
```


# Update Node

Jika anda menggunakan cara otomatis (OPSI 2) saat menjalankan node ```Episode 18``` anda bisa menggunakan command dibawah ini untuk melakukan update terhadap node anda, dengan catatan node ```Versi 18``` anda berada didalam server VPS yang sama dan anda mau mengupdatenya ke ```versi 19```. Silahkan jalan perintah dibawah ini untuk melakukan update.

```bash
wget -O update-node.sh https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/MASSA%20LABS/update-node.sh && chmod +x update-node.sh && ./update-node.sh
```
Dengan menjalankan perintah ```Update Node``` anda telah memperbaharui versi node anda dari versi 18 ke versi 19 sekaligus memindahkan wallet dan Node yang ada di versi 18 ke versi 19, jadi anda tidak perlu membuat wallet baru lagi.

Setelah muncul tulisan ```Sleep.....``` di terminal, silahkan ```CTRL + A + D``` di keyboard anda



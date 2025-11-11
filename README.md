# Server Management Tools

![Bash](https://img.shields.io/badge/Bash-Script-green)
![SSH](https://img.shields.io/badge/SSH-Remote-blue)
![Linux](https://img.shields.io/badge/Linux-Server-orange)
![Version](https://img.shields.io/badge/Version-1.1.0-brightgreen)

Tools untuk mengelola multiple server dengan kemampuan shutdown dan reboot secara remote melalui SSH.

## ✨ Fitur

- ✅ **Shutdown All** - Matikan semua server sekaligus
- ✅ **Reboot All** - Restart semua server sekaligus  
- ✅ **Reboot Selected** - Restart server tertentu saja
- ✅ **Reboot Multiple** - Restart beberapa server pilihan
- ✅ **Status Check** - Cek status koneksi semua server
- ✅ **User-Friendly Menu** - Interface interaktif yang mudah digunakan
- ✅ **Safety Confirmation** - Konfirmasi untuk operasi kritis

## 🚀 Quick Start

### 1. Download & Setup
```bash
# Download script
wget https://github.com/yourusername/server-management-tools/releases/latest/download/server-manager.sh

# Atau clone repository
git clone https://github.com/yourusername/server-management-tools.git
cd server-management-tools

# Beri permission executable
chmod +x server-manager.sh
```
### 2. Konfigurasi Server
Edit script dan sesuaikan dengan servermu
```bash
nano server-manager.sh
```
Ubah konfigurasi pada bagian:
```bash
SERVERS=(
    "username@server1-ip"
    "username@server2-ip" 
    "username@server3-ip"
)
```
### 3. Setup SSH & Sudoers
```bash
# Generate SSH key
ssh-keygen -t rsa

# Copy key ke server
ssh-copy-id username@server1-ip

# Konfigurasi sudoers di server target
ssh username@server1-ip "echo 'username ALL=(ALL) NOPASSWD: /sbin/shutdown, /sbin/reboot' | sudo tee -a /etc/sudoers"
```
### 4. Jalankan
```bash
./server-manager.sh
```
### 📋 MENU UTAMA
```text
===========================================
     SERVER MANAGEMENT TOOLS v1.1.0
===========================================
Server Target:
1. mamoy@192.168.0.101
2. ituk@192.168.0.102
3. ituk@192.168.0.103
===========================================

PILIH AKSI:
1. Shutdown Semua Server
2. Reboot - Pilih Mode
3. Cek Status Server
4. Keluar
-------------------------------------------
```
### Cara penggunaan
🔁 Reboot options
+ Reboot all - Restart semua server
+ Reboot selected - Pilih 1 server tertentu
+ Reboot multiple - pilih beberapa server contoh (1 3)

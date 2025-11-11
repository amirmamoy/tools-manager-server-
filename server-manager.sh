#!/bin/bash

# Server Management Tools
# Version: 1.1.0
# Description: Remote server management via SSH

# Konfigurasi untuk 3 server
SERVERS=(
    "user@your ip"
    "user@your ip"
    "user@your ip"
)

show_header() {
    clear
    echo "==========================================="
    echo "     SERVER MANAGEMENT TOOLS v1.1.0"
    echo "==========================================="
    echo "Server Target:"
    for i in "${!SERVERS[@]}"; do
        echo "$((i+1)). ${SERVERS[$i]}"
    done
    echo "==========================================="
}

check_status() {
    echo ""
    echo "📡 CEK STATUS SERVER..."
    echo "-------------------------------------------"
    
    for i in "${!SERVERS[@]}"; do
        server="${SERVERS[$i]}"
        echo -n "🔍 $((i+1)). $server: "
        if ssh -o ConnectTimeout=3 -o BatchMode=yes $server "echo -n" &>/dev/null; then
            echo "✅ ONLINE"
        else
            echo "❌ OFFLINE"
        fi
    done
}

shutdown_servers() {
    echo ""
    echo "🔄 MEMATIKAN ${#SERVERS[@]} SERVER..."
    echo "-------------------------------------------"
    
    for server in "${SERVERS[@]}"; do
        echo "⏳ Mematikan $server..."
        if ssh -o ConnectTimeout=5 $server "sudo shutdown -h now" &>/dev/null; then
            echo "✅ Perintah dikirim ke $server"
        else
            echo "❌ Gagal mengirim ke $server"
        fi
    done
    
    echo "-------------------------------------------"
    echo "✅ Perintah shutdown dikirim ke ${#SERVERS[@]} server"
}

reboot_all_servers() {
    echo ""
    echo "🔄 REBOOT ${#SERVERS[@]} SERVER..."
    echo "-------------------------------------------"
    
    for server in "${SERVERS[@]}"; do
        echo "⏳ Reboot $server..."
        if ssh -o ConnectTimeout=5 $server "sudo reboot" &>/dev/null; then
            echo "✅ Perintah dikirim ke $server"
        else
            echo "❌ Gagal mengirim ke $server"
        fi
    done
    
    echo "-------------------------------------------"
    echo "✅ Perintah reboot dikirim ke ${#SERVERS[@]} server"
}

reboot_selected_server() {
    echo ""
    echo "🔄 REBOOT SERVER TERTENTU"
    echo "-------------------------------------------"
    echo "Pilih server yang akan di-reboot:"
    for i in "${!SERVERS[@]}"; do
        echo "$((i+1)). ${SERVERS[$i]}"
    done
    echo "0. Kembali ke menu utama"
    echo "-------------------------------------------"
    
    read -p "Masukkan pilihan [0-${#SERVERS[@]}]: " choice
    
    if [[ $choice -eq 0 ]]; then
        return
    fi
    
    if [[ $choice -ge 1 && $choice -le ${#SERVERS[@]} ]]; then
        server="${SERVERS[$((choice-1))]}"


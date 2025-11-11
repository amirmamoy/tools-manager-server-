#!/bin/bash

# Server Management Tools
# Version: 1.1.0
# Description: Remote server management via SSH

# Konfigurasi untuk 3 server
SERVERS=(
    "mamoy@192.168.0.101"
    "ituk@192.168.0.102"
    "ituk@192.168.0.103"
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
        echo "⏳ Reboot $server..."
        if ssh -o ConnectTimeout=5 $server "sudo reboot" &>/dev/null; then
            echo "✅ Perintah reboot dikirim ke $server"
        else
            echo "❌ Gagal mengirim perintah ke $server"
        fi
    else
        echo "❌ Pilihan tidak valid!"
    fi
}

reboot_multiple_servers() {
    echo ""
    echo "🔄 REBOOT BEBERAPA SERVER"
    echo "-------------------------------------------"
    echo "Pilih server yang akan di-reboot:"
    for i in "${!SERVERS[@]}"; do
        echo "$((i+1)). ${SERVERS[$i]}"
    done
    echo "-------------------------------------------"
    echo "Contoh: 1 3 (untuk reboot server 1 dan 3)"
    echo "        all (untuk reboot semua server)"
    echo "-------------------------------------------"
    
    read -p "Masukkan pilihan: " choices
    
    if [[ "$choices" == "all" ]]; then
        reboot_all_servers
        return
    fi
    
    for choice in $choices; do
        if [[ $choice -ge 1 && $choice -le ${#SERVERS[@]} ]]; then
            server="${SERVERS[$((choice-1))]}"
            echo "⏳ Reboot $server..."
            ssh -o ConnectTimeout=5 $server "sudo reboot" &
            echo "✅ Perintah dikirim ke $server"
        else
            echo "❌ Pilihan $choice tidak valid!"
        fi
    done
    
    echo "-------------------------------------------"
    echo "✅ Proses reboot selesai"
}

show_reboot_menu() {
    while true; do
        clear
        show_header
        echo ""
        echo "🔄 PILIH MODE REBOOT:"
        echo "1. Reboot Semua Server"
        echo "2. Reboot Server Tertentu"
        echo "3. Reboot Beberapa Server"
        echo "0. Kembali ke Menu Utama"
        echo "-------------------------------------------"
        
        read -p "Masukkan pilihan [0-3]: " choice
        
        case $choice in
            1)
                echo ""
                read -p "Yakin ingin reboot semua server? (y/n): " confirm
                if [[ $confirm == "y" || $confirm == "Y" ]]; then
                    reboot_all_servers
                    break
                else
                    echo "❌ Dibatalkan oleh user"
                fi
                ;;
            2)
                reboot_selected_server
                break
            3    ;;
            3) reboot_multiple_servers break
                ;;
            0) break
                ;;
            *) echo "❌ Pilihan tidak valid!"
                ;;
        esac done
}
# MENU UTAMA
while true; do show_header echo "" echo "🔧 MENU UTAMA" echo "1. Cek Status Server" echo "2. 
    Reboot Server" echo "3. Shutdown Semua Server" echo "0. Keluar" echo 
    "-------------------------------------------" read -p "Masukkan pilihan [0-3]: " main_choice 
    case $main_choice in
        1) check_status
            ;;
        2) show_reboot_menu
            ;;
        3) read -p "Yakin ingin matikan semua server? (y/n): " confirm if [[ $confirm == "y" || 
            $confirm == "Y" ]]; then
                shutdown_servers else echo "❌ Dibatalkan oleh user" fi
            ;;
        0) echo "👋 Keluar dari Server Management Tools..." exit 0
            ;;
        *) echo "❌ Pilihan tidak valid!"
            ;;
    esac echo "" read -p "Tekan [Enter] untuk kembali ke menu..." done

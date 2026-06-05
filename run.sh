#!/usr/bin/env bash

# Membuat folder logs jika belum ada
mkdir -p logs

# Menjaga agar Termux tetap berjalan di background dan HP tidak sleep
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
    echo "[INFO] Termux wake lock diaktifkan."
else
    echo "[WARNING] Perintah termux-wake-lock tidak ditemukan. Pastikan termux-api terinstal jika diperlukan."
fi

echo "[INFO] Menjalankan WhatsApp Bot dalam loop auto-restart (Always On)..."
echo "[INFO] Log output akan disimpan di: logs/bot.log"

while true; do
    echo "[$(date)] Memulai bot..." >> logs/bot.log
    # Menjalankan bot dan mencatat output ke terminal & file log
    node start.js 2>&1 | tee -a logs/bot.log
    echo "[$(date)] Bot terhenti atau crash. Memulai ulang dalam 3 detik..." | tee -a logs/bot.log
    sleep 3
done

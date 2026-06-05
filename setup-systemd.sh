#!/usr/bin/env bash
# Make sure we are running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "[ERROR] Harap jalankan script ini sebagai root (atau gunakan sudo)."
  exit 1
fi

PROJECT_DIR=$(pwd)
NODE_PATH=$(which node)

if [ -z "$NODE_PATH" ]; then
  echo "[ERROR] Node.js tidak ditemukan. Pastikan Node.js sudah terinstal."
  exit 1
fi

SERVICE_FILE="/etc/systemd/system/bot-wa.service"

echo "[INFO] Membuat Systemd Service untuk bot di: $PROJECT_DIR"
echo "[INFO] Path Node.js: $NODE_PATH"

cat << EOF > "$SERVICE_FILE"
[Unit]
Description=WhatsApp Bot WA Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$PROJECT_DIR
ExecStart=$NODE_PATH start.js
Restart=always
RestartSec=3
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Memuat ulang daemon systemd..."
systemctl daemon-reload

echo "[INFO] Mengaktifkan service bot-wa..."
systemctl enable bot-wa

echo "[INFO] Memulai service bot-wa..."
systemctl start bot-wa

echo ""
echo "=========================================================="
echo "[SUCCESS] Bot WhatsApp berhasil didaftarkan sebagai Systemd Service!"
echo "=========================================================="
echo "Untuk melihat status service:"
echo "systemctl status bot-wa"
echo ""
echo "Untuk melihat log aktivitas bot secara realtime:"
echo "journalctl -u bot-wa -f"
echo ""
echo "Bot akan otomatis menyala saat sistem Armbian di-boot/reboot."
echo "=========================================================="

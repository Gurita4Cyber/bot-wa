#!/usr/bin/env bash
set -e

PROJECT_DIR=$(pwd)
BOOT_DIR="$HOME/.termux/boot"
START_SCRIPT="$BOOT_DIR/start-bot.sh"

echo "[INFO] Mengonfigurasi Termux:Boot untuk proyek di: $PROJECT_DIR"

# Membuat direktori boot Termux jika belum ada
mkdir -p "$BOOT_DIR"

# Membuat script startup
cat << 'EOF' > "$START_SCRIPT"
#!/usr/bin/env bash
# Mengaktifkan wake lock agar tidak sleep
termux-wake-lock

# Pindah ke direktori bot
cd PROJECT_DIR_PLACEHOLDER

# Menjalankan bot dengan loop restart
./run.sh
EOF

# Mengganti placeholder dengan path proyek saat ini
sed -i "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$START_SCRIPT"

# Memberikan akses eksekusi ke script
chmod +x "$START_SCRIPT"
chmod +x "$PROJECT_DIR/run.sh"

echo "[SUCCESS] Konfigurasi boot selesai!"
echo "Script startup dibuat di: $START_SCRIPT"
echo "Silakan pastikan aplikasi Termux:Boot sudah terinstal di HP Anda."

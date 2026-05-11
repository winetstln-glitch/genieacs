# GenieACS Multi-Vendor Complete

GenieACS dengan dukungan multi-vendor lengkap, dashboard multi-tab, dan skrip instalasi otomatis.

## ✨ Fitur

- **Dukungan Multi-Vendor Lengkap**: Huawei, FiberHome, ZTE, CData, GGCLink, VSOL, Mikrotik, dan banyak lagi
- **Dashboard Multi-Tab**: Antarmuka yang mudah digunakan dengan tab untuk berbagai fitur
- **Logo Kustom**: Ganti logo sesuai kebutuhan Anda
- **Skrip Instalasi Otomatis**: Untuk Windows (PowerShell) dan Linux (Bash)
- **Docker Compose**: Setup cepat dengan container Docker

## 🚀 Instalasi

### Prasyarat

- Docker dan Docker Compose harus terinstal
  - Windows: Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Linux: Install Docker dan Docker Compose melalui package manager

### Langkah Instalasi

#### Windows

```powershell
cd c:\Users\MSTORE-MONITORING\Documents\Genieacs
.\install.ps1
```

Setelah container berjalan, tunggu 30 detik lalu restore konfigurasi:

```powershell
.\restore-config.ps1
```

#### Linux

```bash
cd /path/to/Genieacs
chmod +x *.sh
./install.sh
```

Setelah container berjalan, tunggu 30 detik lalu restore konfigurasi:

```bash
./restore-config.sh
```

## 🎨 Kustomisasi Logo

Untuk mengganti logo:

1. Siapkan file logo Anda (format SVG, PNG, atau JPG)
2. Simpan file logo di direktori `logos/` dengan nama `logo.svg` (atau format lain, kemudian update `dashboard.html`)
3. Restart container nginx:
   ```bash
   docker restart genieacs-nginx
   ```

## 🌐 Akses

Setelah instalasi selesai, Anda dapat mengakses:

- **Dashboard Multi-Tab**: http://localhost
- **UI GenieACS**: http://localhost:3000
  - Username: `admin`
  - Password: `admin`
- **CWMP (TR-069)**: http://localhost:7547
- **NBI**: http://localhost:7557
- **File Server**: http://localhost:7567

## 📦 Struktur Direktori

```
Genieacs/
├── docker-compose.yml    # Konfigurasi Docker Compose
├── nginx.conf            # Konfigurasi Nginx
├── dashboard.html        # Dashboard multi-tab
├── install.ps1           # Skrip instalasi Windows
├── install.sh            # Skrip instalasi Linux
├── restore-config.ps1    # Skrip restore konfigurasi (Windows)
├── restore-config.sh     # Skrip restore konfigurasi (Linux)
├── db/                   # Konfigurasi database multi-vendor
├── logos/                # Direktori untuk logo kustom
├── provisions/           # Skrip provision untuk masing-masing perangkat
│   ├── default.js
│   ├── zte.js
│   ├── fiberhome.js
│   ├── huawei.js
│   ├── ggclink.js
│   ├── vsol.js
│   ├── cdata.js
│   └── mikrotik.js
├── ext/                  # Direktori untuk ekstensi GenieACS
└── files/                # Direktori untuk file (firmware, dll.)
```

## 📋 Vendor yang Didukung

- Huawei Technologies Co., Ltd
- FiberHome
- ZTE
- CData (CTCOM, MONU)
- GGCLink (XCU, XCMCC)
- VSOL
- MikroTik
- ALCL
- TDTC
- ZIONCOM
- Dan masih banyak lagi!

## ⚠️ Catatan Penting

- Ganti nilai `GENIEACS_UI_JWT_SECRET` di `docker-compose.yml` dengan string rahasia yang aman untuk penggunaan produksi
- Pastikan port `80`, `3000`, `7547`, `7557`, dan `7567` tidak diblokir oleh firewall
- Jika Anda memiliki konfigurasi kustom sendiri, backup terlebih dahulu sebelum menjalankan `restore-config`

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan buat pull request atau laporkan issue jika menemukan bug.

## 📄 Lisensi

Proyek ini didasari oleh GenieACS dengan lisensi AGPL-3.0.

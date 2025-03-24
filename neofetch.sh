#!/bin/bash

echo "Script untuk menginstal Neofetch di sistem Linux"
echo "Made by: dlzvy"
echo "GitHub: https://github.com/dlzvy"

echo "======================================"
echo "    INSTALLER NEOFETCH OTOMATIS      "
echo "======================================"
echo ""

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif type lsb_release >/dev/null 2>&1; then
        DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO=$DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    elif [ -f /etc/fedora-release ]; then
        DISTRO="fedora"
    elif [ -f /etc/centos-release ]; then
        DISTRO="centos"
    else
        DISTRO="unknown"
    fi
    echo "Distribusi Linux terdeteksi: $DISTRO"
}

install_from_repo() {
    echo "Menginstal Neofetch dari repositori..."
    case $DISTRO in
        ubuntu|debian|linuxmint|pop|elementary|zorin)
            sudo apt-get update
            sudo apt-get install -y neofetch
            ;;
        fedora)
            sudo dnf install -y neofetch
            ;;
        centos|rhel)
            sudo yum install -y epel-release
            sudo yum install -y neofetch
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -Sy --noconfirm neofetch
            ;;
        opensuse|suse)
            sudo zypper install -y neofetch
            ;;
        alpine)
            sudo apk add neofetch
            ;;
        *)
            echo "Repositori untuk distribusi Anda tidak dikenali. Akan mencoba menginstal dari sumber."
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo "Neofetch berhasil diinstal melalui package manager."
        return 0
    else
        echo "Gagal menginstal melalui package manager. Akan mencoba menginstal dari sumber."
        return 1
    fi
}

install_from_source() {
    echo "Menginstal Neofetch dari sumber..."
    
    if command -v git >/dev/null 2>&1; then
        echo "Git sudah terinstal."
    else
        echo "Git belum terinstal. Menginstal Git..."
        case $DISTRO in
            ubuntu|debian|linuxmint|pop|elementary|zorin)
                sudo apt-get update
                sudo apt-get install -y git
                ;;
            fedora)
                sudo dnf install -y git
                ;;
            centos|rhel)
                sudo yum install -y git
                ;;
            arch|manjaro|endeavouros)
                sudo pacman -Sy --noconfirm git
                ;;
            opensuse|suse)
                sudo zypper install -y git
                ;;
            alpine)
                sudo apk add git
                ;;
            *)
                echo "Tidak dapat menginstal Git. Instalasi dibatalkan."
                return 1
                ;;
        esac
    fi

    echo "Mengunduh Neofetch dari GitHub..."
    git clone https://github.com/dylanaraps/neofetch.git
    
    cd neofetch
    echo "Menginstal Neofetch..."
    sudo make install
    
    cd ..
    rm -rf neofetch
    
    echo "Neofetch berhasil diinstal dari sumber."
    return 0
}

check_installation() {
    if command -v neofetch >/dev/null 2>&1; then
        echo "Instalasi berhasil!"
        echo "Versi Neofetch:"
        neofetch --version
        echo ""
        echo "Menjalankan Neofetch:"
        neofetch
        return 0
    else
        echo "Instalasi gagal. Neofetch tidak ditemukan."
        return 1
    fi
}

main() {
    detect_distro
    
    install_from_repo
    
    if [ $? -ne 0 ]; then
        install_from_source
    fi
    
    check_installation
    
    echo ""
    echo "======================================"
    echo "    INSTALASI NEOFETCH SELESAI       "
    echo "======================================"
}

main
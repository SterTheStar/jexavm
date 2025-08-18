#!/bin/bash

# ==============================
# Colors & Styles
# ==============================
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

# Rainbow array for cycling colors
RAINBOW=($RED $YELLOW $GREEN $CYAN $BLUE $MAGENTA)

# ==============================
# Settings
# ==============================
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
PROOT="./libraries/proot"
ROOTFS="$HOMEA/rootfs"

# Multisystem support
DISTROS=("Debian Trixie" "Void Linux" "Arch Linux" "Alpine Linux" "Fedora 39")
DISTRO_FILES=(
    "debian-trixie-x86_64-pd-v4.26.0.tar.xz"
    "void-x86_64-pd-v4.22.1.tar.xz"
    "arch-x86_64-pd-v4.22.1.tar.xz"
    "alpine-x86_64-pd-v4.18.0.tar.xz"
    "fedora-39-x86_64.tar.xz"
)
DISTRO_LINKS=(
    "https://github.com/termux/proot-distro/releases/download/v4.26.0/debian-trixie-x86_64-pd-v4.26.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.22.1/void-x86_64-pd-v4.22.1.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.22.1/archlinux-x86_64-pd-v4.22.1.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.18.0/alpine-x86_64-pd-v4.18.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.27.0/fedora-x86_64-pd-v4.27.0.tar.xz"
)
PROOT_ROOTS=(
    "$ROOTFS/debian-trixie-x86_64"
    "$ROOTFS/void-x86_64"
    "$ROOTFS/arch-x86_64"
    "$ROOTFS/alpine-x86_64"
    "$ROOTFS/fedora-39-x86_64"
)

mkdir -p "$HOMEA"

# ==============================
# ASCII Art Rainbow Bold
# ==============================
ART=(
"       _             __      ____  __ "
"      | |            \\ \\    / /  \\/  |"
"      | | _____  ____ \\ \\  / /| \\  / |"
"  _   | |/ _ \\ \\/ / _\` \\ \\/ / | |\\/| |"
" | |__| |  __/>  < (_| |\\  /  | |  | |"
"  \\____/ \\___/_/\\_\\__,_| \\/   |_|  |_|"
"                                      "
)

for i in "${!ART[@]}"; do
    COLOR=${RAINBOW[$((i % ${#RAINBOW[@]}))]}
    echo -e "${COLOR}${BOLD}${ART[$i]}${RESET}"
done

# ==============================
# Function to extract or download rootfs
# ==============================
function extract_or_download_rootfs() {
    local index=$1
    local ROOTFS_FILE=${DISTRO_FILES[$index]}
    local PROOT_ROOT=${PROOT_ROOTS[$index]}
    local ROOTFS_DIR=$(dirname "$PROOT_ROOT")
    local DOWNLOAD_LINK=${DISTRO_LINKS[$index]}

    if [[ ! -d "$PROOT_ROOT" ]]; then
        if [[ ! -f "$ROOTFS_FILE" ]]; then
            echo -e "${YELLOW}${BOLD}[*] Rootfs file not found locally. Downloading from $DOWNLOAD_LINK ...${RESET}"
            curl -L --progress-bar -o "$ROOTFS_FILE" "$DOWNLOAD_LINK"
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}${BOLD}[!] Download failed. The file may be corrupted.${RESET}"
                echo -e "${RED}You can manually download it from:${RESET}"
                echo -e "${BLUE}${DOWNLOAD_LINK}${RESET}"
                echo -e "${RED}Place the file in the same directory as this script.${RESET}"
                exit 1
            fi
        fi

        echo -e "${YELLOW}${BOLD}[*] Extracting ${ROOTFS_FILE} (ignoring /dev)...${RESET}"
        mkdir -p "$ROOTFS_DIR"
        tar -xJf "$ROOTFS_FILE" -C "$ROOTFS_DIR" --exclude='dev/*' --warning=no-unknown-keyword
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}${BOLD}[!] Extraction failed. The file may be corrupted.${RESET}"
            echo -e "${RED}Please download the file manually from:${RESET}"
            echo -e "${BLUE}${DOWNLOAD_LINK}${RESET}"
            exit 1
        fi
        echo -e "${GREEN}${BOLD}[+] Rootfs successfully installed at $PROOT_ROOT.${RESET}"
    else
        echo -e "${CYAN}${BOLD}[i] Rootfs is already extracted at $PROOT_ROOT. Continuing...${RESET}"
    fi
}

# ==============================
# Interactive prompt function
# ==============================
function runcmd() {
    local PROOT_ROOT=$1
    local SHELL_BIN="/bin/bash"

    # Alpine Linux usa /bin/sh
    if [[ "$PROOT_ROOT" == *"alpine"* ]]; then
        SHELL_BIN="/bin/sh"
    fi

    echo -e "${CYAN}${BOLD}[i] Container ready. Enter commands below:${RESET}"
    while true; do
        printf "${BOLD}${CYAN}Default@Container:~ ${RESET}"
        read -r cmd
        "$PROOT" -S "$PROOT_ROOT" $SHELL_BIN -c "$cmd"
    done
}

# ==============================
# Select Distro with Installed Detection
# ==============================
echo -e "${BOLD}Select a distribution to start:${RESET}"
for i in "${!DISTROS[@]}"; do
    COLOR=${RAINBOW[$((i % ${#RAINBOW[@]}))]}
    STATUS=""
    if [[ -d "${PROOT_ROOTS[$i]}" ]]; then
        STATUS=" - Installed"
    fi
    echo -e "${COLOR}[${i}] ${DISTROS[$i]}${STATUS}${RESET}"
done

read -p "Enter the number: " choice
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#DISTROS[@]}" ]; then
    echo -e "${RED}${BOLD}[!] Invalid selection.${RESET}"
    exit 1
fi

# Set selected rootfs
ROOTFS_FILE=${DISTRO_FILES[$choice]}
PROOT_ROOT=${PROOT_ROOTS[$choice]}

# ==============================
# Execution
# ==============================
extract_or_download_rootfs "$choice"
echo -e "${CYAN}${BOLD}[i] Starting container...${RESET}"
runcmd "$PROOT_ROOT"

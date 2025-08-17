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
ROOTFS_FILE="./debian-trixie-x86_64-pd-v4.26.0.tar.xz"
PROOT_ROOT="$ROOTFS/debian-trixie-x86_64"

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
    # Reaplica BOLD junto da cor
    echo -e "${COLOR}${BOLD}${ART[$i]}${RESET}"
done

# ==============================
# Function to extract rootfs
# ==============================
function extract_rootfs() {
    if [[ ! -d "$PROOT_ROOT" ]]; then
        if [[ -f "$ROOTFS_FILE" ]]; then
            echo -e "${YELLOW}${BOLD}[*] Extracting local rootfs (ignoring /dev)...${RESET}"
            mkdir -p "$ROOTFS"
            tar -xJf "$ROOTFS_FILE" -C "$ROOTFS" --exclude='dev/*' --warning=no-unknown-keyword
            echo -e "${GREEN}${BOLD}[+] Rootfs successfully installed at $PROOT_ROOT.${RESET}"
        else
            echo -e "${RED}${BOLD}[!] Rootfs file not found!${RESET}"
            echo -e "${RED}Place '$ROOTFS_FILE' in the same directory as this script.${RESET}"
            exit 1
        fi
    else
        echo -e "${CYAN}${BOLD}[i] Rootfs is already extracted at $PROOT_ROOT. Continuing...${RESET}"
    fi
}

# ==============================
# Function to prepare utilities (ngrok, gotty, etc.)
# ==============================
function setup_utils() {
    echo -e "${YELLOW}${BOLD}[*] Setting up utilities...${RESET}"
    mkdir -p "$HOMEA/bin"
    echo -e "${GREEN}${BOLD}[+] Bin folder ready at $HOMEA/bin${RESET}"
}

# ==============================
# Interactive prompt function
# ==============================
function runcmd() {
    echo -e "${CYAN}${BOLD}[i] Container ready. Enter commands below:${RESET}"
    while true; do
        printf "${BOLD}${CYAN}Default@Container:~ ${RESET}"
        read -r cmd
        "$PROOT" -S "$PROOT_ROOT" /bin/bash -c "$cmd"
    done
}

# ==============================
# Execution
# ==============================
extract_rootfs
setup_utils
echo -e "${CYAN}${BOLD}[i] Starting container...${RESET}"
runcmd

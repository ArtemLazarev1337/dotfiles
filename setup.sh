#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INVENTORY_FILE="${SCRIPT_DIR}/inventory/hosts.yml"
readonly PLAYBOOK="${SCRIPT_DIR}/deploy.yml"

# Detect OS
detect_os() {
    case "$OSTYPE" in
        darwin*) echo "macos" ;;
        linux-gnu*) echo "linux" ;;
        *) echo "unsupported" ;;
    esac
}

# Check required commands
check_command() {
    command -v "$1" &>/dev/null
}

# Install Ansible on Linux
install_ansible_linux() {
    echo "==> Updating package repositories..."
    if check_command apt-get; then
        sudo apt-get update
        sudo apt-get install -y ansible
    elif check_command dnf; then
        sudo dnf check-update || true
        sudo dnf install -y ansible
    elif check_command pacman; then
        sudo pacman -Sy
        sudo pacman -S --noconfirm ansible
    else
        echo "Unsupported package manager" >&2
        return 1
    fi
}

# Install Ansible on macOS
install_ansible_macos() {
    if ! check_command brew; then
        echo "==> Installing Homebrew..." >&2
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    
    echo "==> Updating Homebrew..."
    brew update
    
    echo "==> Installing Ansible..."
    brew install ansible
}

# Ensure Ansible is installed
ensure_ansible() {
    if check_command ansible; then
        echo "Ansible is already installed"
        return 0
    fi
    
    local os_type
    os_type=$(detect_os)
    
    case "$os_type" in
        macos)
            install_ansible_macos
            ;;
        linux)
            echo "==> Installing Ansible via system package manager..."
            install_ansible_linux
            ;;
        *)
            echo "Unsupported OS: $OSTYPE" >&2
            exit 1
            ;;
    esac
}

# Get hosts from inventory
get_hosts() {
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        echo "Inventory file not found: $INVENTORY_FILE" >&2
        exit 1
    fi
    
    ansible all -i "$INVENTORY_FILE" --list-hosts 2>/dev/null | \
        grep -v '^\s*hosts (' | \
        sed 's/^[[:space:]]*//' | \
        grep -v '^$'
}

# Interactive host selection
select_host() {
    local all_hosts=""
    local host
    local host_count=0
    
    echo "==> Available machines:" >&2
    
    while IFS= read -r host; do
        [[ -z "$host" ]] && continue
        all_hosts="${all_hosts}${host}"$'\n'
        echo "  $host" >&2
        host_count=$((host_count + 1))
    done < <(get_hosts)
    
    if [[ $host_count -eq 0 ]]; then
        echo "" >&2
        echo "No hosts found in $INVENTORY_FILE" >&2
        exit 1
    fi
    
    echo >&2
    read -rp "Select machine: " selected_host >&2
    
    if [[ -z "$selected_host" ]]; then
        echo "No machine selected" >&2
        exit 1
    fi
    
    # Validate selection
    if ! echo "$all_hosts" | grep -qxF "$selected_host"; then
        echo "Invalid machine: $selected_host" >&2
        exit 1
    fi
    
    echo "$selected_host"
}

# Main
main() {
    local os_type
    os_type=$(detect_os)
    echo "==> Detected OS: $os_type"
    
    ensure_ansible
    
    local selected_host
    selected_host=$(select_host)
    
    echo
    echo "==> Deploying to machine: $selected_host"
    echo
    
    if [[ ! -f "$PLAYBOOK" ]]; then
        echo "Playbook $PLAYBOOK not found" >&2
        exit 1
    fi
    
    ansible-playbook \
        -i "$INVENTORY_FILE" \
        "$PLAYBOOK" \
        -v \
        --diff \
        --ask-become-pass \
        --limit "$selected_host"
    
    echo
    echo "==> Done!"
}

main "$@"

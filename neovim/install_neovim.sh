#!/bin/bash

# Neovim configuration installation script
# This script copies the nvim configuration to the system location

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration paths
CONFIG_DIR="$HOME/.config"
NVIM_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nvim"
NVIM_TARGET_DIR="$CONFIG_DIR/nvim"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check and install Prettier
check_prettier() {
    if ! command_exists prettier; then
        print_warning "Prettier not found. Installing Prettier globally via npm..."
        if command_exists npm; then
            npm install -g prettier
            if command_exists prettier; then
                print_status "Prettier installed successfully!"
            else
                print_error "Failed to install Prettier. Please install it manually with: npm install -g prettier"
                return 1
            fi
        else
            print_error "npm not found. Please install Node.js and npm first, then install Prettier with: npm install -g prettier"
            return 1
        fi
    else
        print_status "Prettier is already installed"
    fi
}

# Check if source directory exists
if [ ! -d "$NVIM_SOURCE_DIR" ]; then
    print_error "Source nvim directory not found at: $NVIM_SOURCE_DIR"
    exit 1
fi

print_status "Starting Neovim configuration installation..."

# Check and install Prettier
check_prettier

# Clean up old configuration
if [ -d "$NVIM_TARGET_DIR" ]; then
    print_warning "Removing existing Neovim configuration at: $NVIM_TARGET_DIR"
    rm -rf "$NVIM_TARGET_DIR"
fi

# Create .config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    print_status "Creating .config directory..."
    mkdir -p "$CONFIG_DIR"
fi

# Copy the new configuration
print_status "Copying nvim configuration to: $NVIM_TARGET_DIR"
cp -r "$NVIM_SOURCE_DIR" "$NVIM_TARGET_DIR"

# Set proper permissions
print_status "Setting proper permissions..."
chmod -R 755 "$NVIM_TARGET_DIR"

print_status "Neovim configuration installation completed successfully!"
print_status "Configuration location: $NVIM_TARGET_DIR"
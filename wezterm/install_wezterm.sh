#!/bin/bash

# WezTerm Configuration Installer (Linux)
# Installs configuration files to the correct location

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we are in the correct directory
check_current_dir() {
    if [[ ! -f "wezterm.lua" ]]; then
        log_error "wezterm.lua configuration file not found. Please run this script from the correct directory."
        exit 1
    fi
}

# Get configuration directory path
get_config_dir() {
    # Follow XDG Base Directory specification
    if [[ -n "$XDG_CONFIG_HOME" ]]; then
        echo "$XDG_CONFIG_HOME/wezterm"
    else
        echo "$HOME/.config/wezterm"
    fi
}

# Create configuration directory if it doesn't exist
create_config_dir() {
    local config_dir=$1
    if [[ ! -d "$config_dir" ]]; then
        log_info "Creating configuration directory: $config_dir"
        mkdir -p "$config_dir"
    else
        log_info "Configuration directory already exists: $config_dir"
    fi
}

# Backup existing configuration
backup_existing_config() {
    local config_file=$1
    if [[ -f "$config_file" ]]; then
        local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warn "Existing configuration file found, creating backup: $backup_file"
        cp "$config_file" "$backup_file"
    fi
}

# Update font configuration in the config file
update_font_config() {
    local config_file=$1
    local font_family=$2
    local font_style=$3

    log_info "Updating font configuration: $font_family ($font_style)"

    # Use sed to replace the font configuration
    sed -i "s/family = '[^']*'/family = '$font_family'/" "$config_file"
    sed -i "s/style = '[^']*'/style = '$font_style'/" "$config_file"
}

# Install configuration file
install_config() {
    local config_dir=$1
    local font_family=$2
    local font_style=$3
    local config_file="$config_dir/wezterm.lua"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Backup existing configuration
    backup_existing_config "$config_file"

    # Copy configuration file
    log_info "Installing configuration file to: $config_file"
    cp "$script_dir/wezterm.lua" "$config_file"

    # Update font configuration if specified
    if [[ -n "$font_family" && -n "$font_style" ]]; then
        update_font_config "$config_file" "$font_family" "$font_style"
    fi

    # Set permissions
    chmod 644 "$config_file"

    log_info "Configuration file installation completed!"
}

# Verify installation
verify_installation() {
    local config_file=$1
    if [[ -f "$config_file" ]]; then
        log_info "Configuration file verification successful: $config_file"

        # Check syntax
        if command -v lua >/dev/null 2>&1; then
            log_info "Checking configuration file syntax..."
            if lua -c "$config_file" 2>/dev/null; then
                log_info "Configuration file syntax check passed!"
            else
                log_warn "Configuration file syntax check failed, please check manually"
            fi
        else
            log_warn "lua command not found, skipping syntax check"
        fi
    else
        log_error "Configuration file installation failed!"
        exit 1
    fi
}

# Show help information
show_help() {
    echo "WezTerm Configuration Installer (Linux)"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help information"
    echo "  -d, --dir DIR        Specify config directory (default: ~/.config/wezterm)"
    echo "  -b, --backup         Force backup existing configuration"
    echo "  -f, --font FONT      Set font family (default: FiraCode Nerd Font Mono)"
    echo "  -s, --style STYLE    Set font style (default: Retina)"
    echo "  -v, --verbose        Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0                                   # Use default settings"
    echo "  $0 -d ~/myconfig                     # Specify custom config directory"
    echo "  $0 -f 'JetBrains Mono' -s 'Regular' # Custom font settings"
    echo "  $0 -v                                # Verbose output"
}

# Main function
main() {
    local config_dir=""
    local font_family="FiraCode Nerd Font Mono"
    local font_style="Retina"
    local force_backup=false
    local verbose=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dir)
                config_dir="$2"
                shift 2
                ;;
            -f|--font)
                font_family="$2"
                shift 2
                ;;
            -s|--style)
                font_style="$2"
                shift 2
                ;;
            -b|--backup)
                force_backup=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Check current directory
    check_current_dir

    # Get configuration directory
    if [[ -z "$config_dir" ]]; then
        config_dir=$(get_config_dir)
    fi

    log_info "Using configuration directory: $config_dir"
    log_info "Using font: $font_family ($font_style)"

    # Create configuration directory
    create_config_dir "$config_dir"

    # Install configuration file
    install_config "$config_dir" "$font_family" "$font_style"

    # Verify installation
    verify_installation "$config_dir/wezterm.lua"

    log_info "WezTerm configuration installation completed!"
    log_info "Restart WezTerm or reload configuration to apply changes."
    log_info "Use 'Ctrl+Shift+R' in WezTerm to reload configuration."
}

# Run main function
main "$@"
# WezTerm Configuration Installer (Windows PowerShell)
# Installs configuration files to the correct location

param(
    [string]$ConfigDir = "",
    [string]$Font = "FiraCode Nerd Font Mono",
    [string]$Style = "Retina",
    [switch]$Backup = $false,
    [switch]$Verbose = $false,
    [switch]$Help = $false
)

# Color output functions
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Info($message) {
    Write-ColorOutput Green "[INFO] $message" | Out-Null
}

function Write-Warn($message) {
    Write-ColorOutput Yellow "[WARN] $message" | Out-Null
}

function Write-Error($message) {
    Write-ColorOutput Red "[ERROR] $message" | Out-Null
}

function Write-Verbose-Output($message) {
    if ($script:Verbose) {
        Write-ColorOutput Cyan "[VERBOSE] $message" | Out-Null
    }
}

# Show help information
function Show-Help {
    Write-Output "WezTerm Configuration Installer (Windows PowerShell)"
    Write-Output ""
    Write-Output "Usage: .\install_wezterm.ps1 [OPTIONS]"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -Help              Show this help information"
    Write-Output "  -ConfigDir DIR     Specify config directory (default: %USERPROFILE%\.config\wezterm)"
    Write-Output "  -Font FONT         Set font family (default: FiraCode Nerd Font Mono)"
    Write-Output "  -Style STYLE       Set font style (default: Retina)"
    Write-Output "  -Backup            Force backup existing configuration"
    Write-Output "  -Verbose           Verbose output"
    Write-Output ""
    Write-Output "Examples:"
    Write-Output "  .\install_wezterm.ps1                                       # Use default settings"
    Write-Output "  .\install_wezterm.ps1 -ConfigDir C:\myconfig                  # Specify custom config directory"
    Write-Output "  .\install_wezterm.ps1 -Font 'JetBrains Mono' -Style 'Regular' # Custom font settings"
    Write-Output "  .\install_wezterm.ps1 -Verbose                               # Verbose output"
}

# Check if we are in the correct directory
function Test-CurrentDirectory {
    if (-not (Test-Path "wezterm.lua")) {
        Write-Error "wezterm.lua configuration file not found. Please run this script from the correct directory."
        exit 1
    }
    Write-Verbose-Output "Current directory check passed"
}

# Get configuration directory path
function Get-ConfigDirectory {
    if ([string]::IsNullOrEmpty($ConfigDir)) {
        # Follow XDG Base Directory specification, use USERPROFILE on Windows
        $configPath = Join-Path $env:USERPROFILE ".config\wezterm"
        Write-Verbose-Output "Using default config directory: $configPath"
        return $configPath
    } else {
        Write-Verbose-Output "Using specified config directory: $ConfigDir"
        return $ConfigDir
    }
}

# Create configuration directory if it doesn't exist
function New-ConfigDirectory {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Info "Creating configuration directory: $Path"
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    } else {
        Write-Info "Configuration directory already exists: $Path"
    }
    Write-Verbose-Output "Configuration directory ready: $Path"
}

# Backup existing configuration
function Backup-ExistingConfig {
    param([string]$ConfigFile)

    if (Test-Path $ConfigFile) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupFile = "${ConfigFile}.backup.$timestamp"
        Write-Warn "Existing configuration file found, creating backup: $backupFile"
        Copy-Item $ConfigFile $backupFile
        Write-Verbose-Output "Backup completed: $backupFile"
    } else {
        Write-Verbose-Output "No existing configuration file to backup"
    }
}

# Update font configuration in the config file
function Update-FontConfig {
    param([string]$ConfigFile, [string]$FontFamily, [string]$FontStyle)

    Write-Info "Updating font configuration: $FontFamily ($FontStyle)"

    # Use regex to replace the font configuration
    $content = Get-Content $ConfigFile -Raw
    $content = $content -replace "family = '[^']*'", "family = '$FontFamily'"
    $content = $content -replace "style = '[^']*'", "style = '$FontStyle'"
    Set-Content $ConfigFile $content -NoNewline
}

# Install configuration file
function Install-Configuration {
    param([string]$ConfigDir, [string]$FontFamily, [string]$FontStyle)

    $configFile = Join-Path $ConfigDir "wezterm.lua"
    $scriptDir = Split-Path -Parent $PSCommandPath
    $sourceFile = Join-Path $scriptDir "wezterm.lua"

    Write-Verbose-Output "Source file: $sourceFile"
    Write-Verbose-Output "Target file: $configFile"

    # Backup existing configuration
    Backup-ExistingConfig $configFile

    # Copy configuration file
    Write-Info "Installing configuration file to: $configFile"
    Copy-Item $sourceFile $configFile -Force

    Write-Verbose-Output "Configuration file copy completed"

    # Update font configuration
    Update-FontConfig $configFile $FontFamily $FontStyle

    # Verify file exists
    if (Test-Path $configFile) {
        Write-Info "Configuration file installation successful!"
        Write-Verbose-Output "File size: $((Get-Item $configFile).Length) bytes"
    } else {
        Write-Error "Configuration file installation failed!"
        exit 1
    }
}

# Verify installation
function Test-Installation {
    param([string]$ConfigFile)

    if (Test-Path $ConfigFile) {
        Write-Info "Configuration file verification successful: $ConfigFile"

        # Try basic syntax check (check if contains basic Lua structure)
        try {
            $content = Get-Content $ConfigFile -Raw
            if ($content -match "require\s+['""]wezterm['""]" -and $content -match "return") {
                Write-Info "Configuration file basic structure check passed!"
            } else {
                Write-Warn "Configuration file may be missing basic structure"
            }
        } catch {
            Write-Warn "Unable to read configuration file for validation: $_"
        }
    } else {
        Write-Error "Configuration file verification failed!"
        exit 1
    }
}

# Check PowerShell execution policy
function Test-ExecutionPolicy {
    $policy = Get-ExecutionPolicy
    Write-Verbose-Output "Current execution policy: $policy"

    if ($policy -eq "Restricted") {
        Write-Warn "PowerShell execution policy is Restricted, script execution may be blocked"
        Write-Warn "Consider running: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
        return $false
    }
    return $true
}

# Main function
function Main {
    # Check execution policy
    if (-not (Test-ExecutionPolicy)) {
        Write-Error "Execution policy restriction, cannot continue"
        exit 1
    }

    # Show help
    if ($Help) {
        Show-Help
        exit 0
    }

    Write-Info "Starting WezTerm configuration installation..."

    # Check current directory
    Test-CurrentDirectory

    # Get configuration directory
    $configDirectory = Get-ConfigDirectory
    Write-Info "Using configuration directory: $configDirectory"
    Write-Info "Using font: $Font ($Style)"

    # Create configuration directory
    New-ConfigDirectory $configDirectory

    # Install configuration file
    Install-Configuration $configDirectory $Font $Style

    # Verify installation
    $configFile = Join-Path $configDirectory "wezterm.lua"
    Test-Installation $configFile

    Write-Info "WezTerm configuration installation completed!"
    Write-Info "Restart WezTerm or reload configuration to apply changes."
    Write-Info "Use 'Ctrl+Shift+R' in WezTerm to reload configuration."

    if ($Verbose) {
        Write-Verbose-Output "Installation details:"
        Write-Verbose-Output "- Configuration directory: $configDirectory"
        Write-Verbose-Output "- Configuration file: $configFile"
        Write-Verbose-Output "- Script path: $PSCommandPath"
    }
}

# Error handling
trap {
    Write-Error "Script execution error: $_"
    exit 1
}

# Run main function
try {
    Main
} catch {
    Write-Error "Error occurred during installation: $_"
    exit 1
}
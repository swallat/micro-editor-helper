# Funktion zur Installation von micro
function Install-Micro {
    if (-not (Get-Command micro -ErrorAction SilentlyContinue)) {
        if (Get-Command scoop -ErrorAction SilentlyContinue) {
            Write-Host "Installing micro using scoop..."
            scoop install micro
        } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Installing micro using choco..."
            choco install micro -y
        } elseif (Get-Command winget -ErrorAction SilentlyContinue) {
            Write-Host "Installing micro using winget..."
            winget install -e --id ZhiyuanLck.Micro -s winget
        } else {
            Write-Host "No supported package manager found. Please install micro manually."
            exit 1
        }
    } else {
        Write-Host "micro is already installed."
    }
}

# Funktion zur Deinstallation der Skripte und Aliase
function Uninstall-Scripts {
    Write-Host "Removing editor-select script and aliases..."
    Remove-Item -Force "$HOME\bin\editor-select.ps1" -ErrorAction SilentlyContinue

    # Entfernen der Aliase aus PowerShell Profilen
    $profilePath = $PROFILE
    if (Test-Path $profilePath) {
        (Get-Content $profilePath) -notmatch 'Set-Alias vim "$HOME\\bin\\editor-select.ps1"' | Set-Content $profilePath
        (Get-Content $profilePath) -notmatch 'Set-Alias nano "$HOME\\bin\\editor-select.ps1"' | Set-Content $profilePath
    }
    Write-Host "Uninstallation completed. Aliases and editor-select script removed."
    exit 0
}

# Prüfen, ob das Skript mit dem Parameter --uninstall aufgerufen wurde
if ($args -contains "--uninstall") {
    Uninstall-Scripts
}

# micro installieren
Install-Micro

# Ensure the bin directory exists
$binPath = "$HOME\bin"
if (-Not (Test-Path $binPath)) {
    New-Item -ItemType Directory -Path $binPath
}

# Create editor-select.ps1 script
$editorSelectScript = @'
param (
    [string[]]$args
)
# Benutzerauswahl abfragen
Write-Host "Do you want to use vim, micro, or nano? (v/m/n) [Default: m]"
$editor_choice = Read-Host

# Standardauswahl auf 'm' setzen, wenn keine Eingabe gemacht wurde
if (-not $editor_choice) {
    $editor_choice = 'm'
}

# Editor basierend auf Benutzerauswahl starten
switch ($editor_choice) {
    'v' {
        vim $args
    }
    'm' {
        micro $args
    }
    'n' {
        nano $args
    }
    default {
        Write-Host "Invalid choice. Please choose 'v' for vim, 'm' for micro, or 'n' for nano."
        exit 1
    }
}
'@

# Save the script to the bin directory
$editorSelectScriptPath = "$binPath\editor-select.ps1"
$editorSelectScript | Out-File -FilePath $editorSelectScriptPath -Force

# Add aliases to PowerShell profile
$profilePath = $PROFILE
if (-Not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}

if (-Not (Get-Content $profilePath -ErrorAction SilentlyContinue | Select-String 'Set-Alias vim "$HOME\\bin\\editor-select.ps1"')) {
    Add-Content $profilePath ''
    Add-Content $profilePath 'Set-Alias vim "$HOME\bin\editor-select.ps1"'
}

if (-Not (Get-Content $profilePath -ErrorAction SilentlyContinue | Select-String 'Set-Alias nano "$HOME\\bin\\editor-select.ps1"')) {
    Add-Content $profilePath 'Set-Alias nano "$HOME\bin\\editor-select.ps1"'
}

# Source the profile to apply changes
. $profilePath

Write-Host "Installation completed. You can now use 'vim', 'micro', or 'nano' with the editor-select script."
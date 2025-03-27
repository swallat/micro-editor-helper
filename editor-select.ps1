param (
    [string[]]$Paths
)

# Installation instructions:
# 1. Save this script in a file, e.g., `editor-select.ps1`.
# 2. Copy the script to a user-managed bin folder, e.g.: Copy-Item -Path .\editor-select.ps1 -Destination $HOME\bin\editor-select.ps1
# 3. Add the following aliases to your PowerShell profile (e.g., $PROFILE):
#    Set-Alias vim $HOME\bin\editor-select.ps1
#    Set-Alias nano $HOME\bin\editor-select.ps1

# Prompt the user for editor choice
$editor_choice = Read-Host "Do you want to use vim, micro, or nano? (v/m/n) [Default: m]"

# Set default choice to 'm' if no input is provided
if ([string]::IsNullOrEmpty($editor_choice)) {
    $editor_choice = "m"
}

# Start the editor based on the user's choice
switch ($editor_choice.ToLower()) {
    'v' {
        vim @Paths
    }
    'm' {
        micro @Paths
    }
    'n' {
        nano @Paths
    }
    default {
        Write-Host "Invalid choice. Please choose 'v' for vim, 'm' for micro, or 'n' for nano."
        exit 1
    }
}
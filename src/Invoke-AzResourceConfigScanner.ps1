# Function to display a menu and get the user's selection
function Get-ResourceTypeSelection {
    $options = @("AppServices","FunctionApps","KeyVaults","StorageAccounts")
    Write-Host "Select the type of resource to process:"
    for ($i = 0; $i -lt $options.Length; $i++) {
        Write-Host "$($i + 1). $($options[$i])"
    }
    $selection = Read-Host "Enter the number corresponding to your choice"
    if ($selection -match '^[1-4]$') {
        return $options[$selection - 1]
    } else {
        Write-Host "Invalid selection. Please try again."
        return Get-ResourceTypeSelection
    }
}

# Function to set the foreground color based on a condition
function Set-ForegroundColor {
    param (
        [bool]$condition,
        [string]$trueColor = "DarkRed",
        [string]$falseColor = "Green"
    )
    return $(if ($condition) { $trueColor } else { $falseColor })
}

# Get the resource type from the user
$ResourceType = Get-ResourceTypeSelection

# Main execution based on the selected resource type
switch ($ResourceType) {
    "AppServices" {
        . ./modules/AppServices.ps1
        Process-AppServices
    }
    "FunctionApps" {
        . ./modules/FunctionApps.ps1
        Process-FunctionApps
    }
    "KeyVaults" {
        . ./modules/KeyVaults.ps1
        Process-KeyVaults
    }
    "StorageAccounts" {
        . ./modules/StorageAccounts.ps1
        Process-StorageAccounts
    }
}
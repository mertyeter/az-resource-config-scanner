# Function to retrieve the list of key vaults
function Get-KeyVaults {
    az keyvault list --query "[].{keyVaultName:name, resourceGroupName:resourceGroup}" -otsv
}

# Function to get the configuration of a specific key vault
function Get-KeyVaultConfig($resourceGroupName, $keyVaultName) {
    $config = az keyvault show -g $resourceGroupName -n $keyVaultName --query "{enabledForDiskEncryption: properties.enabledForDiskEncryption, enableSoftDelete: properties.enableSoftDelete, publicNetworkAccess:properties.publicNetworkAccess}" -ojson | ConvertFrom-Json
    return $config
}

# Function to process and output the configuration of each key vault
function Process-KeyVaultConfig($keyVaultName, $resourceGroupName, $config) {
    $enabledForDiskEncryption = $config.enabledForDiskEncryption
    $enableSoftDelete = $config.enableSoftDelete
    $publicNetworkAccess = $config.publicNetworkAccess

    Write-Host "Key Vault Name: $keyVaultName"
    Write-Host "Resource Group Name: $resourceGroupName"
    Write-Host "Disk Encryption Enabled: $enabledForDiskEncryption" -ForegroundColor (Set-ForegroundColor -condition ($enabledForDiskEncryption -eq $false))
    Write-Host "Soft Delete Enabled:  $(if ($enableSoftDelete -eq $null) { $false } else { $enableSoftDelete })" -ForegroundColor (Set-ForegroundColor -condition ($enableSoftDelete -ne $true))
    Write-Host "Public Network Access: $publicNetworkAccess" -ForegroundColor (Set-ForegroundColor -condition ($publicNetworkAccess -eq "Enabled"))
    Write-Host "----------------------------------------"
}

# Main function to process all key vaults
function Process-KeyVaults {
    $keyVaults = Get-KeyVaults

    if (-not $keyVaults) {
        Write-Host "No Key Vaults found."
        return
    }

    foreach ($keyVault in $keyVaults) {
        $keyVaultName, $resourceGroupName = $keyVault -split "`t"
        $config = Get-KeyVaultConfig -resourceGroupName $resourceGroupName -keyVaultName $keyVaultName
        Process-KeyVaultConfig -keyVaultName $keyVaultName -resourceGroupName $resourceGroupName -config $config
    }
}
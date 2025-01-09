# Function to retrieve the list of storage accounts
function Get-StorageAccounts {
    az storage account list --query "[].{storageAccountName:name, resourceGroupName:resourceGroup}" -otsv
}

# Function to get the configuration of a specific storage account
function Get-StorageAccountConfig($resourceGroupName, $storageAccountName) {
    $config = az storage account show -g $resourceGroupName -n $storageAccountName --query "{minTlsVersion: minimumTlsVersion, allowBlobPublicAccess:allowBlobPublicAccess, enableHttpsTrafficOnly:enableHttpsTrafficOnly}" -ojson | ConvertFrom-Json
    return $config
}

# Function to process and output the configuration of each storage account
function Process-StorageAccountConfig($storageAccountName, $resourceGroupName, $config) {
    $minTlsVersion = $config.minTlsVersion
    $allowBlobPublicAccess = $config.allowBlobPublicAccess
    $enableHttpsTrafficOnly = $config.enableHttpsTrafficOnly
    $requireInfrastructureEncryption = $config.requireInfrastructureEncryption

    Write-Host "Storage Account Name: $storageAccountName"
    Write-Host "Resource Group Name: $resourceGroupName"
    Write-Host "TLS Version: $minTlsVersion" -ForegroundColor (Set-ForegroundColor -condition ($minTlsVersion -eq "TLS1_0" -or $minTlsVersion -eq "TLS1_1"))
    Write-Host "Allow Public Access: $allowBlobPublicAccess" -ForegroundColor (Set-ForegroundColor -condition ($allowBlobPublicAccess -eq $true))
    Write-Host "HTTPS Only: $enableHttpsTrafficOnly" -ForegroundColor (Set-ForegroundColor -condition ($enableHttpsTrafficOnly -eq $false))
    Write-Host "----------------------------------------"
}

# Main function to process all storage accounts
function Process-StorageAccounts {
    $storageAccounts = Get-StorageAccounts

    if (-not $storageAccounts) {
        Write-Host "No Storage Accounts found."
        return
    }

    foreach ($storageAccount in $storageAccounts) {
        $storageAccountName, $resourceGroupName = $storageAccount -split "`t"
        $config = Get-StorageAccountConfig -resourceGroupName $resourceGroupName -storageAccountName $storageAccountName
        Process-StorageAccountConfig -storageAccountName $storageAccountName -resourceGroupName $resourceGroupName -config $config
    }
}
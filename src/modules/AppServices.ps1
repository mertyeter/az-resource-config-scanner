# Function to retrieve the list of app services
function Get-AppServices {
    az webapp list --query "[].{appServiceName:name, resourceGroupName:resourceGroup}" -otsv
}

# Function to get the configuration of a specific app service
function Get-AppServiceConfig($resourceGroupName, $appServiceName) {
    $config = az webapp show -g $resourceGroupName -n $appServiceName --query "{minTlsVersion: siteConfig.minTlsVersion, ftpsState: siteConfig.ftpsState, httpsOnly: httpsOnly, http20Enabled: siteConfig.http20Enabled}" -ojson | ConvertFrom-Json
    return $config
}

# Function to process and output the configuration of each app service
function Process-AppServiceConfig($appServiceName, $resourceGroupName, $config) {
    $minTlsVersion = $config.minTlsVersion
    $ftpsState = $config.ftpsState
    $httpsOnly = $config.httpsOnly
    $http20Enabled = $config.http20Enabled

    Write-Host "App Service Name: $appServiceName"
    Write-Host "Resource Group Name: $resourceGroupName"
    Write-Host "TLS Version: $minTlsVersion" -ForegroundColor (Set-ForegroundColor -condition ($minTlsVersion -lt "1.2"))
    Write-Host "FTPS State: $ftpsState" -ForegroundColor (Set-ForegroundColor -condition ($ftpsState -ne "Disabled"))
    Write-Host "HTTPS Only: $httpsOnly" -ForegroundColor (Set-ForegroundColor -condition ($httpsOnly -eq $false))
    Write-Host "HTTP 2.0 Enabled: $http20Enabled" -ForegroundColor (Set-ForegroundColor -condition ($http20Enabled -eq $false))
    Write-Host "----------------------------------------"
}

# Main function to process all app services
function Process-AppServices {
    $appServices = Get-AppServices

    if (-not $appServices) {
        Write-Host "No App Services found."
        return
    }

    foreach ($appService in $appServices) {
        $appServiceName, $resourceGroupName = $appService -split "`t"
        $config = Get-AppServiceConfig -resourceGroupName $resourceGroupName -appServiceName $appServiceName
        Process-AppServiceConfig -appServiceName $appServiceName -resourceGroupName $resourceGroupName -config $config
    }
}
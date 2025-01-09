# Function to retrieve the list of function apps
function Get-FunctionApps {
    az functionapp list --query "[].{functionAppName:name, resourceGroupName:resourceGroup}" -otsv
}

# Function to get the configuration of a specific function app
function Get-FunctionAppConfig($resourceGroupName, $functionAppName) {
    $config = az functionapp show -g $resourceGroupName -n $functionAppName --query "{minTlsVersion: siteConfig.minTlsVersion, ftpsState: siteConfig.ftpsState, httpsOnly: httpsOnly, http20Enabled: siteConfig.http20Enabled}" -ojson | ConvertFrom-Json
    return $config
}

# Function to process and output the configuration of each function app
function Process-FunctionAppConfig($functionAppName, $resourceGroupName, $config) {
    $minTlsVersion = $config.minTlsVersion
    $ftpsState = $config.ftpsState
    $httpsOnly = $config.httpsOnly
    $http20Enabled = $config.http20Enabled

    Write-Host "Function App Name: $functionAppName"
    Write-Host "Resource Group Name: $resourceGroupName"
    Write-Host "TLS Version: $minTlsVersion" -ForegroundColor (Set-ForegroundColor -condition ($minTlsVersion -lt "1.2"))
    Write-Host "FTPS State: $ftpsState" -ForegroundColor (Set-ForegroundColor -condition ($ftpsState -ne "Disabled"))
    Write-Host "HTTPS Only: $httpsOnly" -ForegroundColor (Set-ForegroundColor -condition ($httpsOnly -eq $false))
    Write-Host "HTTP 2.0 Enabled: $http20Enabled" -ForegroundColor (Set-ForegroundColor -condition ($http20Enabled -eq $false))
    Write-Host "----------------------------------------"
}

# Main function to process all function apps
function Process-FunctionApps {
    $functionApps = Get-FunctionApps

    if (-not $functionApps) {
        Write-Host "No Function Apps found."
        return
    }

    foreach ($functionApp in $functionApps) {
        $functionAppName, $resourceGroupName = $functionApp -split "`t"
        $config = Get-FunctionAppConfig -resourceGroupName $resourceGroupName -functionAppName $functionAppName
        Process-FunctionAppConfig -functionAppName $functionAppName -resourceGroupName $resourceGroupName -config $config
    }
}
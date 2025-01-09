# Azure Resource Configuration Scanner

`Invoke-AzResourceConfigScanner.ps1` is a PowerShell script designed to scan and retrieve security related configurations for various Azure resources, including Key Vaults, Storage Accounts, Function Apps, and App Services.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli) installed and configured.
- Appropriate permissions to access the Azure resources.

## Parameters
Specifies the type of Azure resource to scan. Options are `AppServices`, `FunctionApps`, `KeyVaults`, and `StorageAccounts`.

## Modules

The script is modularized into separate files for each resource type, located in the `modules` folder:

- `modules/AppServices.ps1`: Contains functions to scan and retrieve configurations for Azure App Services.
- `modules/FunctionApps.ps1`: Contains functions to scan and retrieve configurations for Azure Function Apps.
- `modules/KeyVaults.ps1`: Contains functions to scan and retrieve configurations for Azure Key Vaults.
- `modules/StorageAccounts.ps1`: Contains functions to scan and retrieve configurations for Azure Storage Accounts.

## Usage

1. Clone the repository.
2. Navigate to the directory containing the scripts.
3. Run `Invoke-AzResourceConfigScanner.ps1` and follow the prompts to select the type of resource you want to scan.


## Output
The script outputs the configuration details of the specified Azure resource type to the console, highlighting important settings with color-coded messages.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
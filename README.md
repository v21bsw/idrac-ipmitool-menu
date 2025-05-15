# Dell Server Fan Control Script

## Overview
This script provides an interactive menu to control the fan speeds of multiple Dell servers using IPMI commands. It allows users to manually set fan speeds, check temperatures, turn fans off, and power servers on/off.

## Features
- Check Wattage
- Set custom fan speed (10% to 100%)
- Set all fans to 10% or 100%
- Enable automatic fan control mode
- Check current fan speeds
- Check ambient temperature
- Turn off fans
- Power servers on and off (with confirmation for shutdown)

## Requirements
- Dell servers with IPMI support
- `ipmitool` installed on the system
- Windows operating system
- Administrator privileges to run the script

## Configuration
Modify the following section in the script to match your server IPs and credentials:

```batch
:: Edit these values to match your servers
set SERVER1=192.168.50.230
set SERVER2=192.168.50.231
set SERVER3=192.168.50.232
set SERVER4=192.168.50.233

:: Credentials for each server
set USERNAME1=admin
set PASSWORD1=admin
set USERNAME2=admin
set PASSWORD2=admin
set USERNAME3=admin
set PASSWORD3=admin
set USERNAME4=admin
set PASSWORD4=admin
```

## Adding More Servers
To add more servers, follow these steps:
1. Add additional `SERVERX`, `USERNAMEX`, and `PASSWORDX` variables in the configuration section.
2. Modify the loops that iterate over the servers:
    - Locate loops using `for %%S in (1 2 3 4)`.
    - Expand the list to include additional servers. For example, if adding a fifth server, change it to:
      ```batch
      for %%S in (1 2 3 4 5) do (
      ```
    - Ensure you update all relevant sections of the script where servers are iterated.

## Usage
1. Open a command prompt with administrator privileges.
2. Run the batch script (`.bat` file).
3. Use the menu to control fan speeds or power operations.

## Notes
- Ensure IPMI is enabled on your servers.
- Incorrect IP or credentials may result in failed operations.
- Shutting down all servers requires confirmation.

## Disclaimer
This script is provided "as-is" without any warranties. Use at your own risk.


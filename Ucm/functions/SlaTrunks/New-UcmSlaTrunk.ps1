<#
.SYNOPSIS
    Adds a new SLA trunk to the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "addSLATrunk" to add a new SLA trunk configuration.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the SLA trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkName
    The name of the SLA trunk to be added. **(Mandatory)**

.PARAMETER Device
    The device associated with the SLA trunk.

.PARAMETER BargeAllowed
    Whether call barging is allowed on the trunk. Options: `yes`, `no`.

.PARAMETER HoldAccess
    Whether hold access is enabled for the trunk. Options: `yes`, `no`.

.EXAMPLE
    New-UcmAddSLATrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkName "NewSLATrunk" `
        -Device "Device1" -BargeAllowed "yes" -HoldAccess "yes"
        This example demonstrates how to add a new SLA trunk with specific settings for call barging and hold access.

#>
function New-UcmAddSLATrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter()][string]$Device,
        [Parameter()][ValidateSet("yes", "no")][string]$BargeAllowed,
        [Parameter()][ValidateSet("yes", "no")][string]$HoldAccess
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "addSLATrunk"
            cookie = $Cookie
            trunk_name = $TrunkName
        }
    }

    # Add optional parameters
    @(
        @{ Name = "Device"; Value = $Device; ApiName = "device" },
        @{ Name = "BargeAllowed"; Value = $BargeAllowed; ApiName = "bargeallowed" },
        @{ Name = "HoldAccess"; Value = $HoldAccess; ApiName = "holdaccess" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
            $apiRequest.request[$_.ApiName] = $_.Value
        }
    }

    # Send API request
    $apiResponse = Invoke-WebRequest -Uri $Uri -Method POST `
        -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-Json $apiRequest -Depth 10) `
        -DisableKeepAlive -SkipCertificateCheck

    # Process API response
    $responseContent = ConvertFrom-Json $apiResponse.Content
    if ($responseContent.status -ne 0) {
        Write-Error "API call to addSLATrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

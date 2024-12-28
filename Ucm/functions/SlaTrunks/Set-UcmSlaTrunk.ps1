<#
.SYNOPSIS
    Updates an existing SLA trunk on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateSLATrunk" to update the configuration of an existing SLA trunk.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the SLA trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkIndex
    The index of the SLA trunk to update. **(Mandatory)**

.PARAMETER TrunkName
    The name of the SLA trunk.

.PARAMETER Device
    The device associated with the SLA trunk.

.PARAMETER BargeAllowed
    Whether call barging is allowed on the trunk. Options: `yes`, `no`.

.PARAMETER HoldAccess
    Whether hold access is enabled for the trunk. Options: `yes`, `no`.

.EXAMPLE
    Set-UcmSLATrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkIndex 1 -TrunkName "SLA_Trunk_1" `
        -Device "Device1" -BargeAllowed "yes" -HoldAccess "yes"
        This example demonstrates how to configure an SLA trunk with specific settings for call barging and hold access.

#>
function Set-UcmSLATrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$TrunkIndex,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter()][string]$Device,
        [Parameter()][ValidateSet("yes", "no")][string]$BargeAllowed,
        [Parameter()][ValidateSet("yes", "no")][string]$HoldAccess
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateSLATrunk"
            cookie = $Cookie
            trunk_index = $TrunkIndex
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
        Write-Error "API call to updateSLATrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
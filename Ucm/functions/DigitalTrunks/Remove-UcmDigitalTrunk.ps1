<#
.SYNOPSIS
    Removes an existing digital trunk from the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "deleteDigitalTrunk" to delete an existing digital trunk from the system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for deleting the digital trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkId
    The ID of the digital trunk to be removed. **(Mandatory)**

.EXAMPLE
    Remove-UcmDigitalTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkId 7
        This example demonstrates how to remove an existing digital trunk with ID 7.

#>
function Remove-UcmDigitalTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$TrunkId
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "deleteDigitalTrunk"
            cookie = $Cookie
            trunk = $TrunkId
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
        Write-Error "API call to removeDigitalTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

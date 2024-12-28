<#
.SYNOPSIS
    Deletes an existing analog trunk from the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "deleteAnalogTrunk" to remove an existing analog trunk configuration from the system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the analog trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkId
    The ID of the trunk to be deleted. **(Mandatory)**

.EXAMPLE
    Remove-UcmAnalogTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkId 7
        This example demonstrates how to delete an existing analog trunk with ID 7.

#>
function Remove-UcmAnalogTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$TrunkId
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "deleteAnalogTrunk"
            cookie = $Cookie
            analogtrunk = $TrunkId
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
        Write-Error "API call to deleteAnalogTrunk failed. Status code: $($responseContent.status)."
    } else {
        return $responseContent.response
    }
}

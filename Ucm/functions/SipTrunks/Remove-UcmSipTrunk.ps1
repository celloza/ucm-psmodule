<#
.SYNOPSIS
    Deletes an existing SIP trunk on the UCM system.

.DESCRIPTION
    This cmdlet invokes the API action "deleteSIPTrunk" to delete a specific SIP trunk from the UCM system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    All requests must include this value. If no cookie is included, error code -6 will be returned.

.PARAMETER TrunkId
    The ID of the SIP trunk to delete.

.EXAMPLE
    Remove-UcmSIPTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkId 5
#>
function Remove-UcmSIPTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$TrunkId
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "deleteSIPTrunk"
            cookie = $Cookie
            trunk = $TrunkId
        }
    }

    # Send API request
    Write-Verbose "Sending API request: $(ConvertTo-Json $apiRequest -Depth 10)"
    $apiResponse = Invoke-WebRequest -Uri $Uri -Method POST `
        -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-Json $apiRequest -Depth 10) `
        -DisableKeepAlive -SkipCertificateCheck

    # Process API response
    $responseContent = ConvertFrom-Json $apiResponse.Content
    if ($responseContent.status -ne 0) {
        Write-Error "API call to deleteSIPTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

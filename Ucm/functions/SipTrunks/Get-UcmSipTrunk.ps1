<#
.SYNOPSIS
    Gets a SIP Trunk using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "getSIPTrunk" and performs operations related to SIPTrunk.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.EXAMPLE
    # Example usage
    Get-UcmSIPTrunk -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -TrunkId 3
#>
function Get-UcmSIPTrunk
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Parameter(Mandatory)]
        [Int32]$TrunkId
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "TrunkId: $TrunkId"

    $apiRequest = @{ 
        request = @{ 
            "action" = "listSIPTrunk"
            "cookie" = $Cookie
            "trunk" = $TrunkId
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to getSIPTrunk failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}
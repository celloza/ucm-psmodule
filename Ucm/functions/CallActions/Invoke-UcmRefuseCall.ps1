﻿<#
.SYNOPSIS
    Invoke the RefuseCall using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "refuseCall" and performs operations related to RefuseCall.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.EXAMPLE
    # Example usage
    Invoke-UcmRefuseCall -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Invoke-UcmRefuseCall
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"

    $apiRequest = @{
        request = @{
            "action" = "refuseCall"
            "cookie" = $Cookie
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to refuseCall failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

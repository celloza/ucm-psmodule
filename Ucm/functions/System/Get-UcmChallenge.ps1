﻿<#
.SYNOPSIS
    Requests a "challenge" from the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "challenge", which returns a string of characters used
    to generate the session cookie (through the Get-UcmCookie cmdlet).

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, i.e. http://10.10.10.1:80/api.

.PARAMETER Username
    The username of an API user configured on the UCM.

.EXAMPLE
    # Request a challenge token
    Get-UcmChallenge -Uri http://10.10.10.1/api -Username cdrapi
#>
function Get-UcmChallenge
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Username
    )

    Write-Verbose "User name: $Username"
    Write-Verbose "Server URI: $Uri"

    $apiRequest = @{
        request = @{
            "action" = "challenge"
            "user" = $Username
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Headers $headers -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.content).status -ne 0)
    {
        Write-Error "Could not get a challenge code from $uri. Status code was $((ConvertFrom-Json $apiResponse.content).status)."
        Write-Verbose "The error code provided by the UCM API was: $(Get-UcmErrorDescription -Code $((ConvertFrom-Json $apiResponse.content).status))"
    }
    else
    {
        return [string](ConvertFrom-Json $apiResponse.content).response.challenge
    }
}

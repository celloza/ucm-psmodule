<#
    .SYNOPSIS
        Requests a "challenge" from the UCM API.
    
    .DESCRIPTION
        This cmdlet invokes the API action "challenge", which returns a string of characters used
        to generate the session cookie (through the Get-UcmCookie cmdlet).
    
    .PARAMETER Uri
        The full URI (including the protocol) to the UCM API, i.e. http://10.10.10.1:80/api.

    .PARAMETER Username
        The username of an API user configured on the UCM.
#>
function Get-UcmChallenge {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Username
    )

    Write-Verbose "User name: $Username"
    Write-Verbose "Server URI: $Uri"

    $challengeRequest = @{
        request = @{
            "action" = "challenge"
            "user" = $Username
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $challengeRequest)"
    
    $challengeResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Headers $headers -Body (ConvertTo-JSON $challengeRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $challengeResponse"

    if((ConvertFrom-Json $challengeResponse.content).status -ne 0)
    {
        Write-Error "Could not get a challenge code from $uri. Status code was $((ConvertFrom-Json $cookieResponse.content).status)."
    }
    else
    {
        return [string](ConvertFrom-Json $challengeResponse.content).response.challenge
    }
}

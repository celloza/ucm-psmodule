<#
    .SYNOPSIS
        Requests a session cookie from the UCM API.
    
    .DESCRIPTION
        This cmdlet invokes the API action "login", which returns a session cookie that can
        be used to invoke authenticated API methods.
    
    .PARAMETER Uri
        The full URI (including the protocol) to the UCM API, i.e. http://10.10.10.1:80/api.

    .PARAMETER Md5Token
        The token to use to authenticate. This expects an MD5 hash of a string consisting of 
        the challenge requested through the Get-UcmChallenge cmdlet, concatenated with the 
        API user's password (as configured on the UCM), i.e. 
        
        $TokenString = "$($challenge)$($password)"

        The Md5Token can only contain alphanumeric characters.

    .PARAMETER Username
        The username of an API user configured on the UCM.
#>
function Get-UcmCookie {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Md5Token,
        [Parameter(Mandatory)]
        [string]$Username
    )

    Write-Verbose "MD5 Token: $Md5Token"
    Write-Verbose "Username: $Username"

    $cookieRequest = @{
        request = @{
            "action" = "login"
            "token" = $Md5Token
            "user" = $Username
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $cookieRequest)"
    
    $cookieResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Headers $headers -Body (ConvertTo-JSON $cookieRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $cookieResponse"

    if((ConvertFrom-Json $cookieResponse.content).status -ne 0)
    {
        Write-Error "Could not get a cookie from $uri. Status code was $((ConvertFrom-Json $cookieResponse.content).status)."
    }
    else 
    {
        Write-Output (ConvertFrom-Json $cookieResponse.content).response.cookie
    }    
}
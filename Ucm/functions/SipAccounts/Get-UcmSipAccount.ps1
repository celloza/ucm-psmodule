<#
.SYNOPSIS
    Gets a SIP Account using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "getSIPAccount" and performs operations related to SIPAccounts.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER Extension
    The extension number of the SIP Account to return.

.EXAMPLE
    # Example usage
    Get-UcmExtension -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -Extension "1"
#>
function Get-UcmExtension
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Parameter(Mandatory)]
        [string]$Extension
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "Extension: $Extension"

    $apiRequest = @{ 
        request = @{ 
            "action" = "getSIPAccount"
            "cookie" = $Cookie
            "Extension" = $ExtensionId
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to getSIPAccount failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}
<#
.SYNOPSIS
    Gets an OutboundRoute using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "getOutboundRoute" and performs operations related to OutboundRoutes.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER RouteId
    The Id of the Outbound Route to return.

.EXAMPLE
    # Example usage
    Get-UcmOutboundRoute -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -RouteId "testRoute"
#>
function Get-UcmOutboundRoute
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Parameter(Mandatory)]
        [string]$RouteId
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "RouteId: $RouteId"

    $apiRequest = @{
        request = @{
            "action" = "getOutboundRoute"
            "cookie" = $Cookie
            "outbound_route" = $RouteId
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to getOutboundRoute failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
        Write-Verbose "The error code provided by the UCM API was: $(Get-UcmErrorDescription -Code $((ConvertFrom-Json $apiResponse.content).status))"
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

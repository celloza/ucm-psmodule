<#
.SYNOPSIS
    Gets a PagingGroup using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "getPaginggroup" and performs operations related to OutboundRoutes.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER PagingGroupId
    The number of the PagingGroup/Intercom to return.

.EXAMPLE
    # Example usage
    Get-UcmPagingGroup -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -PagingGroupId "1"
#>
function Get-UcmPagingGroup
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Parameter(Mandatory)]
        [string]$PagingGroupId
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "PagingGroupId: $PagingGroupId"

    $apiRequest = @{
        request = @{
            "action" = "getPaginggroup"
            "cookie" = $Cookie
            "paginggroup" = $PagingGroupId
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to getPaginggroup failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

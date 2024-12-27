<#
.SYNOPSIS
    Lists all Outbound Routes using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "listOutboundRoute" and performs operations related to
    OutboundRoute.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER Top
    The number of items to return. Returns 30 if unspecified.

.PARAMETER Page
    The page to return. Returns the first page if unspecified.

.PARAMETER SortOrder
    The sort order for results, either "asc" or "desc". Uses "asc" if unspecified.

.PARAMETER SortByIndex
    Sort results according to the index.

.PARAMETER Fields
    The details to return. Needs to be a comma-separated list of these values:
    * outbound_rt_name
    * outbound_rt_index
    * permission
    * sequence
    * pattern
    * out_of_service

.EXAMPLE
    # Example usage
    Get-UcmOutboundGroups -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -Top 15 -Page 2 -SortOrder "desc"
#>
function Get-UcmOutboundGroups
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Int32]$Top = 30,
        [Int32]$Page = 1,
        [ValidateSet("asc","desc")]
        [string]$SortOrder = "asc",
        [bool]$SortByIndex = $true,
        [string]$Fields = "outbound_rt_name,outbound_rt_index,permission,sequence,pattern,out_of_service"
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "Top: $Top"
    Write-Verbose "Page: $Page"
    Write-Verbose "SortOrder: $SortOrder"
    Write-Verbose "SortByIndex: $SortByIndex"
    Write-Verbose "Fields: $Fields"

    $apiRequest = @{
        request = @{
            "action" = "listOutboundGroups"
            "cookie" = $Cookie
            "page" = $Page
            "item_num" = $Top
            "sord" = $SortOrder
            "sidx" = $SortByIndex
            "options" = $Fields
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"

    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to listOutboundRoute failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
        Write-Verbose "The error code provided by the UCM API was: $(Get-UcmErrorDescription -Code $((ConvertFrom-Json $apiResponse.content).status))"
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

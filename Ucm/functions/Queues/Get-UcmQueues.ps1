<#
.SYNOPSIS
    Lists all Queues using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "listQueue" and performs operations related to
    Queues.

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
    * extension
    * queue_name
    * strategy
    * queue_chairmans
    * members

.EXAMPLE
    # Example usage
    Get-UcmQueues -Uri http://10.10.10.1:80/api -Cookie "session_cookie" -Top 15 -Page 2 -SortOrder "desc"
#>
function Get-UcmQueues
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
        [string]$Fields = "extension,queue_name,strategy,queue_chairmans,members"
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
            "action" = "listQueue"
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
        Write-Error "API call to listQueue failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

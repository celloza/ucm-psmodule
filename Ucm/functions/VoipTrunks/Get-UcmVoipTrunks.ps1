<#
.SYNOPSIS
    List all VoipTrunks using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "listVoIPTrunk" and performs operations related to VoipTrunks.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER Top
    The number of items to return. Returns 30 if unspecified.

.PARAMETER Page
    The page to return. Returns the first page if unspecified.

.PARAMETER Fields
    The details of the trunks to display. Needs to be a comma-separated list of these values:
    * trunk_index
    * trunk_name
    * host
    * trunk_type
    * username
    * technology
    * ldap_sync_enable
    * trunks.out_of_service

.PARAMETER SortOrder
    The sort order for results, either "asc" or "desc". Uses "asc" if unspecified.

.PARAMETER SortByIndex
    Sort results according to the index.

.EXAMPLE
    # Example usage
    Get-UcmVoipTrunks -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Get-UcmVoipTrunks
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [Int32]$Top = 30,
        [Int32]$Page = 1,
        [string]$Fields = "trunk_index,trunk_name,host,trunk_type,username,technology,ldap_sync_enable,trunks.out_of_service",
        [string]$SortOrder = "asc",
        [bool]$SortByIndex = $true
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "Top: $Top"
    Write-Verbose "Page: $Page"
    Write-Verbose "Fields: $Fields"
    Write-Verbose "SortOrder: $SortOrder"
    Write-Verbose "SortByIndex: $SortByIndex"

    $apiRequest = @{
        request = @{
            "action" = "listVoIPTrunk"
            "cookie" = $Cookie
            "options" = $Fields
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to listVoIPTrunk failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

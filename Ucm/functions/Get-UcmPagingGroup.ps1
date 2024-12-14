<#
    .SYNOPSIS
        Requests a list of paging groups from the UCM API.
    
    .DESCRIPTION
        This cmdlet invokes the API action "listPaginggroup", which returns a list of all
        Paging Groups configured on the UCM. Results are returned in sets of pages, with the
        PageNumber argument selecting the specific page to return.
    
    .PARAMETER Uri
        The full URI (including the protocol) to the UCM API, i.e. http://10.10.10.1:80/api.

    .PARAMETER Cookie
        A valid authentication cookie.

    .PARAMETER PageNumber
        The number for the page to return. Defaults to 1.

    .PARAMETER SortOrder
        The sorting order, i.e. "asc" or "desc"
#>
function Get-UcmPagingGroup {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [int]$PageNumber = 1,
        [ValidateSet("asc","desc")]
        [switch]$SortOrder = "asc"
    )

    Write-Verbose "Cookie: $Cookie"

    $listPagingGroupRequest = @{
        request = @{
            "action" = "listPaginggroup"
            "cookie" = $Cookie
            "page" = $PageNumber
            "sidx" = "extension"
            "sord" = $SortOrder
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $listPagingGroupRequest)"
    
    $listPagingGroupResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Headers $headers -Body (ConvertTo-JSON $listPagingGroupRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $listPagingGroupResponse"

    if((ConvertFrom-Json $listPagingGroupResponse.content).status -ne 0)
    {
        Write-Error "Could not get a cookie from $Uri. Status code was $((ConvertFrom-Json $listPagingGroupResponse.content).status)."
    }
    else
    {
        return [string](ConvertFrom-Json $listPagingGroupResponse.content).response.paginggroup
    }
}

<#
.SYNOPSIS
    Gets call detail records through the UCM API.

.DESCRIPTION
    Returns call detail records in the format specified, with a number of filter options.

    For the Caller, Callee, and AnsweredBy parameters, the filter can find call records
    that match the input parameter, based on source (caller) number or destination (callee) number.
    
    A format including wildcard ('@' or '_') will be treated as an expression, where:
    * '-' is treated as range symbol rather than hyphen
    * '@' represents characters of any digit(including 0)
    * '_' represents one character

    Otherwise, digits including a hyphen will be recognized as an extension segment. Non-numeric characters
    or characters including multiple hyphens will be ignored.

    '0-0' matches all non-numeric string and null string.

    For example: 
    `caller=5300,5302-5304,_4@-orcaller=5300&caller=5302-5304&caller=_4@` matches extensions 5300, 5302, 5303,
    5304 and any extension of which the second digit is 4.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER Format
    The format of the data returned. Valid values are:
    * csv
    * xml
    * json
    If unspecified, JSON is assumed.

.PARAMETER Top
    The number of items to return. Returns 30 if unspecified.

.PARAMETER Page
    The page to return. Returns the first page if unspecified.

.PARAMETER Caller
    A filter for the caller field. Refer to the Description for information.

.PARAMETER Callee
    A filter for the callee field. Refer to the Description for information.

.PARAMETER StartTime
    A start time to filter CDRs from.

.PARAMETER EndTime
    An end time to filter CDRs to.

.PARAMETER MinimumDuration
    Only return CDRs where a minimum duration (in seconds) exceed this value.

.PARAMETER MaximumDuration
    Only return CDRs where a maximum duration (in seconds) is less than this value.

.PARAMETER TimeFilterType
    Can be either "Start" or "End".

.PARAMETER CallerName
    The name of the caller.

.EXAMPLE
    # Example usage
    Invoke-UcmCdrApi -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Invoke-UcmCdrApi
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [string]$Format = "json",
        [Int32]$Top = 1000,
        [Int32]$Page = 1,
        [string]$Caller,
        [string]$Callee,
        [datetime]$StartTime = "2000-01-01T00:00:00.000",
        [datetime]$EndTime = "2099-12-31T23:59:59.999",
        [string]$TimeFilterType,
        [Int32]$MinimumDuration = 0,
        [Int32]$MaximumDuration = 99999,
        [string]$AnsweredBy,
        [string]$CallerName
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "Format: $Format"
    Write-Verbose "Top: $Top"
    Write-Verbose "Page: $Page"
    Write-Verbose "Caller: $Caller"
    Write-Verbose "Callee: $Callee"
    Write-Verbose "StartTime: $StartTime"
    Write-Verbose "EndTime: $EndTime"

    $offset = ($Page - 1) * $Top

    $apiRequest = @{ 
        request = @{ 
            "action" = "cdrapi"
            "cookie" = $Cookie
            "format" = $Format
            "numRecords" = $Top
            "offset" = $offset
            "caller" = $Caller
            "callee" = $Callee
            "startTime" = $StartTime
            "endTime" = $EndTime
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to cdrapi failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

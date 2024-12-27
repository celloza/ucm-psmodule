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
    Get-UcmCallDetailRecords -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Get-UcmCallDetailRecords
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [ValidateSet("csv","json","xml")]
        [string]$Format = "json",
        [Int32]$Top = 1000,
        [Int32]$Page = 1,
        [string]$Caller,
        [string]$Callee,
        [datetime]$StartTime,
        [datetime]$EndTime,
        [ValidateSet("Start","End")]
        [string]$TimeFilterType,
        [Int32]$MinimumDuration,
        [Int32]$MaximumDuration,
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
    Write-Verbose "MinimumDuration: $EndTime"
    Write-Verbose "MaximumDuration: $EndTime"
    Write-Verbose "AnsweredBy: $AnsweredBy"
    Write-Verbose "CallerName: $CallerName"

    $offset = ($Page - 1) * $Top

    $apiRequest = @{
        request = @{
            "action" = "cdrapi"
            "cookie" = $Cookie
            "format" = $Format
            "numRecords" = $Top
            "offset" = $offset
        }
    }

    if($PSBoundParameters.ContainsKey('Caller'))
    {
        $apiRequest.Add("caller", $Caller)
    }

    if($PSBoundParameters.ContainsKey('Callee'))
    {
        $apiRequest.Add("callee", $Callee)
    }

    if($PSBoundParameters.ContainsKey('StartTime'))
    {
        $apiRequest.Add("startTime", $StartTime)
    }

    if($PSBoundParameters.ContainsKey('EndTime'))
    {
        $apiRequest.Add("endTime", $EndTime)
    }

    if($PSBoundParameters.ContainsKey('MinimumDuration'))
    {
        $apiRequest.Add("minDur", $MinimumDuration)
    }

    if($PSBoundParameters.ContainsKey('MaximumDuration'))
    {
        $apiRequest.Add("maxDur", $MaximumDuration)
    }

    if($PSBoundParameters.ContainsKey('AnsweredBy'))
    {
        $apiRequest.Add("answeredby", $AnsweredBy)
    }

    if($PSBoundParameters.ContainsKey('CallerName'))
    {
        $apiRequest.Add("callerName", $CallerName)
    }

    if($PSBoundParameters.ContainsKey('TimeFilterType'))
    {
        # The documentation refers to this field as 'tineFilterType'... assuming this is an error
        $apiRequest.Add("timeFilterType", $TimeFilterType)
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"

    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if($Format -eq "json")
    {
        if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
        {
            Write-Error "API call to cdrapi failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
            Write-Verbose "The error code provided by the UCM API was: $(Get-UcmErrorDescription -Code $((ConvertFrom-Json $apiResponse.content).status))"
        }
        else
        {
            return (ConvertFrom-Json $apiResponse.Content).response
        }
    }
    else 
    {
        return $apiResponse.Content
    }
}

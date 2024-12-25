<#
.SYNOPSIS
    Download a recording through the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "recapi" and performs operations related to RecApi.

    Directory and Filename are both optional. If neither are specified, a list of the supported recording
    "types" are returned. If only Filename is specified, the Directory is assumed to be "monitor". If only
    Directory is suppled, all recordings of that type will be returned.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.PARAMETER Directory
    The recording "type" to download. You can specify any number of the following in a comma-separated
    list:
    * monitor
    * emergency
    * meetme
    * queue
    * sca

.PARAMETER Filename
    The name of the file to return.

.EXAMPLE
    # Example usage
    Get-UcmRecording -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Get-UcmRecording
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie,
        [string]$Directory,
        [string]$Filename
    )

    Write-Verbose "Uri: $Uri"
    Write-Verbose "Cookie: $Cookie"
    Write-Verbose "Directory: $Directory"
    Write-Verbose "Filename: $Filename"

    $apiRequest = @{
        request = @{
            "action" = "recapi"
            "cookie" = $Cookie
            "filedir" = $Directory
            "filename" = $Filename
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $apiRequest)"
    
    $apiResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-JSON $apiRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $apiResponse"

    if((ConvertFrom-Json $apiResponse.Content).status -ne 0)
    {
        Write-Error "API call to recapi failed. Status code was $((ConvertFrom-Json $apiResponse.Content).status)."
    }
    else
    {
        return (ConvertFrom-Json $apiResponse.Content).response
    }
}

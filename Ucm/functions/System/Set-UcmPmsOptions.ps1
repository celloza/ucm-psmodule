<#
.SYNOPSIS
    Configure PMS actions such as Checkin and Checkout using the UCM API.

.DESCRIPTION
    This cmdlet corresponds to the API method "pmsapi" and performs operations related to PmsApi.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Must be provided to authenticate the API request.

.EXAMPLE
    # Example usage
    Set-UcmPmsOptions -Uri http://10.10.10.1:80/api -Cookie "session_cookie"
#>
function Set-UcmPmsOptions
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$Cookie
    )

    Write-Error "This action has not been implemented yet."
}

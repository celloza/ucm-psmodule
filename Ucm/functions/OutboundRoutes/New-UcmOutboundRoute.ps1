<#
.SYNOPSIS
    Adds a new outbound route in the UCM system.

.DESCRIPTION
    This cmdlet sends a request to the UCM API to create a new outbound route with specified parameters.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER OutboundRtIndex
    The unique identifier for the outbound route. This is mandatory.

.PARAMETER OutboundRtName
    The name of the outbound route. This should be 2-24 alphanumeric characters and can include underscores and hyphens. This is mandatory.

.PARAMETER DefaultTrunkIndex
    The trunk ID used for the outbound route. This is mandatory.

.PARAMETER Pattern
    A JSON array of routing patterns. Patterns are prefixed by an underscore `_` and can include special characters such as:
    - `[12345-9]` for any digit in the brackets.
    - `N` for any digit from 2-9.
    - `.` for wildcard matching one or more characters.
    - `X` for any digit from 0-9.
    - `Z` for any digit from 1-9.
    This is mandatory.

.PARAMETER Permission
    The permission level required to use the route. Valid values are:
    - `none`
    - `internal`
    - `local`
    - `national`
    - `international`.

.PARAMETER OutOfService
    Indicates whether the route is disabled. Valid values are `yes` or `no`.

.PARAMETER Password
    The password (4-10 digits) required to use the route. If not configured, no password will be required.

.PARAMETER Strip
    Specifies the number of digits to be removed from the beginning of the dialed string before placing the call. For example, if users dial a `9` for external calls, this digit can be stripped before the call is placed.

.PARAMETER Prepend
    Digits to be added to the beginning of the dialed string after the number is stripped. For example, if a `9` is stripped, you can prepend an international dialing code.

.PARAMETER EnableWhitelist
    Enables filtering on source caller IDs. When set to `yes`, only specified extensions, extension groups, or those matching a custom dynamic route pattern can use this outbound route.

.EXAMPLE
    New-UcmOutboundRoute -Uri "http://10.10.10.1/api" -Cookie $cookie -OutboundRtIndex "1" `
        -OutboundRtName "OfficeRoute" -DefaultTrunkIndex "3" -Pattern '[{"match":"_1xxx"}]' `
        -Permission "local" -OutOfService "no" -Password "1234" -Strip 1 -Prepend "9" `
        -EnableWhitelist "yes"
    Adds a new outbound route named "OfficeRoute" for trunk index 3 with specific routing rules.

.NOTES
    Ensure all mandatory parameters are provided for successful execution.
#>
function New-UcmOutboundRoute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$OutboundRtIndex,
        [Parameter(Mandatory)][string]$OutboundRtName,
        [Parameter(Mandatory)][string]$DefaultTrunkIndex,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter()][ValidateSet("none", "internal", "local", "national", "international")][string]$Permission,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$Password,
        [Parameter()][int]$Strip,
        [Parameter()][string]$Prepend,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWhitelist
    )

    $apiRequest = @{
        request = @{
            action = "addOutboundRoute"
            cookie = $Cookie
            outbound_rt_index = $OutboundRtIndex
            outbound_rt_name = $OutboundRtName
            default_trunk_index = $DefaultTrunkIndex
            pattern = $Pattern
        }
    }

    $optionalParameters = @(
        @{ Name = "Permission"; ApiName = "permission" },
        @{ Name = "OutOfService"; ApiName = "out_of_service" },
        @{ Name = "Password"; ApiName = "password" },
        @{ Name = "Strip"; ApiName = "strip" },
        @{ Name = "Prepend"; ApiName = "prepend" },
        @{ Name = "EnableWhitelist"; ApiName = "enable_wlist" }
    )

    foreach ($param in $optionalParameters) {
        if ($PSBoundParameters.ContainsKey($param.Name)) {
            $apiRequest.request[$param.ApiName] = $PSBoundParameters[$param.Name]
        }
    }

    $apiResponse = Invoke-WebRequest -Uri $Uri -Method POST `
        -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-Json $apiRequest -Depth 10)

    $responseContent = ConvertFrom-Json $apiResponse.Content
    if ($responseContent.status -ne 0) {
        Write-Error "API call to addOutboundRoute failed. Status: $($responseContent.status)"
    } else {
        return $responseContent.response
    }
}

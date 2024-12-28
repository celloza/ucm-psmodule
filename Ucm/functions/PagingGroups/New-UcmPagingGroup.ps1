<#
.SYNOPSIS
    Adds a new paging group in the UCM system.

.DESCRIPTION
    This cmdlet sends a request to the UCM API to create a new paging group with the specified configurations.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER Extension
    The extension number of the paging group. This is mandatory.

.PARAMETER PaginggroupName
    The name of the paging group. This is mandatory.

.PARAMETER PaginggroupType
    The type of paging group. Valid options are:
    - `1way`: One-way paging
    - `2way`: Two-way intercom
    - `3way`: Multicast paging
    - `announcement`: Announcement paging.
    This is mandatory.

.PARAMETER CustomPrompt
    A custom prompt to play when the paging group is called. This is optional.

.PARAMETER ReplaceCallerId
    Whether to replace the caller display name with the paging group name. Valid values: `yes`, `no`. This is optional.

.PARAMETER MulticastIp
    The multicast IP address for the paging group. The allowed range is 224.0.1.0 to 238.255.255.255. This is optional.

.PARAMETER MulticastPort
    The port number for the multicast address. This is optional.

.PARAMETER Limitime
    The maximum call duration in seconds. A value of 0 means no limit. This is optional.

.PARAMETER CustomDate
    The custom date for scheduling the paging group. This is optional.

.PARAMETER Time
    The time (in HH:MM format) for scheduling the paging group. This is optional.

.PARAMETER Enable
    Whether to enable announcement paging. Valid values: `yes`, `no`. This is optional.

.PARAMETER Members
    A list of members (extensions) included in the paging group. This is optional.

.PARAMETER Paginggroup
    The paging group number. This is mandatory.

.PARAMETER OldMulticastIp
    The previous multicast IP address (if changing). This is optional.

.PARAMETER OldMulticastPort
    The previous multicast port (if changing). This is optional.

.PARAMETER NumberAllowed
    A whitelist of extensions allowed to initiate paging/intercom calls. If not specified, all extensions are allowed. This is optional.

.EXAMPLE
    New-UcmPagingGroup -Uri "http://10.10.10.1/api" -Cookie $cookie -Extension "8001" `
        -PaginggroupName "SalesPaging" -PaginggroupType "1way" -CustomPrompt "welcome.wav" `
        -MulticastIp "224.0.1.1" -MulticastPort 5004 -Limitime 300 -Enable "yes" -Members "1001,1002" `
        -Paginggroup "5" -ReplaceCallerId "yes"
    This example creates a one-way paging group named "SalesPaging" with a custom prompt, multicast settings, and specified members.

.NOTES
    Ensure all mandatory parameters are provided for successful execution.
#>
function New-UcmPagingGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$Extension,
        [Parameter(Mandatory)][string]$PaginggroupName,
        [Parameter(Mandatory)][ValidateSet("1way", "2way", "3way", "announcement")][string]$PaginggroupType,
        [Parameter()][string]$CustomPrompt,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerId,
        [Parameter()][string]$MulticastIp,
        [Parameter()][int]$MulticastPort,
        [Parameter()][int]$Limitime,
        [Parameter()][string]$CustomDate,
        [Parameter()][string]$Time,
        [Parameter()][ValidateSet("yes", "no")][string]$Enable,
        [Parameter()][string]$Members,
        [Parameter(Mandatory)][string]$Paginggroup,
        [Parameter()][string]$OldMulticastIp,
        [Parameter()][int]$OldMulticastPort,
        [Parameter()][string]$NumberAllowed
    )

    $apiRequest = @{
        request = @{
            action = "addPaginggroup"
            cookie = $Cookie
            extension = $Extension
            paginggroup_name = $PaginggroupName
            paginggroup_type = $PaginggroupType
            paginggroup = $Paginggroup
        }
    }

    $optionalParameters = @(
        @{ Name = "CustomPrompt"; ApiName = "custom_prompt" },
        @{ Name = "ReplaceCallerId"; ApiName = "replace_caller_id" },
        @{ Name = "MulticastIp"; ApiName = "multicast_ip" },
        @{ Name = "MulticastPort"; ApiName = "multicast_port" },
        @{ Name = "Limitime"; ApiName = "limitime" },
        @{ Name = "CustomDate"; ApiName = "custom_date" },
        @{ Name = "Time"; ApiName = "time" },
        @{ Name = "Enable"; ApiName = "enable" },
        @{ Name = "Members"; ApiName = "members" },
        @{ Name = "OldMulticastIp"; ApiName = "old_multicast_ip" },
        @{ Name = "OldMulticastPort"; ApiName = "old_multicast_port" },
        @{ Name = "NumberAllowed"; ApiName = "number_allowed" }
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
        Write-Error "API call to addPaginggroup failed. Status: $($responseContent.status)"
    } else {
        return $responseContent.response
    }
}

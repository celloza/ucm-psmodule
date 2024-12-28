<#
.SYNOPSIS
    Updates a paging group on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updatePagingGroup" to update the configuration of an existing paging group.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This is the base URL used to access the UCM API.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    This is needed for every subsequent API request to ensure that the session remains authenticated.

.PARAMETER PagingGroupId
    The ID of the paging group to update.
    This parameter identifies the paging group to modify within the UCM system.

.PARAMETER PagingGroupName
    The name of the paging group.
    This specifies the name for the paging group, used to identify it in the system.

.PARAMETER PagingGroupType
    The type of paging group. Options: `1way`, `2way`, `3way`, `announcement`.
    This defines how the paging group behaves:
    - `1way`: One-way paging where only the server can speak.
    - `2way`: Two-way paging allowing both the server and the users to communicate.
    - `3way`: Similar to 2-way, but with an additional conference capability.
    - `announcement`: Used for announcement-only paging, where the system broadcasts to users but they cannot respond.

.PARAMETER Enable
    Whether the paging group is enabled. Options: `yes`, `no`.
    This determines whether the paging group is active and capable of receiving or transmitting paging messages.

.PARAMETER Members
    List of members in the paging group.
    Specifies the list of extensions or devices that will be included in the paging group, identified by their numbers or IDs.

.PARAMETER ReplaceCallerId
    Whether to replace the caller ID with the paging group name. Options: `yes`, `no`.
    If enabled, the caller ID shown to recipients will be replaced by the paging group's name instead of the original caller ID.

.PARAMETER MulticastIp
    Multicast IP address for the paging group.
    Defines the IP address that will be used for sending multicast paging messages to members of the group.

.PARAMETER MulticastPort
    Multicast port for the paging group.
    Specifies the network port used for multicast transmission.

.PARAMETER MaxCallDuration
    Maximum duration of a call in seconds.
    Defines the maximum amount of time a paging call will last before it is automatically disconnected.

.PARAMETER CustomDate
    Custom date for scheduling paging.
    Allows the user to define a custom date on which the paging group should be active or triggered.

.PARAMETER CustomPrompt
    Path to the custom prompt file.
    This specifies a file (such as an audio file) that will be used for a custom announcement to be played during paging.

.PARAMETER Time
    Time for scheduling paging in HH:MM format.
    Specifies the time at which the paging should occur when scheduled. The time should be in the 24-hour format.

.PARAMETER MulticastPort
    The port number for the multicast address used for paging.
    This defines which port to use for broadcasting paging messages.

.PARAMETER MaxCallDuration
    The maximum length of time for each call to be in progress.
    This parameter ensures that no paging call lasts longer than the defined duration, preventing extended calls from occupying resources.

.PARAMETER CustomDate
    Date for scheduling the paging group to be triggered.
    Used to define a specific day (in YYYY-MM-DD format) on which the paging group should be active.

.PARAMETER CustomPrompt
    Custom prompt audio file for paging.
    Allows you to specify a custom audio file that will be played to users when they are paged. The file must be in a supported audio format and properly uploaded.

.PARAMETER Time
    Time at which the paging will be initiated.
    This should be specified in 24-hour HH:MM format to define when the paging process starts.

.EXAMPLE
    Set-UcmPagingGroup -Uri http://10.10.10.1/api -Cookie $cookie -PagingGroupId "101" -PagingGroupName "SalesPage" `
        -PagingGroupType "2way" -Enable "yes" -Members "1001,1002,1003" -ReplaceCallerId "no" `
        -MulticastIp "239.1.1.1" -MulticastPort "1234" -MaxCallDuration 180 -CustomDate "2024-12-31" `
        -CustomPrompt "sales_prompt.wav" -Time "14:00"
    This example shows how to configure a paging group with specific members, settings, and a custom prompt.
#>
function Set-UcmPagingGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$PagingGroupNumber,
        [Parameter(Mandatory)][string]$PagingGroupName,
        [Parameter(Mandatory)][ValidateSet("1way", "2way", "3way", "announcement")][string]$PagingGroupType,
        [Parameter()][ValidateSet("yes", "no")][string]$Enable,
        [Parameter()][string]$Members,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerId,
        [Parameter()][string]$MulticastIp,
        [Parameter()][int]$MulticastPort,
        [Parameter()][int]$MaxCallDuration,
        [Parameter()][string]$CustomDate,
        [Parameter()][string]$CustomPrompt,
        [Parameter()][string]$Time
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updatePagingGroup"
            cookie = $Cookie
            paginggroup = $PagingGroupNumber
            paginggroup_name = $PagingGroupName
            paginggroup_type = $PagingGroupType
        }
    }

    # Add optional parameters and verbose logging
    @(
        @{ Name = "Enable"; Value = $Enable; ApiName = "enable" },
        @{ Name = "Members"; Value = $Members; ApiName = "members" },
        @{ Name = "ReplaceCallerId"; Value = $ReplaceCallerId; ApiName = "replace_caller_id" },
        @{ Name = "MulticastIp"; Value = $MulticastIp; ApiName = "multicast_ip" },
        @{ Name = "MulticastPort"; Value = $MulticastPort; ApiName = "multicast_port" },
        @{ Name = "MaxCallDuration"; Value = $MaxCallDuration; ApiName = "limitime" },
        @{ Name = "CustomDate"; Value = $CustomDate; ApiName = "custom_date" },
        @{ Name = "CustomPrompt"; Value = $CustomPrompt; ApiName = "custom_prompt" },
        @{ Name = "Time"; Value = $Time; ApiName = "time" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
            Write-Verbose "$($_.Name): $($_.Value)"
            $apiRequest.request[$_.ApiName] = $_.Value
        }
    }

    # Send API request
    Write-Verbose "Sending API request: $(ConvertTo-Json $apiRequest -Depth 10)"
    $apiResponse = Invoke-WebRequest -Uri $Uri -Method POST `
        -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-Json $apiRequest -Depth 10) `
        -DisableKeepAlive -SkipCertificateCheck

    # Process API response
    $responseContent = ConvertFrom-Json $apiResponse.Content
    if ($responseContent.status -ne 0) {
        $errorDescription = Get-UcmErrorDescription -Code $responseContent.status
        Write-Error "API call to updatePagingGroup failed. Status code: $($responseContent.status). Error: $errorDescription"
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
<#
.SYNOPSIS
    Adds a new IVR to the UCM system.

.DESCRIPTION
    This cmdlet sends a request to the UCM API to create a new IVR with specified parameters.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER IvrName
    The name of the IVR. This is mandatory.

.PARAMETER Extension
    The IVR extension number. This is mandatory.

.PARAMETER WelcomePrompt
    The initial prompt played when a caller enters the IVR. This is mandatory.

.PARAMETER ResponseTimeout
    The timeout (in seconds) for DTMF input after the prompt is played. This is mandatory.

.PARAMETER DigitTimeout
    The timeout (in seconds) for entering each subsequent digit. This is mandatory.

.PARAMETER TimeoutPrompt
    The prompt played if the response timeout is reached. This is mandatory.

.PARAMETER InvalidPrompt
    The prompt played when an invalid input is detected. This is mandatory.

.PARAMETER TLoop
    The number of times to repeat the timeout prompt. This is mandatory.

.PARAMETER ILoop
    The number of times to repeat the invalid input prompt. This is mandatory.

.PARAMETER DialExtension
    Allows dialing extensions from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialConference
    Allows dialing conference rooms from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialQueue
    Allows dialing queues from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialRingGroup
    Allows dialing ring groups from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialVmGroup
    Allows dialing voicemail groups from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialPagingGroup
    Allows dialing paging/intercom groups from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialFax
    Allows dialing fax extensions from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialTrunk
    Allows dialing trunks from the IVR. Valid values: `yes`, `no`.

.PARAMETER DialDirectory
    Allows dialing by name using a directory. Valid values: `yes`, `no`.

.PARAMETER Permission
    The permission level for dialing from the IVR. Valid values: `internal`, `internal-local`, `internal-local-national`, `internal-local-national-international`.

.PARAMETER Language
    The language for IVR prompts.

.PARAMETER AlertInfo
    (Optional) Alert info for incoming calls. Options include `none`, `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, `ring6`, `ring7`, `ring8`, `ring9`, `ring10`, `Bellcore-dr1`, `Bellcore-dr2`, `Bellcore-dr3`, `Bellcore-dr4`, `Bellcore-dr5`, and `custom`.
    Specifies the ring pattern or alert tone for calls routed through this inbound route.

.PARAMETER ReplaceCallerId
    Replaces the caller ID with the IVR name. Valid values: `yes`, `no`.

.PARAMETER Switch
    Enables or disables a switch for the IVR. Valid values: `yes`, `no`.

.PARAMETER IvrBlackWhiteList
    Specifies the internal IVR blacklist/whitelist.

.PARAMETER IvrOutBlackWhiteList
    Specifies the external IVR blacklist/whitelist.

.PARAMETER Members
    A JSON array defining key press events and their corresponding actions.

.EXAMPLE
    New-UcmIvr -Uri "http://10.10.10.1/api" -Cookie $cookie -IvrName "MainMenu" `
        -Extension "7000" -WelcomePrompt "welcome" -ResponseTimeout 10 -DigitTimeout 3 `
        -TimeoutPrompt "timeout" -InvalidPrompt "invalid" -TLoop 3 -ILoop 3 -DialExtension "yes" `
        -DialQueue "no" -Permission "internal" -Language "en" -AlertInfo "ring1"
    This example adds a new IVR with the name "MainMenu" and the extension 7000.

.NOTES
    Ensure mandatory parameters are provided for successful execution.
#>
function New-UcmIvr {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$IvrName,
        [Parameter(Mandatory)][string]$Extension,
        [Parameter(Mandatory)][string]$WelcomePrompt,
        [Parameter(Mandatory)][int]$ResponseTimeout,
        [Parameter(Mandatory)][int]$DigitTimeout,
        [Parameter(Mandatory)][string]$TimeoutPrompt,
        [Parameter(Mandatory)][string]$InvalidPrompt,
        [Parameter(Mandatory)][int]$TLoop,
        [Parameter(Mandatory)][int]$ILoop,
        [Parameter()][ValidateSet("yes", "no")][string]$DialExtension,
        [Parameter()][ValidateSet("yes", "no")][string]$DialConference,
        [Parameter()][ValidateSet("yes", "no")][string]$DialQueue,
        [Parameter()][ValidateSet("yes", "no")][string]$DialRingGroup,
        [Parameter()][ValidateSet("yes", "no")][string]$DialVmGroup,
        [Parameter()][ValidateSet("yes", "no")][string]$DialPagingGroup,
        [Parameter()][ValidateSet("yes", "no")][string]$DialFax,
        [Parameter()][ValidateSet("yes", "no")][string]$DialTrunk,
        [Parameter()][ValidateSet("yes", "no")][string]$DialDirectory,
        [Parameter()][string]$Permission,
        [Parameter()][string]$Language,
        [Parameter()][ValidateSet("none", "ring1", "ring2", "custom")][string]$AlertInfo,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerId,
        [Parameter()][ValidateSet("yes", "no")][string]$Switch,
        [Parameter()][string]$IvrBlackWhiteList,
        [Parameter()][string]$IvrOutBlackWhiteList,
        [Parameter()][array]$Members
    )

    $apiRequest = @{
        request = @{
            action = "addIVR"
            cookie = $Cookie
            ivr_name = $IvrName
            extension = $Extension
            welcome_prompt = $WelcomePrompt
            response_timeout = $ResponseTimeout
            digit_timeout = $DigitTimeout
            timeout_prompt = $TimeoutPrompt
            invalid_prompt = $InvalidPrompt
            tloop = $TLoop
            iloop = $ILoop
        }
    }

    $optionalParameters = @(
        @{ Name = "DialExtension"; ApiName = "dial_extension" },
        @{ Name = "DialConference"; ApiName = "dial_conference" },
        @{ Name = "DialQueue"; ApiName = "dial_queue" },
        @{ Name = "DialRingGroup"; ApiName = "dial_ringgroup" },
        @{ Name = "DialVmGroup"; ApiName = "dial_vmgroup" },
        @{ Name = "DialPagingGroup"; ApiName = "dial_paginggroup" },
        @{ Name = "DialFax"; ApiName = "dial_fax" },
        @{ Name = "DialTrunk"; ApiName = "dial_trunk" },
        @{ Name = "DialDirectory"; ApiName = "dial_directory" },
        @{ Name = "Permission"; ApiName = "permission" },
        @{ Name = "Language"; ApiName = "language" },
        @{ Name = "AlertInfo"; ApiName = "alertinfo" },
        @{ Name = "ReplaceCallerId"; ApiName = "replace_caller_id" },
        @{ Name = "Switch"; ApiName = "switch" },
        @{ Name = "IvrBlackWhiteList"; ApiName = "ivr_blackwhite_list" },
        @{ Name = "IvrOutBlackWhiteList"; ApiName = "ivr_out_blackwhite_list" },
        @{ Name = "Members"; ApiName = "members" }
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
        Write-Error "API call to addIVR failed. Status: $($responseContent.status)"
    } else {
        return $responseContent.response
    }
}

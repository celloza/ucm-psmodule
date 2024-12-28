<#
.SYNOPSIS
    Updates a queue on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateQueue" to update the configuration of an existing queue.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER QueueName
    Name of the queue to update.

.PARAMETER QueueId
    The ID of the queue to update.

.PARAMETER AccountEl
    Account to be used for failover conditions.

.PARAMETER AccountT
    Account to be used for the timeout destination. Refers to the maximum waiting time for this account.

.PARAMETER AccountV
    Account to be used for the destination prompt cycle.

.PARAMETER AlertInfo
    Custom Alert-Info header used for this queue.

.PARAMETER AnnounceFrequency
    Frequency (in seconds) to announce the caller's position in the queue.

.PARAMETER AnnounceHoldTime
    Whether to announce the estimated hold time to callers. Options: `yes`, `no`.

.PARAMETER AnnouncePosition
    Whether to announce the caller's position in the queue. Options: `yes`, `no`.

.PARAMETER AutoFill
    Distribute calls to all available agents immediately. Options: `yes`, `no`.

.PARAMETER AutoRecord
    Call recording options for the queue. Options: `all`, `external`, `internal`, `off`.

.PARAMETER CustomDates
    Specific dates for scheduling resets.

.PARAMETER CustomMonths
    Specific months for scheduling resets.

.PARAMETER CustomPrompt
    Path or filename of the custom prompt to be played during the queue.

.PARAMETER CustomWelcomePrompt
    Path or filename of the custom welcome prompt to be played.

.PARAMETER DestinationTypeEl
    Failover destination type for specific conditions. Options: `external`, `ivr`, `queue`, `voicemail`, `ringgroup`.

.PARAMETER DestinationTypeT
    Timeout destination type. Refers to the maximum waiting time for this destination. Options: `external`, `ivr`, `queue`, `voicemail`, `ringgroup`.

.PARAMETER DestinationTypeV
    Destination type for the destination prompt cycle. Options: `external`, `ivr`, `queue`, `voicemail`, `ringgroup`.

.PARAMETER DestinationVoiceEnable
    Enable voice prompt for the destination. Options: `yes`, `no`.

.PARAMETER EnableAgentLogin
    Enable agent login for the queue. Options: `yes`, `no`.

.PARAMETER EnableFeature
    Enable feature codes for queue members. Options: `yes`, `no`.

.PARAMETER EnableWelcome
    Play a welcome prompt for callers. Options: `yes`, `no`.

.PARAMETER Extension
    The extension number associated with the queue.

.PARAMETER ExternalNumberEl
    External number to be used for failover conditions.

.PARAMETER ExternalNumberT
    External number to be used for the timeout destination. Refers to the maximum waiting time for this external number.

.PARAMETER ExternalNumberV
    External number to be used for the destination prompt cycle.

.PARAMETER IvrEl
    IVR destination for failover conditions.

.PARAMETER IvrT
    IVR destination for the timeout condition. Refers to the maximum waiting time for this IVR destination.

.PARAMETER IvrV
    IVR destination for the destination prompt cycle.

.PARAMETER JoinEmpty
    Allow callers to join the queue if no agents are available. Options: `yes`, `no`, `strict`.

.PARAMETER LeaveWhenEmpty
    Disconnect callers if no agents are available. Options: `yes`, `no`, `strict`.

.PARAMETER MaxLength
    Maximum number of calls allowed in the queue.

.PARAMETER Members
    List of static agents assigned to the queue.

.PARAMETER MusicClass
    Music on hold class for the queue.

.PARAMETER PagingType
    Reset cycle type for scheduled resets. Options: `once`, `daily`, `weekly`, `monthly`.

.PARAMETER Pin
    Dynamic agent login password for the queue.

.PARAMETER QueueChairmans
    List of queue chairmen or admin users.

.PARAMETER QueueDestinationEl
    Destination queue for failover conditions.

.PARAMETER QueueDestinationT
    Destination queue for timeout conditions. Refers to the maximum waiting time for this queue destination.

.PARAMETER QueueDestinationV
    Destination queue for the destination prompt cycle.

.PARAMETER QueueTimeout
    Maximum wait time for callers before rerouting them.

.PARAMETER ReplaceCallerId
    Replace the caller ID with the queue name. Options: `yes`, `no`.

.PARAMETER ReportHoldTime
    Display the caller's hold time to agents. Options: `yes`, `no`.

.PARAMETER Retry
    Retry time (in seconds) before ringing another agent.

.PARAMETER RingGroupEl
    Ring group destination for failover conditions.

.PARAMETER RingGroupT
    Ring group destination for timeout conditions. Refers to the maximum waiting time for this ring group.

.PARAMETER RingGroupV
    Ring group destination for the destination prompt cycle.

.PARAMETER RingTime
    Number of seconds to ring an agent before retrying.

.PARAMETER ScheduleCleanEnable
    Enable periodic resets of agent call counts. Options: `yes`, `no`.

.PARAMETER StartTime
    Time to start periodic resets of agent call counts.

.PARAMETER Strategy
    The ring strategy for the queue. Options: `ringall`, `linear`, `leastrecent`, `fewestcalls`, `random`, `memory`.

.PARAMETER VoicePromptTime
    Interval (in seconds) between repeating custom prompts for callers.

.PARAMETER VoicemailExtensionEl
    Voicemail extension for failover conditions.

.PARAMETER VoicemailExtensionT
    Voicemail extension for timeout conditions. Refers to the maximum waiting time for this voicemail extension.

.PARAMETER VoicemailExtensionV
    Voicemail extension for the destination prompt cycle.

.PARAMETER VoicemailGroupEl
    Voicemail group destination for failover conditions.

.PARAMETER VoicemailGroupT
    Voicemail group for timeout conditions. Refers to the maximum waiting time for this voicemail group.

.PARAMETER VoicemailGroupV
    Voicemail group for the destination prompt cycle.

.PARAMETER VqCallbackEnableTimeout
    Enable timeout for virtual queue callbacks. Options: `yes`, `no`.

.PARAMETER VqCallbackTimeout
    Timeout (in seconds) for virtual queue callbacks.

.PARAMETER VqMode
    Virtual queue mode. Options: `timeout`, `dtmf`.

.PARAMETER VqOutPrefix
    Prefix added to numbers for virtual queue callbacks.

.PARAMETER VqPeriodic
    Timeout period (in seconds) before entering the virtual queue.

.PARAMETER VqSwitch
    Enable virtual queue functionality. Options: `yes`, `no`.

.PARAMETER WeekDate
    Specific day(s) for weekly resets.

.PARAMETER WrapUpTime
    Delay (in seconds) after a call before the agent receives another call.
#>
function Update-UcmQueue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$SessionCookie,
        [Parameter(Mandatory)][string]$QueueName,
        [Parameter(Mandatory)][int]$QueueId,
        [Parameter()][string]$AlertInfo,
        [Parameter()][int]$AnnounceFrequency,
        [Parameter()][ValidateSet("yes", "no")][string]$AnnounceHoldTime,
        [Parameter()][ValidateSet("yes", "no")][string]$AnnouncePosition,
        [Parameter()][ValidateSet("yes", "no")][string]$AutoFill,
        [Parameter()][ValidateSet("all", "external", "internal", "off")][string]$AutoRecord,
        [Parameter()][string]$CustomDates,
        [Parameter()][string]$CustomMonths,
        [Parameter()][string]$CustomPrompt,
        [Parameter()][string]$CustomWelcomePrompt,
        [Parameter()][ValidateSet("external", "ivr", "queue", "voicemail", "ringgroup")][string]$DestinationTypeEl,
        [Parameter()][ValidateSet("external", "ivr", "queue", "voicemail", "ringgroup")][string]$DestinationTypeT,
        [Parameter()][ValidateSet("yes", "no")][string]$DestinationVoiceEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableAgentLogin,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableFeature,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWelcome,
        [Parameter()][string]$Extension,
        [Parameter()][string]$ExternalNumberT,
        [Parameter()][string]$ExternalNumberV,
        [Parameter()][string]$IvrEl,
        [Parameter()][ValidateSet("yes", "no", "strict")][string]$JoinEmpty,
        [Parameter()][ValidateSet("yes", "no", "strict")][string]$LeaveWhenEmpty,
        [Parameter()][int]$MaxLength,
        [Parameter()][array]$Members,
        [Parameter()][string]$MusicClass,
        [Parameter()][ValidateSet("once", "daily", "weekly", "monthly")][string]$PagingType,
        [Parameter()][string]$Pin,
        [Parameter()][string]$QueueChairmans,
        [Parameter()][string]$QueueDestinationT,
        [Parameter()][string]$QueueDestinationV,
        [Parameter()][int]$QueueTimeout,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerId,
        [Parameter()][ValidateSet("yes", "no")][string]$ReportHoldTime,
        [Parameter()][int]$Retry,
        [Parameter()][string]$RingGroupEl,
        [Parameter()][int]$RingTime,
        [Parameter()][ValidateSet("yes", "no")][string]$ScheduleCleanEnable,
        [Parameter()][string]$StartTime,
        [Parameter()][ValidateSet("ringall", "linear", "leastrecent", "fewestcalls", "random", "memory")][string]$Strategy,
        [Parameter()][string]$VoicemailExtensionEl,
        [Parameter()][string]$VoicemailGroupEl,
        [Parameter()][int]$VoicePromptTime,
        [Parameter()][ValidateSet("yes", "no")][string]$VqCallbackEnableTimeout,
        [Parameter()][int]$VqCallbackTimeout,
        [Parameter()][ValidateSet("timeout", "dtmf")][string]$VqMode,
        [Parameter()][string]$VqOutPrefix,
        [Parameter()][int]$VqPeriodic,
        [Parameter()][ValidateSet("yes", "no")][string]$VqSwitch,
        [Parameter()][string]$WeekDate,
        [Parameter()][int]$WrapUpTime,
        [Parameter()][string]$VoicemailExtensionT,
        [Parameter()][string]$AccountT,
        [Parameter()][string]$VoicemailGroupT,
        [Parameter()][string]$IvrT,
        [Parameter()][string]$RingGroupT,
        [Parameter()][ValidateSet("external", "ivr", "queue", "voicemail", "ringgroup")][string]$DestinationTypeV,
        [Parameter()][string]$VoicemailExtensionV,
        [Parameter()][string]$AccountV,
        [Parameter()][string]$VoicemailGroupV,
        [Parameter()][string]$IvrV,
        [Parameter()][string]$RingGroupV,
        [Parameter()][string]$AccountEl,
        [Parameter()][string]$QueueDestinationEl,
        [Parameter()][string]$ExternalNumberEl
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateQueue"
            cookie = $SessionCookie
            queue_name = $QueueName
            queue = $QueueId
        }
    }

    # Add optional parameters dynamically
    foreach ($param in $PSBoundParameters.Keys) {
        if ($param -notin @("Uri", "SessionCookie", "QueueName", "QueueId")) {
            $apiRequest.request[$param.ToLower()] = $PSBoundParameters[$param]
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
        Write-Error "API call to updateQueue failed. Status code: $($responseContent.status). Error: $errorDescription"
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
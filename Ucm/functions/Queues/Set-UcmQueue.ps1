<#
.SYNOPSIS
    Updates an existing queue on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateQueue" to update the configuration of an existing queue.

    The parameters for the queue configuration are grouped into different categories for handling various aspects of the queue's behavior:

    - **T Parameters (Timeout Routing)**: These parameters control the routing of calls when they exceed the specified wait time in the queue. They include:
      - `DestinationTypeT`, `VmExtensionT`, `AccountT`, `VmgroupT`, `IvrT`, `RinggroupT`, `QueueDestT`, `ExternalNumberT`
      When configuring these parameters:
      - You should set **DestinationTypeT** to specify the type of destination to route calls to if they exceed the queue's wait time. Options for `DestinationTypeT` include `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, and `external_number`.
      - If you specify a `DestinationTypeT` of `account`, for example, you should only specify the `AccountT` parameter to define the specific account to route the call to.
      - Similarly, if `DestinationTypeT` is set to `voicemail`, you should only specify the `VmExtensionT` parameter.
      - Any other related T parameters will be ignored if a specific `DestinationTypeT` is set, as only the appropriate parameter for that destination type should be used.

    - **V Parameters (Prompt Cycle Routing)**: These parameters manage the routing of calls during the prompt cycle (e.g., after a certain number of prompts or time in the queue). They include:
      - `DestinationTypeV`, `VmExtensionV`, `AccountV`, `VmgroupV`, `IvrV`, `RinggroupV`, `QueueDestV`, `ExternalNumberV`
      When configuring the **V** parameters:
      - You should set **DestinationTypeV** to specify the type of destination to route calls to during the prompt cycle. As with the T parameters, when specifying `DestinationTypeV`, you should only specify the corresponding parameter (e.g., `AccountV` for `account`).
      - If `DestinationTypeV` is set to `queue`, for example, you should only specify the `QueueDestV` parameter and other related V parameters will be ignored.

    - **EL Parameters (Failover Routing)**: These parameters control the failover routing for calls that cannot be answered by any agents or reach the configured destination. They include:
      - `DestinationTypeEl`, `VmExtensionEl`, `AccountEl`, `VmgroupEl`, `IvrEl`, `RinggroupEl`, `QueueDestEl`, `ExternalNumberEl`
      When configuring the **EL** parameters:
      - You should set **DestinationTypeEl** to specify the type of destination for failover routing. If `DestinationTypeEl` is set to `external_number`, for example, you should only specify the `ExternalNumberEl` parameter for the failover destination.
      - As with the T and V parameters, any other related EL parameters will be ignored when a specific `DestinationTypeEl` is specified.

    When configuring a queue, it's important to remember that only the corresponding parameter for each destination type should be used:
    - If `DestinationTypeT` is `account`, use `AccountT`.
    - If `DestinationTypeV` is `queue`, use `QueueDestV`.
    - If `DestinationTypeEl` is `external_number`, use `ExternalNumberEl`.

    This ensures that the queue routing behaves as expected and that only the appropriate parameters are included for each specific destination type.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER QueueId
    The ID of the queue to update.

.PARAMETER QueueName
    The name of the queue.
    This parameter specifies the name of the call queue, used for identification.

.PARAMETER MusicClass
    The music on hold class used by the queue.
    Defines the music on hold (MOH) class that callers will hear when they are placed on hold.

.PARAMETER LeaveWhenEmpty
    Configures whether to disconnect callers in the queue based on agent status.
    Options:
    - `Yes`: Callers will be disconnected if all agents are paused or unavailable.
    - `No`: Callers will never be disconnected.
    - `Strict` (Default): Callers will be disconnected if no agents are available or if all agents are paused.

.PARAMETER JoinEmpty
    Configures whether callers can dial into a queue with no agents.
    Options:
    - `Yes`: Callers can always dial into the queue, even if it's empty.
    - `No` (Default): Callers cannot dial into the queue if all agents are unavailable.
    - `Strict`: Callers cannot dial into the queue if there are no agents available.

.PARAMETER Pin
    Dynamic login password.
    This password can be configured for dynamic login on the agent login page.

.PARAMETER RingTime
    The ring time in seconds for agents.
    This parameter determines how long the queue will attempt to ring an agent before considering the call unanswered.

.PARAMETER Strategy
    The call distribution strategy for agents. Options:
    - `ringall`: Rings all agents at the same time.
    - `linear`: Rings agents in a linear fashion.
    - `leastrecent`: Rings the agent who has been idle for the least amount of time.
    - `fewestcalls`: Rings the agent with the fewest number of answered calls.
    - `random`: Rings agents randomly.
    - `memory`: Rings agents based on their memory allocation.

.PARAMETER WrapUpTime
    The wrap-up time in seconds after a call is completed.
    This time is given to the agent to finalize the call details before they are available for the next call.

.PARAMETER MaxQueueLength
    Configure the maximum number of calls to be queued at once. This number does not include calls that have been connected to agents, only calls that are still in the queue.
    When this maximum value is exceeded, the caller will hear a busy tone and be forwarded to the configured failover destination. Default value is 0 (unlimited).

.PARAMETER AutoRecord
    Whether to enable call recording for the queue. Options:
    - `all`: Record all calls.
    - `external`: Record external calls only.
    - `internal`: Record internal calls only.
    - `off`: Disable call recording.

.PARAMETER QueueTimeout
    Maximum wait time in the queue before handling the call.
    If the caller exceeds the configured timeout, the call will be forwarded to a failover destination.

.PARAMETER EnableFeature
    Whether to enable the queue feature. Options: `yes`, `no`.
    If set to `yes`, the queue feature will be enabled, allowing the system to manage and route calls to this queue.

.PARAMETER AlertInfo
    Specifies the alert-info header for the queue. Options:
    - `none`
    - `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, `ring6`, `ring7`, `ring8`, `ring9`, `ring10`
    - `Bellcore-dr1`, `Bellcore-dr2`, `Bellcore-dr3`, `Bellcore-dr4`, `Bellcore-dr5`
    - `custom`
    This header specifies how the receiving party will be alerted with specific tones or messages.

.PARAMETER VoicePromptTime
    Time for the voice prompt before transferring a call.
    This parameter sets the amount of time the caller hears a voice prompt before being transferred to an agent or another queue.

.PARAMETER CustomPrompt
    Custom voice prompt file for the queue.
    Allows the user to specify a custom audio file to be played to callers.

.PARAMETER Retry
    Retry time before redialing the queue.
    Defines how often the system will attempt to connect calls to agents in the queue.

.PARAMETER ReplaceCallerId
    Whether to replace the caller ID with the queue number. Options: `yes`, `no`.
    If set to `yes`, the caller ID will be replaced with the queue number, making it clear that the call originated from the queue.

.PARAMETER QueueChairmans
    Queue chairpersons to manage the queue.
    Specifies the agents or administrators who can manage the queue settings and performance.

.PARAMETER EnableAgentLogin
    Whether agent login is enabled. Options: `yes`, `no`.
    If enabled, agents can log into the queue to handle calls.

.PARAMETER VqSwitch
    Whether the Virtual Queue feature is enabled. Options: `yes`, `no`.
    This feature allows calls to be placed in a virtual queue rather than in a traditional, real-time queue.

.PARAMETER VqMode
    Virtual Queue mode. Options:
    - `auto`: Automatically switch to virtual queue.
    - `manual`: Manually switch to virtual queue.

.PARAMETER VqPeriodic
    Whether the Virtual Queue feature is periodic. Options: `yes`, `no`.
    If enabled, the virtual queue will periodically check for available agents and queue members.

.PARAMETER VqOutPrefix
    Outgoing prefix for Virtual Queue calls.
    This prefix will be added to the caller's phone number when routed via the virtual queue.

.PARAMETER AnnouncePosition
    Whether to announce position in the queue. Options: `yes`, `no`.
    If enabled, the caller will hear their current position in the queue while waiting.

.PARAMETER AnnounceFrequency
    Frequency of the announcement for position in the queue.
    Specifies how often the caller will hear an update on their position in the queue.

.PARAMETER DestinationTypeT
    The type of destination for routing calls. Options:
    - `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`
    Specifies where the call will be routed once it exceeds the configured wait time.

.PARAMETER VmExtensionT
    Voicemail extension for destination max wait time.
    The voicemail extension used when routing calls to voicemail after exceeding the wait time.

.PARAMETER AccountT
    Account associated with the destination max wait time.
    The account number that will be used as the destination when the call exceeds the configured wait time.

.PARAMETER VmgroupT
    Voicemail group for destination max wait time.
    The voicemail group that will receive the call if no agent answers within the specified wait time.

.PARAMETER IvrT
    IVR destination for max wait time.
    The Interactive Voice Response (IVR) system used as the destination when the call exceeds the wait time.

.PARAMETER RinggroupT
    Ring group destination for max wait time.
    The ring group that will receive the call if no agent answers within the specified wait time.

.PARAMETER QueueDestT
    Queue destination for max wait time.
    Specifies the destination queue where calls will be redirected after waiting for the specified time.

.PARAMETER ExternalNumberT
    External number for the destination max wait time.
    The external phone number where the call will be forwarded if the caller waits too long.

.PARAMETER DestinationTypeV
    Destination type for the prompt cycle. Options:
    - `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`
    Specifies where the call will be routed based on the prompt cycle.

.PARAMETER VmExtensionV
    Voicemail extension for the prompt cycle.
    The voicemail extension used for routing calls during the prompt cycle.

.PARAMETER AccountV
    Account associated with the destination prompt cycle.
    The account number that will receive the call during the prompt cycle.

.PARAMETER VmgroupV
    Voicemail group for the destination prompt cycle.
    Specifies which voicemail group will handle calls in the prompt cycle.

.PARAMETER IvrV
    IVR destination for the prompt cycle.
    Defines which IVR system is used for routing calls based on the prompt cycle.

.PARAMETER RinggroupV
    Ring group for the prompt cycle.
    Specifies which ring group will handle the calls during the prompt cycle.

.PARAMETER QueueDestV
    Queue destination for the prompt cycle.
    The destination queue to which calls will be routed during the prompt cycle.

.PARAMETER ExternalNumberV
    External number for the destination prompt cycle.
    The external phone number used for routing calls during the prompt cycle.

.PARAMETER DestinationVoiceEnable
    Whether voice announcements for destinations are enabled. Options: `yes`, `no`.
    If enabled, the destination will play a voice announcement to the caller.

.PARAMETER Autofill
    Whether autofill is enabled for the queue. Options: `yes`, `no`.
    If enabled, the system will automatically fill empty agent positions when they become available.

.PARAMETER DestinationTypeEl
    Destination type for failover routing. Options:
    - `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`
    Specifies the destination where calls will be routed if failover occurs.

.PARAMETER VmExtensionEl
    Voicemail extension for failover routing.
    The voicemail extension used when calls are forwarded during failover.

.PARAMETER AccountEl
    Account associated with failover routing.
    The account number that will receive the call in the event of failover.

.PARAMETER VmgroupEl
    Voicemail group for failover routing.
    Specifies which voicemail group will handle calls during failover.

.PARAMETER IvrEl
    IVR destination for failover routing.
    Defines which IVR system is used when calls fail over.

.PARAMETER RinggroupEl
    Ring group for failover routing.
    The ring group to which calls will be routed if failover occurs.

.PARAMETER QueueDestEl
    Queue destination for failover routing.
    Specifies which queue will receive the calls during failover.

.PARAMETER ExternalNumberEl
    External number for failover routing.
    The external phone number where calls will be forwarded during failover.

.PARAMETER VqCallbackEnableTimeout
    Timeout for callback feature in the Virtual Queue.
    Defines how long the system will wait before triggering the callback feature.

.PARAMETER VqCallbackTimeout
    Timeout duration for Virtual Queue callback.
    Specifies how long the system will wait for the callback to be answered.

.PARAMETER AnnounceHoldtime
    Whether to announce hold time in the queue. Options: `yes`, `no`.
    If enabled, the caller will hear an announcement about their hold time.

.PARAMETER EnableWelcome
    Whether to enable a welcome message for the queue. Options: `yes`, `no`.
    If enabled, a welcome message will play to callers when they enter the queue.

.PARAMETER CustomWelcomePrompt
    Custom welcome prompt file for the queue.
    Specifies a custom audio file to be played as the welcome message for callers.

.PARAMETER ScheduleCleanEnable
    Whether to enable scheduled cleaning for the queue. Options: `yes`, `no`.
    If enabled, the system will periodically clean up the queue based on the defined schedule.

.PARAMETER Extension
    The queue's extension.

.PARAMETER Starttime
    Start time for scheduling queue operations.
    Specifies the start time for operations related to this queue, like call routing or scheduled activities.

.PARAMETER PagingType
    Type of paging used for the queue. Options: `once`, `daily`, `week`, `month`.
    Specifies the frequency or interval for paging in this queue.

.PARAMETER WeekDate
    Week day for scheduling the queue. Options: `sun`, `mon`, `tue`, `wed`, `thu`, `fri`, `sat`.
    Specifies which day of the week this queue should operate.

.PARAMETER CustomMonths
    Custom months for scheduling the queue. Options: `jan`, `feb`, `mar`, `apr`, `may`, `jun`, `jul`, `aug`, `sep`, `oct`, `nov`, `dec`.
    Defines which months this queue is active for.

.PARAMETER CustomDates
    Custom dates for scheduling the queue.
    Specifies exact dates when the queue should operate.

.PARAMETER Members
    Members associated with the queue.
    Specifies which users or extensions will be part of the queue.

.EXAMPLE
    Set-UcmQueue -Uri http://10.10.10.1/api -Cookie $cookie -QueueId 1 -QueueName "SupportQueue" `
        -MusicClass "default" -LeaveWhenEmpty "Yes" -JoinEmpty "No" -RingTime 30 -Strategy "ringall" `
        -WrapUpTime 10 -MaxQueueLength 10 -AutoRecord "all" -QueueTimeout 60 -EnableFeature "yes" `
        -AlertInfo "info" -VoicePromptTime 10 -CustomPrompt "welcome_prompt" -Retry 5 `
        -ReplaceCallerId "no" -QueueChairmans "admin1, admin2" -EnableAgentLogin "yes" `
        -VqSwitch "yes" -VqMode "auto" -VqPeriodic "yes" -VqOutPrefix "1000" `
        -AnnouncePosition "yes" -AnnounceFrequency 30
#>
function Set-UcmQueue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$QueueId,
        [Parameter(Mandatory)][string]$QueueName,
        [Parameter(Mandatory)][string]$MusicClass,
        [Parameter(Mandatory)][ValidateSet("Yes", "No", "Strict")][string]$LeaveWhenEmpty,
        [Parameter(Mandatory)][ValidateSet("Yes", "No", "Strict")][string]$JoinEmpty,
        [Parameter()][string]$Pin,
        [Parameter(Mandatory)][int]$RingTime,
        [Parameter(Mandatory)][ValidateSet("ringall", "linear", "leastrecent", "fewestcalls", "random", "memory")][string]$Strategy,
        [Parameter(Mandatory)][int]$WrapUpTime,
        [Parameter(Mandatory)][int]$MaxQueueLength,
        [Parameter(Mandatory)][ValidateSet("all", "external", "internal", "off")][string]$AutoRecord,
        [Parameter()][int]$QueueTimeout,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableFeature,
        [Parameter()][string]$Alertinfo,
        [Parameter()][int]$VoicePromptTime,
        [Parameter()][string]$CustomPrompt,
        [Parameter()][int]$Retry,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerId,
        [Parameter()][string]$QueueChairmans,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableAgentLogin,
        [Parameter()][ValidateSet("yes", "no")][string]$VqSwitch,
        [Parameter()][string]$VqMode,
        [Parameter()][ValidateSet("yes", "no")][string]$VqPeriodic,
        [Parameter()][string]$VqOutprefix,
        [Parameter()][ValidateSet("yes", "no")][string]$AnnouncePosition,
        [Parameter()][int]$AnnounceFrequency,
        [Parameter()][ValidateSet("account", "voicemail", "queue", "ringgroup", "vmgroup", "ivr", "external_number")][string]$DestinationTypeT,
        [Parameter()][string]$VmExtensionT,
        [Parameter()][string]$AccountT,
        [Parameter()][string]$VmgroupT,
        [Parameter()][string]$IvrT,
        [Parameter()][string]$RinggroupT,
        [Parameter()][string]$QueueDestT,
        [Parameter()][string]$ExternalNumberT,
        [Parameter()][ValidateSet("account", "voicemail", "queue", "ringgroup", "vmgroup", "ivr", "external_number")][string]$DestinationTypeV,
        [Parameter()][string]$VmExtensionV,
        [Parameter()][string]$AccountV,
        [Parameter()][string]$VmgroupV,
        [Parameter()][string]$IvrV,
        [Parameter()][string]$RinggroupV,
        [Parameter()][string]$QueueDestV,
        [Parameter()][string]$ExternalNumberV,
        [Parameter()][ValidateSet("yes", "no")][string]$DestinationVoiceEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$Autofill,
        [Parameter()][ValidateSet("account", "voicemail", "queue", "ringgroup", "vmgroup", "ivr", "external_number")][string]$DestinationTypeEl,
        [Parameter()][string]$VmExtensionEl,
        [Parameter()][string]$AccountEl,
        [Parameter()][string]$VmgroupEl,
        [Parameter()][string]$IvrEl,
        [Parameter()][string]$RinggroupEl,
        [Parameter()][string]$QueueDestEl,
        [Parameter()][string]$ExternalNumberEl,
        [Parameter()][int]$VqCallbackEnableTimeout,
        [Parameter()][int]$VqCallbackTimeout,
        [Parameter()][ValidateSet("yes", "no")][string]$AnnounceHoldtime,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWelcome,
        [Parameter()][string]$CustomWelcomePrompt,
        [Parameter()][ValidateSet("yes", "no")][string]$ScheduleCleanEnable,
        [Parameter()][string]$Extension,
        [Parameter()][string]$Starttime,
        [Parameter()][ValidateSet("once", "daily", "week", "month")][string]$PagingType,
        [Parameter()][ValidateSet("sun", "mon", "tue", "wed", "thu", "fri", "sat")][string]$WeekDate,
        [Parameter()][ValidateSet("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")][string]$CustomMonths,
        [Parameter()][string]$CustomDates,
        [Parameter()][string]$Members
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateQueue"
            cookie = $Cookie
            queue = $QueueId
            queue_name = $QueueName
        }
    }

    # Add optional parameters
    @(
        @{ Name = "MusicClass"; Value = $MusicClass; ApiName = "musicclass" },
        @{ Name = "LeaveWhenEmpty"; Value = $LeaveWhenEmpty; ApiName = "leavewhenempty" },
        @{ Name = "JoinEmpty"; Value = $JoinEmpty; ApiName = "joinempty" },
        @{ Name = "Pin"; Value = $Pin; ApiName = "pin" },
        @{ Name = "RingTime"; Value = $RingTime; ApiName = "ringtime" },
        @{ Name = "Strategy"; Value = $Strategy; ApiName = "strategy" },
        @{ Name = "WrapUpTime"; Value = $WrapUpTime; ApiName = "wrapuptime" },
        @{ Name = "MaxQueueLength"; Value = $MaxQueueLength; ApiName = "maxlen" },
        @{ Name = "AutoRecord"; Value = $AutoRecord; ApiName = "auto_record" },
        @{ Name = "QueueTimeout"; Value = $QueueTimeout; ApiName = "queue_timeout" },
        @{ Name = "EnableFeature"; Value = $EnableFeature; ApiName = "enable_feature" },
        @{ Name = "Alertinfo"; Value = $Alertinfo; ApiName = "alertinfo" },
        @{ Name = "VoicePromptTime"; Value = $VoicePromptTime; ApiName = "voice_prompt_time" },
        @{ Name = "CustomPrompt"; Value = $CustomPrompt; ApiName = "custom_prompt" },
        @{ Name = "Retry"; Value = $Retry; ApiName = "retry" },
        @{ Name = "ReplaceCallerId"; Value = $ReplaceCallerId; ApiName = "replace_caller_id" },
        @{ Name = "QueueChairmans"; Value = $QueueChairmans; ApiName = "queue_chairmans" },
        @{ Name = "EnableAgentLogin"; Value = $EnableAgentLogin; ApiName = "enable_agent_login" },
        @{ Name = "VqSwitch"; Value = $VqSwitch; ApiName = "vq_switch" },
        @{ Name = "VqMode"; Value = $VqMode; ApiName = "vq_mode" },
        @{ Name = "VqPeriodic"; Value = $VqPeriodic; ApiName = "vq_periodic" },
        @{ Name = "VqOutprefix"; Value = $VqOutprefix; ApiName = "vq_outprefix" },
        @{ Name = "AnnouncePosition"; Value = $AnnouncePosition; ApiName = "announce_position" },
        @{ Name = "AnnounceFrequency"; Value = $AccnounceFrequency; ApiName = "announce_frequency" }
        @{ Name = "DestinationVoiceEnable"; Value = $AccnounceFrequency; ApiName = "destination_voice_enable" }
        @{ Name = "Autofill"; Value = $AccnounceFrequency; ApiName = "autofill" }
        @{ Name = "VqCallbackEnableTimeout"; Value = $VqCallbackEnableTimeout; ApiName = "vq_callback_enable_timeout" }
        @{ Name = "VqCallbackTimeout"; Value = $VqCallbackTimeout; ApiName = "vq_callback_timeout" }
        @{ Name = "AnnounceHoldtime"; Value = $AnnounceHoldtime; ApiName = "announce_holdtime" }
        @{ Name = "EnableWelcome"; Value = $EnableWelcome; ApiName = "enable_welcome" }
        @{ Name = "CustomWelcomePrompt"; Value = $CustomWelcomePrompt; ApiName = "custom_welcome_prompt" }
        @{ Name = "ScheduleCleanEnable"; Value = $ScheduleCleanEnable; ApiName = "schedule_clean_enable" }
        @{ Name = "Extension"; Value = $Extension; ApiName = "extension" }
        @{ Name = "Starttime"; Value = $Starttime; ApiName = "starttime" }
        @{ Name = "PagingType"; Value = $PagingType; ApiName = "pagingtype" }
        @{ Name = "WeekDate"; Value = $WeekDate; ApiName = "week_date" }
        @{ Name = "CustomMonths"; Value = $CustomMonths; ApiName = "custom_months" }
        @{ Name = "CustomDates"; Value = $CustomDates; ApiName = "custom_dates" }
        @{ Name = "Members"; Value = $Members; ApiName = "members" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
            $apiRequest.request[$_.ApiName] = $_.Value
        }
    }

    if ($DestinationTypeT) {
        # Always add the chosen DestinationType to the request
        $apiRequest.request.destination_type_t = $DestinationTypeT

        switch ($DestinationTypeT) {
            'account' {
                if (-not $AccountT) {
                    throw "You specified DestinationTypeT='account' but did not provide -AccountT."
                }
                $apiRequest.request.account_t = $AccountT
            }
            'voicemail' {
                if (-not $VmExtensionT) {
                    throw "You specified DestinationTypeT='voicemail' but did not provide -VmExtensionT."
                }
                $apiRequest.request.vm_extension_t = $VmExtensionT
            }
            'queue' {
                if (-not $QueueDestT) {
                    throw "You specified DestinationTypeT='queue' but did not provide -QueueDestT."
                }
                $apiRequest.request.queue_dest_t = $QueueDestT
            }
            'ringgroup' {
                if (-not $RinggroupT) {
                    throw "You specified DestinationTypeT='ringgroup' but did not provide -RinggroupT."
                }
                $apiRequest.request.ringgroup_t = $RinggroupT
            }
            'vmgroup' {
                if (-not $VmgroupT) {
                    throw "You specified DestinationTypeT='vmgroup' but did not provide -VmgroupT."
                }
                $apiRequest.request.vmgroup_t = $VmgroupT
            }
            'ivr' {
                if (-not $IvrT) {
                    throw "You specified DestinationTypeT='ivr' but did not provide -IvrT."
                }
                $apiRequest.request.ivr_t = $IvrT
            }
            'external_number' {
                if (-not $ExternalNumberT) {
                    throw "You specified DestinationTypeT='external_number' but did not provide -ExternalNumberT."
                }
                $apiRequest.request.external_number_t = $ExternalNumberT
            }
        }
    }

    if ($DestinationTypeV) {
        $apiRequest.request.destination_type_v = $DestinationTypeV

        switch ($DestinationTypeV) {
            'account' {
                if (-not $AccountV) {
                    throw "You specified DestinationTypeV='account' but did not provide -AccountV."
                }
                $apiRequest.request.account_v = $AccountV
            }
            'voicemail' {
                if (-not $VmExtensionV) {
                    throw "You specified DestinationTypeV='voicemail' but did not provide -VmExtensionV."
                }
                $apiRequest.request.vm_extension_v = $VmExtensionV
            }
            'queue' {
                if (-not $QueueDestV) {
                    throw "You specified DestinationTypeV='queue' but did not provide -QueueDestV."
                }
                $apiRequest.request.queue_dest_v = $QueueDestV
            }
            'ringgroup' {
                if (-not $RinggroupV) {
                    throw "You specified DestinationTypeV='ringgroup' but did not provide -RinggroupV."
                }
                $apiRequest.request.ringgroup_v = $RinggroupV
            }
            'vmgroup' {
                if (-not $VmgroupV) {
                    throw "You specified DestinationTypeV='vmgroup' but did not provide -VmgroupV."
                }
                $apiRequest.request.vmgroup_v = $VmgroupV
            }
            'ivr' {
                if (-not $IvrV) {
                    throw "You specified DestinationTypeV='ivr' but did not provide -IvrV."
                }
                $apiRequest.request.ivr_v = $IvrV
            }
            'external_number' {
                if (-not $ExternalNumberV) {
                    throw "You specified DestinationTypeV='external_number' but did not provide -ExternalNumberV."
                }
                $apiRequest.request.external_number_v = $ExternalNumberV
            }
        }
    }

    if ($DestinationTypeEl) {
        $apiRequest.request.destination_type_el = $DestinationTypeEl

        switch ($DestinationTypeEl) {
            'account' {
                if (-not $AccountEl) {
                    throw "You specified DestinationTypeEl='account' but did not provide -AccountEl."
                }
                $apiRequest.request.account_el = $AccountEl
            }
            'voicemail' {
                if (-not $VmExtensionEl) {
                    throw "You specified DestinationTypeEl='voicemail' but did not provide -VmExtensionEl."
                }
                $apiRequest.request.vm_extension_el = $VmExtensionEl
            }
            'queue' {
                if (-not $QueueDestEl) {
                    throw "You specified DestinationTypeEl='queue' but did not provide -QueueDestEl."
                }
                $apiRequest.request.queue_dest_el = $QueueDestEl
            }
            'ringgroup' {
                if (-not $RinggroupEl) {
                    throw "You specified DestinationTypeEl='ringgroup' but did not provide -RinggroupEl."
                }
                $apiRequest.request.ringgroup_el = $RinggroupEl
            }
            'vmgroup' {
                if (-not $VmgroupEl) {
                    throw "You specified DestinationTypeEl='vmgroup' but did not provide -VmgroupEl."
                }
                $apiRequest.request.vmgroup_el = $VmgroupEl
            }
            'ivr' {
                if (-not $IvrEl) {
                    throw "You specified DestinationTypeEl='ivr' but did not provide -IvrEl."
                }
                $apiRequest.request.ivr_el = $IvrEl
            }
            'external_number' {
                if (-not $ExternalNumberEl) {
                    throw "You specified DestinationTypeEl='external_number' but did not provide -ExternalNumberEl."
                }
                $apiRequest.request.external_number_el = $ExternalNumberEl
            }
        }
    }

    # Send API request
    $apiResponse = Invoke-WebRequest -Uri $Uri -Method POST `
        -ContentType "application/json;charset=UTF-8" `
        -Body (ConvertTo-Json $apiRequest -Depth 10) `
        -DisableKeepAlive -SkipCertificateCheck

    # Process API response
    $responseContent = ConvertFrom-Json $apiResponse.Content
    if ($responseContent.status -ne 0) {
        Write-Error "API call to updateQueue failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
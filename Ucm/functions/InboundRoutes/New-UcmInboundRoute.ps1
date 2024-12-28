<#
.SYNOPSIS
    Adds a new inbound route to the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "addInboundRoute" to create a new inbound route configuration in the UCM system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. 
    **(Mandatory)** This cookie is required to authenticate API requests. If no cookie is provided, an error code will be returned.

.PARAMETER InboundRoute
    The ID of the inbound route to configure. **(Mandatory)** 
    This parameter defines the unique identifier for the inbound route being configured.

.PARAMETER TrunkIndex
    The trunk ID for the inbound route. **(Mandatory)**
    The trunk index links the inbound route to the appropriate trunk for routing calls.

.PARAMETER InboundSuffix
    (Optional) Inbound Mode Suffix.
    Dialing the global inbound feature code plus this suffix (or dialing the inbound mode suffix) could switch the mode of the inbound route.
    BLF (Busy Lamp Field) subscription inbound mode suffix can monitor inbound multiple mode. This option allows changes to the mode based on the suffix dialed.

.PARAMETER InboundMultiMode
    (Optional) The current inbound mode of the inbound route.
    Specifies the inbound route's mode, which can be toggled depending on the system's configuration.

.PARAMETER EnableInboundMultiMode
    (Optional) Whether to enable inbound multiple modes.
    If enabled, dialing the global inbound feature code plus the inbound suffix will switch the route's mode to multiple mode, allowing for dynamic inbound routing adjustments.

.PARAMETER SetCallerIdNumber
    (Optional) Configure the pattern-matching format to manipulate the numbers of incoming callers or to set a fixed CallerID number for calls that go through this inbound route.

.PARAMETER SetCallerIdName
    (Optional) Configure the pattern-matching format to customize the CallerID name for incoming calls.
    This allows the customization of the name displayed for incoming calls routed through this inbound route.

.PARAMETER SetCallerIdEnable
    (Optional) Whether to enable the manipulation of CallerID info (name and/or number) for calls routed through this inbound route.
    If enabled, the system will apply the set caller ID values to calls coming through this route.

.PARAMETER OutOfService
    (Optional) Whether the route should be out of service. Options: `yes`, `no`.
    This determines if the route is temporarily inactive. When set to `yes`, the route will be disabled.

.PARAMETER Prepend
    (Optional) The digits that will be prepended after the dialing number is stripped.
    This allows modifications to the dialed number by adding a prefix before the call is processed by the trunk.

.PARAMETER EnableWhitelist
    (Optional) Whether to enable the whitelist for the route. Options: `yes`, `no`.
    If enabled, the system will only allow calls from numbers in the whitelist to route through this inbound route.

.PARAMETER IncomingPrepend
    (Optional) The digits to prepend for incoming calls.
    Similar to the `Prepend` parameter, this allows you to modify the incoming call number by adding a prefix before routing.

.PARAMETER AlertInfo
    (Optional) Alert info for incoming calls. Options include `none`, `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, `ring6`, `ring7`, `ring8`, `ring9`, `ring10`, `Bellcore-dr1`, `Bellcore-dr2`, `Bellcore-dr3`, `Bellcore-dr4`, `Bellcore-dr5`, and `custom`.
    Specifies the ring pattern or alert tone for calls routed through this inbound route.

.PARAMETER DidStrip
    (Optional) The number of digits to strip from the beginning of the dialed number.
    This option allows for stripping specific digits from the DID (Direct Inward Dialing) number before it is routed.

.PARAMETER Callback
    (Optional) Indicates whether to enable the callback feature for the inbound route.
    If enabled, calls that meet certain criteria will trigger a callback action.

.PARAMETER ExternalNumber
    (Optional) The external number to route calls to.
    This can be used to forward incoming calls to an external number outside of the system.

.PARAMETER Directory
    (Optional) Directory service for incoming calls.
    Can be used to route calls based on a directory listing.

.PARAMETER Disa
    (Optional) DISA (Direct Inward System Access) configuration for the inbound route.
    DISA allows external users to dial into the system and make calls as if they were internal users.

.PARAMETER Fax
    (Optional) Whether to enable fax for the inbound route. Options: `yes`, `no`.
    Determines if fax calls will be routed via this inbound route.

.PARAMETER PagingGroup
    (Optional) The paging group associated with the route.
    Defines which paging group (if any) will handle the call.

.PARAMETER Queue
    (Optional) The queue to route calls to.
    Inbound calls can be directed to a specific queue where agents are available to take the calls.

.PARAMETER RingGroup
    (Optional) The ring group for the inbound route.
    Calls can be routed to a ring group where multiple extensions will be rung simultaneously.

.PARAMETER Ivr
    (Optional) The IVR (Interactive Voice Response) system to route calls to.
    Allows for routing calls to an IVR menu for further interaction.

.PARAMETER VmGroup
    (Optional) The voicemail group for the inbound route.
    Inbound calls can be directed to a voicemail group if no other routing options are available.

.PARAMETER Conference
    (Optional) The conference room for the inbound route.
    Calls can be routed to a conference room for group meetings or discussions.

.PARAMETER Voicemail
    (Optional) Voicemail configuration for the inbound route.
    Allows calls to be routed to a voicemail system if no other actions are taken.

.PARAMETER Account
    (Optional) The account to route calls to.
    Can specify which account should be used for the inbound call, if applicable.

.PARAMETER PrependTrunkName
    (Optional) Whether to prepend the trunk name to the caller ID. Options: `yes`, `no`.
    If enabled, the trunk name will be added to the caller ID before displaying it to the recipient.

.PARAMETER DestinationType
    (Optional) The destination type for the inbound route. Valid values: `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`.
    Defines where the inbound call should be routed based on the type of destination.

.PARAMETER DidPatternAllow
    (Optional) Whether to allow the DID pattern. Options: `yes`, `no`.
    Specifies whether a specific DID pattern will be allowed for routing calls through this inbound route.

.PARAMETER DidPatternMatch
    (Optional) The pattern match mode for DID numbers.
    Defines how the system will match incoming DID numbers to routes.

.PARAMETER SeamlessTransferDidWhitelist
    (Optional) A list of extensions allowed to seamlessly transfer DID calls.
    Specifies which extensions can perform seamless transfers of DID calls.

.PARAMETER ExtDirectory
    (Optional) Dial-by-name directory service.
    Allows callers to dial by name to reach the appropriate extension.

.PARAMETER ExtPaging
    (Optional) Paging/intercom group.
    Allows for routing calls to a paging or intercom group for public announcements.

.PARAMETER ExtGroup
    (Optional) Extension group to route calls to.
    Allows for routing calls to a group of extensions rather than a single destination.

.PARAMETER ExtQueues
    (Optional) Queues for routing calls.
    Defines which queues will handle incoming calls.

.PARAMETER ExtConference
    (Optional) Conference rooms for routing calls.
    Allows calls to be directed to a conference room for group meetings.

.PARAMETER Voicemenus
    (Optional) IVR menus for routing calls.
    Defines which IVR menu the call should be routed to, depending on user input.

.PARAMETER VoicemailGroups
    (Optional) Voicemail groups for routing calls.
    Specifies which voicemail group should handle the call when unanswered.

.PARAMETER ExtFax
    (Optional) Fax extension for routing.
    Specifies the extension designated for handling fax transmissions.

.PARAMETER ExtLocal
    (Optional) Local extension for routing.
    Routes calls to a local extension rather than through an external number or group.

.PARAMETER DialTrunk
    (Optional) Whether to use a specific trunk for the inbound route.
    Determines whether the call should be routed through a specified trunk.

.PARAMETER MultiMode
    (Optional) Multi-mode configuration for the inbound route.
    Configures the inbound route to handle multiple call modes (such as voice and fax).

.PARAMETER TimeCondition
    (Optional) Time condition for routing the inbound route.
    Defines when the route will be active, based on time of day or day of week.

.EXAMPLE
    New-UcmInboundRoute -Uri http://10.10.10.1/api -Cookie $cookie -InboundRoute "NewRoute" `
        -TrunkIndex 1 -InboundSuffix "0001" -EnableInboundMultiMode "yes" -SetCallerIdNumber "1001" `
        -SetCallerIdName "Support" -SetCallerIdEnable "yes" -Prepend "123" -AlertInfo "ring1" `
        -Callback "1234" -Queue "SupportQueue" -RingGroup "SalesRingGroup" -DestinationType "queue" `
        -TimeCondition "office_hours"
    This example demonstrates how to add a new inbound route with specific settings for caller ID, alert info, queue, and time condition.

#>
function New-UcmInboundRoute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$InboundRoute,
        [Parameter(Mandatory)][int]$TrunkIndex,
        [Parameter()][string]$InboundSuffix,
        [Parameter()][string]$InboundMultiMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableInboundMultiMode,
        [Parameter()][string]$SetCallerIdNumber,
        [Parameter()][string]$SetCallerIdName,
        [Parameter()][ValidateSet("yes", "no")][string]$SetCallerIdEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$Prepend,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWhitelist,
        [Parameter()][string]$IncomingPrepend,
        [Parameter()][string]$AlertInfo,
        [Parameter()][ValidateSet("yes", "no")][string]$DidStrip,
        [Parameter()][string]$Callback,
        [Parameter()][string]$ExternalNumber,
        [Parameter()][string]$Directory,
        [Parameter()][string]$Disa,
        [Parameter()][ValidateSet("yes", "no")][string]$Fax,
        [Parameter()][string]$PagingGroup,
        [Parameter()][string]$Queue,
        [Parameter()][string]$RingGroup,
        [Parameter()][string]$Ivr,
        [Parameter()][string]$VmGroup,
        [Parameter()][string]$Conference,
        [Parameter()][string]$Voicemail,
        [Parameter()][string]$Account,
        [Parameter()][ValidateSet("yes", "no")][string]$PrependTrunkName,
        [Parameter()][ValidateSet("account", "voicemail", "queue", "ringgroup", "vmgroup", "ivr", "external_number")][string]$DestinationType,
        [Parameter()][ValidateSet("yes", "no")][string]$DidPatternAllow,
        [Parameter()][string]$DidPatternMatch,
        [Parameter()][string]$SeamlessTransferDidWhitelist,
        [Parameter()][string]$ExtDirectory,
        [Parameter()][string]$ExtPaging,
        [Parameter()][string]$ExtGroup,
        [Parameter()][string]$ExtQueues,
        [Parameter()][string]$ExtConference,
        [Parameter()][string]$Voicemenus,
        [Parameter()][string]$VoicemailGroups,
        [Parameter()][string]$ExtFax,
        [Parameter()][string]$ExtLocal,
        [Parameter()][string]$DialTrunk,
        [Parameter()][string]$MultiMode,
        [Parameter()][string]$TimeCondition,
        [Parameter()][ValidateSet("yes", "no")][string]$BlockingDidCollectCalls
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "addInboundRoute"
            cookie = $Cookie
            inbound_route = $InboundRoute
            trunk_index = $TrunkIndex
        }
    }

    # Add optional parameters dynamically
    @(
        @{ Name = "InboundSuffix"; Value = $InboundSuffix; ApiName = "inbound_suffix" },
        @{ Name = "InboundMultiMode"; Value = $InboundMultiMode; ApiName = "inbound_multi_mode" },
        @{ Name = "EnableInboundMultiMode"; Value = $EnableInboundMultiMode; ApiName = "enable_inbound_multi_mode" },
        @{ Name = "SetCallerIdNumber"; Value = $SetCallerIdNumber; ApiName = "set_callerid_number" },
        @{ Name = "SetCallerIdName"; Value = $SetCallerIdName; ApiName = "set_callerid_name" },
        @{ Name = "SetCallerIdEnable"; Value = $SetCallerIdEnable; ApiName = "set_callerid_enable" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "Prepend"; Value = $Prepend; ApiName = "prepend" },
        @{ Name = "EnableWhitelist"; Value = $EnableWhitelist; ApiName = "enable_wlist" },
        @{ Name = "IncomingPrepend"; Value = $IncomingPrepend; ApiName = "incoming_prepend" },
        @{ Name = "AlertInfo"; Value = $AlertInfo; ApiName = "alertinfo" },
        @{ Name = "DidStrip"; Value = $DidStrip; ApiName = "did_strip" },
        @{ Name = "Callback"; Value = $Callback; ApiName = "callback" },
        @{ Name = "ExternalNumber"; Value = $ExternalNumber; ApiName = "external_number" },
        @{ Name = "Directory"; Value = $Directory; ApiName = "directory" },
        @{ Name = "Disa"; Value = $Disa; ApiName = "disa" },
        @{ Name = "Fax"; Value = $Fax; ApiName = "fax" },
        @{ Name = "PagingGroup"; Value = $PagingGroup; ApiName = "paginggroup" },
        @{ Name = "Queue"; Value = $Queue; ApiName = "queue" },
        @{ Name = "RingGroup"; Value = $RingGroup; ApiName = "ringgroup" },
        @{ Name = "Ivr"; Value = $Ivr; ApiName = "ivr" },
        @{ Name = "VmGroup"; Value = $VmGroup; ApiName = "vmgroup" },
        @{ Name = "Conference"; Value = $Conference; ApiName = "conference" },
        @{ Name = "Voicemail"; Value = $Voicemail; ApiName = "voicemail" },
        @{ Name = "Account"; Value = $Account; ApiName = "account" },
        @{ Name = "PrependTrunkName"; Value = $PrependTrunkName; ApiName = "prepend_trunk_name" },
        @{ Name = "DestinationType"; Value = $DestinationType; ApiName = "destination_type" },
        @{ Name = "DidPatternAllow"; Value = $DidPatternAllow; ApiName = "did_pattern_allow" },
        @{ Name = "DidPatternMatch"; Value = $DidPatternMatch; ApiName = "did_pattern_match" },
        @{ Name = "SeamlessTransferDidWhitelist"; Value = $SeamlessTransferDidWhitelist; ApiName = "seamless_transfer_did_whitelist" },
        @{ Name = "ExtDirectory"; Value = $ExtDirectory; ApiName = "ext_directory" },
        @{ Name = "ExtPaging"; Value = $ExtPaging; ApiName = "ext_paging" },
        @{ Name = "ExtGroup"; Value = $ExtGroup; ApiName = "ext_group" },
        @{ Name = "ExtQueues"; Value = $ExtQueues; ApiName = "ext_queues" },
        @{ Name = "ExtConference"; Value = $ExtConference; ApiName = "ext_conference" },
        @{ Name = "Voicemenus"; Value = $Voicemenus; ApiName = "voicemenus" },
        @{ Name = "VoicemailGroups"; Value = $VoicemailGroups; ApiName = "voicemailgroups" },
        @{ Name = "ExtFax"; Value = $ExtFax; ApiName = "ext_fax" },
        @{ Name = "ExtLocal"; Value = $ExtLocal; ApiName = "ext_local" },
        @{ Name = "DialTrunk"; Value = $DialTrunk; ApiName = "dial_trunk" },
        @{ Name = "MultiMode"; Value = $MultiMode; ApiName = "multi_mode" },
        @{ Name = "TimeCondition"; Value = $TimeCondition; ApiName = "time_condition" },
        @{ Name = "BlockingDidCollectCalls"; Value = $BlockingDidCollectCalls; ApiName = "blocking_did_collect_calls" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
            $apiRequest.request[$_.ApiName] = $_.Value
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
        Write-Error "API call to addInboundRoute failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

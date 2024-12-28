<#
.SYNOPSIS
    Updates an existing inbound route on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateInboundRoute" to update the configuration of an existing inbound route.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring inbound routes.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    This cookie is necessary for every request to maintain the authenticated session.

.PARAMETER RouteId
    The ID of the inbound route to update.
    Specifies the unique identifier of the inbound route configuration to modify.

.PARAMETER RouteName
    The name of the inbound route.
    This is a descriptive name for the inbound route, used to identify it in the system.

.PARAMETER DIDPattern
    The DID (Direct Inward Dialing) pattern to match for this route.
    This parameter specifies the pattern for incoming phone numbers (e.g., `1234567890`) to match against for routing decisions.

.PARAMETER RoutePriority
    The priority of the inbound route. Range: `1-10`.
    Determines the order in which inbound routes are evaluated. A lower number means higher priority.

.PARAMETER DestinationType
    The type of destination for this route. Options: `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`.
    This defines where calls matching this route will be forwarded:
    - `account`: Forward to an account.
    - `voicemail`: Send to voicemail.
    - `queue`: Forward to a queue.
    - `ringgroup`: Forward to a ring group.
    - `vmgroup`: Forward to a voicemail group.
    - `ivr`: Forward to an IVR (Interactive Voice Response).
    - `external_number`: Forward to an external phone number.

.PARAMETER Destination
    The destination for this route, depending on the `DestinationType`.
    If `DestinationType` is set to `account`, this should be the account ID. If it's set to `voicemail`, this should be the voicemail extension, etc.

.PARAMETER FailoverDestination
    The failover destination for the route.
    Defines where to send the call if the primary destination is unavailable. For example, if the primary destination is a queue and no agents are available, the call could be routed to voicemail.

.PARAMETER RouteStatus
    Whether the inbound route is enabled or disabled. Options: `enabled`, `disabled`.
    If set to `enabled`, the route is active and can route calls. If set to `disabled`, the route is inactive.

.PARAMETER MatchPattern
    The pattern for matching incoming calls. This pattern is used to match numbers or conditions for this inbound route.
    Typically, it would be a regular expression or a predefined number pattern.

.PARAMETER EnableTimeCondition
    Whether to enable time-based routing for the inbound route. Options: `yes`, `no`.
    If enabled, the system will check the time of the incoming call and route it accordingly, based on a configured time condition.

.PARAMETER TimeConditionId
    The ID of the time condition to apply to the route.
    If `EnableTimeCondition` is set to `yes`, this parameter defines the time condition (e.g., specific hours or days of the week) to apply to this inbound route.

.PARAMETER EnableWhitelist
    Whether to enable a whitelist for the inbound route. Options: `yes`, `no`.
    If enabled, the system will only accept calls from numbers on a predefined whitelist.

.PARAMETER Whitelist
    List of numbers that are allowed to reach this route if `EnableWhitelist` is set to `yes`.
    This is a list of allowed numbers in CSV format (e.g., `1001,1002,1003`) that will be allowed to reach the specified destination.

.PARAMETER MaxCalls
    The maximum number of concurrent calls allowed for this inbound route.
    This limits how many calls the route can handle at once. If the limit is reached, additional calls may be forwarded to a failover destination.

.PARAMETER RingTime
    The ring time in seconds for this route.
    Specifies how long the system will attempt to ring the destination (e.g., agent, queue, voicemail) before considering the call unanswered and routing it to a failover destination.

.PARAMETER CallerId
    The caller ID to display when a call is routed through this route.
    This allows customization of the caller ID that will appear for calls routed by this inbound route.

.PARAMETER RouteDescription
    A description of the inbound route.
    This parameter allows users to add additional notes or details about the route for easier identification and management.

.EXAMPLE
    Set-UcmInboundRoute -Uri http://10.10.10.1/api -Cookie $cookie -RouteId 1 -RouteName "SupportRoute" `
        -DIDPattern "123456*" -RoutePriority 1 -DestinationType "queue" -Destination "supportQueue" `
        -FailoverDestination "voicemail" -RouteStatus "enabled" -MatchPattern "123456" `
        -EnableTimeCondition "yes" -TimeConditionId 1 -EnableWhitelist "yes" `
        -Whitelist "1001,1002,1003" -MaxCalls 10 -RingTime 30 -CallerId "SupportTeam"
    This example demonstrates how to configure an inbound route for support calls with time conditions, a whitelist, and failover to voicemail if the queue is full.
#>
function Set-UcmInboundRoute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$InboundRouteId,
        [Parameter()][string]$InboundSuffix,
        [Parameter()][ValidateSet("internal", "local", "national", "international")][string]$InboundMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableInboundMultiMode,
        [Parameter()][string]$SetCallerIdNumber,
        [Parameter()][string]$SetCallerIdName,
        [Parameter()][ValidateSet("yes", "no")][string]$SetCallerIdEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$Prepend,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWhitelist,
        [Parameter()][string]$IncomingPrepend,
        [Parameter()][string]$Alertinfo,
        [Parameter()][ValidateSet("yes", "no")][string]$DidStrip,
        [Parameter()][ValidateSet("yes", "no")][string]$Callback,
        [Parameter()][string]$ExternalNumber,
        [Parameter()][string]$Directory,
        [Parameter()][string]$Disa,
        [Parameter()][string]$Fax,
        [Parameter()][string]$Paginggroup,
        [Parameter()][string]$Queue,
        [Parameter()][string]$Ringgroup,
        [Parameter()][string]$Ivr,
        [Parameter()][string]$Vmgroup,
        [Parameter()][string]$Conference,
        [Parameter()][string]$Voicemail,
        [Parameter()][string]$Account,
        [Parameter()][ValidateSet("yes", "no")][string]$PrependTrunkName,
        [Parameter()][string]$DestinationType,
        [Parameter()][string]$DidPatternAllow,
        [Parameter()][string]$DidPatternMatch,
        [Parameter()][string]$ExtDirectory,
        [Parameter()][string]$ExtPaging,
        [Parameter()][string]$ExtGroup,
        [Parameter()][string]$ExtQueues,
        [Parameter()][string]$ExtConference,
        [Parameter()][string]$Voicemenus,
        [Parameter()][string]$Voicemailgroups,
        [Parameter()][string]$ExtFax,
        [Parameter()][string]$ExtLocal,
        [Parameter()][ValidateSet("yes", "no")][string]$DialTrunk,
        [Parameter()][string]$MultiMode,
        [Parameter()][string]$TimeCondition
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateInboundRoute"
            cookie = $Cookie
            inbound_route = $InboundRouteId
        }
    }

    # Add optional parameters
    @(
        @{ Name = "InboundSuffix"; Value = $InboundSuffix; ApiName = "inbound_suffix" },
        @{ Name = "InboundMode"; Value = $InboundMode; ApiName = "inbound_mode" },
        @{ Name = "EnableInboundMultiMode"; Value = $EnableInboundMultiMode; ApiName = "enable_inbound_multi_mode" },
        @{ Name = "SetCallerIdNumber"; Value = $SetCallerIdNumber; ApiName = "set_callerid_number" },
        @{ Name = "SetCallerIdName"; Value = $SetCallerIdName; ApiName = "set_callerid_name" },
        @{ Name = "SetCallerIdEnable"; Value = $SetCallerIdEnable; ApiName = "set_callerid_enable" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "Prepend"; Value = $Prepend; ApiName = "prepend" },
        @{ Name = "EnableWhitelist"; Value = $EnableWhitelist; ApiName = "enable_whitelist" },
        @{ Name = "IncomingPrepend"; Value = $IncomingPrepend; ApiName = "incoming_prepend" },
        @{ Name = "Alertinfo"; Value = $Alertinfo; ApiName = "alertinfo" },
        @{ Name = "DidStrip"; Value = $DidStrip; ApiName = "did_strip" },
        @{ Name = "Callback"; Value = $Callback; ApiName = "callback" },
        @{ Name = "ExternalNumber"; Value = $ExternalNumber; ApiName = "external_number" },
        @{ Name = "Directory"; Value = $Directory; ApiName = "directory" },
        @{ Name = "Disa"; Value = $Disa; ApiName = "disa" },
        @{ Name = "Fax"; Value = $Fax; ApiName = "fax" },
        @{ Name = "Paginggroup"; Value = $Paginggroup; ApiName = "paginggroup" },
        @{ Name = "Queue"; Value = $Queue; ApiName = "queue" },
        @{ Name = "Ringgroup"; Value = $Ringgroup; ApiName = "ringgroup" },
        @{ Name = "Ivr"; Value = $Ivr; ApiName = "ivr" },
        @{ Name = "Vmgroup"; Value = $Vmgroup; ApiName = "vmgroup" },
        @{ Name = "Conference"; Value = $Conference; ApiName = "conference" },
        @{ Name = "Voicemail"; Value = $Voicemail; ApiName = "voicemail" },
        @{ Name = "Account"; Value = $Account; ApiName = "account" },
        @{ Name = "PrependTrunkName"; Value = $PrependTrunkName; ApiName = "prepend_trunk_name" },
        @{ Name = "DestinationType"; Value = $DestinationType; ApiName = "destination_type" },
        @{ Name = "DidPatternAllow"; Value = $DidPatternAllow; ApiName = "did_pattern_allow" },
        @{ Name = "DidPatternMatch"; Value = $DidPatternMatch; ApiName = "did_pattern_match" },
        @{ Name = "ExtDirectory"; Value = $ExtDirectory; ApiName = "ext_directory" },
        @{ Name = "ExtPaging"; Value = $ExtPaging; ApiName = "ext_paging" },
        @{ Name = "ExtGroup"; Value = $ExtGroup; ApiName = "ext_group" },
        @{ Name = "ExtQueues"; Value = $ExtQueues; ApiName = "ext_queues" },
        @{ Name = "ExtConference"; Value = $ExtConference; ApiName = "ext_conference" },
        @{ Name = "Voicemenus"; Value = $Voicemenus; ApiName = "voicemenus" },
        @{ Name = "Voicemailgroups"; Value = $Voicemailgroups; ApiName = "voicemailgroups" },
        @{ Name = "ExtFax"; Value = $ExtFax; ApiName = "ext_fax" },
        @{ Name = "ExtLocal"; Value = $ExtLocal; ApiName = "ext_local" },
        @{ Name = "DialTrunk"; Value = $DialTrunk; ApiName = "dial_trunk" },
        @{ Name = "MultiMode"; Value = $MultiMode; ApiName = "multi_mode" },
        @{ Name = "TimeCondition"; Value = $TimeCondition; ApiName = "time_condition" }
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
        Write-Error "API call to updateInboundRoute failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

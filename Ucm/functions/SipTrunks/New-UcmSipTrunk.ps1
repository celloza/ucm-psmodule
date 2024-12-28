<#
.SYNOPSIS
    Adds a new SIP trunk to the UCM system.

.DESCRIPTION
    This cmdlet sends a request to the UCM API to create a new SIP trunk with specified configurations, including optional advanced features.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER TrunkName
    The name of the SIP trunk. This is mandatory.

.PARAMETER ProviderHost
    The host address (IP or domain) for the SIP trunk. This is mandatory.

.PARAMETER TrunkType
    The type of SIP trunk. Valid options: `peer`, `register`. This is mandatory.

.PARAMETER Username
    The username for authentication with the VoIP provider. This is mandatory.

.PARAMETER Secret
    The password for authentication with the VoIP provider. Required for register trunks.

.PARAMETER CidName
    (Optional) The Caller ID name for the trunk.

.PARAMETER CidNumber
    (Optional) The Caller ID number for the trunk.

.PARAMETER DidMode
    (Optional) DID mode. Options: `disable`, `enabled`.

.PARAMETER DtmfMode
    (Optional) DTMF mode. Options: `rfc2833`, `inband`, `sipinfo`.

.PARAMETER EnableQualify
    (Optional) Whether to enable qualify for SIP peers. Options: `yes`, `no`.

.PARAMETER Encryption
    (Optional) SRTP encryption mode. Options: `no`, `yes`, `support`.

.PARAMETER FaxDetect
    (Optional) Fax detection mode. Options: `none`, `incoming`.

.PARAMETER FaxIntelligentRoute
    (Optional) Whether to use intelligent fax routing. Options: `yes`, `no`.

.PARAMETER FaxIntelligentRouteDestination
    (Optional) The destination to route fax calls if intelligent routing is enabled.

.PARAMETER FromDomain
    (Optional) From domain for the SIP trunk.

.PARAMETER FromUser
    (Optional) From user for the SIP trunk.

.PARAMETER NeedRegistered
    (Optional) Whether the trunk needs to be registered. Options: `yes`, `no`.

.PARAMETER OutMaxChans
    (Optional) Maximum channels for outgoing calls on the trunk.

.PARAMETER OutOfService
    (Optional) Whether the trunk is out of service. Options: `yes`, `no`.

.PARAMETER Allow
    (Optional) Supported codec(s). Multiple can be set, including options such as `ulaw`, `alaw`, `gsm`, `g729`, `g722`, etc.

.PARAMETER AllowOutgoingCallsIfRegFailed
    (Optional) Whether outgoing calls are allowed when registration fails. Options: `yes`, `no`.

.PARAMETER AuthTrunk
    (Optional) Authenticate trunk. If enabled, UCM will respond to incoming calls with a 401 message to authenticate the trunk. Options: `yes`, `no`.

.PARAMETER AuthId
    (Optional) Authenticate ID for the SIP trunk.

.PARAMETER AutoRecording
    (Optional) Enable automatic call recording. Options: `yes`, `no`.

.PARAMETER CcAgentPolicy
    (Optional) Enable CC service control. Options: `native`, `never`.

.PARAMETER CcMaxAgents
    (Optional) Maximum number of agents for the trunk.

.PARAMETER CcMaxMonitors
    (Optional) Maximum number of monitor structures for the trunk.

.PARAMETER CcMonitorPolicy
    (Optional) Enable CC service control for monitoring. Options: `native`, `never`.

.PARAMETER DialinDirect
    (Optional) Enable direct callback. Options: `yes`, `no`.

.PARAMETER KeepCid
    (Optional) Whether to keep the caller ID. Options: `yes`, `no`.

.PARAMETER KeepOrgCid
    (Optional) Whether to keep the original caller ID. Options: `yes`, `no`.

.PARAMETER LdapCustomPrefix
    (Optional) Custom prefix for LDAP integration.

.PARAMETER LdapDefaultOutrt
    (Optional) LDAP default outbound route.

.PARAMETER LdapSyncEnable
    (Optional) Whether to enable LDAP synchronization. Options: `yes`, `no`.

.PARAMETER Nat
    (Optional) Enable NAT settings for the trunk. Options: `yes`, `no`.

.PARAMETER OutboundProxy
    (Optional) Outbound proxy for SIP.

.PARAMETER PaiNumber
    (Optional) PAI header number.

.PARAMETER PassthroughPai
    (Optional) Whether to pass through the PAI header. Options: `yes`, `no`.

.PARAMETER QualifyFreq
    (Optional) Frequency (in seconds) to send SIP OPTIONS to check peer quality.

.PARAMETER RmvObpFromRoute
    (Optional) Whether to remove the outbound proxy from the route header. Options: `yes`, `no`.

.PARAMETER SendPpi
    (Optional) Whether to send the PPI header. Options: `yes`, `no`.

.PARAMETER TelUri
    (Optional) TEL URI format. Options: `disabled`, `user_phone`, `enabled`.

.PARAMETER Transport
    (Optional) SIP transport method. Options: `udp`, `tcp`, `tls`.

.PARAMETER UseDodInPpi
    (Optional) Whether to use DOD in the PPI header. Options: `yes`, `no`.

.PARAMETER UseOrigCidInPpi
    (Optional) Whether to use the original CID in the PPI header. Options: `yes`, `no`.

.PARAMETER UseForSfuConf
    (Optional) Whether to use the trunk for SFU (Selective Forwarding Unit) conference. Options: `yes`, `no`.

.EXAMPLE
    New-UcmSipTrunk -Uri "http://10.10.10.1/api" -Cookie $cookie -TrunkName "VoIPProvider" `
        ProviderHost "sip.provider.com" -TrunkType "register" -Username "user1" -Secret "password123" `
        -Encryption "yes" -DtmfMode "rfc2833"
    Creates a new SIP trunk with specified configurations.

.NOTES
    Ensure all mandatory parameters are provided for successful execution.
#>
function New-UcmSipTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter(Mandatory)][string]$ProviderHost,
        [Parameter(Mandatory)][ValidateSet("peer", "register")][string]$TrunkType,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][string]$Secret,
        [Parameter()][string]$CidName,
        [Parameter()][string]$CidNumber,
        [Parameter()][ValidateSet("disable", "enabled")][string]$DidMode,
        [Parameter()][ValidateSet("rfc2833", "inband", "sipinfo")][string]$DtmfMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableQualify,
        [Parameter()][ValidateSet("no", "yes", "support")][string]$Encryption,
        [Parameter()][ValidateSet("none", "incoming")][string]$FaxDetect,
        [Parameter()][ValidateSet("yes", "no")][string]$FaxIntelligentRoute,
        [Parameter()][string]$FaxIntelligentRouteDestination,
        [Parameter()][string]$FromDomain,
        [Parameter()][string]$FromUser,
        [Parameter()][ValidateSet("yes", "no")][string]$NeedRegistered,
        [Parameter()][string]$OutMaxChans,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$Allow,
        [Parameter()][ValidateSet("yes", "no")][string]$AllowOutgoingCallsIfRegFailed,
        [Parameter()][ValidateSet("yes", "no")][string]$AuthTrunk,
        [Parameter()][string]$AuthId,
        [Parameter()][ValidateSet("yes", "no")][string]$AutoRecording,
        [Parameter()][ValidateSet("native", "never")][string]$CcAgentPolicy,
        [Parameter()][int]$CcMaxAgents,
        [Parameter()][int]$CcMaxMonitors,
        [Parameter()][ValidateSet("native", "never")][string]$CcMonitorPolicy,
        [Parameter()][ValidateSet("yes", "no")][string]$DialinDirect,
        [Parameter()][ValidateSet("yes", "no")][string]$KeepCid,
        [Parameter()][ValidateSet("yes", "no")][string]$KeepOrgCid,
        [Parameter()][string]$LdapCustomPrefix,
        [Parameter()][string]$LdapDefaultOutrt,
        [Parameter()][ValidateSet("yes", "no")][string]$LdapSyncEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$Nat,
        [Parameter()][string]$OutboundProxy,
        [Parameter()][string]$PaiNumber,
        [Parameter()][ValidateSet("yes", "no")][string]$PassthroughPai,
        [Parameter()][int]$QualifyFreq,
        [Parameter()][ValidateSet("yes", "no")][string]$RmvObpFromRoute,
        [Parameter()][ValidateSet("yes", "no")][string]$SendPpi,
        [Parameter()][ValidateSet("disabled", "user_phone", "enabled")][string]$TelUri,
        [Parameter()][ValidateSet("udp", "tcp", "tls")][string]$Transport,
        [Parameter()][ValidateSet("yes", "no")][string]$UseDodInPpi,
        [Parameter()][ValidateSet("yes", "no")][string]$UseOrigCidInPpi,
        [Parameter()][ValidateSet("yes", "no")][string]$UseForSfuConf
    )

    $apiRequest = @{
        request = @{
            action = "addSipTrunk"
            cookie = $Cookie
            trunk_name = $TrunkName
            host = $ProviderHost
            trunk_type = $TrunkType
            username = $Username
            secret = $Secret
        }
    }

    # Add optional parameters dynamically
    $optionalParameters = @(
        @{ Name = "CidName"; ApiName = "cidname" },
        @{ Name = "CidNumber"; ApiName = "cidnumber" },
        @{ Name = "DidMode"; ApiName = "did_mode" },
        @{ Name = "DtmfMode"; ApiName = "dtmfmode" },
        @{ Name = "EnableQualify"; ApiName = "enable_qualify" },
        @{ Name = "Encryption"; ApiName = "encryption" },
        @{ Name = "FaxDetect"; ApiName = "faxdetect" },
        @{ Name = "FaxIntelligentRoute"; ApiName = "fax_intelligent_route" },
        @{ Name = "FaxIntelligentRouteDestination"; ApiName = "fax_intelligent_route_destination" },
        @{ Name = "FromDomain"; ApiName = "fromdomain" },
        @{ Name = "FromUser"; ApiName = "fromuser" },
        @{ Name = "NeedRegistered"; ApiName = "need_registered" },
        @{ Name = "OutMaxChans"; ApiName = "out_maxchans" },
        @{ Name = "OutOfService"; ApiName = "out_of_service" },
        @{ Name = "Allow"; ApiName = "allow" },
        @{ Name = "AllowOutgoingCallsIfRegFailed"; ApiName = "allow_outgoing_calls_if_reg_failed" },
        @{ Name = "AuthTrunk"; ApiName = "auth_trunk" },
        @{ Name = "AuthId"; ApiName = "authid" },
        @{ Name = "AutoRecording"; ApiName = "auto_recording" },
        @{ Name = "CcAgentPolicy"; ApiName = "cc_agent_policy" },
        @{ Name = "CcMaxAgents"; ApiName = "cc_max_agents" },
        @{ Name = "CcMaxMonitors"; ApiName = "cc_max_monitors" },
        @{ Name = "CcMonitorPolicy"; ApiName = "cc_monitor_policy" },
        @{ Name = "DialinDirect"; ApiName = "dialin_direct" },
        @{ Name = "KeepCid"; ApiName = "keepcid" },
        @{ Name = "KeepOrgCid"; ApiName = "keeporgcid" },
        @{ Name = "LdapCustomPrefix"; ApiName = "ldap_custom_prefix" },
        @{ Name = "LdapDefaultOutrt"; ApiName = "ldap_default_outrt" },
        @{ Name = "LdapSyncEnable"; ApiName = "ldap_sync_enable" },
        @{ Name = "Nat"; ApiName = "nat" },
        @{ Name = "OutboundProxy"; ApiName = "outboundproxy" },
        @{ Name = "PaiNumber"; ApiName = "pai_number" },
        @{ Name = "PassthroughPai"; ApiName = "passthrough_pai" },
        @{ Name = "QualifyFreq"; ApiName = "qualifyfreq" },
        @{ Name = "RmvObpFromRoute"; ApiName = "rmv_obp_from_route" },
        @{ Name = "SendPpi"; ApiName = "send_ppi" },
        @{ Name = "TelUri"; ApiName = "tel_uri" },
        @{ Name = "Transport"; ApiName = "transport" },
        @{ Name = "UseDodInPpi"; ApiName = "use_dod_in_ppi" },
        @{ Name = "UseOrigCidInPpi"; ApiName = "use_origcid_in_ppi" },
        @{ Name = "UseForSfuConf"; ApiName = "use_for_sfu_conf" }
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
        Write-Error "API call to addSipTrunk failed. Status: $($responseContent.status)"
    } else {
        return $responseContent.response
    }
}

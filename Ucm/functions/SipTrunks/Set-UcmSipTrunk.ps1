<#
.SYNOPSIS
    Updates an existing SIP trunk on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateSIPTrunk" to update the configuration of an existing SIP trunk.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER TrunkId
    The ID of the trunk to update.

.PARAMETER CidName
    Caller ID name for the trunk.

.PARAMETER CidNumber
    Caller ID number for the trunk.

.PARAMETER DidMode
    DID mode. Options: `disable`, `enabled`.
    This parameter controls whether DID (Direct Inward Dialing) mode is enabled or not.

.PARAMETER DtmfMode
    DTMF mode. Options: `rfc2833`, `inband`, `sipinfo`.
    DTMF (Dual-tone multi-frequency) mode determines how the tones used to signal user inputs during a call are sent over the network.

.PARAMETER EnableQualify
    Whether to enable qualify for SIP peers. Options: `yes`, `no`.
    Enabling this setting allows the system to check the status of the SIP trunk periodically by sending OPTIONS messages to the peer.

.PARAMETER Encryption
    SRTP encryption mode. Options: `no`, `yes`, `support`.
    This setting determines whether encryption is used for the media path. `yes` enables encryption, `support` enables SRTP if supported by the peer, and `no` disables it.

.PARAMETER FaxDetect
    Fax detection mode. Options: `none`, `incoming`.
    This parameter enables or disables fax detection for the trunk. `incoming` will enable detection for incoming calls, and `none` disables it.

.PARAMETER FaxIntelligentRoute
    Whether to use intelligent fax routing. Options: `yes`, `no`.
    If enabled, the system will intelligently route fax calls to the appropriate destination based on the call type.

.PARAMETER FaxIntelligentRouteDestination
    The destination to route fax calls if intelligent routing is enabled.
    This specifies the destination (e.g., a voicemail box or another trunk) for calls determined to be faxes by the system.

.PARAMETER FromDomain
    From domain for the SIP trunk.
    The domain used in the "From" field of SIP requests to identify the trunk.

.PARAMETER FromUser
    From user for the SIP trunk.
    This field specifies the user for the "From" field in SIP requests for authentication and call routing purposes.

.PARAMETER NeedRegistered
    Whether the trunk needs to be registered. Options: `yes`, `no`.
    This setting determines whether the trunk must be registered to a server to accept or place calls.

.PARAMETER OutMaxChans
    Maximum channels for outgoing calls on the trunk.
    Defines the maximum number of concurrent channels that can be used for outbound calls on the trunk.

.PARAMETER OutOfService
    Whether the trunk is out of service. Options: `yes`, `no`.
    This setting allows administrators to mark a trunk as out of service, preventing it from handling calls.

.PARAMETER Allow
    Supported codec, multiple values can be set. Options include `ulaw`, `alaw`, `gsm`, `g726`, `g729`, `ilbc`, `g722`, `g726aal2`, `adpcm`, `g723`, `h263`, `h263p`, `h264`, `h265`, `vp8`, `opus`, `rtx`.
    Specifies which codecs are supported for the trunk to use for voice and video calls.

.PARAMETER AllowOutgoingCallsIfRegFailed
    Whether outgoing calls are allowed when registration failed. Options: `yes`, `no`.
    If registration to the server fails, this option determines whether outgoing calls are still allowed.

.PARAMETER AuthTrunk
    Authenticate trunk. Options: `yes`, `no`.
    If enabled, UCM will require authentication for the trunk before allowing calls to be placed or received.

.PARAMETER AuthId
    Authenticate ID for the SIP trunk.
    This ID is used for authentication when establishing the trunk connection.

.PARAMETER AutoRecording
    Auto record. Options: `yes`, `no`.
    Enables or disables automatic recording for calls made through the trunk.

.PARAMETER CcAgentPolicy
    To enable CC service control. Options: `native`, `never`.
    Defines the policy for agent availability control in call centers using the trunk. `native` uses the trunk's agent availability, and `never` disables it.

.PARAMETER CcMaxAgents
    The maximum number of agents for the trunk.
    Specifies the maximum number of agents that can be allocated to the trunk for handling calls in a call center.

.PARAMETER CcMaxMonitors
    The maximum number of monitor structures for the trunk.
    Specifies the maximum number of monitoring structures that can be created for monitoring calls on the trunk.

.PARAMETER CcMonitorPolicy
    To enable CC service control. Options: `native`, `never`.
    Defines how monitoring of call center agents is handled. `native` uses the trunk’s monitoring features, while `never` disables monitoring.

.PARAMETER DialInDirect
    Direct callback. Options: `yes`, `no`.
    Enables or disables direct callback for incoming calls to the trunk.

.PARAMETER ProviderHost
    The host IP or domain for the trunk.
    The domain or IP address of the provider's SIP server.

.PARAMETER KeepCid
    Whether to keep the caller ID. Options: `yes`, `no`.
    If enabled, the system will maintain the caller ID received from the inbound call.

.PARAMETER KeepOrgCid
    Whether to keep the original caller ID. Options: `yes`, `no`.
    If enabled, the system will maintain the original caller ID even if it is changed by the trunk or network.

.PARAMETER LdapCustomPrefix
    Custom prefix for LDAP.
    Defines a custom prefix used in LDAP-based configurations.

.PARAMETER LdapDefaultOutRt
    LDAP default outbound route.
    The default outbound route used for calls originating from the trunk in LDAP-based setups.

.PARAMETER LdapSyncEnable
    Whether to enable LDAP synchronization. Options: `yes`, `no`.
    If enabled, the system will synchronize configurations based on LDAP directory information.

.PARAMETER Nat
    NAT settings. Options: `yes`, `no`.
    Whether to apply Network Address Translation (NAT) to the trunk, typically used when the trunk is behind a NAT device.

.PARAMETER OutboundProxy
    Outbound proxy for SIP.
    Defines the outbound proxy server used for SIP signaling.

.PARAMETER PaiNumber
    PAI header number.
    Specifies the number to be sent in the PAI (P-Asserted-Identity) header for authentication and identification.

.PARAMETER PassthroughPai
    Passthrough PAI header. Options: `yes`, `no`.
    If enabled, the PAI header from the incoming call will be passed through without modification.

.PARAMETER QualifyFreq
    Frequency to send SIP OPTIONS to check peer quality.
    Specifies how often (in seconds) SIP OPTIONS messages are sent to check the status of the peer.

.PARAMETER RmvObpFromRoute
    Whether to remove the outbound proxy from the route header. Options: `yes`, `no`.
    If enabled, the outbound proxy is removed from the route header of the SIP request.

.PARAMETER Secret
    Password for the register trunk.
    The password used to authenticate the trunk for SIP registration.

.PARAMETER SendPpi
    Whether to send the PPI header. Options: `yes`, `no`.
    If enabled, the system will include the PPI (Private-Party-Identity) header in the SIP messages.

.PARAMETER TelUri
    TEL URI format. Options: `disabled`, `user_phone`, `enabled`.
    Defines how the TEL URI is formatted for SIP messages.

.PARAMETER Transport
    SIP transport method. Options: `udp`, `tcp`, `tls`.
    Specifies the transport protocol used for SIP signaling. 

.PARAMETER TrunkName
    The name of the trunk.
    The name used to identify the SIP trunk.

.PARAMETER UseDodInPpi
    Configure how to set the PPI number. 
    When `use_dod_in_ppi` and `use_origcid_in_ppi` are both `no`, set the PPI number by CID option priority. 
    When `use_origcid_in_ppi` is `yes`, use the original CID in the PPI header. If no original CID, use the default number. 
    When `use_dod_in_ppi` is `yes`, use the DOD number in the PPI header. If no DOD number, use the default number.

.PARAMETER UseOrigCidInPpi
    Whether to use the original caller ID in the PPI header. Options: `yes`, `no`.
    If enabled, the original CID will be used in the PPI header, provided the original CID is available.

.PARAMETER Username
    Username for authentication on the SIP trunk.
    The username required for authenticating the trunk during SIP registration.

.PARAMETER UseForSfuConf
    Whether to use the trunk for SFU (Selective Forwarding Unit) conference. Options: `yes`, `no`.
    If enabled, this trunk will be used in the SFU conference scenarios, where media is forwarded selectively to participants.

.EXAMPLE
    Set-UcmSIPTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkId "1" `
        -CidName "MyTrunk" -CidNumber "12345" -DtmfMode "rfc2833" -EnableQualify "yes" `
        -Encryption "yes" -FaxDetect "incoming" -FromDomain "sip.example.com" -ProviderHost "192.168.1.1" `
        -Allow "ulaw,alaw,g729" -AuthTrunk "yes" -Secret "mysecret" -DialInDirect "yes" `
        -Username "trunkuser" -UseForSfuConf "yes"
#>
function Set-UcmSIPTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$TrunkId,
        [Parameter()][string]$CidName,
        [Parameter()][string]$CidNumber,
        [Parameter()][string]$DidMode,
        [Parameter()][string]$DtmfMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableQualify,
        [Parameter()][ValidateSet("no", "yes", "support")][string]$Encryption,
        [Parameter()][ValidateSet("none", "incoming")][string]$FaxDetect,
        [Parameter()][ValidateSet("yes", "no")][string]$FaxIntelligentRoute,
        [Parameter()][string]$FaxIntelligentRouteDestination,
        [Parameter()][string]$FromDomain,
        [Parameter()][string]$FromUser,
        [Parameter()][ValidateSet("yes", "no")][string]$NeedRegistered,
        [Parameter()][int]$OutMaxChans,
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
        [Parameter()][ValidateSet("yes", "no")][string]$DialInDirect,
        [Parameter()][string]$ProviderHost,
        [Parameter()][ValidateSet("yes", "no")][string]$KeepCid,
        [Parameter()][ValidateSet("yes", "no")][string]$KeepOrgCid,
        [Parameter()][string]$LdapCustomPrefix,
        [Parameter()][string]$LdapDefaultOutRt,
        [Parameter()][ValidateSet("yes", "no")][string]$LdapSyncEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$Nat,
        [Parameter()][string]$OutboundProxy,
        [Parameter()][string]$PaiNumber,
        [Parameter()][ValidateSet("yes", "no")][string]$PassthroughPai,
        [Parameter()][int]$QualifyFreq,
        [Parameter()][ValidateSet("yes", "no")][string]$RmvObpFromRoute,
        [Parameter()][string]$Secret,
        [Parameter()][ValidateSet("yes", "no")][string]$SendPpi,
        [Parameter()][ValidateSet("disabled", "user_phone", "enabled")][string]$TelUri,
        [Parameter()][ValidateSet("udp", "tcp", "tls")][string]$Transport,
        [Parameter()][string]$TrunkName,
        [Parameter()][ValidateSet("yes", "no")][string]$UseDodInPpi,
        [Parameter()][ValidateSet("yes", "no")][string]$UseOrigCidInPpi,
        [Parameter()][string]$Username,
        [Parameter()][ValidateSet("yes", "no")][string]$UseForSfuConf
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateSIPTrunk"
            cookie = $Cookie
            trunk = $TrunkId
        }
    }

    # Add parameters to API request
    @(
        @{ Name = "CidName"; Value = $CidName; ApiName = "cidname" },
        @{ Name = "CidNumber"; Value = $CidNumber; ApiName = "cidnumber" },
        @{ Name = "DidMode"; Value = $DidMode; ApiName = "did_mode" },
        @{ Name = "DtmfMode"; Value = $DtmfMode; ApiName = "dtmfmode" },
        @{ Name = "EnableQualify"; Value = $EnableQualify; ApiName = "enable_qualify" },
        @{ Name = "Encryption"; Value = $Encryption; ApiName = "encryption" },
        @{ Name = "FaxDetect"; Value = $FaxDetect; ApiName = "faxdetect" },
        @{ Name = "FaxIntelligentRoute"; Value = $FaxIntelligentRoute; ApiName = "fax_intelligent_route" },
        @{ Name = "FaxIntelligentRouteDestination"; Value = $FaxIntelligentRouteDestination; ApiName = "fax_intelligent_route_destination" },
        @{ Name = "FromDomain"; Value = $FromDomain; ApiName = "fromdomain" },
        @{ Name = "FromUser"; Value = $FromUser; ApiName = "fromuser" },
        @{ Name = "NeedRegistered"; Value = $NeedRegistered; ApiName = "need_registered" },
        @{ Name = "OutMaxChans"; Value = $OutMaxChans; ApiName = "out_maxchans" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "Allow"; Value = $Allow; ApiName = "allow" },
        @{ Name = "AllowOutgoingCallsIfRegFailed"; Value = $AllowOutgoingCallsIfRegFailed; ApiName = "allow_outgoing_calls_if_reg_failed" },
        @{ Name = "AuthTrunk"; Value = $AuthTrunk; ApiName = "auth_trunk" },
        @{ Name = "AuthId"; Value = $AuthId; ApiName = "authid" },
        @{ Name = "AutoRecording"; Value = $AutoRecording; ApiName = "auto_recording" },
        @{ Name = "CcAgentPolicy"; Value = $CcAgentPolicy; ApiName = "cc_agent_policy" },
        @{ Name = "CcMaxAgents"; Value = $CcMaxAgents; ApiName = "cc_max_agents" },
        @{ Name = "CcMaxMonitors"; Value = $CcMaxMonitors; ApiName = "cc_max_monitors" },
        @{ Name = "CcMonitorPolicy"; Value = $CcMonitorPolicy; ApiName = "cc_monitor_policy" },
        @{ Name = "DialInDirect"; Value = $DialInDirect; ApiName = "dialin_direct" },
        @{ Name = "ProviderHost"; Value = $ProviderHost; ApiName = "host" },
        @{ Name = "KeepCid"; Value = $KeepCid; ApiName = "keepcid" },
        @{ Name = "KeepOrgCid"; Value = $KeepOrgCid; ApiName = "keeporgcid" },
        @{ Name = "LdapCustomPrefix"; Value = $LdapCustomPrefix; ApiName = "ldap_custom_prefix" },
        @{ Name = "LdapDefaultOutRt"; Value = $LdapDefaultOutRt; ApiName = "ldap_default_outrt" },
        @{ Name = "LdapSyncEnable"; Value = $LdapSyncEnable; ApiName = "ldap_sync_enable" },
        @{ Name = "Nat"; Value = $Nat; ApiName = "nat" },
        @{ Name = "OutboundProxy"; Value = $OutboundProxy; ApiName = "outboundproxy" },
        @{ Name = "PaiNumber"; Value = $PaiNumber; ApiName = "pai_number" },
        @{ Name = "PassthroughPai"; Value = $PassthroughPai; ApiName = "passthrough_pai" },
        @{ Name = "QualifyFreq"; Value = $QualifyFreq; ApiName = "qualifyfreq" },
        @{ Name = "RmvObpFromRoute"; Value = $RmvObpFromRoute; ApiName = "rmv_obp_from_route" },
        @{ Name = "Secret"; Value = $Secret; ApiName = "secret" },
        @{ Name = "SendPpi"; Value = $SendPpi; ApiName = "send_ppi" },
        @{ Name = "TelUri"; Value = $TelUri; ApiName = "tel_uri" },
        @{ Name = "Transport"; Value = $Transport; ApiName = "transport" },
        @{ Name = "TrunkName"; Value = $TrunkName; ApiName = "trunk_name" },
        @{ Name = "UseDodInPpi"; Value = $UseDodInPpi; ApiName = "use_dod_in_ppi" },
        @{ Name = "UseOrigCidInPpi"; Value = $UseOrigCidInPpi; ApiName = "use_origcid_in_ppi" },
        @{ Name = "Username"; Value = $Username; ApiName = "username" },
        @{ Name = "UseForSfuConf"; Value = $UseForSfuConf; ApiName = "use_for_sfu_conf" }
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
        Write-Error "API call to updateSIPTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
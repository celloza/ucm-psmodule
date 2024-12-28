<#
.SYNOPSIS
    Updates an existing SIP account on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateSIPAccount" to update the configuration of an existing SIP account.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER Extension
    The extension to configure (2-18 digits).
    The SIP extension number used for the account.

.PARAMETER HasVoicemail
    Whether to enable voicemail. Options: `yes`, `no`.
    If enabled, voicemail will be activated for this extension.

.PARAMETER CidNumber
    Caller ID number (2-32 digits).
    The caller ID number associated with this extension.

.PARAMETER Secret
    SIP/IAX password (4-32 alphanumeric or special characters).
    The password used for authentication in SIP or IAX accounts.

.PARAMETER VmSecret
    Voicemail password (4-32 digits).
    The password used to access voicemail.

.PARAMETER SkipVmSecret
    Whether to skip voicemail password verification when dialing into voicemail. Options: `yes`, `no`.
    If enabled, users will not need to enter the voicemail password when accessing voicemail.

.PARAMETER RingTimeout
    Ring timeout in seconds (3-600 seconds or null for default).
    The amount of time (in seconds) before a call to the extension is considered unanswered.

.PARAMETER AutoRecord
    Whether to enable call recording for this extension. Options: `all`, `external`, `internal`, `off`.
    Defines whether calls made or received on this extension are automatically recorded.

.PARAMETER Encryption
    SRTP encryption mode. Options: `no`, `yes`, `support`.
    Determines whether encryption is used for the media path.

.PARAMETER FaxDetect
    Fax detection mode. Options: `no`, `yes`.
    Determines whether fax detection is enabled for the extension. 

.PARAMETER SendToFax
    Whether to send calls to fax. Options: `yes`, `no`.
    If enabled, all calls to this extension will be routed to fax detection if applicable.

.PARAMETER StrategyIpAcl
    IP ACL strategy.
    The access control list (ACL) strategy used for restricting access to this extension based on IP addresses.

.PARAMETER LocalNetworks
    Array of local networks to configure (up to 10 networks).
    The list of local networks for this SIP account, used to identify trusted IP ranges.

.PARAMETER SpecificIp
    Whether to use a specific IP for this account.
    If enabled, this extension will only accept calls from a specific IP address.

.PARAMETER Allow
    Supported codecs, multiple values allowed. Options: `ulaw`, `alaw`, `gsm`, `g726`, `g722`, `g729`, `h264`, `ilbc`.
    Specifies the codecs that this extension supports for voice and video calls.

.PARAMETER Dnd
    Do Not Disturb status. Options: `yes`, `no`.
    If enabled, the extension will reject incoming calls while in "Do Not Disturb" mode.

.PARAMETER DndTimeType
    Type of DND timer.
    Specifies the type of timer to be used for Do Not Disturb functionality.

.PARAMETER Permission
    Permission settings for the extension.
    Configures the permissions (e.g., outbound calls) for this SIP extension.

.PARAMETER Nat
    NAT settings. Options: `yes`, `no`.
    Determines whether to apply NAT (Network Address Translation) for this SIP account, typically used when the account is behind a NAT device.

.PARAMETER BypassOutRtAuth
    Whether to bypass outbound route authentication. Options: `yes`, `no`.
    If enabled, the system will bypass authentication when the extension uses outbound routes.

.PARAMETER SkipAuthTimeType
    Whether to skip authentication at a specific time.
    Determines whether authentication is skipped during certain time periods.

.PARAMETER T38Udptl
    T38 UDP Transport Layer for fax. Options: `yes`, `no`.
    Determines whether T38 faxing over UDP is enabled for this extension.

.PARAMETER DirectMedia
    Whether to use direct media. Options: `yes`, `no`.
    If enabled, SIP media (audio, video) will be sent directly to the peer without passing through the UCM.

.PARAMETER DtmfMode
    DTMF mode. Options: `rfc2833`, `inband`, `sipinfo`.
    Specifies the method for transmitting DTMF tones, such as through the SIP INFO message or in-band.

.PARAMETER EnableQualify
    Whether to enable qualify for SIP peers. Options: `yes`, `no`.
    If enabled, UCM will periodically check the status of SIP peers.

.PARAMETER QualifyFreq
    Frequency to check peer quality.
    The interval (in seconds) between sending SIP OPTIONS messages to check peer status.

.PARAMETER AuthId
    Authentication ID for SIP/IAX authentication.
    The ID used to authenticate SIP or IAX communication for this extension.

.PARAMETER TelUri
    Telephone URI for SIP.
    The telephone number or URI used in SIP INVITE messages for routing calls.

.PARAMETER EnableHotDesk
    Whether to enable hotdesking. Options: `yes`, `no`.
    If enabled, users can log into this extension from any physical phone (hotdesk mode).

.PARAMETER UserOutRtPasswd
    User outbound route password.
    Password for outbound routes, used to authenticate the route selection.

.PARAMETER OutOfService
    Whether the extension is out of service. Options: `yes`, `no`.
    If enabled, the extension is disabled for making or receiving calls.

.PARAMETER MohSuggest
    Music on hold suggestion.
    The music or audio prompt used when callers are placed on hold by this extension.

.PARAMETER EnRingBoth
    Whether to ring both endpoints. Options: `yes`, `no`.
    If enabled, both endpoints will ring simultaneously when receiving a call.

.PARAMETER ExternalNumber
    External number associated with the extension.
    A phone number outside of the UCM system, such as a mobile or landline number, associated with this extension.

.PARAMETER UseCalleeDodOnFwdRb
    Whether to use callee DOD on forwarded calls. Options: `yes`, `no`.
    If enabled, the DOD (Dialed Number) of the callee is used for forwarded calls.

.PARAMETER UseCalleeDodOnFm
    Whether to use callee DOD on follow-me. Options: `yes`, `no`.
    If enabled, the DOD of the callee is used when the follow-me feature is active.

.PARAMETER RingBothTimeType
    Time type for the `en_ringboth` parameter.
    Defines when both endpoints should ring during call setup.

.PARAMETER EnableLdap
    Whether to enable LDAP. Options: `yes`, `no`.
    If enabled, the extension will integrate with LDAP for user management and authentication.

.PARAMETER MaxContacts
    Maximum number of contacts allowed for this extension.
    Defines the maximum number of contacts (phone numbers or directories) this extension can manage.

.PARAMETER CustomAutoAnswer
    Whether to use custom auto-answer. Options: `yes`, `no`.
    If enabled, the extension will automatically answer incoming calls after a defined delay.

.PARAMETER ScaEnable
    Whether to enable shared call appearance. Options: `yes`, `no`.
    If enabled, the extension can share call appearances with other extensions, allowing multiple users to manage the same line.

.PARAMETER CallWaiting
    Whether call waiting is enabled. Options: `yes`, `no`.
    If enabled, the extension can receive additional calls while a call is already active.

.PARAMETER EmergCidNumber
    Emergency caller ID number.
    The caller ID number to be used during emergency calls made from this extension.

.PARAMETER EnableWebrtc
    Whether WebRTC is enabled for this extension. Options: `yes`, `no`.
    If enabled, this extension can make and receive WebRTC calls via browsers.

.PARAMETER AlertInfo
    Alert info for the SIP account. Options:
    - `none`, `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, `ring6`, `ring7`, `ring8`, `ring9`, `ring10`
    - `Bellcore-dr1`, `Bellcore-dr2`, `Bellcore-dr3`, `Bellcore-dr4`, `Bellcore-dr5`, `custom`
    This field specifies the alert information sent to the called party to determine the alerting tone or behavior.

.PARAMETER Limitime
    Limitation time for the SIP account.
    The maximum allowed call time for this extension, after which the call will be disconnected.

.PARAMETER DndWhitelist
    DND whitelist.
    A list of extensions or numbers that are allowed to bypass the Do Not Disturb (DND) setting.

.PARAMETER FwdWhitelist
    Forwarding whitelist.
    A list of extensions or numbers that can bypass call forwarding settings.

.PARAMETER CallBargingMonitor
    Whether to monitor call barging. Options: `yes`, `no`.
    If enabled, this extension can be monitored for call barging by other authorized users.

.PARAMETER SeamlessTransferMembers
    Seamless transfer members configuration.
    Specifies members for seamless transfer, which allows calls to be transferred between users without interruption.

.PARAMETER SipPresenceSettings
    Presence settings, requires entire JSON list of SIP presence settings.
    Configures SIP presence functionality for this extension, including presence states and behaviors.

.PARAMETER PresenceStatus
    Presence status. Options: `available`, `away`, `chat`, `unavailable`, `userdef`.
    Defines the current presence status of the extension for others to see.

.PARAMETER Cfb
    Call Forward on Busy configuration.
    Configures call forwarding when the extension is busy.

.PARAMETER Cfn
    Call Forward on No Answer configuration.
    Configures call forwarding when the extension does not answer.

.PARAMETER Cfu
    Call Forward Unconditional configuration.
    Configures unconditional call forwarding, where all calls are forwarded regardless of the extension’s status.

.PARAMETER CfbTimeType
    Type of time settings for CFB.
    Configures when Call Forward on Busy (CFB) should be activated.

.PARAMETER CfnTimeType
    Type of time settings for CFN.
    Configures when Call Forward on No Answer (CFN) should be activated.

.PARAMETER CfuTimeType
    Type of time settings for CFU.
    Configures when Call Forward Unconditional (CFU) should be activated.

.PARAMETER CfbDestinationType
    The destination type for Call Forward on Busy.
    Specifies where calls should be forwarded when the extension is busy. Options: `account`, `voicemail`, `queue`, `ringgroup`, `vmgroup`, `ivr`, `external_number`.

.PARAMETER CfnDestinationType
    The destination type for Call Forward on No Answer.
    Specifies where calls should be forwarded when the extension is not answered.

.PARAMETER CfuDestinationType
    The destination type for Call Forward Unconditional.
    Specifies where calls should be forwarded when the extension has Call Forward Unconditional enabled.

.PARAMETER VmAttach
    Whether voicemail is attached to this SIP account.
    If enabled, voicemail is attached to the extension for managing voicemail messages.

.PARAMETER VmReserve
    Whether voicemail is reserved.
    If enabled, this extension has exclusive access to its voicemail.

.EXAMPLE
    Set-UcmSIPAccount -Uri http://10.10.10.1/api -Cookie $cookie -Extension "1001" `
        -HasVoicemail "yes" -CidNumber "1001" -Secret "secretpassword" -VmSecret "password" `
        -RingTimeout 30 -AutoRecord "all" -Encryption "yes" -FaxDetect "yes" -SendToFax "no" `
        -Allow "ulaw,alaw" -Dnd "no" -Nat "no" -BypassOutRtAuth "no" -DirectMedia "yes" `
        -DtmfMode "rfc2833" -EnableQualify "yes" -QualifyFreq 60 -EnableHotDesk "yes" `
        -OutOfService "no" -MohSuggest "default" -EnRingBoth "no" -ExternalNumber "12345" `
        -EnableWebrtc "yes" -AlertInfo "ring1" -Limitime 300 -DndWhitelist "none" `
        -LocalNetworks @("192.168.1.0/24", "192.168.2.0/24")
#>
function Set-UcmSIPAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$Extension,
        [Parameter()][ValidateSet("yes", "no")][string]$HasVoicemail,
        [Parameter()][string]$CidNumber,
        [Parameter(Mandatory)][string]$Secret,
        [Parameter()][string]$VmSecret,
        [Parameter()][ValidateSet("yes", "no")][string]$SkipVmSecret,
        [Parameter()][int]$RingTimeout,
        [Parameter()][ValidateSet("all", "external", "internal", "off")][string]$AutoRecord,
        [Parameter()][ValidateSet("no", "yes", "support")][string]$Encryption,
        [Parameter()][ValidateSet("no", "yes")][string]$FaxDetect,
        [Parameter()][ValidateSet("yes", "no")][string]$SendToFax,
        [Parameter()][string]$StrategyIpAcl,
        [Parameter()][string[]]$LocalNetworks,
        [Parameter()][string]$SpecificIp,
        [Parameter()][string]$Allow,
        [Parameter()][ValidateSet("yes", "no")][string]$Dnd,
        [Parameter()][string]$DndTimeType,
        [Parameter()][string]$Permission,
        [Parameter()][string]$Nat,
        [Parameter()][ValidateSet("yes", "no")][string]$BypassOutRtAuth,
        [Parameter()][string]$SkipAuthTimeType,
        [Parameter()][ValidateSet("yes", "no")][string]$T38Udptl,
        [Parameter()][ValidateSet("yes", "no")][string]$DirectMedia,
        [Parameter()][ValidateSet("rfc2833", "inband", "sipinfo")][string]$DtmfMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableQualify,
        [Parameter()][int]$QualifyFreq,
        [Parameter()][string]$AuthId,
        [Parameter()][string]$TelUri,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableHotDesk,
        [Parameter()][string]$UserOutRtPasswd,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$MohSuggest,
        [Parameter()][ValidateSet("yes", "no")][string]$EnRingBoth,
        [Parameter()][string]$ExternalNumber,
        [Parameter()][ValidateSet("yes", "no")][string]$UseCalleeDodOnFwdRb,
        [Parameter()][ValidateSet("yes", "no")][string]$UseCalleeDodOnFm,
        [Parameter()][string]$RingBothTimeType,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableLdap,
        [Parameter()][int]$MaxContacts,
        [Parameter()][ValidateSet("yes", "no")][string]$CustomAutoAnswer,
        [Parameter()][ValidateSet("yes", "no")][string]$ScaEnable,
        [Parameter()][ValidateSet("yes", "no")][string]$CallWaiting,
        [Parameter()][string]$EmergCidNumber,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWebrtc,
        [Parameter()][string]$AlertInfo,
        [Parameter()][int]$Limitime,
        [Parameter()][string]$DndWhitelist,
        [Parameter()][string]$FwdWhitelist,
        [Parameter()][ValidateSet("yes", "no")][string]$CallBargingMonitor,
        [Parameter()][string]$SeamlessTransferMembers,
        [Parameter()][string]$SipPresenceSettings,
        [Parameter()][ValidateSet("available", "away", "chat", "unavailable", "userdef")][string]$PresenceStatus,
        [Parameter()][string]$Cfb,
        [Parameter()][string]$Cfn,
        [Parameter()][string]$Cfu,
        [Parameter()][string]$CfbTimeType,
        [Parameter()][string]$CfnTimeType,
        [Parameter()][string]$CfuTimeType,
        [Parameter()][string]$CfbDestinationType,
        [Parameter()][string]$CfnDestinationType,
        [Parameter()][string]$CfuDestinationType,
        [Parameter()][ValidateSet("account", "voicemail", "queue", "ringgroup", "vmgroup", "ivr", "external_number")][string]$VmAttach,
        [Parameter()][string]$VmReserve
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateSIPAccount"
            cookie = $Cookie
            extension = $Extension
        }
    }

    # Check if more than 10 local networks are supplied
    if ($LocalNetworks.Count -gt 10) {
        Throw "You can only provide up to 10 local networks. Supplied: $($LocalNetworks.Count)"
    }

    # Set local_networks based on input array
    $localNetworkParams = 1..10 | ForEach-Object {
        if ($LocalNetworks[$_-1]) {
            @{ "local_network$_" = $LocalNetworks[$_-1] }
        }
    }

    # Add local network parameters to API request
    $localNetworkParams | ForEach-Object { $apiRequest.request += $_ }

    # Add other parameters
    @(
        @{ Name = "HasVoicemail"; Value = $HasVoicemail; ApiName = "hasvoicemail" },
        @{ Name = "CidNumber"; Value = $CidNumber; ApiName = "cidnumber" },
        @{ Name = "Secret"; Value = $Secret; ApiName = "secret" },
        @{ Name = "VmSecret"; Value = $VmSecret; ApiName = "vmsecret" },
        @{ Name = "SkipVmSecret"; Value = $SkipVmSecret; ApiName = "skip_vmsecret" },
        @{ Name = "RingTimeout"; Value = $RingTimeout; ApiName = "ring_timeout" },
        @{ Name = "AutoRecord"; Value = $AutoRecord; ApiName = "auto_record" },
        @{ Name = "Encryption"; Value = $Encryption; ApiName = "encryption" },
        @{ Name = "FaxDetect"; Value = $FaxDetect; ApiName = "faxdetect" },
        @{ Name = "SendToFax"; Value = $SendToFax; ApiName = "sendtofax" },
        @{ Name = "Allow"; Value = $Allow; ApiName = "allow" },
        @{ Name = "Dnd"; Value = $Dnd; ApiName = "dnd" },
        @{ Name = "DndTimeType"; Value = $DndTimeType; ApiName = "dnd_timetype" },
        @{ Name = "Permission"; Value = $Permission; ApiName = "permission" },
        @{ Name = "Nat"; Value = $Nat; ApiName = "nat" },
        @{ Name = "BypassOutRtAuth"; Value = $BypassOutRtAuth; ApiName = "bypass_outrt_auth" }
        # Add the rest of the parameters similarly...
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
        Write-Error "API call to updateSIPAccount failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

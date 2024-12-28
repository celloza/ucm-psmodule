<#
.SYNOPSIS
    Updates an existing analog trunk on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateAnalogTrunk" to update the configuration of an existing analog trunk.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the analog trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    This cookie must be passed in for every request to maintain the session's authentication. **(Mandatory)**

.PARAMETER TrunkIndex
    The index of the analog trunk to update.
    This uniquely identifies the analog trunk in the system. **(Mandatory)**

.PARAMETER TrunkName
    The name of the analog trunk.
    This is the descriptive name for the analog trunk, used to identify it in the system. **(Mandatory)**

.PARAMETER Chans
    The number of channels for the analog trunk. Range: `1-100`.
    Defines the number of analog lines or channels allocated to the trunk. **(Mandatory)**

.PARAMETER TrunkGroup
    The trunk group this analog trunk is associated with.
    This parameter defines which trunk group this trunk belongs to. **(Mandatory)**

.PARAMETER AutoRecord
    Whether to enable call recording for the trunk. Options: `yes`, `no`.
    If enabled, all calls routed through this trunk will be automatically recorded.

.PARAMETER Busy
    Whether to indicate a busy condition for the trunk. Options: `yes`, `no`.
    This determines if the trunk is considered "busy" and cannot take additional calls.

.PARAMETER Busydetect
    Whether to enable busy detection on the trunk. Options: `yes`, `no`.
    If enabled, the system will detect when a call is considered busy on the trunk.

.PARAMETER BusyCount
    The number of busy signals to detect before marking the trunk as busy. Range: `1-10`.
    This parameter defines how many busy signals must be detected before the trunk is marked as unavailable for new calls.

.PARAMETER Congestion
    Whether to enable congestion detection. Options: `yes`, `no`.
    If enabled, the system will detect if the trunk is congested and prevent further calls from being routed through it.

.PARAMETER CongestionCount
    The number of congestion signals to detect before marking the trunk as congested. Range: `1-10`.
    This parameter defines how many congestion signals need to be detected before the trunk is considered congested.

.PARAMETER CongestionDetect
    Whether to enable congestion detection on the trunk. Options: `yes`, `no`.
    This specifies if the system should monitor for congestion events on the trunk.

.PARAMETER CurrentDisconnectThreshold
    The current disconnect threshold in seconds. Range: `5-300`.
    Defines the amount of time (in seconds) the system will wait before disconnecting a call based on current settings.

.PARAMETER DahdiLineSelectMode
    The DAHDI line selection mode for the trunk.
    Defines how the DAHDI driver will select lines for this trunk, based on its configuration.

.PARAMETER EnableCurrentDisconnectThreshold
    Whether to enable the current disconnect threshold. Options: `yes`, `no`.
    If enabled, the system will use the current disconnect threshold to decide when to disconnect calls.

.PARAMETER FxoOutboundCallDialDelay
    The dial delay for FXO outbound calls in milliseconds.
    Specifies the amount of time to wait before attempting an outbound call when using the FXO port.

.PARAMETER FaxGateway
    Whether to use a fax gateway. Options: `yes`, `no`.
    If enabled, the system will route calls that detect fax tones to a fax gateway for processing.

.PARAMETER Lectype
    The type of line for the analog trunk. Options: `fxs`, `fxo`.
    Defines whether the trunk is configured as an FXS (Foreign Exchange Station) or FXO (Foreign Exchange Office) line.

.PARAMETER OutMaxChans
    The maximum number of outbound channels for the trunk.
    Specifies how many channels will be available for outbound calls on the trunk at any given time.

.PARAMETER OutOfService
    Whether the trunk is out of service. Options: `yes`, `no`.
    If enabled, the trunk is marked as unavailable, and calls will not be routed through this trunk.

.PARAMETER PolarityOnAnswer
    Whether to apply polarity on answer. Options: `yes`, `no`.
    If enabled, the trunk will apply polarity reversal once the call is answered.

.PARAMETER Delay
    The delay before the trunk starts routing calls. Range: `1-30` seconds.
    Specifies the amount of time (in seconds) the system will wait before routing calls through this trunk.

.PARAMETER PolaritySwitch
    Whether to switch polarity on the trunk. Options: `yes`, `no`.
    If enabled, the trunk will change polarity on call setup.

.PARAMETER RingTimeout
    The timeout duration for ringing the trunk before the call is redirected. Range: `10-60` seconds.
    Defines how long the system will ring the trunk for before moving the call to the next destination or failover.

.PARAMETER RxGain
    The receive gain for the trunk. Range: `1-10`.
    Specifies the gain level to be applied to incoming audio signals on the trunk.

.PARAMETER TrunkMode
    The mode for the trunk operation. Options: `normal`, `emergency`.
    Defines how the trunk operates during normal or emergency situations.

.PARAMETER TxGain
    The transmit gain for the trunk. Range: `1-10`.
    Specifies the gain level for outgoing audio signals from the trunk.

.PARAMETER UseCallerId
    Whether to use caller ID on the trunk. Options: `yes`, `no`.
    If enabled, the system will display the caller’s ID information on outgoing calls.

.PARAMETER CidSignaling
    The CID signaling method used by the trunk. Options: `bell`, `polarity`, etc.
    Defines the method for transmitting caller ID information over the trunk.

.PARAMETER CidMode
    The caller ID mode for the trunk. Options: `disable`, `enable`.
    If enabled, caller ID information will be transmitted when making calls over this trunk.

.EXAMPLE
    Set-UcmAnalogTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkIndex "1" -TrunkName "AnalogTrunk1" `
        -AutoRecord "yes" -Busy "no" -Busydetect "yes" -BusyCount 3 -Chans 4 -Congestion "no" `
        -CongestionCount 2 -CongestionDetect "yes" -CountryTone "us" -CurrentDisconnectThreshold 10 `
        -DahdiLineSelectMode "auto" -EnableCurrentDisconnectThreshold "yes" `
        -FxoOutboundCallDialDelay 500 -FaxGateway "yes" -Lectype "fxs" -OutMaxChans 10 `
        -OutOfService "no" -PolarityOnAnswer "yes" -Delay 3 -PolaritySwitch "yes" `
        -RingTimeout 30 -RxGain 5 -TrunkMode "normal" -TxGain 5 -UseCallerId "yes" `
        -TrunkGroup "group1" -CidSignaling "bell" -CidMode "enable"
        This example demonstrates how to configure an analog trunk with specific settings, including codec, failover, and CID.

#>
function Set-UcmAnalogTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$TrunkIndex,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter(Mandatory)][int]$Chans,
        [Parameter(Mandatory)][string]$TrunkGroup,
        [Parameter()][ValidateSet("yes", "no")][string]$AutoRecord,
        [Parameter()][ValidateSet("yes", "no")][string]$Busy,
        [Parameter()][ValidateSet("yes", "no")][string]$Busydetect,
        [Parameter()][int]$BusyCount,
        [Parameter()][ValidateSet("yes", "no")][string]$Congestion,
        [Parameter()][int]$CongestionCount,
        [Parameter()][ValidateSet("yes", "no")][string]$CongestionDetect,
        [Parameter()][string]$CountryTone,
        [Parameter()][ValidateRange(5, 300)]$CurrentDisconnectThreshold,
        [Parameter()][string]$DahdiLineSelectMode,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableCurrentDisconnectThreshold,
        [Parameter()][int]$FxoOutboundCallDialDelay,
        [Parameter()][ValidateSet("yes", "no")][string]$FaxGateway,
        [Parameter()][ValidateSet("fxs", "fxo")][string]$Lectype,
        [Parameter()][int]$OutMaxChans,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][ValidateSet("yes", "no")][string]$PolarityOnAnswer,
        [Parameter()][int]$Delay,
        [Parameter()][ValidateSet("yes", "no")][string]$PolaritySwitch,
        [Parameter()][ValidateRange(10, 60)]$RingTimeout,
        [Parameter()][ValidateRange(1, 10)]$RxGain,
        [Parameter()][ValidateSet("normal", "emergency")][string]$TrunkMode,
        [Parameter()][ValidateRange(1, 10)]$TxGain,
        [Parameter()][ValidateSet("yes", "no")][string]$UseCallerId,
        [Parameter()][string]$CidSignaling,
        [Parameter()][ValidateSet("disable", "enable")][string]$CidMode
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateAnalogTrunk"
            cookie = $Cookie
            trunk_name = $TrunkName
            trunk_index = $TrunkIndex
        }
    }

    # Add optional parameters
    @(
        @{ Name = "AutoRecord"; Value = $AutoRecord; ApiName = "auto_record" },
        @{ Name = "Busy"; Value = $Busy; ApiName = "busy" },
        @{ Name = "Busydetect"; Value = $Busydetect; ApiName = "busydetect" },
        @{ Name = "BusyCount"; Value = $BusyCount; ApiName = "busycount" },
        @{ Name = "Congestion"; Value = $Congestion; ApiName = "congestion" },
        @{ Name = "CongestionCount"; Value = $CongestionCount; ApiName = "congestioncount" },
        @{ Name = "CongestionDetect"; Value = $CongestionDetect; ApiName = "congestiondetect" },
        @{ Name = "CountryTone"; Value = $CountryTone; ApiName = "countrytone" },
        @{ Name = "CurrentDisconnectThreshold"; Value = $CurrentDisconnectThreshold; ApiName = "currentdisconnectthreshold" },
        @{ Name = "DahdiLineSelectMode"; Value = $DahdiLineSelectMode; ApiName = "dahdilineselectmode" },
        @{ Name = "EnableCurrentDisconnectThreshold"; Value = $EnableCurrentDisconnectThreshold; ApiName = "enablecurrentdisconnectthreshold" },
        @{ Name = "FxoOutboundCallDialDelay"; Value = $FxoOutboundCallDialDelay; ApiName = "fxooutboundcalldialdelay" },
        @{ Name = "FaxGateway"; Value = $FaxGateway; ApiName = "fax_gateway" },
        @{ Name = "Lectype"; Value = $Lectype; ApiName = "lectype" },
        @{ Name = "OutMaxChans"; Value = $OutMaxChans; ApiName = "out_maxchans" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "PolarityOnAnswer"; Value = $PolarityOnAnswer; ApiName = "polarityonanswer" },
        @{ Name = "Delay"; Value = $Delay; ApiName = "delay" },
        @{ Name = "PolaritySwitch"; Value = $PolaritySwitch; ApiName = "polarityswitch" },
        @{ Name = "RingTimeout"; Value = $RingTimeout; ApiName = "ringtimeout" },
        @{ Name = "RxGain"; Value = $RxGain; ApiName = "rxgain" },
        @{ Name = "TrunkMode"; Value = $TrunkMode; ApiName = "trunkmode" },
        @{ Name = "TxGain"; Value = $TxGain; ApiName = "txgain" },
        @{ Name = "UseCallerId"; Value = $UseCallerId; ApiName = "usecallerid" },
        @{ Name = "CidSignaling"; Value = $CidSignaling; ApiName = "cidsignaling" },
        @{ Name = "CidMode"; Value = $CidMode; ApiName = "cidmode" }
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
        Write-Error "API call to updateAnalogTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

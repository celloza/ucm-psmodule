<#
.SYNOPSIS
    Adds a new analog trunk to the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "addAnalogTrunk" to create a new analog trunk configuration.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the analog trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkName
    The name of the analog trunk to be added. **(Mandatory)**

.PARAMETER AutoRecord
    Whether to enable auto-recording on the trunk. Options: `yes`, `no`.

.PARAMETER Busy
    Whether to enable the busy signal on the trunk. Options: `yes`, `no`.

.PARAMETER BusyDetect
    Whether to enable busy detection on the trunk. Options: `yes`, `no`.

.PARAMETER BusyCount
    The number of busy signals to detect before marking the trunk as busy.

.PARAMETER Chans
    The number of channels (ports) for the analog trunk. **(Mandatory)**

.PARAMETER Congestion
    Whether to enable congestion detection. Options: `yes`, `no`.

.PARAMETER CongestionCount
    The number of congestion signals to detect before marking the trunk as congested.

.PARAMETER CongestionDetect
    Whether to enable congestion detection. Options: `yes`, `no`.

.PARAMETER CountryTone
    The country-specific tone to use. Used to customize the tone behavior for the trunk.

.PARAMETER CurrentDisconnectThreshold
    The current disconnect threshold in milliseconds. Range: `50-3000`.

.PARAMETER DahdiLineSelectMode
    The DAHDI line selection mode. Options: `ascend`, `poll`, `descend`.

.PARAMETER DialInDirect
    Whether to allow dial-in direct. Options: `yes`, `no`.

.PARAMETER EnableCurrentDisconnectThreshold
    Whether to enable the current disconnect threshold. Options: `yes`, `no`.

.PARAMETER FxoOutbandCallDialDelay
    The FXO outbound call dial delay in milliseconds. Range: `0-3000`.

.PARAMETER FaxGateway
    Whether to set the FXO mode to fax gateway. Options: `yes`, `no`.

.PARAMETER Lectype
    The type of line for the analog trunk. Options: `fxs`, `fxo`.

.PARAMETER OutMaxChans
    The maximum number of channels for outbound calls. 

.PARAMETER OutOfService
    Whether the trunk is out of service. Options: `yes`, `no`.

.PARAMETER PolarityOnAnswer
    Whether polarity is applied on answer. Options: `yes`, `no`.

.PARAMETER PolaritySwitch
    Whether to apply polarity switch on call setup. Options: `yes`, `no`.

.PARAMETER RingTimeout
    The timeout for ringing the trunk before call routing. Range: `1000-30000` milliseconds.

.PARAMETER RxGain
    The receive gain value. Range: `-13` to `12`.

.PARAMETER TrunkMode
    The trunk mode. Options: `normal`, `emergency`.

.PARAMETER TxGain
    The transmit gain value. Range: `-13` to `12`.

.PARAMETER UseCallerId
    Whether to enable caller ID on the trunk. Options: `yes`, `no`.

.PARAMETER TrunkGroup
    The group to which the trunk belongs.

.PARAMETER CidSignaling
    The CID signaling method. Options include `bell`, `polarity`, etc.

.PARAMETER CidMode
    The CID mode. Options: `disable`, `enable`.

.EXAMPLE
    New-UcmAnalogTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkName "AnalogTrunk1" `
        -AutoRecord "yes" -Busy "no" -BusyDetect "yes" -BusyCount 3 -Chans 4 -Congestion "no" `
        -CongestionCount 2 -CongestionDetect "yes" -CountryTone "us" -CurrentDisconnectThreshold 200 `
        -DahdiLineSelectMode "ascend" -DialInDirect "no" -EnableCurrentDisconnectThreshold "yes" `
        -FxoOutbandCallDialDelay 0 -FaxGateway "no" -Lectype "fxs" -OutMaxChans 10 -OutOfService "no" `
        -PolarityOnAnswer "yes" -PolaritySwitch "no" -RingTimeout 10000 -RxGain 0 -TrunkMode "normal" `
        -TxGain 0 -UseCallerId "yes" -TrunkGroup "group1" -CidSignaling "bell" -CidMode "enable"
        This example demonstrates how to add a new analog trunk with the specified settings.

#>
function New-UcmAnalogTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter(Mandatory)][int]$Chans,
        [Parameter()][ValidateSet("yes", "no")][string]$AutoRecord,
        [Parameter()][ValidateSet("yes", "no")][string]$Busy,
        [Parameter()][ValidateSet("yes", "no")][string]$BusyDetect,
        [Parameter()][int]$BusyCount,
        [Parameter()][ValidateSet("yes", "no")][string]$Congestion,
        [Parameter()][int]$CongestionCount,
        [Parameter()][ValidateSet("yes", "no")][string]$CongestionDetect,
        [Parameter()][string]$CountryTone,
        [Parameter()][ValidateRange(50, 3000)]$CurrentDisconnectThreshold,
        [Parameter()][ValidateSet("ascend", "poll", "descend")][string]$DahdiLineSelectMode,
        [Parameter()][ValidateSet("yes", "no")][string]$DialInDirect,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableCurrentDisconnectThreshold,
        [Parameter()][int]$FxoOutbandCallDialDelay,
        [Parameter()][ValidateSet("yes", "no")][string]$FaxGateway,
        [Parameter()][ValidateSet("fxs", "fxo")][string]$Lectype,
        [Parameter()][int]$OutMaxChans,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][ValidateSet("yes", "no")][string]$PolarityOnAnswer,
        [Parameter()][ValidateSet("yes", "no")][string]$PolaritySwitch,
        [Parameter()][ValidateRange(1000, 30000)]$RingTimeout,
        [Parameter()][ValidateRange(-13, 12)]$RxGain,
        [Parameter()][ValidateSet("normal", "emergency")][string]$TrunkMode,
        [Parameter()][ValidateRange(-13, 12)]$TxGain,
        [Parameter()][ValidateSet("yes", "no")][string]$UseCallerId,
        [Parameter()][string]$TrunkGroup,
        [Parameter()][string]$CidSignaling,
        [Parameter()][ValidateSet("disable", "enable")][string]$CidMode
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "addAnalogTrunk"
            cookie = $Cookie
            trunk_name = $TrunkName
            chans = $Chans
        }
    }

    # Add optional parameters
    @(
        @{ Name = "AutoRecord"; Value = $AutoRecord; ApiName = "auto_record" },
        @{ Name = "Busy"; Value = $Busy; ApiName = "busy" },
        @{ Name = "BusyDetect"; Value = $BusyDetect; ApiName = "busydetect" },
        @{ Name = "BusyCount"; Value = $BusyCount; ApiName = "busycount" },
        @{ Name = "Congestion"; Value = $Congestion; ApiName = "congestion" },
        @{ Name = "CongestionCount"; Value = $CongestionCount; ApiName = "congestioncount" },
        @{ Name = "CongestionDetect"; Value = $CongestionDetect; ApiName = "congestiondetect" },
        @{ Name = "CountryTone"; Value = $CountryTone; ApiName = "countrytone" },
        @{ Name = "CurrentDisconnectThreshold"; Value = $CurrentDisconnectThreshold; ApiName = "currentdisconnectthreshold" },
        @{ Name = "DahdiLineSelectMode"; Value = $DahdiLineSelectMode; ApiName = "dahdilineselectmode" },
        @{ Name = "DialInDirect"; Value = $DialInDirect; ApiName = "dialin_direct" },
        @{ Name = "EnableCurrentDisconnectThreshold"; Value = $EnableCurrentDisconnectThreshold; ApiName = "enablecurrentdisconnectthreshold" },
        @{ Name = "FxoOutbandCallDialDelay"; Value = $FxoOutbandCallDialDelay; ApiName = "fxooutbandcalldialdelay" },
        @{ Name = "FaxGateway"; Value = $FaxGateway; ApiName = "fax_gateway" },
        @{ Name = "Lectype"; Value = $Lectype; ApiName = "lectype" },
        @{ Name = "OutMaxChans"; Value = $OutMaxChans; ApiName = "out_maxchans" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "PolarityOnAnswer"; Value = $PolarityOnAnswer; ApiName = "polarityonanswer" },
        @{ Name = "PolaritySwitch"; Value = $PolaritySwitch; ApiName = "polarityswitch" },
        @{ Name = "RingTimeout"; Value = $RingTimeout; ApiName = "ringtimeout" },
        @{ Name = "RxGain"; Value = $RxGain; ApiName = "rxgain" },
        @{ Name = "TrunkMode"; Value = $TrunkMode; ApiName = "trunkmode" },
        @{ Name = "TxGain"; Value = $TxGain; ApiName = "txgain" },
        @{ Name = "UseCallerId"; Value = $UseCallerId; ApiName = "usecallerid" },
        @{ Name = "TrunkGroup"; Value = $TrunkGroup; ApiName = "trunkgroup" },
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
        Write-Error "API call to addAnalogTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

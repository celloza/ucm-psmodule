﻿<#
.SYNOPSIS
    Updates an existing digital trunk on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateDigitalTrunk" to update the configuration of an existing digital trunk.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API for configuring the digital trunk.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. **(Mandatory)**

.PARAMETER TrunkId
    The unique identifier of the digital trunk to update. **(Mandatory)**

.PARAMETER TrunkName
    The name of the digital trunk to update. **(Mandatory)**

.PARAMETER GroupIndex
    The index of the group to which the trunk belongs. Options: `Yes`, `No`.
    This parameter defines the group index for the trunk. **(Optional)**

.PARAMETER HideCallerId
    Whether to hide the caller ID on the trunk. Options: `yes`, `no`.
    If enabled, the caller ID information will not be displayed when the trunk is used. **(Optional)**

.PARAMETER KeepCallerId
    Whether to keep the caller ID on the trunk. Options: `yes`, `no`.
    If enabled, the caller ID information will be retained when the trunk is used. **(Optional)**

.PARAMETER CallerId
    The caller ID to be associated with the trunk.
    This specifies the caller ID number that will be used for outgoing calls on this trunk. **(Optional)**

.PARAMETER CallerIdName
    The name to be associated with the caller ID.
    This specifies the caller name that will be displayed for outgoing calls on this trunk. **(Optional)**

.PARAMETER AutoRecording
    Whether to enable automatic recording for calls made through this trunk. Options: `yes`, `no`.
    If enabled, all calls made through this trunk will be recorded automatically. **(Optional)**

.PARAMETER DahdiLineSelectMode
    The DAHDI line selection mode. Options: `ascend`, `poll`, `descend`.
    This parameter defines how the DAHDI driver will select the lines for the trunk. **(Optional)**

.PARAMETER DialInDirect
    Whether direct dialing is enabled for the trunk. Options: `yes`, `no`.
    If enabled, the trunk will support direct dialing without routing through additional systems. **(Optional)**

.EXAMPLE
    Update-UcmDigitalTrunk -Uri http://10.10.10.1/api -Cookie $cookie -TrunkId 1 -TrunkName "DigitalTrunk1" `
        -GroupIndex "Yes" -HideCallerId "no" -KeepCallerId "yes" -CallerId "1001" -CallerIdName "Support" `
        -AutoRecording "yes" -DahdiLineSelectMode "ascend" -DialInDirect "yes"
    This example demonstrates how to update the configuration of a digital trunk with ID 1. The trunk's name is set to "DigitalTrunk1" and the following settings are applied:
    - Group index is enabled.
    - Caller ID is retained and shown for outgoing calls.
    - Automatic recording is enabled for all calls.
    - DAHDI line selection mode is set to "ascend".
    - Direct dialing is enabled for this trunk.
#>
function Set-UcmDigitalTrunk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][int]$TrunkId,
        [Parameter(Mandatory)][string]$TrunkName,
        [Parameter()][ValidateSet("Yes", "No")][string]$GroupIndex,
        [Parameter()][ValidateSet("yes", "no")][string]$HideCallerId,
        [Parameter()][ValidateSet("yes", "no")][string]$KeepCallerId,
        [Parameter()][string]$CallerId,
        [Parameter()][string]$CallerIdName,
        [Parameter()][ValidateSet("yes", "no")][string]$AutoRecording,
        [Parameter()][ValidateSet("ascend", "poll", "descend")][string]$DahdiLineSelectMode,
        [Parameter()][ValidateSet("yes", "no")][string]$DialInDirect
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateDigitalTrunk"
            cookie = $Cookie
            trunk = $TrunkId
            trunk_name = $TrunkName
        }
    }

    # Add optional parameters
    @(
        @{ Name = "GroupIndex"; Value = $GroupIndex; ApiName = "group_index" },
        @{ Name = "HideCallerId"; Value = $HideCallerId; ApiName = "hidecallerid" },
        @{ Name = "KeepCallerId"; Value = $KeepCallerId; ApiName = "keepcid" },
        @{ Name = "CallerId"; Value = $CallerId; ApiName = "callerid" },
        @{ Name = "CallerIdName"; Value = $CallerIdName; ApiName = "cidname" },
        @{ Name = "AutoRecording"; Value = $AutoRecording; ApiName = "auto_recording" },
        @{ Name = "DahdiLineSelectMode"; Value = $DahdiLineSelectMode; ApiName = "dahdilineselectmode" },
        @{ Name = "DialInDirect"; Value = $DialInDirect; ApiName = "dialin_direct" }
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
        Write-Error "API call to updateDigitalTrunk failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
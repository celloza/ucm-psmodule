<#
.SYNOPSIS
    Updates an IVR on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateIVR" to update the configuration of an existing IVR.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API where the IVR configurations will be updated.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    This cookie must be passed in for every request to ensure the session remains authenticated.

.PARAMETER IvrId
    The ID of the IVR to update.
    This parameter specifies the unique identifier of the IVR configuration to modify.

.PARAMETER IvrName
    The name of the IVR.
    This is a descriptive name for the IVR that will help administrators easily identify it.

.PARAMETER IvrType
    The type of IVR. Options: `simple`, `advanced`.
    - `simple`: Basic IVR setup where a caller interacts with simple prompts and options.
    - `advanced`: More complex IVR setup with multiple layers and dynamic options based on input.

.PARAMETER WelcomePrompt
    The welcome prompt to play to the caller.
    This specifies the audio prompt file (in .wav or other supported format) to play when a caller first enters the IVR.

.PARAMETER Timeout
    Timeout duration in seconds for the IVR menu.
    This defines how long the IVR will wait for input from the caller before playing a timeout message or redirecting them to a different destination.

.PARAMETER TimeoutDest
    The destination for a timeout action.
    Specifies where the call should go if the caller doesn't make a selection within the timeout duration. Options might include an agent group, voicemail, or an external number.

.PARAMETER InvalidDest
    The destination for invalid input.
    If a caller enters an invalid option, this specifies where the call should be routed, such as a fallback menu or an error message.

.PARAMETER RetryCount
    The number of retry attempts for invalid input.
    Defines how many times the IVR will ask for input again after an invalid selection before redirecting to the `InvalidDest`.

.PARAMETER TimeoutDestType
    The type of destination for timeout actions. Options: `account`, `voicemail`, `queue`, `ivr`, `external_number`.
    This determines the type of destination (such as voicemail or an external number) where the call will be routed if the caller does not respond within the timeout period.

.PARAMETER InvalidDestType
    The type of destination for invalid input. Options: `account`, `voicemail`, `queue`, `ivr`, `external_number`.
    This defines the destination type where the call will be directed if the caller makes an invalid input, such as an incorrect key press.

.PARAMETER ExitDest
    The destination when the caller exits the IVR.
    Specifies the destination for the call after the caller successfully completes the IVR interaction (e.g., an agent, voicemail, or another IVR).

.PARAMETER ExitDestType
    The type of destination when the IVR ends. Options: `account`, `voicemail`, `queue`, `ivr`, `external_number`.
    Defines the type of destination where the call should be routed when the IVR session is completed.

.PARAMETER MaxRetries
    Maximum number of retries for invalid or timeout input.
    Specifies how many times the system will allow the caller to retry before taking an alternate action, such as disconnecting the call or routing to another destination.

.PARAMETER AnnouncementMessage
    The announcement message to be played before the main IVR options.
    Defines an introductory message (e.g., “Thank you for calling, please select an option”) that plays before the caller selects an option.

.PARAMETER Language
    The language for the IVR prompts. Options: `en`, `es`, `fr`, etc.
    Specifies the language used for all prompts within the IVR. This ensures the IVR is tailored to the caller's preferred language.

.PARAMETER MaxTime
    The maximum time allowed for an IVR interaction.
    Defines the time limit for an IVR session before the system terminates the call or redirects it to another destination.

.PARAMETER CustomPrompt
    Custom prompt audio file for the IVR.
    Specifies a custom audio file that will be played as part of the IVR interaction, such as a personalized greeting or special message.

.PARAMETER EnableFeature
    Whether to enable the IVR feature. Options: `yes`, `no`.
    If set to `yes`, the IVR feature is active, and calls can be routed through it. If set to `no`, the IVR is disabled.

.PARAMETER IvrMenu
    The menu options for the IVR.
    This defines the menu options available for the caller to choose from. Typically, it consists of a list of keypress options, such as “Press 1 for Sales, Press 2 for Support.”

.PARAMETER IvrOption
    The action associated with each menu option.
    Defines what happens when a caller selects an option from the IVR menu, such as routing to a specific department or voicemail.

.PARAMETER IvrOptionType
    The type of action associated with the IVR option. Options: `route`, `voicemail`, `ivr`, `external_number`.
    Defines the type of action that occurs when the caller selects a menu option. This could be routing to a different queue, sending the call to voicemail, or transferring to another IVR.

.PARAMETER IvrRetryDest
    The destination to retry if the caller selects an invalid option.
    If the caller presses an invalid option, this destination determines where the system will redirect them for a retry (such as back to the main menu or to an error message).

.PARAMETER AlertInfo
    (Optional) Alert info for incoming calls. Options include `none`, `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, `ring6`, `ring7`, `ring8`, `ring9`, `ring10`, `Bellcore-dr1`, `Bellcore-dr2`, `Bellcore-dr3`, `Bellcore-dr4`, `Bellcore-dr5`, and `custom`.
    Specifies the ring pattern or alert tone for calls routed through this inbound route.

.EXAMPLE
    Set-UcmIvr -Uri http://10.10.10.1/api -Cookie $cookie -IvrId "1" -IvrName "Main Menu" `
        -IvrType "advanced" -WelcomePrompt "welcome.wav" -Timeout 30 -TimeoutDest "voicemail" `
        -InvalidDest "ivr" -RetryCount 3 -TimeoutDestType "voicemail" -InvalidDestType "ivr" `
        -ExitDest "queue" -ExitDestType "queue" -MaxRetries 3 -AnnouncementMessage "Thank you for calling!" `
        -Language "en" -MaxTime 600 -CustomPrompt "custom_prompt.wav" -EnableFeature "yes" `
        -IvrMenu "1=Sales,2=Support,3=Emergency" -IvrOption "1=SalesQueue,2=SupportQueue,3=EmergencyLine" `
        -IvrOptionType "route" -IvrRetryDest "mainmenu"
    This example demonstrates how to configure an advanced IVR setup with specific timeout, retry, and routing options for sales, support, and emergency calls.
#>
function Set-UcmIVR {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$IVRNumber,
        [Parameter(Mandatory)][string]$IVRName,
        [Parameter(Mandatory)][string]$Extension,
        [Parameter()][string]$WelcomePrompt,
        [Parameter()][int]$ResponseTimeout,
        [Parameter()][int]$DigitTimeout,
        [Parameter()][string]$TimeoutPrompt,
        [Parameter()][string]$InvalidPrompt,
        [Parameter()][int]$TimeoutRepeats,
        [Parameter()][int]$InvalidInputRepeats,
        [Parameter()][ValidateSet("internal", "local", "national", "international")][string]$Permission,
        [Parameter()][ValidateSet("yes", "no")][string]$ReplaceCallerID,
        [Parameter()][string]$AlertInfo,
        [Parameter()][ValidateSet("yes", "no")][string]$DialExtensions,
        [Parameter()][ValidateSet("yes", "no")][string]$DialTrunk
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateIVR"
            cookie = $Cookie
            ivr = $IVRNumber
            ivr_name = $IVRName
            extension = $Extension
        }
    }

    # Add optional parameters dynamically
    @(
        @{ Name = "WelcomePrompt"; Value = $WelcomePrompt; ApiName = "welcome_prompt" },
        @{ Name = "ResponseTimeout"; Value = $ResponseTimeout; ApiName = "response_timeout" },
        @{ Name = "DigitTimeout"; Value = $DigitTimeout; ApiName = "digit_timeout" },
        @{ Name = "TimeoutPrompt"; Value = $TimeoutPrompt; ApiName = "timeout_prompt" },
        @{ Name = "InvalidPrompt"; Value = $InvalidPrompt; ApiName = "invalid_prompt" },
        @{ Name = "TimeoutRepeats"; Value = $TimeoutRepeats; ApiName = "tloop" },
        @{ Name = "InvalidInputRepeats"; Value = $InvalidInputRepeats; ApiName = "iloop" },
        @{ Name = "Permission"; Value = $Permission; ApiName = "permission" },
        @{ Name = "ReplaceCallerID"; Value = $ReplaceCallerID; ApiName = "replace_caller_id" },
        @{ Name = "AlertInfo"; Value = $AlertInfo; ApiName = "alertinfo" },
        @{ Name = "DialExtensions"; Value = $DialExtensions; ApiName = "dial_extension" },
        @{ Name = "DialTrunk"; Value = $DialTrunk; ApiName = "dial_trunk" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
            Write-Verbose "$($_.Name): $($_.Value)"
            $apiRequest.request[$_.ApiName] = $_.Value
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
        Write-Error "API call to updateIVR failed. Status code: $($responseContent.status). Error: $errorDescription"
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}
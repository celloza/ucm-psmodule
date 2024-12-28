<#
.SYNOPSIS
    Updates an outbound route on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateOutboundRoute" to update the configuration of an existing outbound route.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This URI is used to access the UCM API where the outbound route configurations will be updated.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    This cookie must be passed in for every request after a successful login to authenticate the session.

.PARAMETER RouteId
    The ID of the outbound route to update.
    This parameter specifies the identifier of the outbound route you wish to modify.

.PARAMETER RouteName
    The name of the outbound route.
    This specifies a descriptive name for the outbound route. The name helps users and administrators to easily identify the route.

.PARAMETER DialPatterns
    List of dial patterns for this outbound route.
    This parameter defines the dialing patterns that are used to match numbers for routing. Multiple dial patterns can be provided, typically in the form of a regular expression.

.PARAMETER RouteType
    The type of outbound route. Options: `normal`, `emergency`.
    - `normal`: Standard outbound calls routed through this route.
    - `emergency`: Special route for emergency calls that may have higher priority.

.PARAMETER TrunkIds
    List of trunk IDs to use for this outbound route.
    Specifies which trunks (identified by their IDs) are used for this outbound route. Multiple trunks can be assigned to a route for redundancy or load balancing.

.PARAMETER ForceRoute
    Whether to force the route to be used. Options: `yes`, `no`.
    If set to `yes`, this option forces the system to always use the selected trunks for the route, overriding other routing logic.

.PARAMETER RoutePriority
    The priority of the outbound route. Range: `1-10`.
    This sets the priority for the outbound route. A lower value indicates a higher priority.

.PARAMETER StripDigits
    The number of digits to strip from the dialed number before sending it to the trunk.
    This is useful for cases where the dialed number needs to be modified (e.g., stripping country codes or area codes).

.PARAMETER AddPrefix
    The prefix to add to the dialed number.
    This allows you to prepend a specific string or number to the dialed number, often used to indicate the route (e.g., adding a prefix for a specific area code or provider).

.PARAMETER MaxCallDuration
    The maximum duration of a call in seconds.
    This sets a limit on how long a call can last before being automatically disconnected. Helps in preventing excessively long calls that might tie up trunk resources.

.PARAMETER FailoverDestination
    The failover destination for the route.
    This defines the fallback destination in case the primary route fails or is unavailable. It can be another trunk, voicemail, or another route.

.PARAMETER CallLimit
    The maximum number of concurrent calls allowed on the route.
    This parameter helps in controlling the maximum load on a route by limiting the number of simultaneous calls allowed. Exceeding this limit may route calls to failover destinations.

.PARAMETER PriorityGroup
    The priority group for the outbound route. Options: `low`, `medium`, `high`.
    Defines the priority level for this route compared to others. Routes with higher priority are preferred when multiple routes could match.

.PARAMETER EnableFeature
    Whether to enable the outbound route feature. Options: `yes`, `no`.
    This determines whether the route is enabled and active. If set to `no`, the route will be disabled and not used for routing calls.

.PARAMETER AlertInfo
    The alert-info header to send with outbound calls. Options: `none`, `ring1`, `ring2`, `ring3`, `ring4`, `ring5`, etc.
    Specifies the alerting behavior for the outbound calls. This header allows you to customize the type of ring or alert the calling party will hear.

.PARAMETER TrunkFailover
    Whether to enable trunk failover. Options: `yes`, `no`.
    If enabled, calls that fail on one trunk will automatically be redirected to a secondary trunk as defined by the `FailoverDestination` parameter.

.PARAMETER UseCodec
    Whether to use a specific codec for the route. Options: `yes`, `no`.
    If enabled, the system will prioritize using the specified codec(s) for calls routed through this outbound route. If `no`, codec selection is left to the trunk configuration.

.EXAMPLE
    Set-UcmOutboundRoute -Uri http://10.10.10.1/api -Cookie $cookie -RouteId 101 -RouteName "SalesCalls" `
        -DialPatterns "9XXXXXXXXXX" -RouteType "normal" -TrunkIds "1,2" -ForceRoute "no" `
        -RoutePriority 1 -StripDigits 1 -AddPrefix "1" -MaxCallDuration 1800 `
        -FailoverDestination "voicemail" -CallLimit 10 -PriorityGroup "high" `
        -EnableFeature "yes" -AlertInfo "ring1" -TrunkFailover "yes" -UseCodec "yes"
    This example demonstrates how to configure an outbound route for sales calls with specific trunks, priorities, and failover destinations.
#>
function Set-UcmOutboundRoute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$RouteName,
        [Parameter(Mandatory)][string]$RouteId,
        [Parameter()][ValidateSet("none", "internal", "local", "national", "international")][string]$Permission,
        [Parameter()][string]$DefaultTrunkIndex,
        [Parameter()][array]$Patterns,
        [Parameter()][ValidateSet("yes", "no")][string]$OutOfService,
        [Parameter()][string]$Password,
        [Parameter()][int]$Strip,
        [Parameter()][string]$Prepend,
        [Parameter()][ValidateSet("yes", "no")][string]$EnableWhitelist,
        [Parameter()][string]$Members
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateOutboundRoute"
            cookie = $Cookie
            outbound_rt_name = $RouteName
            outbound_rt_index = $RouteId
        }
    }

    # Add optional parameters and verbose logging
    @(
        @{ Name = "Permission"; Value = $Permission; ApiName = "permission" },
        @{ Name = "DefaultTrunkIndex"; Value = $DefaultTrunkIndex; ApiName = "default_trunk_index" },
        @{ Name = "Patterns"; Value = $Patterns; ApiName = "pattern" },
        @{ Name = "OutOfService"; Value = $OutOfService; ApiName = "out_of_service" },
        @{ Name = "Password"; Value = $Password; ApiName = "password" },
        @{ Name = "Strip"; Value = $Strip; ApiName = "strip" },
        @{ Name = "Prepend"; Value = $Prepend; ApiName = "prepend" },
        @{ Name = "EnableWhitelist"; Value = $EnableWhitelist; ApiName = "enable_wlist" },
        @{ Name = "Members"; Value = $Members; ApiName = "members" }
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
        Write-Error "API call to updateOutboundRoute failed. Status code: $($responseContent.status). Error: $errorDescription"
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

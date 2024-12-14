<#
    .SYNOPSIS
        Invokes a dial through the UCM API.
    
    .DESCRIPTION
        This cmdlet invokes the API action "dialExtension" from the specified Caller's
        extension to the specified Callee's extension.
    
    .PARAMETER Uri
        The full URI (including the protocol) to the UCM API, i.e. http://10.10.10.1:80/api.

    .PARAMETER CallerExtension
        The extension number for the call originator.

    .PARAMETER CalleeExtension
        The extension number for the call destination.

    .PARAMETER Cookie
        A valid authentication cookie.
#>
function Invoke-UcmDialExtension {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$CallerExtension,
        [Parameter(Mandatory)]
        [string]$CalleeExtension,
        [Parameter(Mandatory)]
        [string]$Cookie
    )

    Write-Verbose "Caller Extension: $CallerExtension"
    Write-Verbose "Callee Extension: $CalleeExtension"

    $dialExtensionRequest = @{
        request = @{
            "action" = "dialExtension"
            "callee" = $CalleeExtension
            "caller" = $CallerExtension
            "cookie" = $Cookie
        }
    }

    Write-Verbose "Request: $(ConvertTo-Json $dialExtensionRequest)"
    
    $dialExtensionResponse = Invoke-WebRequest -Method POST -ContentType "application/json;charset=UTF-8" `
        -Headers $headers -Body (ConvertTo-JSON $dialExtensionRequest) -Uri $Uri -DisableKeepAlive -SkipCertificateCheck

    Write-Verbose "Response: $dialExtensionResponse"

    if((ConvertFrom-Json $dialExtensionResponse.content).status -ne 0)
    {
        Write-Error "Could not dial extension $CalleeExtension. Status code was $((ConvertFrom-Json $dialExtensionResponse.content).status)."
    }
    else
    {
        Write-Output "Success."
    }
}
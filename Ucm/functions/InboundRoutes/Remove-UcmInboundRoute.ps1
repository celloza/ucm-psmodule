<#
.SYNOPSIS
    Deletes an existing inbound route on the UCM system.

.DESCRIPTION
    This cmdlet invokes the API action "deleteInboundRoute" to delete a specific inbound route on the UCM system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.
    All requests must include this value. If no cookie is included, error code -6 will be returned.

.PARAMETER InboundRoute
    The ID of the inbound route to be deleted.
    This parameter specifies which inbound route configuration to delete from the system.

.EXAMPLE
    Remove-UcmInboundRoute -Uri http://10.10.10.1/api -Cookie $cookie -InboundRoute "3"
#>
function Remove-UcmInboundRoute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$InboundRoute
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "deleteInboundRoute"
            cookie = $Cookie
            inbound_route = $InboundRoute
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
        Write-Error "API call to deleteInboundRoute failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        Write-Host "Inbound route $InboundRoute has been successfully deleted."
    }
}

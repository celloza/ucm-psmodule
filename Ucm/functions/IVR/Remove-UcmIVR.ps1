<#
.SYNOPSIS
    Deletes an existing IVR on the UCM system.

.DESCRIPTION
    This cmdlet invokes the API action "deleteIVR" to delete a specific IVR (Interactive Voice Response) system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request. 
    **(Mandatory)** This cookie is required for authentication, and if not provided, an error code -6 will be returned.

.PARAMETER Ivr
    The ID of the IVR to be deleted. **(Mandatory)**
    This parameter specifies which IVR configuration to delete. The IVR ID is not an extension number but a unique identifier for the IVR.

.EXAMPLE
    Remove-UcmIVR -Uri http://10.10.10.1/api -Cookie $cookie -Ivr "ivr-1"
#>
function Remove-UcmIVR {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$Ivr
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "deleteIVR"
            cookie = $Cookie
            ivr = $Ivr
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
        Write-Error "API call to deleteIVR failed. Status code: $($responseContent.status)."
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

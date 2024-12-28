<#
.SYNOPSIS
    Updates a user on the UCM API.

.DESCRIPTION
    This cmdlet invokes the API action "updateUser" to update user details in the UCM system.

.PARAMETER Uri
    The full URI (including the protocol) to the UCM API, e.g., http://10.10.10.1:80/api.
    This is the base URL used to access the UCM API.

.PARAMETER Cookie
    The session cookie obtained from the login process. Used to authenticate the API request.

.PARAMETER UserName
    The username of the user to update.
    This is a mandatory parameter that identifies the user to be updated.

.PARAMETER UserId
    The ID of the user. If not provided, the username will be used for identification.

.PARAMETER FirstName
    The first name of the user.

.PARAMETER LastName
    The last name of the user.

.PARAMETER Department
    The department that the user belongs to.

.PARAMETER Email
    The email address of the user.

.PARAMETER PhoneNumber
    The phone number of the user.

.PARAMETER FamilyNumber
    The family number of the user.

.PARAMETER Fax
    The fax number of the user.

.EXAMPLE
    Set-UcmUser -Uri http://10.10.10.1/api -Cookie $cookie -UserName "jdoe" `
        -FirstName "John" -LastName "Doe" -Email "jdoe@example.com"
    Updates the user "jdoe" with new details such as first name, last name, and email.

.NOTES
    All requests must include a valid cookie obtained after logging in.
#>
function Set-UcmUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Cookie,
        [Parameter(Mandatory)][string]$UserName,
        [Parameter()][int]$UserId,
        [Parameter()][string]$FirstName,
        [Parameter()][string]$LastName,
        [Parameter()][string]$Department,
        [Parameter()][string]$Email,
        [Parameter()][string]$PhoneNumber,
        [Parameter()][string]$FamilyNumber,
        [Parameter()][string]$Fax
    )

    # Initialize API request
    $apiRequest = @{
        request = @{
            action = "updateUser"
            cookie = $Cookie
            user_name = $UserName
        }
    }

    # Add optional parameters
    @(
        @{ Name = "UserId"; Value = $UserId; ApiName = "user_id" },
        @{ Name = "FirstName"; Value = $FirstName; ApiName = "first_name" },
        @{ Name = "LastName"; Value = $LastName; ApiName = "last_name" },
        @{ Name = "Department"; Value = $Department; ApiName = "department" },
        @{ Name = "Email"; Value = $Email; ApiName = "email" },
        @{ Name = "PhoneNumber"; Value = $PhoneNumber; ApiName = "phone_number" },
        @{ Name = "FamilyNumber"; Value = $FamilyNumber; ApiName = "family_number" },
        @{ Name = "Fax"; Value = $Fax; ApiName = "fax" }
    ) | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_.Name)) {
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
        Write-Error "API call to updateUser failed. Status code: $($responseContent.status). Error: $errorDescription"
    } else {
        if ($responseContent.response.need_apply -eq "yes") {
            Write-Warning "Changes have been made that require applying. Please run the Invoke-UcmApplyChanges cmdlet."
        }
        return $responseContent.response
    }
}

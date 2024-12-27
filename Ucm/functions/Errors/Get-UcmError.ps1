<#
.SYNOPSIS
    Returns the textual description for a given UCM API error code.

.DESCRIPTION
    The API document contains several descriptions for error codes. This method returns that textual description,
    based on the passed in error code.

.PARAMETER Code
    The error code returned by the UCM API, i.e. -47.

.EXAMPLE
    # Example usage
    Get-UcmErrorDescription -Code -47
#>
function Get-UcmErrorDescription
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int32]$Code
    )

    $errors = @{
        0 = "Success"
        -1 = "Invalid parameters"
        -5 = "Need authentication"
        -6 = "Cookie error"
        -7 = "Connection closed"
        -8 = "System timeout"
        -9 = "Abnormal system error!"
        -15 = "Invalid value"
        -16 = "No such item. Please refresh the page and try again"
        -19 = "Unsupported"
        -24 = "Failed to operate data"
        -25 = "Failed to update data"
        -26 = "Failed to get data"
        -37 = "Wrong account or password!"
        -43 = "Some data in this page has been modified or deleted. Please refresh the page and try again"
        -44 = "This item has been added"
        -45 = "Operating too frequently or other users are doing the same operation. Please retry after 15 seconds."
        -46 = "Operating too frequently or other users are doing the same operation. Please retry after 15 seconds."
        -47 = "No permission. Check your API whitelist?"
        -50 = "Command contains sensitive characters"
        -51 = "Another task is running now"
        -57 = "Operating too frequently, or other users are doing the same operation. Please retry after 60 seconds"
        -68 = "Login Restriction"
        -69 = "There is currently a conference going on. Changes cannot be applied at this time"
        -70 = "Login Forbidden"
        -71 = "The username doesn't exist"
        -90 = "The conference is busy, cannot be edited or deleted"
        -98 = "There are currently digital calls. Failed to apply configuration"
    }

    if($errors.ContainsKey($Code))
    {
        return $errors[$Code]
    }
    else 
    {
        return "Undocumented error"
    }
}

<#
    .SYNOPSIS
        Generates an MD5 hash.
    
    .DESCRIPTION
        This cmdlet generates an MD5 hash from the supplied input value.
    
    .PARAMETER InputValue
        The value to create an MD5 hash for.
#>
function Get-Md5Hash
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$InputValue
    )

    $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $utf8 = New-Object -TypeName System.Text.UTF8Encoding
    $hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($InputValue)))
    Write-Verbose "Generated $hash from $InputValue"
    return [string]$hash
}

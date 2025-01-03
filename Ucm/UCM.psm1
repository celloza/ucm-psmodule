#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\UCM\functions\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\UCM\internal\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
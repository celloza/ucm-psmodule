Describe "Validating the Get-Md5Hash function" {
	$moduleRoot = (Resolve-Path "$global:testroot\..\ucm-psmodule").Path
	$manifest = ((Get-Content "$moduleRoot\ucm-psmodule.psd1") -join "`n") | Invoke-Expression
	Context "Hashing" {
		
        It "Should match a given MD5 hash" {
			
			Get-Md5Hash -InputValue "test" | Should -Be "09-8F-6B-CD-46-21-D3-73-CA-DE-4E-83-26-27-B4-F6"
			Get-Md5Hash -InputValue "42" | Should -Be "A1-D0-C6-E8-3F-02-73-27-D8-46-10-63-F4-AC-58-A6"
			Get-Md5Hash -InputValue "42" | Should -Not -Be "09-8F-6B-CD-46-21-D3-73-CA-DE-4E-83-26-27-B4-F6"
		}
    }
}
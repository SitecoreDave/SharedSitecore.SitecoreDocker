Set-StrictMode -Version Latest
function Set-SitecoreDockerLicenseEnvironnmentVariable
{
    Param
    (
        [Parameter(Position=0)] # Positional parameter
		[alias("SitecoreVersion")]
        [string[]]$version = @("9.3.0")
    )
	begin {
		$ErrorActionPreference = 'Stop'

		Clear-Host
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))

		#####################################################
		#
		#  Check-LicenseEnvironnmentVariable
		#
		#####################################################
		Write-Verbose "$scriptName $version started"

		$cwd = Get-Location

		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		$repoPath = (Get-Item $cwd).parent.parent.parent.FullName
		Write-Verbose "repoPath:$repoPath"

		#$SettingsFileName = "$scriptName.settings.json"
		#$SettingsFile = Join-Path "$cwd" $SettingsFileName
	}
	process {
		try {
			if ($version -eq @("9.3.0")) {
				Write-Verbose "licensePath:$licensePath checking license"
				#first try using SharedSitecore.Sinstall
				$licensePath = Join-Path (Join-Path (Join-Path $repoPath "SharedSitecore.Sinstall") "assets") "license.xml"
				if (!(Test-Path $licensePath)) {
					Set-Location "$repoPath\docker-images"
					. .\build\Set-LicenseEnvironmentVariable.ps1 -Path $licensePath
				} else {
					Write-Verbose "licensePath:$licensePath not found"
					EXIT 1
				}
			}
		}
		finally {
			Set-Location $cwd
		}
	}
}
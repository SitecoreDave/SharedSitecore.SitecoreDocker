Set-StrictMode -Version Latest
<#
.SYNOPSIS
    Sets a variable in a Docker environment (.env) file.
.DESCRIPTION
    Sets a variable in a Docker environment (.env) file.
    Assumes .env file is in the current directory by default.
.PARAMETER Variable
    Specifies the variable name.
.PARAMETER Value
    Specifies the variable value.
.PARAMETER Path
    Specifies the Docker environment (.env) file path. Assumes .env file is in the current directory by default.
.EXAMPLE
    PS C:\> Set-SitecoreDockerLicense -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Set-SitecoreDockerLivense "VAR1"
.EXAMPLE
    PS C:\> Set-SitecoreDockerLicense -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>		
#####################################################
#
#  Set-SitecoreDockerLicense
#
#####################################################
function Set-SitecoreDockerLicense
{
	[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)] # Positional parameter
		[alias("licensePath")]
        [string]$license = "\\license\\license.xml",
		[Parameter(Position=1)] # Positional parameter
		[alias("images")]
        [string]$dockerimages = "docker-images"
    )
	begin {
		$ErrorActionPreference = 'Stop'

		#Clear-Host
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
		$scriptPath = $PSScriptRoot

		Write-Verbose "$scriptName $license started"

		$cwd = Get-Location
		if ($cwd -ne $scriptPath) {
			Write-Verbose "Set-Location:$scriptPath"
			Set-Location $scriptPath
		}
		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		$reposPath = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent
		Write-Verbose "reposPath:$reposPath"

		#$SettingsFileName = "$scriptName.settings.json"
		#$SettingsFile = Join-Path "$cwd" $SettingsFileName
	}
	process {
		try {
			if (!(Test-Path $license)) {
				$license = "c:\license\license.xml"
				if (!(Test-Path $license)) {
					$license = Join-Path (Join-Path (Join-Path $reposPath "SharedSitecore.Sinstall") "assets") "license.xml"
				}
			}
			
			#MUST HAVE VALID LICENSEPATH TO CONTINUE WITHOUT ERROR
			if (!(Test-Path $license)) {
				Write-Error "license:$license not found"
				EXIT 1
			}

			#MUST HAVE VALID LICENSEPATH TO CONTINUE WITHOUT ERROR
			if (!(Test-Path "$reposPath\$dockerimages")) {
				Write-Error "github.com/sitecore/docker-images is a prerequisite for $scriptName."
				EXIT 1
			}
			
			Set-Location "$reposPath\$dockerimages"
			Write-Verbose "Set-LicenseEnvironmentVariable:$license"
			if($PSCmdlet.ShouldProcess($license)) {
				. .\build\Set-LicenseEnvironmentVariable.ps1 -Path $license
			}
		}
		finally {
			Set-Location $cwd
		}
	}
}
Set-StrictMode -Version Latest
#####################################################
#  Set-SitecoreDockerLicense
#####################################################
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
    PS C:\> "value one" | Set-SitecoreDockerLicense "VAR1"
.EXAMPLE
    PS C:\> Set-SitecoreDockerLicense -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>		
function Set-SitecoreDockerLicense
{
	[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)] # Positional parameter
		[alias("licensePath")]
		[ValidateScript( { Test-Path $_ -PathType "Leaf" })]
        [string]$license = "",
		[Parameter(Position=1)] # Positional parameter
		[alias("images")]
        [string]$dockerimages = "docker-images"
    )
	begin {
		$ErrorActionPreference = 'Stop'

		#Clear-Host
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
		$scriptPath = $PSScriptRoot #$MyInvocation.MyCommand.Path
		$scriptFolder = Split-Path $scriptPath

		Write-Verbose "$scriptName $license started"
		Push-Location $PSScriptRoot
		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		$repoPath = Split-Path (Split-Path $scriptPath -Parent) -Parent
		Write-Verbose "repoPath:$repoPath"
		$reposPath = Split-Path $repoPath -Parent
		Write-Verbose "reposPath:$reposPath"

		#$SettingsFileName = "$scriptName.settings.json"
		#$SettingsFile = Join-Path "$cwd" $SettingsFileName
	}
	process {
		try {
			$license = "\license\license.xml"
			if (!(Test-Path $license)) {
				Write-Verbose "license:$license not found trying other locations."
				$license = "$repoPath/assets/license/license.xml"
				if (!(Test-Path $license)) {
					Write-Verbose "license:$license not found trying other locations."
					$license = "c:\license\license.xml"
					#Check other locations: another repo? older SharedSitecore.Sinstall?
					#if (!(Test-Path $license)) {
					#	$license = Join-Path (Join-Path (Join-Path $reposPath "SharedSitecore.Sinstall") "assets") "license.xml"
					#}
				}
			}
			
			#MUST HAVE VALID LICENSEPATH TO CONTINUE WITHOUT ERROR
			if (!(Test-Path $license)) {
				Write-Error "license:$license not found"
				EXIT 1
			}

			#MUST HAVE VALID github.com/sitecore/docker-images repo TO CONTINUE WITHOUT ERROR
			if (!(Test-Path "$reposPath\$dockerimages")) {
				Write-Error "github.com/sitecore/docker-images is a prerequisite for $scriptName."
				#TODO: CALL git clone github.com/sitecore/docker-images
				EXIT 1
			}
			#Had to add this check, Set-LicenseEnvironmentVariable sent \ to c
			if ($license.StartsWith("\")) {
				$license = "$((Get-Location).Drive.Name):$license"
			}
			Write-Verbose "Set-LicenseEnvironmentVariable:$license"
			if($PSCmdlet.ShouldProcess($license)) {
				Copy-Item $license "$repoPath\..\assets"
				Set-Location "$reposPath\$dockerimages"
				. .\build\Set-LicenseEnvironmentVariable.ps1 -Path $license -PersistForCurrentUser
			}
		}
		finally {
			Pop-Location
		}
	}
}
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
    PS C:\> Set-DockerComposeEnvFileVariable -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Set-DockerComposeEnvFileVariable "VAR1"
.EXAMPLE
    PS C:\> Set-DockerComposeEnvFileVariable -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
function Start-SitecoreDocker
{
    Param
    (
        [Parameter(Position=0)] # Positional parameter
        [string]$config = "docker-compose.xp.spe"
    )
    begin {
		$ErrorActionPreference = 'Stop'

		Clear-Host
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))

		#####################################################
		#
		#  Build-SitecoreDocker
		#
		#####################################################
		Write-Verbose "$scriptName $config started"

		$cwd = Get-Location

		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		$repoPath = (Get-Item $cwd).parent.parent.parent.FullName
		Write-Verbose "repoPath:$repoPath"
	}
	process {
		try {
    	    Set-Location "$repoPath\docker-images\build\windows\tests\9.3.x\"
	
	        if ($version -eq @("9.3.0")) {
				$licensePath = Join-Path (Join-Path (Join-Path $repoPath "SharedSitecore.Sinstall") "assets") "license.xml"
				if (!(Test-Path $licensePath)) {
					. .\build\Set-LicenseEnvironmentVariable.ps1 -Path $licensePath
				} else {
					Write-Verbose "licensePath:$licensePath not found"
					EXIT 1					
				}
			}
	
	        docker-compose -f "$config.yml" up
        }
        finally {
            Set-Location $cwd
        }
    }
}
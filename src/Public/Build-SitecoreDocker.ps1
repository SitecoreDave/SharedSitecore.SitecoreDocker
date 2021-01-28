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
function Build-SitecoreDocker
{
    Param
    (
        [Parameter(Position=0)] # Positional parameter
		[alias("SitecoreVersion")]
        [string[]]$version = @("9.3.0"),
		
        [Parameter(Position=1)] # Positional parameter
		[alias("OSVersion")]
        [string[]]$os = @("ltsc2019")
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
		Write-Verbose "$scriptName $version $os started"

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
			Set-Location "$repoPath\docker-images"
			
			. .\..\Private\Check-LicenseEnvironnmentVariable.ps1
			
			if (!(Test-Path "certs")) {
				mkdir "certs"
			}
			
			$cert = "dev.local"
			if (!(Test-Path (Join-Path "certs" "$cert.pem"))) {
				Set-Location .\certs

				#Set-ExecutionPolicy Bypass -Scope Process -Force; 
				#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
				#iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
				choco install mkcert
				mkcert $cert
				Set-Location ..
			}
			
			. .\build.ps1 -SitecoreVersion $version -IncludeSpe:$true -Verbose:$false
			#. .\build.ps1 -SitecoreVersion $version -OSVersion $osversion -includespe
			#. .\Build.ps1 -SitecoreVersion @("9.3.0") -IncludeSpe
			#. .\Build.ps1 -SitecoreVersion @("9.3.0")
			#. .\Build.ps1 -SitecoreVersion "9.3.0"
		}
		finally {
			Set-Location $cwd
		}
	}
}
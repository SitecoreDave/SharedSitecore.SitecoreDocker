Set-StrictMode -Version Latest
#####################################################
#  Stop-SitecoreDocker
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
    PS C:\> Stop-SitecoreDocker -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Stop-SitecoreDocker "VAR1"
.EXAMPLE
    PS C:\> Stop-SitecoreDocker -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
function Stop-SitecoreDocker
{
	[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)] # Positional parameter
        [string]$config = "docker-compose.xp.spe",
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
		
		Write-Verbose "$scriptName $config started"
		$location = Get-Location
		Write-Verbose "location:$location"
		#$cwd = Set-LocationPSScript $PSScriptRoot $location
		Push-Location $PSScriptRoot
		Write-Verbose "cwd:$cwd"
		#$cwd = Get-Location
		#if ($cwd -ne $scriptPath) {
	#		Write-Verbose "Set-Location:$scriptPath"
#			Set-Location $scriptPath
		#}
		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		#$repoPath = (Get-Item $cwd).parent.parent.parent.FullName
		$reposPath = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent
		Write-Verbose "reposPath:$reposPath"
	}
	process {
		try {
    	    Set-Location "$reposPath\$dockerimages\build\windows\tests\9.3.x"
			if($PSCmdlet.ShouldProcess($config)) {
	        	docker-compose -f "$config.yml" down
			}
        }
        finally {
            Pop-Location
        }
    }
}
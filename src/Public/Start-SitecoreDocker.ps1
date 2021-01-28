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
    PS C:\> Start-SitecoreDocker -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Start-SitecoreDocker "VAR1"
.EXAMPLE
    PS C:\> Start-SitecoreDocker -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
#####################################################
#
#  Start-SitecoreDocker
#
#####################################################
function Start-SitecoreDocker
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
		$scriptPath = $PSScriptRoot #$MyInvocation.MyCommand.Path
		$scriptFolder = Split-Path $scriptPath
		
		Write-Verbose "$scriptName $config started"
		$cwd = Set-LocationPSScript $scriptFolder
		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		#$repoPath = (Get-Item $cwd).parent.parent.parent.FullName
		$reposPath = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent
		Write-Verbose "reposPath:$reposPath"
	}
	process {
		try {
			#TODO: Check if it needs to do Build-SitecoreDocker first and call it
			#Build-SitecoreDocker
    	    Set-Location "$reposPath\$dockerimages\build\windows\tests\9.3.x"
			if($PSCmdlet.ShouldProcess($config)) {
				Set-SitecoreDockerLicense
	        	docker-compose -f "$config.yml" up
				#TODO: Launch browser?
			}
        }
        finally {
            Set-Location $cwd
        }
    }
}
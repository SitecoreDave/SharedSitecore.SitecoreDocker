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
    PS C:\> Set-LocationPSScript -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Set-LocationPSScript "VAR1"
.EXAMPLE
    PS C:\> Set-LocationPSScript -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
#####################################################
#
#  Set-LocationPSScript
#
#####################################################
function Set-LocationPSScript
{
	[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)] # Positional parameter
        [string]$path = $PSScriptRoot,		
        [Parameter(Position=1)] # Positional parameter
        [string]$cwd = ""
    )
	begin {
		$ErrorActionPreference = 'Stop'
		$VerbosePreference = "Continue"
		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
		$scriptPath = $PSScriptRoot
		if(!$cwd){
			#$cwd = Get-Location
			$cwd = $MyInvocation.PSCommandPath
			#TODO: believe this needs to be changed to folder, think its actual stop-sitecoredocker.ps1
		}

		Write-Verbose "$scriptName $path $cwd started"
	}
	process {	
		if ($cwd -ne $scriptPath) {
			Write-Verbose "Set-Location:$scriptPath"
			Set-Location $scriptPath
		}
		return $cwd
	}
}
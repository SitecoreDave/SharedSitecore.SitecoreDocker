Set-StrictMode -Version Latest
<#
.SYNOPSIS
    Sets current working directory and returns original directory as string so it can be restored when ready
.DESCRIPTION
    Sets current working directory
.PARAMETER Path
    Specifies the path that needs to be set as current working directory
.PARAMETER Cwd
    Specifies the path that should be reset to return to original working directory.
.EXAMPLE
    PS C:\> Set-LocationPSScript -Path VAR1 -Cwd "value one"
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
        [string]$path = "",		
        [Parameter(Position=1)] # Positional parameter
        [string]$cwd = ""
    )
	begin {
		$ErrorActionPreference = 'Stop'
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
		$scriptPath = $PSScriptRoot #$MyInvocation.MyCommand.Path
		$callingScript = $MyInvocation.PSCommandPath | Split-Path -Parent
		Write-Verbose "$scriptName $path $cwd called by:$callingScript"
		if(!$path) { $path = $scriptPath | Split-Path }
		if(!$cwd) { $cwd = $callingScript }
	}
	process {	
		Write-Verbose "$scriptName $path $cwd processing"		
		if ($cwd -ne $scriptPath) {
			if($PSCmdlet.ShouldProcess($scriptPath)) {
				Write-Verbose "Set-Location:$scriptPath"
				Set-Location $scriptPath
			}
		}
		return $cwd
	}
}
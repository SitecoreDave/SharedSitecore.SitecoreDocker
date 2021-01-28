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
function Stop-SitecoreDocker
{
    Param
    (
        [Parameter(Position=0)] # Positional parameter
        [string]$config = "docker-compose.xp.spe"
    )
    $ErrorActionPreference = 'Stop'

    Clear-Host
    $VerbosePreference = "Continue"

    $scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))

    #####################################################
    #
    #  Stop-SitecoreDocker
    #
    #####################################################
    Write-Verbose "$scriptName $config started"

    $cwd = Get-Location
    #$SettingsFileName = "$scriptName.settings.json"
    #$SettingsFile = Join-Path "$PWD" $SettingsFileName

	Set-Location ..\..\..\docker-images\build\windows\tests\9.3.x\
	docker-compose -f "$config.yml" down
	Set-Location $cwd
}
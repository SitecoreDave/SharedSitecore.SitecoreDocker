param (
    [Parameter(Mandatory=$False)]
    [string]$cwd = ""
)
clear-host
$owd = $pwd
$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
Write-Host "scriptName:$scriptName"
$scriptPath = $MyInvocation.MyCommand.Path
Write-Host "scriptPath:$scriptPath"
$scriptFolder = Split-Path $scriptPath
Write-Host "scriptFolder:$scriptFolder"

$cwd = $MyInvocation.MyCommand.Path | Split-Path
Write-Host "cwd:$cwd"
Write-Host "PSScriptRoot:$PSScriptRoot"
$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
Write-Host "PSScriptRoot:$PSScriptRoot"
Write-Host "PSCommandPath:$PSCommandPath"
$name = $PSCommandPath | Split-Path -Leaf
Write-Host "results:$name"


Write-Host "MyInvocation.MyCommand.Name:$($MyInvocation.MyCommand.Name)"
Write-Host "MyInvocation.MyCommand.Path:$($MyInvocation.MyCommand.Path)"
Write-Host "MyInvocation.MyCommand:$($MyInvocation.MyCommand)"


$results = Set-LocationPSScript
Write-Host "results:$results"

$reposPath = Split-Path (Split-Path $scriptPath -Parent) -Parent
Write-Host "reposPath:$reposPath"

Set-Location $reposPath
Write-Host "pwd:$pwd"
$results = Set-LocationPSScript
Write-Host "results:$results"

Set-Location $owd
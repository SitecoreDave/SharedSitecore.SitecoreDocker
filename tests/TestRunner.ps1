param(
    [Parameter(HelpMessage="The block of tests to run in the scope of the module")]
    [ScriptBlock]$TestScope
)
$ModuleName = Split-Path (Split-Path $PSScriptRoot -Parent) -Leaf
if (Get-Module $ModuleName -ErrorAction SilentlyContinue) {
    Remove-Module $ModuleName -Force
}
Clear-Host
$ModulePath = Join-Path $PSScriptRoot "..\src\$ModuleName\$ModuleName.psm1"
Write-Verbose "ModulePath:$ModulePath"
Import-Module $ModulePath -Force -Scope Global -ErrorAction Stop
InModuleScope $ModuleName $TestScope
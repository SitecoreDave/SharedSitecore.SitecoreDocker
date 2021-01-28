param(
    [Parameter(HelpMessage="The block of tests to run in the scope of the module")]
    [ScriptBlock]$TestScope
)
if (Get-Module SharedSitecore.SitecoreDocker -ErrorAction SilentlyContinue) {
    Remove-Module SharedSitecore.SitecoreDocker -Force
}
Import-Module $PSScriptRoot\..\src\SharedSitecore.SitecoreDocker.psd1 -Force -Scope Global -ErrorAction Stop
InModuleScope SharedSitecore.SitecoreDocker $TestScope
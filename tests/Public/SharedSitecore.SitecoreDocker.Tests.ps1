. $PSScriptRoot\..\TestRunner.ps1 {
    . $PSScriptRoot\..\TestUtils.ps1

    $ModuleScriptName = 'SharedSitecore.SitecoreDocker.psm1'
    $ModuleManifestName = 'SharedSitecore.SitecoreDocker.psd1'
    $ModuleScriptPath = "$PSScriptRoot\..\..\src\$ModuleScriptName"
    $ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

    if (!(Get-Module PSScriptAnalyzer -ErrorAction SilentlyContinue)) {
        Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force
    }

    Describe 'Module Tests' {
        $ModuleScriptName = 'SharedSitecore.SitecoreDocker.psm1'
        #$ModuleManifestName = 'SharedSitecore.SitecoreDocker.psd1'
        $ModuleScriptPath = "$PSScriptRoot\..\..\src\$ModuleScriptName"
        #$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

        It 'imports successfully' {
            $ModuleScriptName = 'SharedSitecore.SitecoreDocker.psm1'
            #$ModuleManifestName = 'SharedSitecore.SitecoreDocker.psd1'
            $ModuleScriptPath = "$PSScriptRoot\..\..\src\$ModuleScriptName"
            #$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

            Write-Verbose "Import-Module -Name $($ModuleScriptPath)"
            { Import-Module -Name $ModuleScriptPath -ErrorAction Stop } | Should -Not -Throw
        }

        It 'passes default PSScriptAnalyzer rules' {
            
            $ModuleScriptName = 'SharedSitecore.SitecoreDocker.psm1'
            $ModuleScriptPath = "$PSScriptRoot\..\..\src\$ModuleScriptName"

            Invoke-ScriptAnalyzer -Path $ModuleScriptPath | Should -BeNullOrEmpty
        }
    }

    Describe 'Module Manifest Tests' {
        It 'passes Test-ModuleManifest' {
            
            $ModuleManifestName = 'SharedSitecore.SitecoreDocker.psd1'
            $ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

            Write-Output $ModuleManifestPath
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }
}
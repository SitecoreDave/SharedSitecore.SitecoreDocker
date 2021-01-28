. $PSScriptRoot\..\TestRunner.ps1 {
    . $PSScriptRoot\..\TestUtils.ps1

    Describe 'Set-SitecoreDockerLicense.Tests' {

        It 'not null' {
            { Set-SitecoreDockerLicense } | Should -Not -Throw
        }
    }
}
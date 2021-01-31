. $PSScriptRoot\tests\TestRunner.ps1 {
    . $PSScriptRoot\tests\TestUtils.ps1

    Describe 'Set-SitecoreDockerLicense.Tests' {

        It 'not null' {
            { Set-SitecoreDockerLicense } | Should -Not -Throw
        }
    }
}
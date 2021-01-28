. $PSScriptRoot\..\TestRunner.ps1 {
    . $PSScriptRoot\..\TestUtils.ps1

        Describe 'Set-LocationPSScript.Tests' {
            $ModuleScriptName = Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Leaf
            Write-Output "ModuleScriptName:$ModuleScriptName"
            #$ModuleScriptName = $PSScriptRoot | Split-Path -Parent -Parent -Leaf
            $ModuleScriptPath = Join-Path $PSScriptRoot "\..\..\src\$ModuleScriptName.psm1"
            Write-Output "ModuleScriptPath:$ModuleScriptPath"

            It 'imports successfully' {
                #$ModuleScriptName = 'SharedSitecore.SitecoreDocker'
                #$ModuleScriptPath = "$PSScriptRoot\..\..\src\$ModuleScriptName.psm1"

                $ModuleScriptName = Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Leaf
                Write-Output "ModuleScriptName:$ModuleScriptName"
                #$ModuleScriptName = $PSScriptRoot | Split-Path -Parent -Parent -Leaf
                $ModuleScriptPath = Join-Path $PSScriptRoot "\..\..\src\$ModuleScriptName.psm1"
                Write-Output "ModuleScriptPath:$ModuleScriptPath"
    
                { Import-Module -Name $ModuleScriptPath -ErrorAction Stop } | Should -Not -Throw
            }

            It 'not null' {
                { Set-LocationPSScript } | Should -Not -Throw #| Should Exist
            }
            It 'not null' {
                #$scriptFolder = $PSScriptRoot | Split-Path -Parent
                $expected = $pwd
                Set-LocationPSScript $expected | Should -Be $expected
                Get-Location | Should -Be $expected #| Should Exist
            }
            It 'not null' {
                $expected = $PSScriptRoot | Split-Path
                Set-LocationPSScript '..\Public' | Should -Be $expected #| Should Exist
            }
            It 'not null' {
                $expected = $PSScriptRoot | Split-Path -Parent
                { Set-LocationPSScript $expected } | Should -Not -Throw
                Get-Location | Should -Be $expected #| Should Exist
            }
            It 'not null' {
                $expected = $PSScriptRoot | Split-Path -Parent
                Set-Location $expected
                { Set-LocationPSScript $expected } | Should -Not -Throw
                Get-Location | Should -Be $expected #| Should Exist
            }
            #It "$someFile should exist" {
            #    $someFile | Should Exist
            #}
    }
}
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
    PS C:\> Build-SitecoreDocker -Variable VAR1 -Value "value one"
.EXAMPLE
    PS C:\> "value one" | Build-SitecoreDocker "VAR1"
.EXAMPLE
    PS C:\> Build-SitecoreDocker -Variable VAR1 -Value "value one" -Path .\src\.env
.INPUTS
    System.String. You can pipe in the Value parameter.
.OUTPUTS
    None.
#>
#####################################################
#
#  Build-SitecoreDocker
#
#####################################################
function Build-SitecoreDocker
{
    Param
    (
        [Parameter(Position=0)] # Positional parameter
		[alias("SitecoreVersion")]
        [string[]]$version = @("9.3.0"),
		
        [Parameter(Position=1)] # Positional parameter
		[alias("OSVersion")]
        [string[]]$os = @("ltsc2019"),
		[Parameter(Position=2)] # Positional parameter
		[alias("images")]
        [string]$dockerimages = "docker-images"
    )
	begin {
		$ErrorActionPreference = 'Stop'
		$VerbosePreference = "Continue"

		$scriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
		$scriptPath = $PSScriptRoot #$MyInvocation.MyCommand.Path
		$scriptFolder = Split-Path $scriptPath

		Write-Verbose "$scriptName $version $os started"
		$cwd = Set-LocationPSScript $scriptFolder
		#$repoPath = [System.IO.Path]::GetFullPath("$cwd/../../..")
		#$repoPath = System.IO.Path]::GetFullPath(($cwd + "\.." * 3))
		#$moduleName = (Get-Item $cwd).Parent.Parent.Parent.FullName
		#$moduleName = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Leaf
		$reposPath = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent

		#$SettingsFileName = "$scriptName.settings.json"
		#$SettingsFile = Join-Path "$cwd" $SettingsFileName
	}
	process {
		try {
			Set-SitecoreDockerLicense
			
			Set-Location "$reposPath\$dockerimages"
			
			if (!(Test-Path "certs")) {
				mkdir "certs"
			}
			
			$cert = "dev.local"
			if (!(Test-Path (Join-Path "certs" "$cert.pem"))) {
				Set-Location .\certs

				#Set-ExecutionPolicy Bypass -Scope Process -Force; 
				#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
				#iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
				choco install mkcert
				mkcert $cert
				Set-Location ..
			}
			. .\build.ps1 -SitecoreVersion $version -IncludeSpe:$true -Verbose:$false
			#. .\build.ps1 -SitecoreVersion $version -OSVersion $osversion -includespe
			#. .\Build.ps1 -SitecoreVersion @("9.3.0") -IncludeSpe
			#. .\Build.ps1 -SitecoreVersion @("9.3.0")
			#. .\Build.ps1 -SitecoreVersion "9.3.0"
		}
		finally {
			Set-Location $cwd
		}
	}
}
# SIG # Begin signature block
# MIIFwQYJKoZIhvcNAQcCoIIFsjCCBa4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUb+LpGlo/td0TqaWD91fdBl6j
# scagggNOMIIDSjCCAjKgAwIBAgIQHpPHVhJV5LBKSHdfHA+9HzANBgkqhkiG9w0B
# AQsFADAoMSYwJAYDVQQDDB1TaGFyZWRTaXRlY29yZS5TaXRlY29yZURvY2tlcjAe
# Fw0yMTAxMjcyMTUxMDJaFw0yMjAxMjcyMjExMDJaMCgxJjAkBgNVBAMMHVNoYXJl
# ZFNpdGVjb3JlLlNpdGVjb3JlRG9ja2VyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEA0v29oDKrlTF1LgojLFLlqC/jP5LbQ46oGDJGi+D94HTLCcSGpOk9
# HcE5x1aedVMK65CBHFj5BjY8j5NEVDi67fpif3OGmVWagjwclJzylcKlQgTioV6+
# rfffuJtFQ0/C3ftXy+l083ophmRPN8bu6BMWkC1uaHIg2Qqd7cf6Keu5j3LGw2eJ
# ncoSyZtxNSjbfX6FHm2KR0y9kD3RmBAUDZEmulht2mvn2ezGgPvJgCaMrW7xXq13
# iCx+TFdeaLLD5+V49WtWsW1PiHRFV7VMkOfjHOgW1mAYhlTCL38ByyqEG6D2dVGy
# ATX05fYszuRLfPdelxotvrk78evLiTaYeQIDAQABo3AwbjAOBgNVHQ8BAf8EBAMC
# B4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwKAYDVR0RBCEwH4IdU2hhcmVkU2l0ZWNv
# cmUuU2l0ZWNvcmVEb2NrZXIwHQYDVR0OBBYEFKT93awe2JYz+yfWHfrRE0AgR6Jg
# MA0GCSqGSIb3DQEBCwUAA4IBAQBYCsL16TX6A+72bbWp6IhGIh2SPwPlHJKEhAmX
# KK+TGe27yWEqLD2eEAgIHFd4IEFg3Fm+4ybJsAAbVh1+kePtELlrct+7brMaDvN6
# dpwPnh7K3H022C4IekCU5/DyEMZvmGtaQfAOQ9jiQC9aoseYDXg+O6Vs2HbdhL5S
# c3K8x/8jm7bLWymyFs6xatO8QzkwfWs2f/4KEzL0dW9iRmKW4HMoItIBSbe2WNKT
# TJ2VxIS3Fi+XuQDmkLngeUF5cyDXz9gnhsyImUTjV64tA1EAv0n991XC50fQRPbt
# Uybn44qecqGHObWoGYBL6Y0fdMi+PsUR3OympqCPJVPBfTINMYIB3TCCAdkCAQEw
# PDAoMSYwJAYDVQQDDB1TaGFyZWRTaXRlY29yZS5TaXRlY29yZURvY2tlcgIQHpPH
# VhJV5LBKSHdfHA+9HzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUSu5XbV9PMvdaiHxowmc3MOtP
# umMwDQYJKoZIhvcNAQEBBQAEggEABkzxl30j4k/IOC+AN1BNvDkP942Q603Pky7E
# h1AYXpqQx53wYbab83obvXIVifeAfJxASh1Wt/JaTKpnJ6Ged6t4457jLQ96rbtm
# Wrcvem2vbBMkbFRMbYptPnilEAtzPCRtqwm6B72ERDS5LQih/796ojskOqh4OLPd
# fWSrSsCLIPioiAYhnBiCGVr/4kuaYu4z2fYXtznJcHfqL9bl6nG47RPPDO2xmBuE
# u3a5frvDiLs4N92/eqZH1bUqNxRAv5Z4nREW7RqFY7v73lQhzHggDWYtk8ChADea
# TGBVcn0rQCGOz/oXBRqCBk9MSz35NH7AIKgHk+ekQPEbGjz2PQ==
# SIG # End signature block

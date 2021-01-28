@{
    RootModule              = 'SharedSitecore.SitecoreDocker.psm1'
    GUID                    = 'f59f3524-efda-4153-a319-d2adc6aafce6'
    Author                  = 'David Walker, Sitecore Dave, Radical Dave'
    CompanyName             = 'Radical Dave'
    Copyright               = 'Copyright (C) by Radical Dave'
    Description             = 'PowerShell extensions for Docker-based Sitecore development'
    ModuleVersion           = '0.0.1'
    PowerShellVersion       = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Build-SitecoreDocker','Start-SitecoreDocker','Stop-SitecoreDocker')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    # VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            Tags            = @('sitecore','docker','powershell')
            LicenseUri      = 'https://davidwalker.visualstudio.com/_git/SharedSitecore.SitecoreDocker?path=%2Flicense'
            ProjectUri      = 'https://davidwalker.visualstudio.com/SharedSitecore.SitecoreDocker'
            IconUri         = 'https://mygetwwwsitecoreeu.blob.core.windows.net/feedicons/sc-packages.png'
        }
    }
}


#Requires -Version 5.1

<#
    .SYNOPSIS
        Publish the Partner Center module to the internal gallery.
#>

param
(
    [Parameter(Mandatory = $true)]
    [System.String]
    $Version
)

while ((Read-Host -Prompt 'Is there a current Visual Studio Release build in the /artifacts folder? [y] Yes [n] No' -OutVariable 'response') -ne 'y')
{
    if ($response -eq 'n')
    {
        exit
    }
}

# $modulePath = '{0}\Documents\WindowsPowerShell\Modules\PartnerCenter\{1}' -f $HOME, $Version
$modulePath = '{0}\publish\PartnerCenter\{1}' -f $PSScriptRoot, $Version
if (Test-Path -Path $modulePath)
{
    throw "The module PartnerCenter with version $Version already exists."
}

# $libraryPath = '{0}\lib' -f $PSScriptRoot
# if (-not (Test-Path -Path $libraryPath))
# {
#     throw "The Release Build Path \lib does not exist."
# }

$artifactPath = '{0}\artifacts\Release' -f $PSScriptRoot
if (-not (Test-Path -Path $artifactPath))
{
    throw "The Release Build Path \artifacts\Release does not exist."
}

New-Item -Path "$modulePath\PreloadAssemblies" -ItemType 'Directory' | Out-Null
Copy-Item -Path "$artifactPath\PreloadAssemblies\*" -Destination "$modulePath\PreloadAssemblies"
# Copy-Item -Path "$libraryPath\Microsoft.Identity.Client\4.23.0.0\Microsoft.Identity.Client.dll" -Destination "$modulePath\PreloadAssemblies"
# Copy-Item -Path "$libraryPath\Microsoft.Identity.Client.Extensions.Msal\2.16.6.0\Microsoft.Identity.Client.Extensions.Msal.dll" -Destination "$modulePath\PreloadAssemblies"
Copy-Item -Path "$artifactPath\Microsoft.Extensions.*" -Destination $modulePath
Copy-Item -Path "$artifactPath\Microsoft.Graph.*" -Destination $modulePath
Copy-Item -Path "$artifactPath\Microsoft.Identity.*" -Destination $modulePath
Copy-Item -Path "$artifactPath\Microsoft.IdentityModel.*" -Destination $modulePath
# Copy-Item -Path "$artifactPath\Microsoft.Rest.*" -Destination $modulePath
Copy-Item -Path "$artifactPath\Microsoft.Store.PartnerCenter.*" -Destination $modulePath
Copy-Item -Path "$artifactPath\newtonsoft.Json.Dll" -Destination $modulePath
Copy-Item -Path "$artifactPath\PartnerCenter.ps*1" -Destination $modulePath
Copy-Item -Path "$artifactPath\System.Buffers.dll" -Destination $modulePath
Copy-Item -Path "$artifactPath\System.Runtime.CompilerServices.Unsafe.dll" -Destination $modulePath
Copy-Item -Path "$artifactPath\System.Security.Cryptography.ProtectedData.dll" -Destination $modulePath

$token = Use-VaultSecureString -TargetName 'PowerShell Gallery Key (arcade)' | Unprotect-SecureString
# Publish-Module -Path $modulePath -Repository 'Arcade' -NuGetApiKey $token -Confirm:$true -Verbose

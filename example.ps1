configuration Software
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -Module xInstallSoftware

    node ("localhost")
    {
        File SetupSources {
            Ensure          = 'Present'
            SourcePath      = '\\Share\Sources\'
            DestinationPath = 'C:\Sources\'
            Recurse         = $true
            Type            = 'Directory'
        }
        
        xInstallSoftware Microsoft_SSMS {
            Ensure     = 'Present'
            BinaryPath = 'C:\Sources\Microsoft_SSMS\SSMS-Setup-ENU.exe'
            Arguments  = '/s'
            AppName    = 'SQL Server Management Studio 18.0'
            ExitCodes  = @(0)
            TestPath   = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{673f06b0-3fd3-4b11-a775-3359fa5df604}'
            Shortcut   = @{
                Exe = "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe"
            }
            DependsOn  = '[File]SetupSources'
        }

        xInstallSoftware NodeJSLatestStable {
        
            Ensure     = 'Present'
            BinaryPath = 'C:\windows\system32\msiexec.exe'
            Arguments  = '/I C:\Sources\NodeJS\LatestStable\node-LatestStable-x64.msi /q'
            AppName    = 'NodeJSLatestStable'
            ExitCodes  = @(0, 3010)
            TestPath   = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F62C0E94-FBB4-4009-9941-6271BD2EBCEF}'
            DependsOn  = '[File]SetupSources'
        }

    }
}
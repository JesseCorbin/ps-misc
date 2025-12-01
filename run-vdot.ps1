cd $env:TEMP
Invoke-WebRequest "https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip" -OutFile .\VDOT_main.zip
Expand-Archive -Path .\VDOT_main.zip -DestinationPath .\VDOT -Force

cd .\VDOT\Virtual-Desktop-Optimization-Tool-main
cd .\2009\ConfigurationFiles

$json = cat .\AppxPackages.json -Raw | ConvertFrom-Json

$packagesToDisable = @(
    'Microsoft.Copilot',
    'Microsoft.BingNews',
    'Microsoft.BingWeather',
    'Microsoft.Edge.GameAssist ',
    'Microsoft.GamingApp',
    'Microsoft.Getstarted',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.People',
    'Microsoft.PowerAutomateDesktop',
    'Microsoft.SkypeApp',
    'Microsoft.USNationalParks',
    'microsoft.windowscommunicationsapps',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.YourPhone',
    'Microsoft.XboxApp',
    'Microsoft.MixedReality.Portal',
    'MicrosoftTeams',
    'MSTeams',
    'Microsoft.Wallet'
)

$json | foreach-object { 
    if ( $_.AppxPackage -in $packagesToDisable -and $_.vdistate -eq "Unchanged" ) {
        $_.VDIState = "Disabled" 
    }
}

$json | ConvertTo-Json | set-content .\AppxPackages.json

cd ..\..
& .\Windows_VDOT.ps1 -Optimizations All

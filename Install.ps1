if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}
# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Installing IIS..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
 Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4Extended-ASPNET45" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServerRole" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServer" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-CommonHttpFeatures" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpErrors" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpRedirect" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ApplicationDevelopment" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-NetFxExtensibility" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-NetFxExtensibility45" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HealthAndDiagnostics" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpLogging" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-LoggingLibraries" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-RequestMonitor" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpTracing" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-Security" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-URLAuthorization" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-RequestFiltering" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-Performance" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServerManagementTools" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-IIS6ManagementCompatibility" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-Metabase" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WAS-WindowsActivationService" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WAS-ProcessModel" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WAS-NetFxEnvironment" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WAS-ConfigurationAPI" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-StaticContent" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-DefaultDocument" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-DirectoryBrowsing" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebSockets" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ASPNET" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ASPNET45" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-CGI " -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ISAPIExtensions" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ISAPIFilter" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ServerSideIncludes" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-BasicAuthentication" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpCompressionStatic" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ManagementConsole" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ManagementService" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-FTPServer" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-FTPSvc" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-FTPExtensibility" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WCF-HTTP-Activation" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "WCF-NonHTTP-Activation" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WindowsAuthentication" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ClientCertificateMappingAuthentication" -All
 Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v #"AllowDevelopmentWithoutDevLicense" /d "1"

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

if (Check-Command -cmdname 'git') {
    Write-Host "Git is already installed, checking new version..."
    choco update git -y
}
else {
    Write-Host ""
    Write-Host "Installing Git for Windows..." -ForegroundColor Green
    choco install git -y
}

if (Check-Command -cmdname 'node') {
    Write-Host "Node.js is already installed, checking new version..."
    choco update nodejs -y
}
else {
    Write-Host ""
    Write-Host "Installing Node.js..." -ForegroundColor Green
    choco install nodejs -y
}
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Applications install" -ForegroundColor Green
choco install googlechrome -y
choco install firefox -y
choco install opera -y
choco install opera-gx -y
choco install dotnetcore-sdk -y
choco install vscode -y
choco install vscode-icons -y
choco install vscode-powershell -y
choco install vscode-gitlens -y
choco install vscode-python -y
choco install typescript -y
choco install visualstudio2019community -y
choco install sql-server-management-studio -y
choco install dotnetcore-windowshosting -y
choco install wget -y
choco install fiddler -y
choco install beyondcompare -y
choco install lightshot.install -y
choco install teamviewer -y
choco install vlc -y
choco install winrar --params "/English" -y
choco install nodejs.install -y
choco install k-litecodecpackfull -y
choco install sublimetext3 -y
choco install cmder -y
choco install npmtaskrunner -y
choco install postman -y
choco install python -y
choco install git-fork -y
choco install discord -y
choco install jdownloader -y
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Theme Dark SSMS18" -ForegroundColor Green
powershell -Command "(gc 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\ssms.pkgundef') -replace '\[\`$RootKey\`$\\Themes\\{1ded0138-47ce-435e-84ef-9ec1f439b749}\]', '//[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]' | Out-File 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\ssms.pkgundef'"
# -----------------------------------------------------------------------------
Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
Restart-Computer
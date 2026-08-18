# Default
winget install --id Google.Chrome --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id Notepad++.Notepad++ --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id MHNexus.HxD --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.14 --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.VisualStudioCode --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id Oracle.VirtualBox --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id Git.Git --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# C언어
winget install --id Orwell.Dev-C++ --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# 암호기술
winget install --id Anaconda.Anaconda3 --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# 웹보안
winget install --id JetBrains.PhpStorm --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id ZAP.ZAP --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id PortSwigger.BurpSuite.Community --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# JAVA
winget install --id EclipseAdoptium.Temurin.25.JDK --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id JetBrains.IntelliJIDEA.Community --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install --id EclipseFoundation.Eclipse.Java --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# Forensics
winget install --id SleuthKit.Autopsy --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# Network
winget install --id WiresharkFoundation.Wireshark --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements

# Sysprep
Get-AppxPackage -Name *Winget.Source* -AllUsers | Remove-AppxPackage -AllUsers
Get-AppxPackage -Name *NotepadPlusPlus* -AllUsers | Remove-AppxPackage -AllUsers
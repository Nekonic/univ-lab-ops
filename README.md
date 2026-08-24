# univ-lab-ops
University lab PC management and operations

```cmd
winget install GitHub.cli
```

## 설치

```ps1
New-Item -ItemType Directory -Path "C:\Setup\Installers" -Force

.\GNS3.ps1
.\VMware.ps1
.\install.ps1

Get-AppxPackage -Name *Winget.Source* -AllUsers | Remove-AppxPackage -AllUsers
Get-AppxPackage -Name *NotepadPlusPlus* -AllUsers | Remove-AppxPackage -AllUsers

Copy-Item ".\Unattend.xml" "C:\Setup\Unattend.xml" -Force
Copy-Item ".\lang.ps1" "C:\Setup\lang.ps1" -Force
```

```ps1
C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:C:\Setup\unattend.xml
```

## wim 생성
![img](assets\images\Vmware.png)

![img](assets\images\Vmware2.png)

![img](assets\images\Vmware3.png)

wpeinit 쳐야 할수도 있음.

![img](assets\images\Vmware4.png)

![img](assets\images\Vmware5.png)



## 올리기
 
```cmd
7z a -v1900m -mx0 C:\Capture\20260824\p.7z C:\Capture\Win11.wim
gh release create 20260824 C:\Capture\20260824\* --title 20260824 --notes 20260824
```
 
`-mx0` — WIM은 이미 압축돼 있어 재압축 이득이 없음.
 
## 받기
 
```cmd
git clone https://github.com/Nekonic/univ-lab-ops
cd univ-lab-ops
gh release download 20260824
7z x p.7z.001
```

```ps1
$ProgressPreference = 'SilentlyContinue'
$r = irm https://api.github.com/repos/Nekonic/univ-lab-ops/releases/tags/20260824
$r.assets | % { irm $_.browser_download_url -OutFile $_.name }
7z x p.7z.001
```

## 적용
 
```cmd
dism /Apply-Image /ImageFile:Win11.wim /Index:1 /ApplyDir:C:\
```


## Link
```
https://cisco-packet-tracer.en.uptodown.com/windows/download
```

```
https://sourceforge.net/projects/gns-3/
```


```md
[공통]
- Google Chrome
- Notepad++
- HxD
- Python 3.14
- Visual Studio Code
- VirtualBox
- Git

- VMware
- GNS3

[C언어]
- Dev-C++

[암호기술]
- Anaconda3

[웹보안]
- PhpStorm
- OWASP ZAP
- Burp Suite Community

[JAVA]
- Temurin JDK 25
- IntelliJ IDEA Community
- Eclipse (Java)

[포렌식]
- Autopsy

[네트워크]
- Wireshark
- cisco-packet-tracer
```
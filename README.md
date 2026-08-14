# univ-lab-ops
University lab PC management and operations

```cmd
winget install GitHub.cli
```

## 올리기
 
```cmd
7z a -v1900m -mx0 C:\Capture\20260814\p.7z C:\Capture\Win11.wim
gh release create 20260814 C:\Capture\20260814\* --title 20260814 --notes 20260814
```
 
`-mx0` — WIM은 이미 압축돼 있어 재압축 이득이 없음.
 
## 받기
 
```cmd
git clone https://github.com/Nekonic/univ-lab-ops
cd univ-lab-ops
gh release download 20260814
7z x p.7z.001
```

```ps1
$ProgressPreference = 'SilentlyContinue'
$r = irm https://api.github.com/repos/Nekonic/univ-lab-ops/releases/tags/20260814
$r.assets | % { irm $_.browser_download_url -OutFile $_.name }
7z x p.7z.001
```

## 적용
 
```cmd
dism /Apply-Image /ImageFile:Win11.wim /Index:1 /ApplyDir:C:\
```

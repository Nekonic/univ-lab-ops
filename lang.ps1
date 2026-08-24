# 배포 후 첫 부팅 1회 실행 (내장 Administrator 자동 로그온 → FirstLogonCommands)
# 3계정 프로필을 미리 만들고 계정별 표시 언어를 심는다.
$log = 'C:\Setup\lang.log'
function Log($m) { "$(Get-Date -f 'HH:mm:ss') $m" | Tee-Object $log -Append }

Add-Type -Namespace UP -Name Env -MemberDefinition @'
[DllImport("userenv.dll", CharSet=CharSet.Unicode, SetLastError=true)]
public static extern int CreateProfile(string pszUserSid, string pszUserName,
    System.Text.StringBuilder pszProfilePath, uint cchProfilePath);
'@

# 하이브를 열어 스크립트 블록을 실행하고 확실히 언로드한다
function Use-Hive($Sid, $Dat, $Work) {
    $loaded = Test-Path "Registry::HKEY_USERS\$Sid"
    $root   = if ($loaded) { "HKU\$Sid" } else { "HKU\TMP_$([guid]::NewGuid().ToString('N').Substring(0,8))" }
    if (-not $loaded) {
        if (-not (Test-Path $Dat)) { throw "NTUSER.DAT 없음: $Dat" }
        & reg.exe load $root $Dat | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "reg load 실패($LASTEXITCODE): $Dat" }
    }
    try { & $Work $root }
    finally {
        if (-not $loaded) {
            [gc]::Collect(); [gc]::WaitForPendingFinalizers()
            for ($i=0; $i -lt 10; $i++) {
                & reg.exe unload $root | Out-Null
                if ($LASTEXITCODE -eq 0) { break }
                Start-Sleep 2
            }
        }
    }
}

# CopyProfile 잔재 정리 — 안 하면 첫 로그온마다 기본 앱/파일 연결이 초기화된다
function Clear-DefaultProfileHash {
    $pl  = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'
    $dat = Join-Path (Get-ItemProperty $pl -Name Default).Default 'NTUSER.DAT'
    Use-Hive 'DEFAULT_NA' $dat {
        param($root)
        foreach ($k in 'Software\Microsoft\Windows\Shell\Associations\FileAssociationsUpdateVersion',
                       'Software\Microsoft\Windows\Shell\Associations\UrlAssociations',
                       'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts') {
            & reg.exe delete "$root\$k" /f 2>$null | Out-Null
        }
    }
    Log 'Default 프로필 해시 항목 정리 완료'
}

function Set-UserUILanguage($Account, $Language) {
    $sid  = ([System.Security.Principal.NTAccount]$Account).
            Translate([System.Security.Principal.SecurityIdentifier]).Value
    $user = $Account.Split('\')[-1]

    $sb = New-Object System.Text.StringBuilder 260
    $hr = [UP.Env]::CreateProfile($sid, $user, $sb, $sb.Capacity)
    # 0x800700B7 = HRESULT_FROM_WIN32(ERROR_ALREADY_EXISTS) — 이미 있으면 정상
    if ($hr -ne 0 -and $hr -ne -2147024713) {
        throw "CreateProfile 실패: 0x$('{0:X8}' -f $hr)"
    }

    $pl  = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
    $dat = Join-Path (Get-ItemProperty $pl -Name ProfileImagePath).ProfileImagePath 'NTUSER.DAT'

    Use-Hive $sid $dat {
        param($root)
        & reg.exe add "$root\Control Panel\Desktop" /v PreferredUILanguages `
            /t REG_MULTI_SZ /d $Language /f | Out-Null
        & reg.exe add "$root\Control Panel\International\User Profile" /v Languages `
            /t REG_MULTI_SZ /d $Language /f | Out-Null
    }
    Log "$Account -> $Language"
}

try { Clear-DefaultProfileHash } catch { Log "Default 정리 실패: $_" }

# 계정별로 격리 — 하나가 실패해도 나머지는 계속한다
foreach ($e in @(
    @{ a = 'SCHOOL\korea';    l = 'ko-KR' },
    @{ a = 'SCHOOL\mongolia'; l = 'mn-MN' },
    @{ a = 'SCHOOL\china';    l = 'zh-CN' }
)) {
    try { Set-UserUILanguage $e.a $e.l } catch { Log "$($e.a) 실패: $_" }
}
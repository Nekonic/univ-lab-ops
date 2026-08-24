$d='school.local'; $pw='123456'
@{korea='ko-KR'; mongolia='mn-MN'; china='zh-CN'}.GetEnumerator() | % {
  $c = [pscredential]::new("$d\$($_.Key)", (ConvertTo-SecureString $pw -AsPlainText -Force))
  Start-Process cmd '/c exit' -Credential $c -Wait
  Start-Sleep 3
  reg load HKU\T "C:\Users\$($_.Key)\NTUSER.DAT"
  reg add "HKU\T\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /d $_.Value /f
  reg unload HKU\T
}

# 判断解压命令是否存在
if(Get-Command Expand-Archive -ErrorAction SilentlyContinue) {
    Write-Host "Expand-Archive command exists"
} else {
    Write-Host "Expand-Archive command does not exist"
}


# 获取当前操作系统名称
$var1 = (wmic os get Caption /value | Select-String "Caption").ToString() -replace "Caption=",""

# 输出当前操作系统名称
Write-Host "Current OS name: $var1"

# 根据操作系统名称进行判断
if ($var1 -like "Microsoft Windows 10 *") {
    Write-Host "OK"
    # 可以添加其他命令
}
elseif ($var1 -eq "Microsoft Windows 7") {
    Write-Host "OK 7"
}
else {
    Write-Host "Fail other OS"
    # 可以添加其他命令
}

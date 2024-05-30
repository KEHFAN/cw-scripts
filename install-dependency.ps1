

# 循环遍历当前文件所有内容
foreach ($file in Get-ChildItem -Path . -Recurse) {

    # 是文件夹跳过
    if($file.PSIsContainer){
        continue
    }

    # jar文件
    if($file.Extension -eq ".jar"){

        $fullPath = $file.FullName
        $pomFileName = [System.IO.Path]::GetFileNameWithoutExtension($fullPath) + ".pom"
        $folderPath = Split-Path $fullPath
        $pomFilePath = Join-Path $folderPath $pomFileName

        Write-Host $fullPath

        # 判断是否存在*.pom
        if(Test-Path $pomFilePath){
            # 存在pom 直接安装依赖
            $pomFile = Get-Item -Path $pomFilePath
            Write-Host $pomFile.FullName
            # 切换目录
            $rootDir = Get-Location
            Set-Location $folderPath
            try{
                & mvn install:install-file -Dfile="$file" -DpomFile="$pomFile"
            } catch {
                # 命令异常
            } finally{
                # 回到根目录
                Set-Location $rootDir
            }
        } else {
            Write-Host "pom does not exist. skip."
        }
    }
    elseif ($file.Extension -eq ".zip") {
        Write-Host "zip file , execute unzip $file.FullName"
    }
}

# 解压zip
function unzip {
    # sourceZipFile 文件路径
    # targetPath 解压目录
    param($sourceZipFile,$targetPath)

    # 判断解压命令是否存在
    if(Get-Command Expand-Archive -ErrorAction SilentlyContinue) {
        Write-Host "Expand-Archive command exists"
        # 直接使用Expand-Archive命令解压
        Expand-Archive -Path $sourceZipFile -DestinationPath $targetPath
    } else {
        Write-Host "Expand-Archive command does not exist"
        # 想办法使用其他方式解压文件
    }
}

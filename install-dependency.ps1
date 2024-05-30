# 解压zip
function unzip {
    # sourceZipFile 文件路径
    # targetPath 解压目录
    param($sourceZipFile,$targetPath)

    # 判断解压命令是否存在
    if(Get-Command Expand-Archive -ErrorAction SilentlyContinue) {
        Write-Host "Expand-Archive command exists"
        # 直接使用Expand-Archive命令解压
        Expand-Archive -Path $sourceZipFile -DestinationPath $targetPath -Force
    } else {
        Write-Host "Expand-Archive command does not exist"
        # 想办法使用其他方式解压文件
    }
}

function RemoveDir {
    param([String]$dir)
    Get-ChildItem -Path $dir -Recurse | Remove-Item -Force -Recurse
    Remove-Item -Path $dir -Force -Recurse
}

function traverseDir {
    param($dir)

    # 循环遍历当前文件所有内容
    foreach ($file in Get-ChildItem -Path $dir -Recurse) {

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
            $installBatPath = Join-Path $folderPath "install.bat"

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
            } elseif (Test-Path $installBatPath) {
                Write-Host "install.bat exists."
                # 切换目录
                $rootDir = Get-Location
                Set-Location $folderPath
                try{
                    & .\install.bat
                } catch {
                    # 命令异常
                    Write-Host "Caught:" $_.Exception.Message
                } finally{
                    # 回到根目录
                    Set-Location $rootDir
                }
            } else {
                # 检查是否存在install.bat
                Write-Host "pom does not exist. skip."
            }
        }
        elseif ($file.Extension -eq ".zip") {
            Write-Host "zip file, unzip $file"
            unzip -sourceZipFile $file -targetPath "tmp"
            # 递归调用解压目录
            traverseDir -dir "tmp"

            # 清空tmp
            RemoveDir -dir "tmp"
        }
    }
}

traverseDir -dir "."




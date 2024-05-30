# cw-scripts
codewave相关脚本

进入依赖文件夹

# window ps1
```powershell
iex(Invoke-WebRequest -Uri "https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/install-dependency.ps1" -UseBasicParsing).Content
```
```powershell
iex(Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KEHFAN/cw-scripts/main/install-dependency.ps1" -UseBasicParsing).Content
```
win7下载失败 就手动下载

# window
1. 打开powershell
2. 粘贴命令
```shell
curl -o install-dependency.cmd "https://raw.githubusercontent.com/KEHFAN/cw-scripts/main/install-dependency.cmd"; .\install-dependency.cmd
```
如果提示没有curl命令,则在浏览器输入地址手动下载执行；
如果无法访问github,则输入gitee地址下载
https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/install-dependency.cmd

# linux/mac
unix curl -o my_script.sh https://gitee.com/your_username/your_repository/raw/branch/path_to_your_script.sh && bash my_script.sh
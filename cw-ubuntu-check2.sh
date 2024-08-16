# cw ubuntu 18.04 LTS env check
# wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && sudo bash test.sh


Get_Pack_Manager(){
	# 检查apt-get dpkg 文件是否存在
	if [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
		PM="apt-get"
	fi
}

Set_Repo_Url(){
	if [ ! -f "/etc/apt/sources.list" ]; then
		return
	fi
	# 修改apt-get镜像源
	if [ "${PM}"="apt-get" ]; then

		GET_SOURCES_URL=$(cat /etc/apt/sources.list|grep ^deb|head -n 1|awk -F[/:] '{print $4}')
		echo "${GET_SOURCES_URL}"
	fi
}

Install_Main(){
	Get_Pack_Manager

	if [ "${PM}" = "apt-get" ]; then
		echo "${PM}"
	fi
}


# 循环读取命令行参数 -u or --user
while [ ${#} -gt 0 ]; do
	# 匹配参数为 -u or --user
	case $1 in
		-u|--user)
			# 读取参数值
			PANEL_USER=$2
			# 左移列表参数
			shift 1
			;;
	esac
	shift 1
done


Install_Main

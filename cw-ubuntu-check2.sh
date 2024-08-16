# cw ubuntu 18.04 LTS env check
# wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && sudo bash test.sh


Get_Pack_Manager(){
	if [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
		PM="apt-get"
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

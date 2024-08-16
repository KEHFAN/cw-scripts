# wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && sudo bash test.sh



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

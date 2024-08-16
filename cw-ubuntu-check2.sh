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

		SOURCE_URL_CHECK=$(grep -E 'security.ubuntu.com|archive.ubuntu.com' /etc/apt/sources.list)

		GET_SOURCES_URL=$(cat /etc/apt/sources.list|grep ^deb|head -n 1|awk -F[/:] '{print $4}')
		echo "${GET_SOURCES_URL}"
		NODE_CHECK=$(curl --connection-timeout 3 -m 3 2>/dev/null -w "%{http_code} %{time_total" ${GET_SOURCES_URL} -o /dev/null)
		NODE_STATUS=$(echo ${NODE_CHECK}|awk '{print $1}')
		TIME_TOTAL=$(echo ${NODE_CHECK}|awk '{print $2 * 1000}'|cut -d '.' -f 1)

		echo "${NODE_STATUS},${TIME_TOTAL}"

		if { [ "${NODE_STATUS}" != "200" ] && [ "${NODE_STATUS}" != "301" ]; } || [ "${TIME_TOTAL}" -ge "150" ] || [ "${SOURCE_URL_CHECK}" ]; then
			\cp -rpa /etc/apt/sources.list /etc/apt/sources.list.cwbackup
			apt_lists=(mirrors.cloud.tencent.com mirrors.163.com repo.huaweicloud.com mirrors.tuna.tsinghua.edu.cn mirrors.aliyun.com mirrors.ustc.edu.cn )
			for list in ${apt_lists[@]};
			do
				NODE_CHECK=$(curl --connect-timeout 3 -m 3 2>/dev/null -w "%{http_code} %{time_total}" ${list} -o /dev/null)
				NODE_STATUS=$(echo ${NODE_CHECK}|awk '{print $1}')
				TIME_TOTAL=$(echo ${NODE_CHECK}|awk '{print $2 * 1000}'|cut -d '.' -f 1)
				if [ "${NODE_STATUS}" == "200" ] || [ "${NODE_STATUS}" == "301" ]; then
					if [ "${TIME_TOTAL}" -le "150" ];then
						sed -i "s/${GET_SOURCES_URL}/${list}/g" /etc/apt/sources.list
						sed -i "s/security.ubuntu.com/${list}/g" /etc/apt/sources.list
						sed -i "s/archive.ubuntu.com/${list}/g" /etc/apt/sources.list
						break;
					fi
				fi
			done
		fi
	fi
}

Install_Main(){
	Get_Pack_Manager
	Set_Repo_Url

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

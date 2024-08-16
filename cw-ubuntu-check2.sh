# cw ubuntu 18.04 LTS env check
# wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && sudo bash test.sh


# root用户检查
# Ubuntu 如果非root用户 使用sudo 执行脚本
if [ $(whoami) != "root" ];then
	echo "======================================================="
	echo "检查到当前非root权限"

	IS_UBUNTU=$(cat /etc/issue|grep Ubuntu)
	
	if [ "${IS_UBUNTU}" ];then
		echo "请使用下面命令重新执行"
		echo "sudo wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && bash test.sh"
	fi

fi


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

# apt-get安装依赖
Install_Deb_Pack(){
	# 更新软件列表
	apt-get update -y

	# 安装必备依赖
	debPacks="zip unzip";
	apt-get install -y $debPacks --force-yes
}

Install_Docker(){
	# 检查docker是否存在
	if [ -f "/usr/bin/docker" ]; then
		docker -v
		return
	fi
	# 不存在 使用apt-get安装
	if [ "${PM}" = "apt-get" ]; then
		apt-get install -y docker.io --force-yes

		# 配置docker镜像源

	fi
}

Install_Mysql(){
	echo "skip"
}

Install_OpenJDK8(){
	# 检查jdk是否存在
	if [ -f "/usr/bin/java" ];then
		java -version
		return
	fi

	if [ "${PM}" = "apt-get" ];then
		apt-get install -y openjdk-8-jdk --force-yes
	fi

}

Install_Maven(){
	echo "skip"
}

Install_Main(){
	Get_Pack_Manager
	Set_Repo_Url

	if [ "${PM}" = "apt-get" ]; then
		echo "${PM}"
		Install_Deb_Pack
	fi
	
	# 后续通过命令参数来指定是否要安装下列软件，以便允许用户在不同机器上分别安装
	if [ "${IS_INSTALL_JDK}" = "true" ];then
		Install_OpenJDK8
	fi
	
	if [ "${IS_INSTALL_MYSQL}" = "true" ];then
		echo "skip"
	fi

	# echo "IS_INSTALL_DOCKER=${IS_INSTALL_DOCKER}"
	if [ "${IS_INSTALL_DOCKER}" = "true" ];then
		Install_Docker
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
		--mysql)
			# 指定安装mysql
			IS_INSTALL_MYSQL="true"
			;;
		--docker-mysql)
			# 指定安装docker版本的mysql
			;;
		--jdk)
			# 指定安装jdk
			IS_INSTALL_JDK="true"
			;;
		--maven)
			# 指定安装maven
			;;
		--docker-nexus3)
			# 指定安装docker版本的nexus3
			;;
		--docker)
			# 指定安装docker
			IS_INSTALL_DOCKER="true"
			;;
		--containerd)
			# 指定安装containerd
			;;
	esac
	# 左移列表参数
	shift 1
done


Install_Main

# cw ubuntu 18.04 LTS env check
# wget -O install.sh https://download.bt.cn/install/install_lts.sh && sudo bash install.sh ed8484bec

while [ ${#} -gt 0 ]; do
	case $1 in
		-u|--user)
			PANEL_USER=$2
			shift 1
			;;
		-p|--password)
			PANEL_PASSWORD=$2
			shift 1
			;;
		-P|--port)
			PANEL_PORT=$2
			shift 1
			;;
		--safe-path)
			SAFE_PATH=$2
			shift 1
			;;
		--ssl-disable)
			SSL_PL="disable"
			;;
		-y)
			go="y"
			;;
		*)
			IDC_CODE=$1
			;;
	esac
	shift 1
done
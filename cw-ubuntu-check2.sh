# wget -O test.sh https://gitee.com/KEHFAN_admin/cw-scripts/raw/main/cw-ubuntu-check2.sh && sudo bash test.sh




while [ ${#} -gt 0 ]; do
	case $1 in
		-u|--user)
			PANEL_USER=$2
			shift 1
			;;
	esac
	shift 1
done

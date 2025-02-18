#!/bin/bash
PATH_TO_DIR="/etc/xminer/"
BIN_NAME="xminer"
PATH_TO_BIN=${PATH_TO_DIR}${BIN_NAME}
SERVICE_NAME=${BIN_NAME}
DOWNLOAD_ADDR="https://github.com/mc-miner/XMiner/raw/main/xminer"
case $1 in
install)
	if [ -f ${PATH_TO_BIN} ]; then
		${PATH_TO_DIR}${BIN_NAME} uninstall  >/dev/null 2>&1
	fi
	#remove exists files
	rm -rf ${PATH_TO_DIR}
	rm -rf /etc/systemd/system/${SERVICE_NAME}*
	systemctl daemon-reload
	systemctl reset-failed
	mkdir ${PATH_TO_DIR}
	cd ${PATH_TO_DIR}
	set -e
	curl -s -L -o ${BIN_NAME} ${DOWNLOAD_ADDR}
	chmod +x ${BIN_NAME}
	./${BIN_NAME} install
	./${BIN_NAME} start
	./${BIN_NAME} status
	IP=$(curl -s ifconfig.me)
	echo "install done, please open the URL to login, http://$IP:51301 , password is: 123456"
	;;
update)
	if [ -f ${PATH_TO_BIN} ]; then
		rm -f ${PATH_TO_DIR}${BIN_NAME}
		cd ${PATH_TO_DIR}
		curl -s -L -o ${BIN_NAME} ${DOWNLOAD_ADDR}
		chmod +x ${BIN_NAME}
		systemctl restart ${SERVICE_NAME}
		./${BIN_NAME} status
		echo ${BIN_NAME}" updated!"
	else
		echo "ERROR:please install "${BIN_NAME}" software first"
	fi
	;;
esac

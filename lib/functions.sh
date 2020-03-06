function pause() {
	read -p "$*"
}

function addKey() {
	read -p "Do you wish to enable key based authentication? [yn] " addkey
	if [ "$addkey" == y ]; then
		#Enable key based authentication

		echo "Adding key based authentication..."
		mkdir ~/.ssh >/dev/null 2>&1
		file="~/.ssh/authorized_keys2"
		if
			[ -s "$file" ]
			currenttime="$(date +%s)"
		then
			mv ~/.ssh/authorized_keys2 ~/.ssh/authorized_keys2."$currenttime"
			chmod 0700 ~/.ssh
			read -p "Enter your key for key based authentication: " rsakey
			echo "$rsakey" >~/.ssh/authorized_keys2
			chmod 0600 ~/.ssh/authorized_keys2
			restorecon -R -v ~/.ssh
			service sshd restart
		fi
		echo "	Key based authentication has been installed and configured."
		echo ""
	else
		echo "Key based authentication has been skipped."
	fi
}

function addAuto() {
	read -p "Do you wish to enable automatic updates? [yn] " addauto
	if [ "$addauto" == y ]; then
		#Enable automatic updates, but first check for the yum-cron config.  If it exists, make a backup with the current time stamp.
		echo "Adding automatic updates..."
		{
			file="/etc/sysconfig/yum-cron"
			if [ -s "$file" ]; then
				currenttime="$(date +%s)"
				yum install -y yum-cron
				cp /etc/sysconfig/yum-cron /etc/sysconfig/yum-cron."$currenttime"
				perl -pi -e 's/CHECK_FIRST=no/CHECK_FIRST=yes/g' /etc/sysconfig/yum-cron
				service yum-cron start
				chkconfig yum-cron on
			fi
		} >/dev/null 2>&1
		echo "	yum-cron has been installed and configured."
		echo ""
	else
		echo "Automatic updates have been skipped."
	fi
}

function changeZone() {
	read -p "Do you wish to change the time zone? [yn] " changetime
	if [ "$changetime" == y ]; then
		#Modify Time Zone

		echo "Changing time zone..."
		read -p "Enter your time zone in the format 'Canada/Eastern': " timezone
		{
			currenttime="$(date +%s)"
			mv /etc/localtime /etc/localtime.$currenttime
			#unlink /etc/localtime
			ln -s /usr/share/zoneinfo/"$timezone" /etc/localtime
		} >/dev/null 2>&1

		echo "	Time zone has been changed."
		echo ""
	else
		echo "Time zone configuration has been skipped."
	fi
}

function addNTP() {
	read -p "Do you wish to enable NTP support? [yn] " addntp
	if [ "$addntp" == y ]; then
		#Modify and enable NTP settings

		echo "Adding network time protocol..."

		{
			yum install -y ntp
			service ntpd restart
		} >/dev/null 2>&1
		read -p "Do you want to change the default time server(s) to time.nrc.ca? [yn] " changeserver
		if [ "$changeserver" == "y" ]; then
			currenttime="$(date +%s)"
			cp /etc/ntp.conf /etc/ntp.conf.$currenttime
			perl -pi -e 's/server 0.centos.pool.ntp.org iburst/server time.nrc.ca iburst/g' /etc/ntp.conf
			perl -pi -e 's/server 1.centos.pool.ntp.org iburst//g' /etc/ntp.conf
			perl -pi -e 's/server 2.centos.pool.ntp.org iburst//g' /etc/ntp.conf
			perl -pi -e 's/server 3.centos.pool.ntp.org iburst//g' /etc/ntp.conf
			echo "The default Pool NTP servers have been replaced with time.nrc.ca"
		fi
		echo "	ntp has been installed and configured."
		echo ""
	else
		echo "NTP configuration has been skipped."
	fi
}

#!/bin/bash
#Author: Alex Gabriel <alex.gabriel@live.ca>
#Created: 26/02/2015
#Modified: 04/03/2015
#Description: Virtual machine setup script to enable key based authentication, automatic updates, and ntp settings.
#License: GPL 3.0

# Primary Tasks performed by this script:
#
# 1. Configure network settings.
# Pending
# 2. Enable key based authentication.
# Basic task complete
# 3. Configure automatic updates.
# Basic task complete
# 4. Change time zone.
# Basic task complete
# 5. Enable NTP.
# Basic task complete
# 6. Update man database.
# Pending
# 7. Configure firewall.
# Pending
# 8. Disable SELinux.
# Pending
# 9. NFS Management.
# Pending
# 10. Backup and restore.
# Pending
#
# TODO: Add menu
# TODO: Add security checks
# TODO: Add error checking and warning messages
# TODO: Add file backups, for both creation and restore
# TODO: Add multiple platform support
# TODO: Add updatedb as a cron job
# TODO: Add firewall configuration
# TODO: Finish network configuration

echo ""
echo "This is a virtual machine setup script to enable key based authentication, automatic updates, and ntp settings.  More may be added at a later time."
echo ""
pause "Press Enter to continue"

gpltext="gpl-3.0.txt"
more "$gpltext"
read -p "Do you agree to the terms and conditions and conditions as specified in the GNU Public License v3? [yn]" accept

if [ $accept == "y" ]; then
	source lib/functions.sh
	addKey() addAuto() changeZone() addNTP() else
	exit
fi

#!/bin/bash

# If Pashua isn't installed ...
if [ ! -x /Applications/Pashua.app/Contents/MacOS/Pashua ]; then
	echo "/!\ Can't find Pashua on your machine !"
	exit
fi

# Create the pashu conf file in /tmp
cat > /tmp/bitnami_init_conf.pashua <<EOL
opb.type = openbrowser
opb.label = Select your repository
opb.default = ~/Desktop/
opb.filetype = directory
opb.width = 250
EOL

# Get User input
REPOSITORY="$(/Applications/Pashua.app/Contents/MacOS/Pashua /tmp/bitnami_init_conf.pashua | cut -d'=' -f2)"
APP_NAME="$(basename $REPOSITORY)"

# Create conf directories and checking for previous conf files or invalid Mamp installation
# Which should be in your home
if [ -d ~/mamp/apps ]; then
	mkdir ~/mamp/apps/$APP_NAME
	mkdir ~/mamp/apps/$APP_NAME/conf
	mkdir ~/mamp/apps/$APP_NAME/htdocs
	cp $REPOSITORY/ex00/httpd-* ~/mamp/apps/$APP_NAME/conf/
	cp -R $REPOSITORY/* ~/mamp/apps/$APP_NAME/htdocs/
	if [ -e ~/mamp/apache2/conf/bitnami/bitnami-apps-vhosts.conf ]; then
		cat $REPOSITORY/ex00/bitnami-apps-vhosts.conf > ~/mamp/apache2/conf/bitnami/bitnami-apps-vhosts.conf
		echo "~/mamp/apache2/conf/bitnami/bitnami-apps-vhosts.conf Updated !"
	else
		echo "Creating ~/mamp/apache2/conf/bitnami/bitnami-apps-vhosts.conf"
		cp $REPOSITORY/ex00/bitnami-apps-vhosts.conf ~/mamp/apache2/conf/bitnami/
		echo "~/mamp/apache2/conf/bitnami/bitnami-apps-vhosts.conf Updated !"
	fi
else
	echo "/!\ ~/mamp/apps doesn't exist !"
	exit
fi

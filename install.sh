#!/bin/bash

# Install
# wget --no-cache -O - https://raw.githubusercontent.com/tzvio/symfony-boilerplate/main/install.sh | bash


# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

# PASSOWRD
PASS_MYSQL_ROOT='secret'

# Check if running as root  
if [ "$(id -u)" != "0" ]; then  
  echo -e "\n${Yellow} This script must be run as root ${Color_Off}" 
  echo -e "${Yellow} Try change to user root: sudo su -- or sudo su - userroot ${Color_Off}" 
  echo -e "${Blue} sudo su -- or ${Color_Off}" 
  echo -e "${Blue} sudo su - [root username] ${Color_Off}" 
  echo -e "" 1>&2 
  exit 1  
fi

update() {
  # Update system repos
  echo -e "\n${Purple} * Updating package repositories... ${Color_Off}"
  sudo apt-get -qq update -y
  sudo apt-get --fix-broken install --yes
  sudo apt-get list
}

installPHP() {
  # PHP and Modules
  echo -e "\n${Cyan} * Installing PHP and common Modules.. ${Color_Off}"
  sudo apt-get -qy install php php-common libapache2-mod-php php-curl php-dev php-gd php-gettext php-imagick php-intl php-mbstring php-mysql php-pear php-pspell php-recode php-xml php-zip
}

installMySQL() {
  # MySQL
  echo -e "\n${Cyan} * Installing MySQL.. ${Color_Off}"
  
  # set password with `debconf-set-selections` so you don't have to enter it in prompt and the script continues
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASS_MYSQL_ROOT}" # new password for the MySQL root user
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASS_MYSQL_ROOT}" # repeat password for the MySQL root user
  
  # DEBIAN_FRONTEND=noninteractive # by setting this to non-interactive, no questions will be asked
  DEBIAN_FRONTEND=noninteractive sudo apt-get -qy install mysql-server mysql-client
}


finally () {
 # update
 sudo apt update
 sudo apt upgrade
 sudo apt-get autoremove
 sudo apt-get autoclean
} 


# RUN
update
installPHP
installMySQL
update
finally



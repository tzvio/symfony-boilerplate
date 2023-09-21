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
  sudo apt-get -qy install php php-intl php-pgsql php-mysql php-xsl php-amqp php-gd php-redis php-curl php-zip php-ssh2
}

installGIT() {
  echo -e "\n${Cyan} * Installing GIT.. ${Color_Off}"
  sudo apt-get -qy install git
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

installComposer() {
  echo -e "\n${Cyan} * Installing Composer.. ${Color_Off}"
  wget https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer -O - -q | php
  sudo mv composer.phar /usr/local/bin/composer
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
installGIT
installPHP
installComposer
installMySQL
update
finally



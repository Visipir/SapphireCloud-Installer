#!/bin/bash

set -e

###############################################################################
#                                                                             #
#                        Pterodactyl Installer                                #
#                                                                             #
#                           Terms Of Service                                  #
#                           1. No refunds                                     #
#                    2. You cannot share this resource                        #
#              4. You will not steal any code from this script                #
#            3. You may not resell or redistribute this resource              #
#                                                                             #
#                      Updates are not guaranteed                             #
#                                                                             #
#                              Need Help?                                     #
#                              Vspr#6969                                      #
#                                                                             #
#                             Made By Vspr                                    #
#                       Copyright (C) 2022, Vspr                              #
#                                                                             #
###############################################################################

export GITHUB_SOURCE="v0.12.1"
export SCRIPT_RELEASE="v0.12.1"
export GITHUB_BASE_URL="https://raw.githubusercontent.com/VsprKunz/SapphireCloud-Installer"
COLOR_MAGENTA='\033[0;35m'

yhgitu() {
  echo "###############################################################################"
  echo "#                                                                             #"
  echo "#                       ${COLOR_MAGENTA}SapphireCloud Installer${COLOR_NC}                               #"
  echo "#                                                                             #"
  echo "#                    official script for SapphireCloud                        #"
  echo "#                                                                             #"
  echo "#                                                                             #"
  echo "#                             Made By Vspr                                    #"
  echo "#                       Copyright (C) 2022, Vspr                              #"
  echo "#                                                                             #"
  echo "###############################################################################"
}

LOG_PATH="/var/log/sapphirecloud-installer.log"

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

# Always remove lib.sh, before downloading it
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh https://raw.githubusercontent.com/VsprKunz/SapphireCloud-Installer/main/lib/lib.sh
# shellcheck source=lib/lib.sh
source /tmp/lib.sh

execute() {
  echo -e "\n\n* sapphirecloud-installer $(date) \n\n" >>$LOG_PATH

  update_lib_source

  if [[ -n $2 ]]; then
    echo -e -n "* Installation of $1 completed. Do you want to proceed to $2 installation? (y/N): "
    read -r CONFIRM
    if [[ "$CONFIRM" =~ [Yy] ]]; then
      execute "$2"
    else
      error "Installation of $2 aborted."
      exit 1
    fi
  fi
}

yhgitu ""

done=false
while [ "$done" == false ]; do
  options=(
    "Install Panel"
    "Install Wings"
    "Uninstall Panel"
    "Uninstall Wings"
    "Install Database"
    "Update Panel"
    "Update Wings"
    "Create SSL"
    "Building Panel Assets"
    "Build Panel"
    "Install Auto Backup"
  )

  actions=(
    "panel"
    "wings"
    "uninstall_panel"
    "uninstall_wings"
    "database"
    "update_panel"
    "update_wings"
    "ssl"
    "panel_assets"
    "build_panel"
    "auto_backup"
  )

  echo "Mau yang mana ganteng? >//<"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "> Masukin 0-$((${#actions[@]} - 1)): "
  read -r action

  [ -z "$action" ] && error "Input is required" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done

# Remove lib.sh, so next time the script is run the, newest version is downloaded.
rm -rf /tmp/lib.sh

# this file can be sourced e.g. by .profile.
# It contains some useful ros functions and aliases.

alias roscdd='roscd && cd ../src'

# Asks the user to choose from preconfigured ROS masters
# (configured in $HOME/.config/ros_masters.conf)
set_ros_master_uri() {
  lo_dev="lo"
  hosts_file=$HOME/.config/ros_masters.conf
  devices=() # Not strictly necessary, but added for clarity
  for item in `ls /sys/class/net`
  do
      if [ "$item" != "$lo_dev"  ]
      then
          devices+=("$item")
      fi
  done

  devices_string=""
  for device in ${devices[@]}
  do
      ip=$(ip addr show $device | grep "inet\ " | sed -e 's/^\s\+inet\ //' | sed -e 's/\/.*//')
      if [ -n "$ip" ]; then
          devices_string+="$ip $device "
      fi
  done

  if [ -e $hosts_file ]
  then
      masters=$(cat $hosts_file | tr '\n' ' ')
  else
      echo "No hosts file $hosts_file exists. Creating a default file containing localhost."
      masters="\"localhost\" \"(Local ROS master)\""
      echo $masters > $hosts_file
  fi


  master_whiptail=$(echo "whiptail --title \"ROS_MASTER_URI\" --nocancel --menu \"What is your ROS master?\" 20 70 10 $masters")


  master=$(eval ${master_whiptail} 2>&1 >/dev/tty)
  export ROS_MASTER_URI=http://$master:11311
  echo "Set ROS_MASTER_URI=$ROS_MASTER_URI"

  whiptail_cmd=$(echo "whiptail --title \"ROS_IP\" --nocancel --menu \"What is your ROS network device?\" 20 70 10 $devices_string")
  ip=$(eval ${whiptail_cmd} 2>&1 >/dev/tty)

  export ROS_IP=$ip
  echo "Set ROS_IP=$ROS_IP"
}

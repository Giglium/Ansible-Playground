#!/bin/bash

#
# Implemented command
#
ANSIBLE_COMMAND=(
	start
	stop
	run
	setup
	help
)

#
#	display help info
#
function help_info {
echo ""
echo "Choose a command typing: "
echo "	ansible [command]"
echo ""
echo "Avalidable commands are: "
for i in "${!ANSIBLE_COMMAND[@]}"
  do
    echo "	$i. ${ANSIBLE_COMMAND[$i]}"
  done
echo ""
}

#
# Check if the input command is the list
#
if [[ "${1}" ]]; then
  command="${1}"
  for i in "${!ANSIBLE_COMMAND[@]}";
    do
      if [[ $command == "${ANSIBLE_COMMAND[$i]}" ]]; then
	    command_name=${ANSIBLE_COMMAND[$i]};
	    break;
      fi
    done
fi

#
# Input command not implemented so I display helper
#
if [[ -z "${command_name}" ]]; then
  help_info;
  exit 1
fi
#
# Start Vagrant VM
#
if [[ $command == start ]]; then
  vagrant up
fi
#
# Shoutdown and destroy Vagrant VM
#
if [[ $command == stop ]]; then
	vagrant destroy
fi
#
# Run ansible playbook
#
if [[ $command == run ]]; then
	ansible-playbook -v main.yml
fi
#
# Set up the environment
#
if [[ $command == setup ]]; then
  ansible-galaxy role install -r requirements.yml
fi
#
# Display the helper
#
if [[ $command == help ]]; then
	help_info;
fi

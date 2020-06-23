#!/bin/bash

#
# Implemented command
#
ANSIBLE_COMMAND=(
	start
	stop
	run
	setup
	check
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
# Check the docker API connection
#
if [[ $command == check ]]; then
  for machine in machine1 machine2
  do
    echo "Ping $machine"
    curl https://$machine:2376/version \
      --cert ./roles/enable_docker_api/files/$machine-server-cert.pem \
      --key ./roles/enable_docker_api/files/$machine-server-key.pem \
      --cacert ./roles/enable_docker_api/files/$machine-ca.pem
  done
fi
#
# Inspect and Deploy a hello world service on swarm
#
if [[ $command == deploy ]]; then
  curl https://machine1:2376/swarm \
    --cert ./roles/enable_docker_api/files/machine1-server-cert.pem \
    --key ./roles/enable_docker_api/files/machine1-server-key.pem \
    --cacert ./roles/enable_docker_api/files/machine1-ca.pem
  curl https://machine1:2376/services/create \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"Name": "web","TaskTemplate": {"ContainerSpec": {"Image": "hello-world:latest"}}}' \
    --cert ./roles/enable_docker_api/files/machine1-server-cert.pem \
    --key ./roles/enable_docker_api/files/machine1-server-key.pem \
    --cacert ./roles/enable_docker_api/files/machine1-ca.pem
fi
#
# Display the helper
#
if [[ $command == help ]]; then
	help_info;
fi



# Ansible Playground

[![Build Status](https://travis-ci.org/Giglium/Ansible-Playground.svg?branch=master)](https://travis-ci.org/Giglium/Ansible-Playground) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/3ef31ac90852431a9b966360d44366d6)](https://www.codacy.com/manual/Giglium/Ansible-Playground?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Giglium/Ansible-Playground&amp;utm_campaign=Badge_Grade) 

## Goal

During this playground I'm going to:

* creating 2 CentOs VM to Provisioning (It's for running this playbook on a local environment);
* check the disk size on the VM and if this is lower to 40GB resize them;
* install Docker on the VM;
* configure Docker:
  * expose the docker API;
  * run docker on system startup;
*  create a Docker swarm.

##  Prerequisites

- [Ansible](https://www.ansible.com/)
- [Vagrant](https://www.vagrantup.com/) (Optionally, for run locally the playground)
- [Vagrant plugin Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) (Optionally, for less manual work)

## Usage

```bash
#
# Setup the enviroment and download all the role from Ansible Galaxy
#docker_cert_ca_path
./ansible.sh setup
#
# Starting the Vagrant VM
#
./ansible.sh start
#
# Run Ansible playbookinstadheck the connection with the docker API 
#
./ansible.sh run
#
# Check the connection with the docker API 
#
./ansible.sh check
#
# Inspect and Deploy a hello world service on swarm
#
./ansible.sh deploy
#
#Shoutdown and destroy Vagrant heck the connection with the docker API VM
#
. ./ansible.sh stop
```

## Explanationheck the connection with the docker API 

### CentsOs VM

The two centOs VM used in this playground was created using [Vagrant](https://www.vagrantup.com/) and they are defined in the `VagrantFile`. I also suggest installing the Vagrant plugin [Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) so every time you boot or destroy a VM your `/etc/hosts` will have the host's name added or removed automatically, it's less time consuming but otherwise you need to do itinstad manually.

If you have two remote hosts, you want to run in on the localhost or you don't want to use [Vagrant](https://www.vagrantup.com/) you only need to update the `hosts` file of this playground heck the connection with the docker API removing `machine1` and `machine2` and adding your machine under the `[centOs]` group.

> For accessing throw ssh, without using [Vagrant](https://www.vagrantup.com/), to the created VM I copy the `ssh_public_hey` from the local machine to the two VM. This script was founded on [StackOverflow](https://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm) and it isn't idempotent so it will add a line at every provision, but since this is out of the scope of this playground. So be careless if you are going to use them for other purposes.heck the connection with the docker API 

> For connecting more easily to the VM I have added the following line: `ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null'` to the `[centOS]` group. Remember to remove or comment this line if you connect to a remote to avoid man in the middle attack

### Check Disk

With this role, Ansible is going to check if the total size of the given partition has enough space to install Docker lately. For doing this it loops inside the `ansible_mounts` variable searching for the given partition and checking is size, storing the results of this operation on the variable `disk_free`.

heck the connection with the docker API If the check fails firstly it will install lvm2 (if it isn't already installed)  to be sure of having all the tools for the resizing.

Secondly, it calls [fsadm](https://www.systutorials.com/docs/linux/man/8-fsadm/) to resize the file system for us.

### Install Docker

For installing Docker I've decided to use an out of the box implementation available on [Ansible Galaxy](https://galaxy.ansible.com). My choice was for [Geerlingguy](https://galaxy.ansible.com/geerlingguy/docker) role because he has a high rating, it supports CentOs operation system and it covers our needs.

With this role will also install *Docker-Compose* but since this program is not needed I have decided to set the `docker_install_compose` to `false` so the role will not install it. Feel free to change this variable if you want to play with docker-compose.

> I've also decided to expose the variable `docker_users` that is useful if you want to add some user in the docker group. For this playground, I don't need it but feel free to change this variable if you need it.

### Configure Docker

#### Docker on Startup

[Geerlingguy](https://galaxy.ansible.com/geerlingguy/docker) role will ensure that Docker is started and enabled at boot, so we don't have to do anything.

#### Expose the docker API

In order to complete this task, I've followed this [guide](https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd) and so I've created the role `enable_docker_api` that creates a configuration file that overrides the docker configuration and it will expose the API on port `2376`. To secure the communication between a client and the server I've allows all the connections from clients authenticated by a certificate. For this reason, the `enable_docker_api` roles will also copy all the certificates for each machine.

> The self-signed certificate provided in this repo is generated with [OMGWTFSSL](https://github.com/paulczar/omgwtfssl) please don't use them with remote hosts. 

### Create a docker Swarm

For installing Docker I've decided to use an out of the box implementation available on [Ansible Galaxy](https://galaxy.ansible.com). My choice was for [thomasjpfan](https://galaxy.ansible.com/thomasjpfan/docker-swarm) role because he has a high rating.
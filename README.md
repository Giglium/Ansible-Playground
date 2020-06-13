# Ansible Playground

[![Build Status](https://travis-ci.org/Giglium/Ansible-Playground.svg?branch=master)](https://travis-ci.org/Giglium/Ansible-Playground) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/3ef31ac90852431a9b966360d44366d6)](https://www.codacy.com/manual/Giglium/Ansible-Playground?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Giglium/Ansible-Playground&amp;utm_campaign=Badge_Grade) 

## Goal

During this playground I'm going to:

* Creating 2 CentOs VM to Provisioning (It's for running this playbook on a local environment);
* ~~Check the disk size on the VM, if this is lower to 40GB resize them~~;
* ~~Setup Docker on the VM~~;
* ~~Docker Configuration~~:
  * ~~expose the docker API~~;
  * ~~run docker on system startup~~;
*  ~~Create a Docker swarm~~.

##  Prerequisites

- [Ansible](https://www.ansible.com/)
- [Vagrant](https://www.vagrantup.com/) (Optionally, for run locally the playground)
- [Vagrant plugin Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) (Optionally, for less manual work)

## Usage

```bash
# Starting the Vagrant VM

./ansible.sh start

#Shoutdown and destroy Vagrant VM

. ./ansible.sh stop
```

## CentsOs VM

The two centOs VM used in this playground was created using [Vagrant](https://www.vagrantup.com/) and they are defined in the `VagrantFile`. I also suggest installing the Vagrant plugin [Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) so every time you boot or destroy a VM your `/etc/hosts` will have the host's name added or removed automatically, it's less time consuming but otherwise you need to do it manually.

If you have two remote hosts, you want to run in on the localhost or you don't want to use [Vagrant](https://www.vagrantup.com/) you only need to update the `hosts` file of this playground removing `machine1` and `machine2` and adding your machine under the `[centOs]` group.

> For accessing throw ssh, without using [Vagrant](https://www.vagrantup.com/), to the created VM I copy the `ssh_public_hey` from the local machine to the two VM. This script was founded on [StackOverflow](https://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm) and it isn't idempotent so it will add a line at every provision, but since this is out of the scope of this playground. So be careless if you are going to use them for other purposes.


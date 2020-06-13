VAGRANTFILE_API_VERSION = "2"
# VM Operating System
OP = "centos/7"
# Number of VM to create
N = 2


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = OP

  (1..N).each do |machine_id|
    config.vm.define "machine#{machine_id}" do |machine|
      machine.vm.hostname = "machine#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.77.#{20+machine_id}"

      # Add public key to the VM for ssh access without using vagrant
      config.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        SHELL
      end

    end
  end

end

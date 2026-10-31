PUB_KEY = File.read(File.expand_path("~/.ssh/id_ed25519.pub")).strip

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
  end

  config.vm.define "cloudServer" do |machine|
    machine.vm.hostname = "cloudServer"
    machine.vm.network "private_network", ip: "192.168.56.99"

    # Add this host's public key to the vagrant user, so Ansible can SSH in.
    # grep first: running the provisioner again does not add the key twice.
    machine.vm.provision "shell", inline: <<-SHELL
      AUTH=/home/vagrant/.ssh/authorized_keys
      grep -qxF "#{PUB_KEY}" "$AUTH" || echo "#{PUB_KEY}" >> "$AUTH"
    SHELL
  end
end

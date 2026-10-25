Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2096
    v.cpus=4
  end

  config.vm.define "cloudServer" do |machine|
    machine.vm.hostname = 'cloudServer'
    machine.vm.network 'private_network', ip: "192.168.56.99"
  end
end
Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-7.2-64-nocm"
  config.vm.provider "virtualbox" do |vb|
     vb.cpus = "2"
     vb.customize ["modifyvm", :id, "--ioapic", "on"]
     vb.memory = "4096"
   end
  config.vm.provision :shell, path: "bootstrap.sh"
end

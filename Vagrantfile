Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 8282
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.synced_folder ".", "/vagrant"
  config.vm.network "private_network", ip: "192.168.1.99"
end

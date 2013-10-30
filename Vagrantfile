Vagrant::Config.run do |config|
  config.vm.box = "raring"
  config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"
  config.vm.forward_port 8880, 8880
  config.vm.share_folder("vagrant-root", "/vagrant", ".")
  Vagrant::Config.run do |config|
    config.vm.customize ["modifyvm", :id, "--memory", 512]
  end
end

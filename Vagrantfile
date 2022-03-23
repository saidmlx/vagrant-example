Vagrant.configure("2") do |config|
  servers=[
      {
        :hostname => "Server3",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.1.86",
        :ssh_port => '2202'
      },
      {
        :hostname => "Server2",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.1.85",
        :ssh_port => '2201'
      },
      {
        :hostname => "Server1",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.1.84",
        :ssh_port => '2200'
      }
    ]

  servers.each do |machine|
      config.vm.define machine[:hostname] do |node|
          node.vm.box = machine[:box]
          node.vm.hostname = machine[:hostname]
          node.vm.network :public_network, ip: machine[:ip]
          node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
          node.vm.synced_folder "./data", "/home/vagrant/data"
          #node.vm.provision "shell", path: "provision.sh"
          node.vm.provision "shell" do |s|
            s.path = "provision.sh"
            s.args = [ machine[:ip],  machine[:hostname]]
          end
          node.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", 512]
              vb.customize ["modifyvm", :id, "--cpus", 1]
          end
      end
  end
end
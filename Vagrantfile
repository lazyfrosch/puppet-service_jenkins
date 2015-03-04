# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu-trusty-server-amd64'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.hostname = 'jenkins.example.org'

  config.vm.network :forwarded_port, id: 'http',    guest: 80,   host: 8080
  config.vm.network :forwarded_port, id: 'jenkins', guest: 8080, host: 8081

  # Only for local testing
  #config.vm.synced_folder "~/devel/puppet/modules", "/puppet"

  config.vm.provision 'puppet' do |puppet|
    puppet.options = '--show_diff'
    puppet.manifests_path = 'vagrant'
    # 1. use this option if you ran `rake spec_prep` before
    puppet.options += ' --modulepath /vagrant/spec/fixtures/modules'
    # 2. use this path if you have a work postfix with all required modules
    #puppet.module_path = '../'
    # 3. local testing
    #puppet.options += ' --modulepath /puppet/_env-service_jenkins'
  end

end

BOX_NAME =  ENV['BOX_NAME'] || "bento/ubuntu-16.04"
CLUSTER_HOSTS = ENV['CLUSTER_HOSTS'] || "vagrant_hosts"
VAGRANTFILE_API_VERSION = "2"

$num_consul_instances = 3
$num_vault_instances = 1

Vagrant.require_version ">= 1.9.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    CONSUL_IFACE = "eth1"
    # Configure 3 Consul nodes
    (1..$num_consul_instances).each do |i|
        config.vm.define vm_name = "consul%1d" % [i] do |config|
            config.vm.box = BOX_NAME
            config.ssh.shell = "/bin/sh"
            config.ssh.forward_agent = true
            config.vm.network :private_network, ip: "10.1.42.10%1d"  % [i]
            config.vm.hostname = vm_name
            config.vm.provider "virtualbox" do |v|
                v.name = "consul-node%1d"  % [i]
                v.customize ["modifyvm", :id, "--memory", "1024"]
                v.customize ["modifyvm", :id, "--ioapic", "on"]
                v.customize ["modifyvm", :id, "--cpus", "2"]
                v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
                config.vm.post_up_message = "Consul server 3 spun up!\n\nAccess https://consul1.consul:8433/ui/ in a browser for Consul UI."
            end
            # config.vm.provision :hosts do |provisioner|
            #     provisioner.sync_hosts = false
            #     provisioner.add_host '10.1.42.101', ['consul1.consul']
            #     provisioner.add_host '10.1.42.102', ['consul2.consul']
            #     provisioner.add_host '10.1.42.103', ['consul3.consul']
            # end
            if i == $num_consul_instances
                config.vm.provision :ansible do |ansible|
                    ansible.inventory_path = CLUSTER_HOSTS
                    ansible.playbook = "consul.yml"
                    ansible.limit = "all"
                    compatibility_mode = "2.0"
                end
            end
        end
    end

    (1..$num_vault_instances).each do |i|
        config.vm.define vm_name = "vault%1d" % [i] do |config|
            config.vm.box = BOX_NAME
            config.ssh.shell = "/bin/sh"
            config.ssh.forward_agent = true
            config.vm.network :private_network, ip: "10.1.42.20%1d"  % [i]
            config.vm.hostname = vm_name
            config.vm.provider "virtualbox" do |v|
                v.name = "vault-node%1d"  % [i]
                v.customize ["modifyvm", :id, "--memory", "1024"]
                v.customize ["modifyvm", :id, "--ioapic", "on"]
                v.customize ["modifyvm", :id, "--cpus", "1"]
                v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
                config.vm.post_up_message = "vault server %1d spun up." % [i]
            end
            # config.vm.provision :hosts do |provisioner|
            #     provisioner.sync_hosts = false
            #     provisioner.add_host '10.1.42.101', ['consul1.consul']
            #     provisioner.add_host '10.1.42.102', ['consul2.consul']
            #     provisioner.add_host '10.1.42.103', ['consul3.consul']
            #     provisioner.add_host '10.1.42.201', ['vault1.consul']
            #     # provisioner.add_host '10.1.42.102', ['vault2.consul']
            # end
            if i == $num_vault_instances
                config.vm.provision :ansible do |ansible|
                    ansible.inventory_path = CLUSTER_HOSTS
                    ansible.playbook = "vault.yml"
                    ansible.limit = "all"
                    compatibility_mode = "2.0"
                end
            end
        end
    end

end

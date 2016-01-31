#Run updates
sudo yum update -y

#Install puppetserver
sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppetserver

#Configure hosts file and puppet.conf
sudo su
echo "dns_alt_names = puppet,puppet.localdomain" >> /etc/puppetlabs/puppet/puppet.conf
echo "127.0.0.1 puppet puppet.localdomain" >> /etc/hosts

#Start puppetserver
sudo service puppetserver start

#Install puppet module
sudo /opt/puppetlabs/bin/puppet module install evenup-puppet --version 0.6.0

#Configure hiera.yaml
echo "---" > /etc/puppetlabs/code/environments/production/hieradata/common.yaml
echo "puppet::runmode: 'service'" >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml
echo "puppet::manage_hiera: false" >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml
echo "puppet::dns_alt_names:" >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml
echo " - 'puppet'" >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml
echo " - 'puppet.localdomain'" >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml

#Configure manifest site.pp
echo "class testhiera {" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " \$test_runmode = hiera('puppet::runmode')" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " \$test_manage_hiera = hiera('puppet::manage_hiera')" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " \$test_dns_alt_names = hiera('puppet::dns_alt_names')" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " notify{\"Runmode: \${test_runmode}\": }" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " notify{\"Manage Hiera: \${test_manage_hiera}\": }" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " notify{\"DNS Alt Names: \${test_dns_alt_names}\": }" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "}" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "class { 'testhiera': }" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "class { 'puppet':" >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo " server => true," >> /etc/puppetlabs/code/environments/production/manifests/site.pp
echo "}" >> /etc/puppetlabs/code/environments/production/manifests/site.pp

#Run puppet agent
sudo /opt/puppetlabs/bin/puppet agent --test

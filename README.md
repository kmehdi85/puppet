puppet
======
1. Install Puppet agent using below command
    sudo apt-get install -y puppet
2. Clone the puppet-portia repository
   cd ~ && git clone https://github.com/kmehdi85/puppet.git 
3. To install portia run the puppet using below command
    sudo puppet apply ~/puppet/portia/manifests/site.pp --modulepath=~/puppet/portia/modules/ $*  --debug
4. Check for running portia in browser using url
    http://localhost:9001/static/main.html


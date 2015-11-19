# vagrant-lamp-bootstrap

This package is put together as a simple way to quickly launch customized local php development 
environments using vagrant and virtualbox.  

### Quick Start

1. Clone repo to your local machine
2. Duplicate /system_files/config_sample.yml to /system_files/config.yml
3. Customise config.yml as needed
4. Run vagrant up
5. Add a hosts entry pointing at 192.168.33.112 (or whatever )
6. Begin devlopment. The public html folder for the site will be added to the repo as /working_files/

### Basic Configuration

See comments in /system_files/config_sample.yml for full details. 

Notes

* The project folder shouldn't be changed unless .gitignore is updated to match
* IP address should be unique to each local vagrant box. 
* Updating the values for the project database will not wipe out old values when provisioning. 
  So if the database name changes, the user will have access to both repos. If the user changes, they will not have access to the old databases, but the original user will still be there.
* Changing the ip_address doesn't update when simply running vagrant provision on a running machine

### Advanced Configuration

Beyond the basic config file, there are several other items that can be tweaked to customize the machine.  

#### Modifying the packages installed

Inside of /system_files/bootstrap.sh are a whole lot of php and apache modules that are commented out. 
Simply change the commenting to match what you need explicitly. 

If extra packages that aren't listed need to be installed, simply add a sudo apt-get install as needed.
It's recommended these are kept to a single item per install on most machines, for ease of reading and
debugging. However, if the setup is known and people won't be changing it, they can be consolidated. Just
make sure that the order things are added doesn't interfere with the entire flow of the document.

#### Customize php.ini files

Within /system_files/php5/ there are folders containing some opinionated (and probably insecure) php.ini
files that match my usual dev needs. These are copied to the correct locations in /etc/php5/ on each provision.
If there are specific settings that you need, simply put them here.

#### Customize apache config

Like the php.ini customizations, it's possible to completely customize the apache config as needed.
If use_custom_hostfile is set to true in the config.yml, then /system_files/apache2/custom_hostfile.conf
will be copied to the right place in /etc/apache2 to be used as the default. 

This will only copy the one file, so if you have multiple vhosts that need to be set up, they will all need to
be written together. Improper configuration here can prevent the site from being accessible in your local
browser. 

### Limitations

### TODO / Roadmap

### Credits

The basis for this project came from Chris / panique's great work. Their repo was invaluable in learning
how everything fit together using Vagrant

http://www.dev-metal.com/super-simple-vagrant-lamp-stack-bootstrap-installable-one-command/
https://github.com/panique/vagrant-lamp-bootstrap
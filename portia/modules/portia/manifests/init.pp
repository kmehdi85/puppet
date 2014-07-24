
class portia { 
   exec { "update-apt":
        command => "sudo /usr/bin/apt-get update",
    }

    # Let's install the dependecies
    package {
        ["python-pip", "python-dev", "libxml2-dev", "libxslt1-dev", "libffi-dev", "libssl-dev"]:
        ensure => installed,
        require => Exec['update-apt'] # The system update needs to run first
    }


$portia_dir = "/portia"

file { $portia_dir:
	ensure => directory,
	mode   => '0777',
}

	exec { "clone":
		unless => ["test -f /portia/slyd.conf"],
		command => "git clone https://github.com/scrapinghub/portia.git $portia_dir",
		require => File[$portia_dir]
	}

file {"$portia_dir/install_venv.sh":
	ensure => present,
	mode => '0777',
	source => 'puppet:///modules/portia/install_venv.sh'
}

exec { "install_venv":
	command => "/bin/bash $portia_dir/install_venv.sh",
	require => File["$portia_dir/install_venv.sh"] 
}


## Let's install the project dependecies from pip
    exec { "pip-install-requirements":
	cwd => '/portia/slyd',
	require => Exec["install_venv"],
	#onlyif => ["test -d /portia/venv"]
        command => '/bin/bash -c "source /portia/venv/bin/activate && /usr/bin/pip install -r requirements.txt"',
	user => 'root',
        tries => 2,
#        timeout => 600, # Too long, but this can take awhile
#        require => Package['python-pip', 'python-dev'], # The package dependecies needs to run first
        logoutput => on_failure,
    }


##Run Slyd
    exec { "run-slyd":
	require => Exec['pip-install-requirements'],
	cwd => '/portia/slyd',
        command => '/bin/bash -c "source /portia/venv/bin/activate && twistd -n slyd"',
	user => 'root',
        logoutput => on_failure
	}

}



class spacewalk::osad {
	package { "osad" :
		ensure => installed,
		require => Class["spacewalk::client"]
	}

	file { "/etc/sysconfig/rhn/osad.conf" :
		require => Package["osad"],
	}

	replace { "osa_ssl_cert" :
		file => "/etc/sysconfig/rhn/osad.conf",
		pattern => "^osa_ssl_cert.*",
		replacement => "osa_ssl_cert = \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT",
		require => File["/etc/sysconfig/rhn/osad.conf"]
	}

	service { "osad" :
		enable => true,
		ensure => true,
		require => File["/etc/sysconfig/rhn/osad.conf"],
		subscribe => [File["/etc/sysconfig/rhn/osad.conf"],
			      Replace['osa_ssl_cert'],
			     ],
	}

	cron { "osad_restart" :
		command => "/sbin/service osad restart > /dev/null",
		user => "root",
		hour => 0,
		minute => 0,
	}

	exec { "rhn-actions-control_enable-all" :
		command => "rhn-actions-control -f --enable-all",
		onlyif => "rhn-actions-control --report| grep disabled",
		require => File["/etc/sysconfig/rhn/osad.conf"],
	}
}

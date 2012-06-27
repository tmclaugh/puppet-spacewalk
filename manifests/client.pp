
class spacewalk::client ($host, $keys) {
	# This way we can easilly switch between osad and rhnsd.
	include spacewalk::osad

	package { "rhn-setup" :
		ensure => present,
	}


	exec { "spacewalk_join" :
		command => "rhnreg_ks --serverUrl=https://${host}/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=${keys} --profilename=$::fqdn",
		unless => "rhn-profile-sync",
		require => Package["rhn-setup"],
	}
}

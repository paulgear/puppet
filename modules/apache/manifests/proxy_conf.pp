# puppet module to manage autoproxy server with apache

define apache::proxy_conf(
	$domain,
	$email
) {
	include apache::package
	include apache::service
	$dir = $operatingsystem ? {
		CentOS	=> "/etc/httpd/conf.d",
		default	=> "/etc/apache2/sites-enabled",
	}
	$proxy_conf_dir = $operatingsystem ? {
		CentOS	=> "/var/www/html/proxy-conf",
		default	=> "/srv/www/proxy-conf",
	}
	file { $proxy_conf_dir:
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		require	=> Class["apache::package"],
	}
	file { "$dir/wpad-proxy.conf":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require	=> [ Class["apache::package"], File["$proxy_conf_dir"] ],
		notify	=> Class["apache::service"],
		content	=> "# Managed by puppet on $servername - do not edit here
NameVirtualHost *:80
<VirtualHost *:80>
ServerAdmin $email
VirtualDocumentRoot $proxy_conf_dir
ServerName wpad.$domain
ServerAlias wpad
ServerAlias proxy.$domain
ServerAlias proxy
</VirtualHost>
		",
	}
}


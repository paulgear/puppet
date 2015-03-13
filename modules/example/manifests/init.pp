define example::one (
    $string
) {
    file { "/tmp/$name":
	contents => $string,
    }
}

class example::setup {
    $examples = hiera('example::one', {})
    create_resources('example::one', $examples['catalog'][$fqdn])
}

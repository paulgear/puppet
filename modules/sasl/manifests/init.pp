# puppet class to configure sasl

class sasl {
	include sasl::package
	include sasl::service
}


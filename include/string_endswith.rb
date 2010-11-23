# Extend system String class with some Ruby 1.9-like functionality

class String

	def endswith( otherstring )
		return rindex(otherstring) == length() - 1
	end

end


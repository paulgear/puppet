# first two functions come from
# http://www.debian-administration.org/articles/528
#
# Original license unknown
# Additions and updates Copyright (c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>
# Released under GPLv3

class text {

	$safe_path = "/usr/bin:/bin:/usr/sbin:/sbin"

	# add the line to the file if it is not already present
	define append_if_no_such_line($file, $line, $refreshonly = 'false') {
		exec { "/bin/echo '$line' >> '$file'":
			unless		=> "/bin/grep -Fxqe '$line' '$file'",
			path		=> $text::safe_path,
			refreshonly	=> $refreshonly,
		}
	}

	# delete all lines in a file matching the given pattern
	define delete_lines($file, $pattern) {
		exec { "sed -i -r -e '/$pattern/d' $file":
			path		=> $text::safe_path,
			onlyif		=> "/bin/grep -Ee '$pattern' '$file'",
		}
	}

	define comment_lines($file, $pattern) {
		exec { "sed -i -r -e 's/($pattern)/##Commented out by puppet## \\1/' $file":
			path		=> $text::safe_path,
			onlyif		=> "/bin/grep -Ee '$pattern' '$file'",
		}
	}

	# Use $optimise to reduce the noise of running this exec when there is no need.
	# The main reason you might use this is if the pattern matches the replace.
	define replace_lines($file, $pattern, $replace, $optimise = 0) {
		$unless = $optimise ? {
			/(no|off|false|0)/	=> "/bin/false",
			default			=> "/bin/grep -Ee '$replace' '$file'",
		}
		exec { "sed -i -r -e 's/$pattern/$replace/' $file":
			path		=> $text::safe_path,
			onlyif		=> "/bin/grep -Ee '$pattern' '$file'",
			unless		=> $unless,
		}
	}

	# replace or add the given line if it is not present in the file
	define replace_add_line($file, $pattern = undef, $line) {
		# replace the line if the pattern exists
		if $pattern {
			exec { "replace_add_line $line $file":
				command	=> "sed -i -r -e 's/$pattern/$line/' '$file'",
				path	=> $text::safe_path,
				onlyif	=> "/bin/grep -Ee '$pattern' '$file'",
				unless	=> "/bin/grep -Fqxe '$line' '$file'",
			}
		}
		# add the line if it doesn't exist
		append_if_no_such_line { "$file $line":
			file	=> $file,
			line	=> $line,
			require	=> Exec["replace_add_line $line $file"],
		}
	}

}


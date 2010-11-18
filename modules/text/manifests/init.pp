# first two functions come from
# http://www.debian-administration.org/articles/528
#
# License unknown

class text {

    define append_if_no_such_line($file, $line, $refreshonly = 'false') {
	exec { "/bin/echo '$line' >> '$file'":
	    unless		=> "/bin/grep -Fxqe '$line' '$file'",
	    path		=> "/bin",
	    refreshonly	=> $refreshonly,
	}
    }

    define delete_lines($file, $pattern) {
	exec { "sed -i -r -e '/$pattern/d' $file":
	    path	=> "/bin",
	    onlyif	=> "/bin/grep -E '$pattern' '$file'",
	}
    }

    define comment_lines($file, $pattern) {
	exec { "sed -i -r -e 's/($pattern)/##Commented out by puppet## \\1/' $file":
	    path	=> "/bin",
	    onlyif	=> "/bin/grep -E '$pattern' '$file'",
	}
    }

    # Use $optimise to reduce the noise of running this exec when there is no need.
    # The main reason you might use this is if the pattern matches the replace.
    define replace_lines($file, $pattern, $replace, $optimise = 0) {
	$unless = $optimise ? {
	    /(no|off|false|0)/	=> "/bin/false",
	    default		=> "/bin/grep -E '$replace' '$file'",
	}
	exec { "sed -i -r -e 's/$pattern/$replace/' $file":
	    path	=> "/bin",
	    onlyif	=> "/bin/grep -E '$pattern' '$file'",
	    unless	=> $unless,
	}
    }

}

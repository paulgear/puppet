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

    define replace_lines($file, $pattern, $replace) {
	exec { "sed -i -r -e 's/$pattern/$replace/' $file":
	    path	=> "/bin",
	    onlyif	=> "/bin/grep -E '$pattern' '$file'",
	}
    }

}

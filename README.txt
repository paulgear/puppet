LICENSE
-------

This is a collection of puppet modules focused on support of remote office Linux
servers.  The collection is tested only on Debian, CentOS, and Ubuntu Linux at
present.

    Copyright (c) 2010-2015 Gear Consulting Pty Ltd http://libertysys.com.au/

    Written by Paul Gear <github@libertysys.com.au>

    The latest version of these modules may be found at
	http://github.com/paulgear/puppet

Unless otherwise stated, all code and configuration in this repository ("this
program" below) is licensed under the GNU GPL v3:

This program is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

A copy of the GNU General Public License may be found in the file COPYING.txt at
the top of this repository.  See also http://www.gnu.org/licenses/gpl.html for full
license details.

ACKNOWLEDGEMENT
---------------

The kind support of Queensland Baptist Care http://www.qbc.com.au/ ICT Services
Manager, Rick Saul, in the development of these is gratefully acknowledged.
Without Rick's encouragement and commitment, most of this code would never have
been possible.

NOTES
-----

-   The modules as supplied may not be completely usable - some may depend on files
    which are not included in the repository.  These files should be supplied after
    the repository is cloned.  The following modules are known to be in a
    non-functional state:
    	modules/nut

-   The modules contained here may or may not adhere to best practices for the
    software in question.  In some cases this may be intentional; in others it may
    be due simply to ignorance or inattention to detail.  All suggestions for
    improvement will be gratefully accepted.

-   Some third-party code is used in the modules.  These modules are covered under
    a separate license - see the documentation in each module for details.
    Directories currently containing code covered under separate licenses are:
	modules/apt
	modules/logwatch
	modules/puppet-concat
	modules/resolver
	modules/sysctl
	modules/text
	modules/vmware


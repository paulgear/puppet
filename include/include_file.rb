
def include_file( name )
	# add the path separator if it's not already there
	templatedir = scope.lookupvar("templatedir")
	templatedir.concat("/") unless templatedir.endswith("/")

	includeheader = "#####\n# Included file: \n# " + templatedir + name + "\n#####\n"
	includefooter = "#####\n# End of included file: \n# " + templatedir + name + "\n#####\n"

	ret = "## " + templatedir + name

	if File.exists?( templatedir + name ) then
		return ret + "\n" + includeheader + IO.read( templatedir + name ) + includefooter
	else
		return ret + " not found\n"
	end
end


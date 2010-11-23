
def include_file( name )
	includeheader = "#####\n# Included file: \n# " + templatedir + name + "\n#####\n"
	includefooter = "#####\n# End of included file: \n# " + templatedir + name + "\n#####\n"

	# add the path separator if it's not already there
	templatedir.concat("/") unless templatedir.endswith("/")

	if File.exists?( templatedir + name ) then
		return	includeheader + IO.read( templatedir + name ) + includefooter
	else
		return "## " + templatedir + name + " not found\n"
	end
end


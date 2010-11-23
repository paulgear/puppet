
def include_file( name )
	# find templatedir variable; ensure it's set
	templatedir = scope.lookupvar("templatedir")
	if templatedir.empty? then
		Puppet.warning( "Template directory not set" )
		return nil
	end

	# add the path separator if it's not already there
	templatedir.concat("/") unless templatedir.endswith("/")

	filename = templatedir + name

	includeheader = "#####\n# Included file: \n# " + filename + "\n#####\n"
	includefooter = "#####\n# End of included file: \n# " + filename + "\n#####\n"

	if File.exists?( filename ) then
		return includeheader + IO.read( filename ) + includefooter
	else
		Puppet.notice( filename + " not found" )
		return nil
	end
end


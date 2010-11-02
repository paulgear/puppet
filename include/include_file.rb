
def include_file( name )
	includeheader = "#####\n# Included file: \n# " + templatedir + name + "\n#####\n"
	includefooter = "#####\n# End of included file: \n# " + templatedir + name + "\n#####\n"
	if File.exists?( templatedir + name ) then
		return	includeheader + IO.read( templatedir + name ) + includefooter
#	else
#		return "## " + templatedir + name + " not found\n"
	end
end


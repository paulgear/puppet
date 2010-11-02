############################################################################
#
# rsnapgraph makefile
# Denis McLaughlin
# March 31, 2005
#
###########################################################################

#PREFIX=/usr
PREFIX=/usr/local

EXE=rsnapgraph
BIN=$(PREFIX)/bin
ETC=/etc

install:
	cp $(EXE) $(BIN)/$(EXE)
	if test ! -e "$(ETC)/$(EXE).conf"; then cp $(EXE).conf $(ETC)/$(EXE).conf; else echo; echo "$(ETC)/$(EXE).conf detected, no changes made."; fi
	@echo
	@echo remember to set rootdir in $(ETC)/$(EXE).conf, or use -d!
	@echo '$(EXE) -h' to get help
	@echo

uninstall:
	rm -f $(BIN)/$(EXE)
	rm -f $(ETC)/$(EXE).conf

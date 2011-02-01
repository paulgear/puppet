FILES=whitelist_clients.local whitelist_recipients.local
VC=git --no-pager
CI=$(VC) commit -m'postgrey automatic checkpoint'

UPDATE:	$(FILES)
	service postgrey restart && touch $@
	-$(VC) diff .
	-$(CI) $(PWD)


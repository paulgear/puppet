PLAINTEXT=header-checks main.cf
SOURCES=header-checks sender-access transport virtual
DATABASES=sender-access.db transport.db virtual.db /etc/aliases.db
FILES=$(PLAINTEXT) $(DATABASES)
POSTMAP=postmap -v
PGREY=/etc/postgrey
VC=git --no-pager
CI=$(VC) commit -m'postfix automatic checkpoint'

UPDATE:	$(FILES)
	-make checkin
	postfix reload && touch $@

checkin:
	-$(VC) add $(PLAINTEXT)
	-$(VC) diff .
	-$(CI) $(PWD)

force:	force-aliases UPDATE

force-aliases:
	touch /etc/aliases

/etc/aliases.db:	/etc/aliases
	newaliases

sender-access.db:	sender-access
	$(POSTMAP) hash:$<

transport.db:	transport
	$(POSTMAP) $<

virtual.db:	virtual
	$(POSTMAP) $<


PLAINTEXT=header-checks main.cf
DATABASES=sender-access.db transport.db virtual.db /etc/aliases.db
FILES=$(PLAINTEXT) $(DATABASES)
PGDIR=/etc/postgrey
PGFILES=$(PGDIR)/whitelist_recipients.local $(PGDIR)/whitelist_clients.local
POSTMAP=postmap -v
VC=git --no-pager
CI=$(VC) commit -m'postfix automatic checkpoint'

UPDATE:	$(FILES) POSTGREY
	postfix reload && touch $@
	-$(VC) diff .
	-$(CI) $(PWD)

POSTGREY:	$(PGFILES)
	service postgrey restart && touch $@
	-$(VC) diff $(PGDIR)
	-$(CI) $(PGDIR)

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


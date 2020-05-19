prefix=/usr/local
bindir=$(prefix)/bin

SCRIPTS = \
	create-config-drive \
	virt-addr \
	virt-boot \
	virt-destroy \
	virt-disks \
	virt-from \
	virt-hosts \
	virt-interfaces \
	virt-ip \
	virt-list \
	virt-pick \
	virt-pick-vol \
	virt-query \
	virt-rename \
	virt-run \
	virt-ssh \
	virt-start \
	virt-stop \
	virt-vol \
	write-mime-multipart

all:

install: all
	install -m 755 -d $(DESTDIR)$(bindir)/
	install -m 755 $(SCRIPTS) $(DESTDIR)$(bindir)/


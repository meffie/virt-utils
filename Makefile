prefix=/usr/local
bindir=$(prefix)/bin

SCRIPTS = \
	create-config-drive \
	virsh-rename \
	virt-addr \
	virt-boot \
	virt-delete \
	virt-disks \
	virt-from \
	virt-hosts \
	virt-interfaces \
	virt-pick \
	virt-pick-vol \
	virt-query \
	virt-run \
	virt-ssh \
	virt-vol \
	write-mime-multipart

all:

install: all
	install -m 755 -d $(DESTDIR)$(bindir)/
	install -m 755 $(SCRIPTS) $(DESTDIR)$(bindir)/


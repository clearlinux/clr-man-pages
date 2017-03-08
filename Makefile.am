EXTRA_DIST = \
	README.rst \
	LICENSE \
	os-core.7 \
	os-core.7.rst \
	stateless.7 \
	stateless.7.rst

dist_man_MANS = \
	os-core.7 \
	stateless.7

clean-local:
	rm -f $(dist_man_MANS)

man: $(dist_man_MANS)

$(dist_man_MANS):
	rst2man.py $(patsubst %,%.rst,$@) > $@

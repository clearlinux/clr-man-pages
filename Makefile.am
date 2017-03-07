EXTRA_DIST = \
	README.md \
	LICENSE \
	os-core.7 \
	os-core.7.md \
	stateless.7 \
	stateless.7.md

dist_man_MANS = \
	os-core.7 \
	stateless.7

clean-local:
	rm -f $(dist_man_MANS)

man: $(dist_man_MANS)

$(dist_man_MANS):
	ronn -r $(patsubst %,%.md,$@)

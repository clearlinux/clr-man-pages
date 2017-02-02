EXTRA_DIST = \
	README.md \
	LICENSE \
	stateless.7 \
	stateless.7.md

dist_man_MANS = \
	stateless.7

all:
	@echo 'Run `make man` to regenerate roff man page files'

.PHONY: man
man:
	ronn stateless.7.md
	rm -f stateless.7.html

EXTRA_DIST = \
	README.md \
	LICENSE \
	stateless.1 \
	stateless.1.md

dist_man_MANS = \
	stateless.1

all:
	@echo 'Run `make man` to regenerate roff man page files'

.PHONY: man
man:
	ronn stateless.1.md
	rm -f stateless.1.html

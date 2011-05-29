.PHONY: mod hak

all: mod hak

mod:
	make -C mod all

hak:
	make -C hak all

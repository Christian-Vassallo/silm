.PHONY: mod hak tlk

all: mod hak tlk

mod:
	make -C mod all

hak:
	make -C hak all

tlk:
	make -C tlk all

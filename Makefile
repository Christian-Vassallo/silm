all: documentation

mod:
	make -C mod all

documentation:
	naturaldocs -o html generated-doc -i . \
		-xi generated-doc \
		-xi naturaldocs-project \
	-p naturaldocs-project

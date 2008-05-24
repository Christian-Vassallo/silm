all: documentation

mod:
	make -C mod all

documentation:
	naturaldocs -o framedhtml generated-doc -i . \
		-xi generated-doc \
		-xi naturaldocs-project \
		-xi build \
		-xi linnwnx2 \
	-s sternenfall -p naturaldocs-project

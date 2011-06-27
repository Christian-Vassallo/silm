all: client_2da client_cep2c client_merge client_portraits

.PHONY: client_2da client_cep2c client_merge client_portraits clean

client_2da:
	make -C client_2da all

client_cep2c:
	make -C client_cep2c all

client_merge:
	make -C client_merge all

client_portraits:
	make -C client_portraits all

clean:
	make -C client_2da clean
	make -C client_cep2c clean
	make -C client_merge clean
	make -C client_portraits clean

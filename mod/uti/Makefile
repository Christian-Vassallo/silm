
all: clean_recipes recipes

# Generates new recipe items from database

clean: clean_recipes

clean_recipes:
	-rm cp_[0-9]*.uti

recipes:
	../../buildutil/gen_recipes.rb ../../database.yaml .

deploy:
	rsync -Pdu --include \*.uti --delete-after --exclude \* . $(NWNHOME)/res

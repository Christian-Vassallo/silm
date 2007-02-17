class CraftController < ApplicationController
	before_filter :authenticate
	before_filter :enter_details
	before_filter :authenticate_craft_view, :only => %w{index spell}
	before_filter :authenticate_craft_admin, :only => %w{new show kill skill}

	def enchant
	end

	def spell	
		rspell = params['spell'] || -1
		rspell = rspell.to_i

		spellIDs = []
		for i in 0..9 do
			spellIDs << (params['spell_' + i.to_s] != nil ? params['spell_' + i.to_s].to_i : -1)
		end
		s = 0
		names = []
		max = 2048

		for i in 0..9 do
			break if spellIDs[i] < 0
			names << SPELLS.index(spellIDs[i])
			s += (i * max) + spellIDs[i]
		end
		
		@names = names
		@spell = s

		if rspell > -1
			@rnames = ["1", "2"] 
		end
	end

	# Show a list of all recipes
	def index
		show_craft = params[:id].to_i
		@current_craft = show_craft

		session['last_show_craft'] = show_craft == 0 ? nil : show_craft

		@crafts = Craft.find(:all)

		@products = show_craft == 0 ?
			CraftingProduct.find(:all,
				:order => "cskill asc, cskill_min asc, cskill_max asc, name asc"
			#	, :group => 'cskill'
			) : CraftingProduct.find(:all,
				:conditions => ['cskill = ?', show_craft],
				:order => "cskill asc, cskill_min asc, cskill_max asc, name asc"
			#	, :group => 'cskill'
			)
	end

	# Show/set the skills for a specific character id
	def skill
		@skills = CraftingSkill.find(:all, :conditions => ['`character`=?', params['id']])
	end


	# show/edit a specific recipe
	def show
		@product = CraftingProduct.find(params[:id])

		last_show_craft = session['last_show_craft'] || 0
		
		save = params['product']

		if save && @product
			save.delete("id")
			save['ability'] = ABILITY[save['ability']]
			save['skill'] = SKILLS[save['skill']]
			save['feat'] = FEATS[save['feat']]
			# save['spell'] = SPELLS[save['spell']]
			# save['spell_fail'] = SPELLS[save['spell_fail']]
			save['cskill'] = Craft.find(:first, :conditions => ['name = ?', save['cskill']]).cskill

			
			if @product.update_attributes(save)
				flash[:notice] = "Saved."
				redirect_to :action => 'index', :id => last_show_craft
			else
				flash[:notice] = "Failed."
				flash[:errors] = @product.errors
			end
		end
	end

	def new
		pd = CraftingProduct.create(:cskill => 1)
		redirect_to :action => 'show', :id => pd.id
	end

	def kill
		CraftingProduct.delete(params[:id])
		last_show_craft = session['last_show_craft'] || 0
		redirect_to :action => 'index', :id => last_show_craft
	end

	def copy
		p = CraftingProduct.find(params[:id])
		if !p
			notice[:error] = "Cannot find ID #{params[:id]}"
			redirect_to :action => 'show', :id => params[:id]
		else
			cp = p.clone
			if !cp.save
				notice[:error] = "Error saving stuff"
				notice[:errors] = cp.errors
				redirect_to :action => 'show', :id => params[:id]
			else
				redirect_to :action => 'show', :id => cp['id']
			end
		end
	end

end

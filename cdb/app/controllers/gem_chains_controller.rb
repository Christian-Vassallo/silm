class GemChainsController < ApplicationController
	before_filter() {|c| c.authenticate(Account::CAN_SEE_LOOT_CHAINS) }
	before_filter(:only => %w{add kill}) {|c| c.authenticate(Account::CAN_EDIT_LOOT_CHAINS) }

	ORDER = "stone, area, `order` asc"

	def auto_complete_for_new_loot
		auto_complete_responder_for_resrefs(params[:new][:loot])
	end


	def index
		@new = GemChain::new
		@loot_chains = GemChain::find(:all, :order => ORDER)

		# Save any changes.
		if amask(Account::CAN_EDIT_LOOT_CHAINS) && params['loot_chains']
			params['loot_chains'].each do |k,l|
				ll = @loot_chains[k.to_i]
				ll.update_attributes(l)
				if !ll.save
					flash[:notice] = "Cannot save."
					flash[:errors] = lo.errors
					return
				end
			end
			flash[:notice] = "Created/saved."
		end

		if amask(Account::CAN_EDIT_LOOT_CHAINS) && params['new']
			n = GemChain::new(params['new'])
			# n.racial_type = -1 if n.racial_type == nil
			if !n.save
				flash[:notice] = "Cannot create new item."
				flash[:errors] = n.errors
				return
			end
			flash[:notice] = "Created/saved."
			@loot_chains = GemChain::find(:all, :order => ORDER)
		end
	end

	def kill
		id = params[:id]
		begin
			GemChain::delete(id)
		rescue
		end
		redirect_to :action => 'index', :controller => 'loot_chains'
	end

	private
	def auto_complete_responder_for_resrefs(ref)
		# resref => { :name }
		ref = ref.downcase
		@resrefs = CraftingProduct::RESREFS.reject{|resref,hash|
			resref.downcase !~ /^.*#{Regexp.escape(ref)}.*$/ && 
			(hash[:name] || "").downcase !~ /^.*#{Regexp.escape(ref)}.*$/
		}

		@resrefs = @resrefs.sort[0,15]

		render :partial => 'autocomplete/resref'
	end

end

class LootChainsController < ApplicationController
	before_filter() {|c| c.authenticate(Account::CAN_SEE_LOOT_CHAINS) }
	before_filter(:only => %w{add kill}) {|c| c.authenticate(Account::CAN_EDIT_LOOT_CHAINS) }

	def index
		@loot_chains = Loot::find(:all, :order => 'base, tag, resref asc')

		# Save any changes.
		if amask(Account::CAN_EDIT_LOOT_CHAINS) && params['loot_chains']
			params['loot_chains'].each do |k,l|
				ll = @loot_chains[k.to_i]
				if !ll || ll['id'].to_i != l['id'].to_i
					flash[:notice] = "ID difference. Stop fooling around."
				else
					li.update_attributes(l)
					if !li.save
						flash[:notice] = "Cannot save."
						flash[:errors] = lo.errors
						return
					end
				end
			end
			flash[:notice] = "Created/saved."
		end

		if amask(Account::CAN_EDIT_LOOT_CHAINS) && params['new'] &&
				(params['new']['resref'] != "" || params['new']['base'] != 0 ||
				 params['new']['tag'] != "") && params['new']['loot'] != ""
			n = Loot::new(params['new'])
			n.base = 0 if n.base == nil
			if !n.save
				flash[:notice] = "Cannot create new item."
				flash[:errors] = n.errors
				return
			end
			flash[:notice] = "Created/saved."
			@loot_chains = Loot::find(:all, :order => 'base, tag, resref asc')
		end
	end

	def kill
		id = params[:id]
		begin
			Loot::delete(id)
		rescue
		end
		redirect_to :action => 'index', :controller => 'loot_chains'
	end

end

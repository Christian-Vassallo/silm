class LootChainsController < ApplicationController
	before_filter() {|c| c.authenticate(Account::CAN_SEE_LOOT_CHAINS) }
	before_filter(:only => %w{add kill}) {|c| c.authenticate(Account::CAN_EDIT_LOOT_CHAINS) }

	def index
		@new = Loot::new
		@loot_chains = Loot::find(:all, :order => 'racial_type, tag, resref asc')

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

		if amask(Account::CAN_EDIT_LOOT_CHAINS) && params['new'] &&
				(params['new']['resref'] != "" || params['new']['racial_type'] != 0 ||
				 params['new']['tag'] != "") && params['new']['loot'] != ""
			n = Loot::new(params['new'])
			n.racial_type = -1 if n.racial_type == nil
			if !n.save
				flash[:notice] = "Cannot create new item."
				flash[:errors] = n.errors
				return
			end
			flash[:notice] = "Created/saved."
			@loot_chains = Loot::find(:all, :order => 'racial_type, tag, resref asc')
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

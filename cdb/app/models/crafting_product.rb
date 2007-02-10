class CraftingProduct < ActiveRecord::Base
	set_table_name "craft_prod"
	WORKPLACES = %w{
		hws_alchemie
		hws_arkanist
		
		hws_gaerfass
		
		hws_gerbbottich
		
		hws_werkbank
		hws_bogner
		
		hws_juwelier
		hws_juw_schleif
		
		hws_schmelzofen
		hws_schmiede

		hws_backofen
		hws_kochstelle
	} #.sort
	
	RESREFS = Marshal.load(File.new("/home/silm/cdb/app/resref.uti", "r"))

	
	def craft
		Craft.find(:first, :conditions => ['cskill = ?', self.cskill])
	end

	# Returns a string with all the required checks neat-o described
	def checks_s
		r = []
		if self['ability'].to_i != -1
			abi = S_ABILITY[self['ability'].to_i].to_s
			abi = abi == "" ? "<b>none</b>" : abi
			r << abi + ": " + self['ability_dc'].to_s
		end
		if self['skill'].to_i != -1
			r << SKILLS.index(self['skill']).to_s + ": " + self['skill_dc'].to_s
		end
		if self['feat'].to_i != -1
			r << FEATS.index(self['feat']).to_s
		end

		r.join("/")
	end

	def components_s
		r = []
		begin
			comp = self.components.split("#")
			ret = []
			r << "Reihenfolge:"
			comp.each do |n|
				ret << (RESREFS[n] ? RESREFS[n][:name] : "Unknown (%s)" % n)
			end

			r << ret.join(" # ")
			r << ""
			r << "Anzahl/Mengen (nicht Reihenfolge!):"
			all = Hash.new(0)
			ret.sort.each do |c|
				all[c] += 1
			end

			all.sort {|a,b| b[1] <=> a[1]}.each do |k,v|
				r << "%-2d %s" % [v,k]
			end

		rescue Exception => e
			r << e.to_s
		end
		
		r.join("\n")
	end

	def d_colour_s
		"#%.6x" % [d_colour == 0 ? 0xffffff : d_colour]
	end
	
	def d_colour_s= x
		d_colour = x[0,6].hex
	end
end

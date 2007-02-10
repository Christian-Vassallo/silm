class WeatherOverride < ActiveRecord::Base
	AREA_TYPES = %w{open river north desert indoor}
	
	WIND_TYPES = %w{fair varies severe}
	
	PREC_TYPES = %w{clear rain downpour snow sleet fog hail hsnow thunderstorm sandstorm}
	
	TEMP_TYPES = %w{xcold cold moderate warm hot vhot}

	def self.type_to_val(array, name)
		2 ** array.index(name)
	end

	def self.val_to_type(array, val)
		x = 0
		x += 1 while 2 ** x < val
		array[x]
	end
end

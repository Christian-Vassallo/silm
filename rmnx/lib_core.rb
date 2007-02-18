
class Array
	def index_of_range(val)
		i = 0
		for i in 0..self.size
			if (self[i].is_a?(Range) && self[i].to_a.index(val) != nil) ||
				(self[i].is_a?(Fixnum) && self[i] == val)
				return i
			end
		end
		return -1
	end
end

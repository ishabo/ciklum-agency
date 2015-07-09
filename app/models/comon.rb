class Comon 

	def self.hash_to_vars(hash_object, prefix = "_")
		hash_object.each do |key, val|
    	instance_variable_set(:"@#{prefix}#{key}", val)
    end
	end
end
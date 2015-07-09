module SecurityHelper
	def hash_string(string)
    	return Digest::SHA1.hexdigest (string)
 	end
end
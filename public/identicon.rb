class Identicon
	def initialize name
		@name = name
	end

	def hash=(hash)
		@hash = hash
	end

	def self.from_hash hash
		id = Identicon.new ""
		id.hash = hash

		id
	end

	def self.salt
		"salt"
	end

	def self.res
		4
	end

	# Returns a hash of the name
	# The number of characters in the hash should be 1 if divided by Identicon::res 3 times
	# And that should be hex
	def to_hash
		if defined? @hash
			@hash
		else
			Digest::SHA2.hexdigest(Identicon.salt + @name + Identicon.salt)
		end
	end

	# Returns a 3D boolean array of size res that represents this name
	def to_a(res = Identicon.res)
		#Distribute the hash over the dimensions
		ret = []
		hash = self.to_hash

		#Loop through x 0..res
		0.upto(res-1) do |x|
			x_partial = hash[x*((hash.length/res)-1)+x, hash.length/res]

			ret[x] = []

			#Loop through y 0..res
			0.upto(res-1) do |y|
				y_partial = x_partial[y*((x_partial.length/res)-1)+y, x_partial.length/res]

				ret[x][y] = []

				#Loop through z 0..res
				0.upto(res-1) do |z|
					z_partial = y_partial[z*((y_partial.length/res)-1)+z, y_partial.length/res]

					ret[x][y][z] = (z_partial.hex > 7 ? true : false)
				end
			end
		end

		ret
	end

	def to_png
		arr = self.to_a

		Icon.new(arr).to_png
	end

	def to_coord
		arr = self.to_a

		Icon::to_coords(arr)
	end
end
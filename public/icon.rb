# Represents the actual image on an identicon
class Icon
	def initialize arr
		@arr = arr
		@img = Magick::Image.new(Icon::res.x, Icon::res.y) {
			self.background_color = 'none'
		}

		block = Magick::Image.read("block.png")

		arr.each_index do |x|
			arr[x].each_index do |y|
				(arr_res-1).downto(0) do |z|
					#Draw the block on (x,y,z)
					if arr[x][y][z]
						#TODO: Only valid for y = z = 0, should correct to the left for other rows
						screen_x = (Icon::origin.x - Icon::block_size.x/2) + x * Icon::block_size.x/2 - y * Icon::block_size.x/2
						screen_y = (Icon::origin.y - Icon::block_size.y) - ((x+y+z*2) * Icon::block_size.y/4)

						@img.composite!(block[0], screen_x, screen_y, Magick::DstOverCompositeOp)
					end
				end
			end
		end

		back = Magick::Image.new(Icon::res.x, Icon::res.y) {
			self.background_color = Icon::background_color
		}

		@img.composite!(back, 0, 0, Magick::DstOverCompositeOp)
	end

	def self.to_coords arr
		ret = ""
		arr.each_index do |x|
			arr[x].each_index do |y|
				arr[y].each_index do |z|
					ret += "#{x},#{y},#{z}: #{arr[x][y][z]}\n"
				end
			end
		end

		ret
	end

	def arr_res
		@arr[0].length
	end

	def self.background_color
		'#fafafa'
	end

	def self.res
		Coord2d.new 189, 216
	end

	#Height of the front of the block (one face)
	def self.block_size
		Coord2d.new res.x/4.5, res.y/4.5
	end

	def self.origin
		Coord2d.new(res.x/2, res.y - block_size.y/2)
	end

	def to_png
		@img.format = "png"
		@img.to_blob
	end
end
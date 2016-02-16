module RubyTower

class RTPlatformStyle
		def initialize( color = "blue" )
			@left = Gosu::Image.new( "media/platformstyles/left_corner_#{color}.png", :tileable => true )
			@center = Gosu::Image.new( "media/platformstyles/center_#{color}.png",  :tileable => true ) 
			@right = Gosu::Image.new( "media/platformstyles/right_corner_#{color}.png", :tileable => true )

			puts "Loaded PlatformStyle: \n\t #{color} of size #{@left.width}x#{@left.height}\n\t #{color} of size #{@center.width}x#{@center.height}\n\t #{color} of size #{@right.width}x#{@right.height}"
		end

		# Draws platform starting at x, y 
		# Platform is at least 2 blocks wide - left + right corner
		# size - number of center blocks of the platform
		# width of the platform is always (64 + size * 32)
		def draw( x, y, size = 0)
			@left.draw(x, y, 0)

			(0..size-1).each do |i|
				@center.draw(x + @left.width + i*@center.width, y, 0)
			end unless size == 0
			@right.draw(x + @left.width + size*@center.width, y, 0 )
		end
	end

end
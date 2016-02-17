module RubyTower

	class RTPlatformStyle
		#@@sign = Gosu::Image.new( "media/platform/sign.png" )

		def sign
			@sign
		end

		def initialize( color = "blue", is_wide = false )
			@left = Gosu::Image.new( "#{MEDIA}/platformstyles/left_corner_#{color}.png", :tileable => true )
			@center = Gosu::Image.new( "#{MEDIA}/platformstyles/center_#{color}.png",  :tileable => true ) 
			@right = Gosu::Image.new( "#{MEDIA}/platformstyles/right_corner_#{color}.png", :tileable => true )
			@sign = Gosu::Image.new( "#{MEDIA}/platform/sign.png" )
			@is_wide = is_wide

			#puts "Loaded PlatformStyle: \n\t #{color} of size #{@left.width}x#{@left.height}\n\t #{color} of size #{@center.width}x#{@center.height}\n\t #{color} of size #{@right.width}x#{@right.height}"
		end

		# Draws platform starting at x, y 
		# Platform is at least 2 blocks wide - left + right corner
		# size - number of center blocks of the platform
		# width of the platform is always (64 + size * 32)
		def draw( x, y, size)
			offset = 0
			if !@is_wide
				@left.draw(x, y, ZOrder::Platforms)
				size -= 2
				offset = @left.width
			end

			(0..size-1).each do |i|
				@center.draw(x + offset + i*@center.width, y, ZOrder::Platforms)
			end unless size == 0

			@right.draw(x + offset + size*@center.width, y, ZOrder::Platforms) if !@is_wide
		end
	end
end
module RubyTower


	class RTTabStyle
		def initialize( color )
			@left = Gosu::Image.new("media/tab_left_#{color}.png", :tileable => true)
			@center = Gosu::Image.new("media/tab_center_#{color}.png", :tileable => true)
			@right = Gosu::Image.new("media/tab_right_#{color}.png", :tileable => true)
		end

		def width(size)
			@left.width + size*@center.width + @right.width
		end

		def height
			@left.height
		end

		def draw( x, y, sizef = 0 )
			size = sizef.ceil.to_i
			@left.draw(x, y, 0)

			(0..size-1).each do |i|
				@center.draw(x + @left.width + i*@center.width, y, 0)
			end unless size == 0
			@right.draw(x + @left.width + size*@center.width, y, 0 )
		end
	end

end
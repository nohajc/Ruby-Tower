module RubyTower
	class RTWall
		include RubyTower
		attr_accessor :image

		def initialize(win, x, y, w, h, ctype, image_path)
			@win = win
			@width = w
			@height = h
			@weight = 1000000
			@ctype = ctype
			@image = Gosu::Image.new(image_path)

			body = CP::Body.new(@weight, Float::INFINITY)
			hull = [vec(-w / 2, -h / 2), vec(-w / 2, h / 2), vec(w / 2, h / 2), vec(w / 2, -h / 2)]
			@shape = CP::Shape::Poly.new(body, hull, vec(w / 2, h / 2))
			@shape.collision_type = ctype

			@win.space.add_body(body)
			@win.space.add_shape(@shape)
			warp(vec(x, y))
			puts "t = #{@shape.bb.t}, b = #{@shape.bb.b}, l = #{@shape.bb.l}, r = #{@shape.bb.r}"
			@shape.body.apply_force(vec(0, -GRAVITY * @weight), vec(0, 0))
			@camera_y_last = @win.camera_y
		end

		def warp(vect)
			@shape.body.p = vect
		end

		def update
			@shape.body.p.y -= @win.camera_y - @camera_y_last
			@camera_y_last = @win.camera_y
		end

		def draw
			#Gosu::draw_rect(@shape.body.p.x, @shape.body.p.y + @win.camera_y, @width, @height, Gosu::Color.new(0xFFFFBC00), ZOrder::Platforms)
			@image.draw(@shape.body.p.x, @shape.body.p.y + @win.camera_y, ZOrder::Platforms)
		end
	end
end
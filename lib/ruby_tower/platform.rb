module RubyTower
	class RTPlatform
		include RubyTower
		attr_accessor :shape

		def initialize(win, x, y, w, h, ctype, pl_style)
			@win = win
			@width = w
			@height = h
			@weight = 1000000
			@ctype = ctype
			@pl_style = pl_style

			body = CP::Body.new(@weight, Float::INFINITY)
			hull = [vec(-w / 2 + 3, -h / 2), vec(-w / 2 + 3, h / 2), vec(w / 2 - 3, h / 2), vec(w / 2 - 3, -h / 2)]
			@shape = CP::Shape::Poly.new(body, hull, vec(w / 2 - 3, h / 2))
			@shape.collision_type = ctype

			@win.space.add_body(body)
			@win.space.add_shape(@shape)
			warp(vec(x + 3, y + 4))
			puts "t = #{@shape.bb.t}, b = #{@shape.bb.b}, l = #{@shape.bb.l}, r = #{@shape.bb.r}"
			@shape.body.apply_force(vec(0, -GRAVITY * @weight), vec(0, 0))
		end

		def warp(vect)
			@shape.body.p = vect
		end

		def draw
			#Gosu::draw_rect(@shape.body.p.x, @shape.body.p.y, @width, @height, Gosu::Color.new(0xFFFFBC00), ZOrder::Platforms)
			@pl_style.draw(@shape.body.p.x - 3, @shape.body.p.y - 4 + @win.camera_y, @width / PLAT_SEGM_WIDTH)
		end
	end
end
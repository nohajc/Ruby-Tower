module RubyTower
	class RTPlatform
		include RubyTower
		attr_accessor :shape, :label

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

			@label = nil
			@font = Gosu::Font.new(24)
		end

		def warp(vect)
			@shape.body.p = vect
		end

		def draw
			#Gosu::draw_rect(@shape.body.p.x, @shape.body.p.y, @width, @height, Gosu::Color.new(0xFFFFBC00), ZOrder::Platforms)
			@pl_style.draw(@shape.body.p.x - 3, @shape.body.p.y - 4 + @win.camera_y, @width / PLAT_SEGM_WIDTH)
			if @label != nil
				text_width = @font.text_width(@label)
				sx = @shape.body.p.x - 3 + 20
				sy = @shape.body.p.y - 4 + @win.camera_y + @height / 2 - @font.height / 2 - 40
				x = sx + 20 - text_width / 2
				y = sy + 6

				@pl_style.sign.draw(sx, sy, ZOrder::Platforms)
				[[1, 0], [-1, 0], [0, 1], [0, -1]].each do |i, j|
					@font.draw(@label, x + i, y + j, ZOrder::Platforms, 1.0, 1.0, 0xFF000000)
				end
				@font.draw(@label, x, y, ZOrder::Platforms, 1.0, 1.0, 0xFFFFFFFF)
			end
		end
	end
end
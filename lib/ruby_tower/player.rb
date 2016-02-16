module RubyTower
	class RTPlayer
		include RubyTower
		attr_accessor :shape, :onTheGround
		attr_reader :width, :height

		def initialize(win)
			@win = win
			@width = 32
			@height = 64
			body = CP::Body.new(10.0, 150.0)
			hull = [
				vec(-@width / 2, -@height / 2),
				vec(-@width / 2, @height / 2),
				vec(@width / 2, @height / 2),
				vec(@width / 2, -@height / 2)
			]
			@shape = CP::Shape::Poly.new(body, hull, vec(@width / 2, @height / 2))
			#@shape = CP::Shape::Circle.new(body, 22, vec(0, 0))
			@shape.collision_type = :cplayer
			@win.space.add_body(body)
			@win.space.add_shape(@shape)
			#@image = Gosu::Image.new(win, Circle.new(36), false)
			@onTheGround = false
			warp(vec(512, 384))
			puts "t = #{@shape.bb.t}, b = #{@shape.bb.b}, l = #{@shape.bb.l}, r = #{@shape.bb.r}"
		end

		def warp(vect)
			@shape.body.p = vect
		end

		def jump
			puts "JUMP"
			@onTheGround = false
			#@shape.body.v = vec(0, -200)
			@shape.body.apply_impulse(vec(0, -1500), vec(0, 0))
			@shape.body.apply_force(vec(0, GRAVITY * 10), vec(0, 0))
		end

		def goLeft
			#puts "LEFT"
			@shape.body.apply_impulse(vec(-4, 0), vec(0, 0))
		end

		def goRight
			#puts "RIGHT"
			@shape.body.apply_impulse(vec(4, 0), vec(0, 0))
		end

		def draw
			#@image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
			Gosu::draw_rect(@shape.body.p.x, @shape.body.p.y, @width, @height, Gosu::Color.new(0xFFFFFFFF), ZOrder::Player)
		end
	end
end
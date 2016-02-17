module RubyTower
	class RTPlayer
		include RubyTower
		attr_accessor :shape, :onTheGround, :impulse, :sound_impact
		attr_reader :width, :height, :weight

		def initialize(win)
			@win = win
			@width = 32
			@height = 32
			@weight = 10.0
			body = CP::Body.new(@weight, Float::INFINITY)
			hull = [
				vec(-@width / 2, -@height / 2),
				vec(-@width / 2, @height / 2),
				vec(@width / 2, @height / 2),
				vec(@width / 2, -@height / 2)
			]
			@shape = CP::Shape::Poly.new(body, hull, vec(@width / 2, @height / 2))
			#@shape = CP::Shape::Poly.new(body, hull, vec(0, 0))
			@shape.collision_type = :cplayer
			@win.space.add_body(body)
			@win.space.add_shape(@shape)
			#@image = Gosu::Image.new(win, Circle.new(36), false)
			@onTheGround = true
			warp(vec(512 - @width / 2, HEIGHT - PLAT_HEIGHT - @height + 4))
			#puts "t = #{@shape.bb.t}, b = #{@shape.bb.b}, l = #{@shape.bb.l}, r = #{@shape.bb.r}"
			@image = Gosu::Image.new("#{MEDIA}/character/cube_cute.png")
			@face = :right

			@impulse = 35
			init_sounds
		end

		def init_sounds
			@sound_impact = Gosu::Sample.new("#{MEDIA}/character/impact.wav")
		end

		def warp(vect)
			@shape.body.p = vect
		end

		def jump
			puts "JUMP"
			@onTheGround = false
			@shape.body.apply_impulse(vec(0, -1200 - 10 * @shape.body.v.x.abs), vec(0, 0))
			@shape.body.apply_force(vec(0, GRAVITY * 10), vec(0, 0))
		end

		def goLeft
			#puts "LEFT #{@impulse}"
			@shape.body.apply_impulse(vec(-@impulse / SUBSTEPS, 0), vec(0, 0))
			@impulse += 0.04
			@face = :left
		end

		def goRight
			#puts "RIGHT #{@impulse}"
			@shape.body.apply_impulse(vec(@impulse / SUBSTEPS, 0), vec(0, 0))
			@impulse += 0.04
			@face = :right
		end

		def stopLeft
			#puts "STOP LEFT"
			@shape.body.apply_impulse(vec(27 / SUBSTEPS, 0), vec(0, 0))
		end

		def stopRight
			#puts "STOP RIGHT"
			@shape.body.apply_impulse(vec(-27 / SUBSTEPS, 0), vec(0, 0))
		end

		def draw
			#Gosu::draw_rect(@shape.body.p.x, @shape.body.p.y, @width, @height, Gosu::Color.new(0xFFFFFFFF), ZOrder::Player)
			if @face == :right
				@image.draw(@shape.body.p.x, @shape.body.p.y + @win.camera_y, ZOrder::Player, 1.0, 1.0)
			else
				@image.draw(@shape.body.p.x + @width, @shape.body.p.y + @win.camera_y, ZOrder::Player, -1.0, 1.0)
			end
		end
	end
end
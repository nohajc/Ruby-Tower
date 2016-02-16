require "ruby_tower/player"
require "ruby_tower/platform"

module RubyTower
	def vec(x, y)
		CP::Vec2.new(x, y)
	end

	class RTGame
		include RubyTower

		def initialize(win)
			@win = win
			@wallWidth = 100
			@player = RTPlayer.new(@win)
			init_platforms

			@leftWall = RTPlatform.new(@win, 0, 0, @wallWidth, 736, :cwall)
			@rightWall = RTPlatform.new(@win, 924, 0, @wallWidth, 736, :cwall)

			@win.space.add_collision_func(:cplayer, :cplatform) do |player_shape, platform_shape|
				if player_shape.body.v.y > 0 && player_shape.body.p.y <= platform_shape.body.p.y - @player.height + 5
					#puts "DOWNWARD COLLISION!"
					player_shape.body.p.y = platform_shape.body.p.y - @player.height
					player_shape.body.reset_forces
					player_shape.body.apply_impulse(vec(0, -player_shape.body.v.y * @player.weight), vec(0, 0))
					player_shape.body.apply_force(vec(0, -GRAVITY * 10), vec(0, 0))
					@player.onTheGround = true
				end
			end

			@win.space.add_collision_func(:cplayer, :cwall) do |player_shape, wall_shape|
				puts "WALL COLLISION!"
				if player_shape.body.v.x > 0 # right wall
					player_shape.body.p.x = wall_shape.body.p.x - @player.width
				else # left wall
					player_shape.body.p.x = wall_shape.body.p.x + @wallWidth
				end
				player_shape.body.v.x = -player_shape.body.v.x # bounce
			end
		end

		def init_platforms
			@platforms = [RTPlatform.new(@win, 0, HEIGHT - 32, 1024, 32, :cplatform)]
			@platforms << RTPlatform.new(@win, 300, HEIGHT - 128, 128, 24, :cplatform)
			@platforms << RTPlatform.new(@win, 500, HEIGHT - 308, 240, 24, :cplatform)
		end

		def button_down(id)
			@win.switchTo(:leaderboard) if id == Gosu::KbS
			case id
			when Gosu::KbSpace, Gosu::KbUp
				@player.jump if @player.onTheGround
			when Gosu::KbEscape
				@win.close
			end
		end

		def update
			@win.caption = "Ruby Tower [Game]"
			SUBSTEPS.times do
				if Gosu::button_down? Gosu::KbLeft
					@player.goLeft
				elsif @player.shape.body.v.x < -0.1
					@player.stopLeft
				end


				if Gosu::button_down? Gosu::KbRight
					@player.goRight
				elsif @player.shape.body.v.x > 0.1
					@player.stopRight
				end

				if @player.shape.body.v.y > 0
					@player.onTheGround = false
				end

				@win.space.step(@win.dt)
				@player.shape.body.reset_forces
			end
		end

		def draw
			@player.draw
			@platforms.each{|p| p.draw}
			@leftWall.draw
			@rightWall.draw
		end
	end
end
require "ruby_tower/player"
require "ruby_tower/wall"
require "ruby_tower/platform"
require "ruby_tower/platformstyle"

module RubyTower
	def vec(x, y)
		CP::Vec2.new(x, y)
	end

	class RTGame
		include RubyTower

		def initialize(win)
			@win = win
			@wallWidth = 96
			@player = RTPlayer.new(@win)
			@game_over = false
			@font = Gosu::Font.new(64)

			@min_seg_num = 4
			@max_seg_num = 12
			@prng = Random.new
			init_platforms

			@leftWall = RTWall.new(@win, 0, 0, @wallWidth, 768, :cwall, "media/background/left.png")
			@rightWall = RTWall.new(@win, 928, 0, @wallWidth, 768, :cwall, "media/background/right.png")

			@win.space.add_collision_func(:cplayer, :cplatform) do |player_shape, platform_shape|
				if player_shape.body.v.y > 0 && player_shape.body.p.y <= platform_shape.body.p.y - @player.height + 5
					#puts "DOWNWARD COLLISION!"
					@player.sound_impact.play if @player.onTheGround == false
					player_shape.body.p.y = platform_shape.body.p.y - @player.height
					player_shape.body.reset_forces
					player_shape.body.apply_impulse(vec(0, -player_shape.body.v.y * @player.weight), vec(0, 0))
					player_shape.body.apply_force(vec(0, -GRAVITY * 10), vec(0, 0))
					@player.onTheGround = true

					if Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbUp)
						@player.jump
					end
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

			@background = Gosu::Image.new("media/background/back.png")
		end

		def rand_platform(floor_num, pl_style)
			x = @prng.rand((@wallWidth / PLAT_SEGM_WIDTH)..((WIDTH - @wallWidth) / PLAT_SEGM_WIDTH - @min_seg_num)) * PLAT_SEGM_WIDTH
			y = HEIGHT - floor_num * FLOOR_HEIGHT
			w = [@prng.rand(@min_seg_num..@max_seg_num) * PLAT_SEGM_WIDTH, (WIDTH - @wallWidth - x)].min
			h = PLAT_HEIGHT
			RTPlatform.new(@win, x, y, w, h, :cplatform, pl_style)
		end

		def init_platforms
			@platform_style = RTPlatformStyle.new
			@wplatform_style = RTPlatformStyle.new("blue", true)
			@platforms = []
			@platforms << RTPlatform.new(@win, @wallWidth, HEIGHT - PLAT_HEIGHT, WIDTH - 2 * @wallWidth, PLAT_HEIGHT, :cplatform, @wplatform_style)
			#@platforms << RTPlatform.new(@win, 300, HEIGHT - 128, 128, 24, :cplatform)
			#@platforms << RTPlatform.new(@win, 500, HEIGHT - 308, 240, 24, :cplatform)
			(1..500).each do |i|
				@platforms << rand_platform(i, @platform_style)
			end
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
					@player.impulse = 3.5
					@player.stopLeft
				end

				if Gosu::button_down? Gosu::KbRight
					@player.goRight
				elsif @player.shape.body.v.x > 0.1
					@player.impulse = 3.5
					@player.stopRight
				end

				if @player.shape.body.v.y > 5
					@player.onTheGround = false
				end

				@win.space.step(@win.dt)
				@player.shape.body.reset_forces

				#puts "player y = #{@player.shape.body.p.y + @win.camera_y}"
				camera_y = HEIGHT / 2 - @player.shape.body.p.y

				@win.camera_y = camera_y if camera_y > @win.camera_y
				@leftWall.update
				@rightWall.update

				if @player.shape.body.p.y + @win.camera_y > HEIGHT
					@game_over = true
				end
			end
		end

		def draw
			@background.draw(0, 0, ZOrder::Background)
			@player.draw
			@platforms.each{|p| p.draw}
			@leftWall.draw
			@rightWall.draw

			if @game_over
				text_width = @font.text_width("GAME_OVER")
				@font.draw("GAME OVER", WIDTH / 2 - text_width / 2, HEIGHT / 2 - @font.height, ZOrder::Overlay, 1.0, 1.0, 0xFFFFFFFF)
			end
		end
	end
end
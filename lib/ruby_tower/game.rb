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
			@min_seg_num = 4
			@max_seg_num = 12
			@player = RTPlayer.new(@win)
			@platforms = []
			@font = Gosu::Font.new(64)
			@score_font = Gosu::Font.new(32)
			@prng = Random.new

			load_images
			set_collision_callbacks

			@game_over = false
		end

		def reset
			@platforms.each do |p|
				@win.space.remove_body(p.shape.body)
				@win.space.remove_shape(p.shape)
			end
			@platforms.clear
			@win.camera_y = 0
			@player.reset_position

			@game_over = false
			init_platforms
			@highest_floor_reached = 0
		end

		def load_images
			@leftWall = RTWall.new(@win, 0, 0, @wallWidth, 768, :cwall, "#{MEDIA}/background/left.png")
			@rightWall = RTWall.new(@win, 928, 0, @wallWidth, 768, :cwall, "#{MEDIA}/background/right.png")
			@background = Gosu::Image.new("#{MEDIA}/background/back.png")
		end

		def set_collision_callbacks
			@win.space.add_collision_func(:cplayer, :cplatform) do |player_shape, platform_shape|
				if player_shape.body.v.y > 0 && player_shape.body.p.y <= platform_shape.body.p.y - @player.height + 5
					#puts "DOWNWARD COLLISION!"
					if @player.onTheGround == false
						@player.sound_impact.play
						current_floor = (player_shape.body.p.y - 4 - HEIGHT + PLAT_HEIGHT).abs.to_i / FLOOR_HEIGHT
						@highest_floor_reached = current_floor if current_floor > @highest_floor_reached
					end
					player_shape.body.p.y = platform_shape.body.p.y - @player.height
					player_shape.body.reset_forces
					player_shape.body.apply_impulse(vec(0, -player_shape.body.v.y * @player.weight), vec(0, 0))
					player_shape.body.apply_force(vec(0, -GRAVITY * 10), vec(0, 0))
					@player.onTheGround = true

					# rejump
					if Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbUp)
						@player.jump
					end
				end
			end

			@win.space.add_collision_func(:cplayer, :cwall) do |player_shape, wall_shape|
				#puts "WALL COLLISION!"
				if player_shape.body.v.x > 0 # right wall
					player_shape.body.p.x = wall_shape.body.p.x - @player.width
				else # left wall
					player_shape.body.p.x = wall_shape.body.p.x + @wallWidth
				end
				player_shape.body.v.x = -player_shape.body.v.x # bounce
			end
		end

		def wide_platform(floor_num, pl_style)
			y = HEIGHT - PLAT_HEIGHT - floor_num * FLOOR_HEIGHT
			RTPlatform.new(@win, @wallWidth, y, WIDTH - 2 * @wallWidth, PLAT_HEIGHT, :cplatform, pl_style)
		end

		def rand_platform(floor_num, pl_style)
			x = @prng.rand((@wallWidth / PLAT_SEGM_WIDTH)..((WIDTH - @wallWidth) / PLAT_SEGM_WIDTH - @min_seg_num)) * PLAT_SEGM_WIDTH
			y = HEIGHT - PLAT_HEIGHT - floor_num * FLOOR_HEIGHT
			w = [@prng.rand(@min_seg_num..@max_seg_num) * PLAT_SEGM_WIDTH, (WIDTH - @wallWidth - x)].min
			h = PLAT_HEIGHT
			RTPlatform.new(@win, x, y, w, h, :cplatform, pl_style)
		end

		def rand_platform_range(a, b)
			(a..b).each do |i|
				idx = @last_floor_generated + i
				style_idx = (idx / FLOOR_STYLE_CHANGE_RATE) % @platform_styles.length
				if idx % (FLOOR_STYLE_CHANGE_RATE / 2) == 0
					@platforms << wide_platform(idx, @wplatform_styles[style_idx])
				else
					@platforms << rand_platform(idx, @platform_styles[style_idx])
				end
				if idx % 10 == 0
					@platforms[-1].label = idx.to_s
				end
			end
			@last_floor_generated += b
		end

		def init_platforms
			@platform_styles = [
				RTPlatformStyle.new("grey"),
				RTPlatformStyle.new("blue"),
				RTPlatformStyle.new("green"),
				RTPlatformStyle.new("lime"),
				RTPlatformStyle.new("yellow"),
				RTPlatformStyle.new("red"),
				RTPlatformStyle.new("purple"),
				RTPlatformStyle.new("pink")
			]

			@wplatform_styles = [
				RTPlatformStyle.new("grey", true),
				RTPlatformStyle.new("blue", true),
				RTPlatformStyle.new("green", true),
				RTPlatformStyle.new("lime", true),
				RTPlatformStyle.new("yellow", true),
				RTPlatformStyle.new("red", true),
				RTPlatformStyle.new("purple", true),
				RTPlatformStyle.new("pink", true)
			]
			@platforms << wide_platform(0, @wplatform_styles[0])
			#@platforms << RTPlatform.new(@win, 300, HEIGHT - 128, 128, 24, :cplatform)
			#@platforms << RTPlatform.new(@win, 500, HEIGHT - 308, 240, 24, :cplatform)
			@last_floor_generated = 0
			rand_platform_range(1, 7)
		end

		def button_down(id)
			if @game_over
				case id
				when Gosu::KbReturn
					@win.contents[:leaderboard].addScore(@highest_floor_reached)
					@win.switchTo(:leaderboard)
				when Gosu::KbEscape
					@win.switchTo(:menu)
				end
			else
				case id
				when Gosu::KbSpace, Gosu::KbUp
					@player.jump if @player.onTheGround
				when Gosu::KbEscape
					@win.switchTo(:menu)
				end
			end
		end

		def update_platforms
			platforms_to_remove = 0
			@platforms.each do |p|
				if p.shape.body.p.y + @win.camera_y > HEIGHT
					@win.space.remove_body(p.shape.body)
					@win.space.remove_shape(p.shape)
					platforms_to_remove += 1
				end
			end

			@platforms.shift(platforms_to_remove)
			rand_platform_range(1, platforms_to_remove)
		end

		def update
			@win.caption = "Ruby Tower [Game]"
			SUBSTEPS.times do
				if Gosu::button_down? Gosu::KbLeft
					@player.goLeft
				elsif @player.shape.body.v.x < -0.1
					@player.impulse = 35
					@player.stopLeft
				end

				if Gosu::button_down? Gosu::KbRight
					@player.goRight
				elsif @player.shape.body.v.x > 0.1
					@player.impulse = 35
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

				update_platforms

				if @player.shape.body.p.y + @win.camera_y > HEIGHT
					@game_over = true
				end
			end
			#puts "FPS = #{Gosu::fps}"
		end

		def draw
			@background.draw(0, 0, ZOrder::Background)
			@player.draw
			@platforms.each{|p| p.draw}
			@leftWall.draw
			@rightWall.draw

			# Draw score with outline
			[[1, 0], [-1, 0], [0, 1], [0, -1]].each do |i, j|
				@score_font.draw(@highest_floor_reached.to_s, 6 + i, 2 + j, ZOrder::Overlay, 1.0, 1.0, 0xFF000000)
			end
			@score_font.draw(@highest_floor_reached.to_s, 6, 2, ZOrder::Overlay, 1.0, 1.0, 0xFFFFFFFF)

			if @game_over
				text_width = @font.text_width("GAME_OVER")
				@font.draw("GAME OVER", (WIDTH - text_width) / 2, HEIGHT / 2 - @font.height, ZOrder::Overlay, 1.0, 1.0, 0xFFFFFFFF)
				score_str = "score: #{@highest_floor_reached}"
				text_width = @font.text_width(score_str)
				@font.draw(score_str, (WIDTH - text_width) / 2, HEIGHT / 2, ZOrder::Overlay, 1.0, 1.0, 0xFFFFFFFF)
			end
		end
	end
end
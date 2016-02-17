require 'ruby_tower/tabstyle'

module RubyTower

	class RTMenuItem
		def initialize(x, y, text, active = false)
			@x = x
			@y = y


			@active = active
			@color_inactive = Gosu::Color.new(0xff00ffff)
			@color_active = Gosu::Color.new(0xffffff00)
			@text = text
			@color_text = Gosu::Color.new(0xff_000000)

			@active_tab = RTTabStyle.new("blue")
			@inactive_tab = RTTabStyle.new("ble")

			if active == true
				@tab = @active_tab
			else
				@tab = @inactive_tab
			end
			#@image = Gosu::Image.new(self, "")
			@font = Gosu::Font.new(20)

			@min_width = @font.text_width(@text)
		end

		def setActive
			@active = true
			@tab = @active_tab
		end

		def unsetActive
			@active = false
			@tab = @inactive_tab
		end

		def draw( size = 7 )

			@tab.draw(@x, @y, size)
			@font.draw( @text, @x+10, @y+20, 0, 1, 1, @color_text)
		end
	end


	class RTMenu
		def initialize(win)
			@win = win
			@items = Array.new

			@num_items = 0
			@active = 0
			@tab_width = 7 * 32 + 64
			add_item(WIDTH/2 - @tab_width/2, 100,  "New game", true)
			add_item(WIDTH/2 - @tab_width/2, 160,  "Leaderboard")
			add_item(WIDTH/2 - @tab_width/2, 220,  "Quit")

			@left = Gosu::Image.new("media/left2.png")
			@right = Gosu::Image.new("media/right2.png")
			@back = Gosu::Image.new("media/back.png")

			@beep = Gosu::Sample.new("media/button-46.wav")

			@sign = Gosu::Image.new("media/sign.png")
			@font = Gosu::Font.new(18)
			@color_text = Gosu::Color.new(0xff_000000)
			@num = 0

		end

		def add_item(x, y, text, active = false)
			item = RTMenuItem.new(x, y, text, active)
			@items << item
			@num_items += 1
			self
		end

		def mod(num)
			if(num < 0)
				num + @num_items # add module
			else
				num % @num_items 
			end
		end

		def selectActive
			case @active
			when 0  
				:game
			when 1 
				:leaderboard
			end
		end

		def button_down(id)
			case id
			when Gosu::KbS 
				@win.switchTo(:game)
			when Gosu::KbA 
				@rot = !@rot
			when Gosu::KbQ 
				@num += 1
			when Gosu::KbUp 
				@beep.play
				@items[@active].unsetActive
				@active = mod(@active - 1)
				@items[@active].setActive
			when Gosu::KbDown 
				@beep.play
				@items[@active].unsetActive
				@active = mod(@active + 1)
				@items[@active].setActive
			when Gosu::KbReturn
				if @active == 2
					@win.close
				else
				@win.switchTo(selectActive)
				end
			when Gosu::KbEscape
				@win.close
			else
				
			end
		end

		def update
			@win.caption = "Ruby Tower [Menu]"
		end



		def draw
			@back.draw(0,0,0)

			@items.each do |item|
				item.draw(7)
			end

			@left.draw( 0, 0, 0)
			@right.draw( WIDTH - 96, 0, 0)


			#@sign.draw(150, 50, 0)
			#@text_w = @font.text_width("#{@num}")

			#@font.draw( "#{@num}", 150 + @sign.width/2 - @text_w/2, 50 + @font.height/2, 0, 1, 1, @color_text)
		end
	end
end
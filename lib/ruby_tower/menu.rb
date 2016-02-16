module RubyTower

	class RTMenuItem
		def initialize(x, y, width, height, text, active = false)
			@x = x
			@y = y
			@width = width
			@height = height
			@active = active
			@color_inactive = Gosu::Color.new(0xff00ffff)
			@color_active = Gosu::Color.new(0xffffff00)
			@text = text
			@color_text = Gosu::Color.new(0xff_000000)

			if active == true
				@color = @color_active
			else
				@color = @color_inactive
			end
			#@image = Gosu::Image.new(self, "")
			@font = Gosu::Font.new(20)
		end

		def setActive
			@active = true
			@color = @color_active
		end

		def unsetActive
			@active = false
			@color = @color_inactive
		end

		def draw
			Gosu::draw_rect(@x, @y, @width, @height, @color,  0, :default)
			@font.draw( @text, @x+5, @y+5, 0, 1, 1, @color_text)
		end
	end


	class RTMenu
		def initialize(win)
			@win = win
			@items = Array.new
			@num_items = 0
			@active = 0
			add_item(WIDTH/2 - 150/2, 100, 150, 40, "New game", true)
			add_item(WIDTH/2 - 150/2, 150, 150, 40, "Leaderboard")
			add_item(WIDTH/2 - 150/2, 200, 150, 40, "Quit")
			
		end

		def add_item(x, y, width, height, text, active = false)
			item = RTMenuItem.new(x, y, width, height, text, active)
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
			when Gosu::KbUp 
				@items[@active].unsetActive
				@active = mod(@active - 1)
				@items[@active].setActive
			when Gosu::KbDown 
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
			@items.each do |item|
				item.draw
			end
		end
	end
end
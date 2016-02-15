module RubyTower
	class RTMenu
		def initialize(win)
			@win = win
		end

		def button_down(id)
			@win.switchTo(:game) if id == Gosu::KbS
		end

		def update
			@win.caption = "Ruby Tower [Menu]"
		end

		def draw
		end
	end
end
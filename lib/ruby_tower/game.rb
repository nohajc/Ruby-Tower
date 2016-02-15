module RubyTower
	class RTGame
		def initialize(win)
			@win = win
		end

		def button_down(id)
			@win.switchTo(:leaderboard) if id == Gosu::KbS
		end

		def update
			@win.caption = "Ruby Tower [Game]"
		end

		def draw
		end
	end
end
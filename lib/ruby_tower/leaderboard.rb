module RubyTower
	class RTLeaderBoard
		def initialize(win)
			@win = win
		end

		def button_down(id)
			@win.switchTo(:menu) if id == Gosu::KbS
		end

		def update
			@win.caption = "Ruby Tower [Leaderboard]"
		end

		def draw
		end
	end
end
require "gosu"
require "chipmunk"
require "ruby_tower/menu"
require "ruby_tower/game"
require "ruby_tower/leaderboard"

module RubyTower
	WIDTH = 1024
	HEIGHT = 768

	module ZOrder
		Background, Platforms, Player = *0..2
	end

	class RTWindow < Gosu::Window
		def initialize
			super WIDTH, HEIGHT
			self.caption = "Ruby Tower"

			@space = CP::Space.new
			@space.damping = 0.8

			@contents = {
				:menu => RTMenu.new(self),
				:game => RTGame.new(self),
				:leaderboard => RTLeaderBoard.new(self)
			}

			@current = @contents[:menu]
		end

		def switchTo(content)
			@current = @contents[content]
		end

		def button_down(id)
			@current.button_down(id)
		end

		def update
			@current.update
		end

		def draw
			@current.draw
		end
	end
end

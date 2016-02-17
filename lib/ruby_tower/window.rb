require "gosu"
require "chipmunk"
require "ruby_tower/menu"
require "ruby_tower/game"
require "ruby_tower/leaderboard"

module RubyTower
	WIDTH = 1024
	HEIGHT = 768
	SUBSTEPS = 10
	GRAVITY = 40
	PLAT_SEGM_WIDTH = 32
	PLAT_HEIGHT = 24
	FLOOR_HEIGHT = 100
	FLOOR_STYLE_CHANGE_RATE = 50

	module ZOrder
		Background, Platforms, Player, Overlay = *0..3
	end

	class RTWindow < Gosu::Window
		include RubyTower
		attr_accessor :space, :dt, :camera_y

		def initialize
			super WIDTH, HEIGHT
			self.caption = "Ruby Tower"
			puts MEDIA

			# Chipmunk properties
			@dt = (1.0 / (6 * SUBSTEPS))
			@space = CP::Space.new
			@space.damping = 0.8
			@space.gravity = vec(0, GRAVITY)

			@camera_y = 0

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

require 'ruby_tower/tabstyle'

module RubyTower


	class RTRecord
		def initialize(name, score, active = false)
			@name = name
			@score = score
			@y_origin = 100

			@height = 50

			@text_name = name
			@text_score = "#{score}"

			@color_text = Gosu::Color.new(0xff_000000)
			@font = Gosu::Font.new(20)

			@active = active

			@active_tab = RTTabStyle.new("blue")
			@inactive_tab = RTTabStyle.new("ble")

			if @active == true
				@tab = @active_tab
			else
				@tab = @inactive_tab
			end

			@gap_x = 5
			@name_x = WIDTH/2 - (@tab.width(7) + @tab.width(1))/2
			@score_x = @name_x + @tab.width(7) + @gap_x

		end

		def setActive
			@active = true
			@tab = @active_tab
		end

		def unsetActive
			@active = false
			@tab = @inactive_tab
		end

		def draw( pos )
			@tab.draw(@name_x, @y_origin + @height*pos + 5, 7)
			@tab.draw(@score_x, @y_origin + @height*pos + 5, 1)

			@text_w = @font.text_width(@text_score)
			@font.draw( @text_name, @name_x + 15, @y_origin + 10 + (@height*pos) + @font.height/2, 0, 1, 1, @color_text)
			@font.draw( @text_score, @score_x + @tab.width(1)/2 - @text_w/2, @y_origin + 10 + (@height*pos) + @font.height/2, 0, 1, 1, @color_text)
		end
	end

	class RTLeaderBoard
		def initialize(win)
			@win = win
			@board = Array.new
			@num_records = 0
			loadLeaderBoard

			@origin = 0
			@max_records = 10
			updateRange
			@beep = Gosu::Sample.new("media/button-46.wav")

			@left = Gosu::Image.new("media/left2.png")
			@right = Gosu::Image.new("media/right2.png")
			@back = Gosu::Image.new("media/back.png")

			@active = 0
			@board[@active].setActive
		end

		def updateRange
			if @num_records > @max_records
				@range = Range.new(@origin, @origin + @max_records - 1)
			else
				@range = Range.new(0, @num_records -1)
			end
			
		end

		def loadLeaderBoard
			file = File.open("saves/save1.rt", "r+")

			file.each_line do |line|
				splitted = line.split(';')
				record = RTRecord.new(splitted[0], splitted[1].to_i)
				@board << record
				@num_records += 1
			end

		end

		def button_down(id)
			case id
			when Gosu::KbBackspace
				@win.switchTo(:menu)
			when Gosu::KbDown 
				@beep.play
				@origin += 1 unless @num_records - 1 - @origin < @max_records 
				updateRange
				@board[@active].unsetActive

				@active = @active + 1 unless @active == @num_records - 1
				@board[@active].setActive
			when Gosu::KbUp 
				@beep.play
				@origin -= 1 unless @origin == 0
				updateRange

				@board[@active].unsetActive
				@active = @active - 1 unless @active == 0
				@board[@active].setActive
			when Gosu::KbEscape
				@win.close
			else
				
			end
		end

		def update
			@win.caption = "Ruby Tower [Leaderboard]"
		end

		def draw
			@back.draw(0, 0, 0)

			@board[@range].each_with_index do |record, i|
				record.draw(i)
			end

			@left.draw( 0, 0, 0)
			@right.draw( WIDTH - 96, 0, 0)
		end
	end
end
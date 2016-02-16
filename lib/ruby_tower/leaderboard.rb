module RubyTower

	class RTRecord
		def initialize(name, score)
			@name = name
			@score = score
			@x = WIDTH/2 - 300/2
			@y_origin = 100
			@width = 300
			@height = 40
			@color = Gosu::Color.new(0xffffff00)
			@text_name = name
			@text_score = "#{score}"
			@color_text = Gosu::Color.new(0xff_808080)
			@font = Gosu::Font.new(20)
		end

		def draw(pos)
			Gosu::draw_rect(@x, @y_origin + (@height*pos) + 5, @width, @height, @color,  0, :default)
			@font.draw( @text_name, @x+5, @y_origin+5 + (@height*pos) + 5, 0, 1, 1, @color_text)
			@font.draw( @text_score, @x+250, @y_origin+5 + (@height*pos) + 5, 0, 1, 1, @color_text)
		end


	end

	class RTLeaderBoard
		def initialize(win)
			@win = win
			@board = Array.new
			@num_records = 0
			loadLeaderBoard

			@origin = 0
			@max_records = 5
			updateRange
			@beep = Gosu::Sample.new("media/button-15.wav")
			
		end

		def updateRange
			if @num_records > @max_records
				@range = Range.new(@origin, @origin + @max_records - 1)
			else
				@range = Range.new(0, @num_records -1)
			end
			
		end

		def loadLeaderBoard
			file = File.open("bin/save1.rt", "r+")

			file.each_line do |line|
				splitted = line.split(' ')
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
			when Gosu::KbUp 
				@beep.play
				@origin -= 1 unless @origin == 0
				updateRange
			when Gosu::KbEscape
				@win.close
			else
				
			end
		end

		def update
			@win.caption = "Ruby Tower [Leaderboard]"
		end

		def draw
			@board[@range].each_with_index do |record, i|
				record.draw(i)
			end
		end
	end
end
require 'ruby_tower/tabstyle'

module RubyTower

	class RTRecord

		include Comparable
		include Enumerable

		def initialize( name, score, active = false)

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

			if name.empty?
				@input = true
			else
				@input = false
			end

			if @active == true
				@tab = @active_tab
			else
				@tab = @inactive_tab
			end

			@gap_x = 5
			@name_x = WIDTH/2 - (@tab.width(7) + @tab.width(1))/2
			@score_x = @name_x + @tab.width(7) + @gap_x

		end

		def <=> (other)
			if other.kind_of? RTRecord 
				@score <=> other.score
			else
				@score <=> other
			end
		end

		def updateText(text = "")
			@text_name = text
		end

		def setActive
			@active = true
			@tab = @active_tab
		end

		def unsetActive
			@active = false
			@tab = @inactive_tab
		end

		def to_s
			"#{@text_name};#{@text_score}"
		end

		def draw( pos, win )
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

			@color_text = Gosu::Color.new(0xff_000000)
			@font = Gosu::Font.new(20)

			@win.text_input = nil

			@beep = Gosu::Sample.new("#{MEDIA}/button-46.wav")

			@left = Gosu::Image.new("#{MEDIA}/background/left.png")
			@right = Gosu::Image.new("#{MEDIA}/background/right.png")
			@back = Gosu::Image.new("#{MEDIA}/background/back.png")

			@active = 0
			@board[@active].setActive
			@new = -2
			@input = false
		end

		def findPos( score )
			@board.find_index{|x| x <= score}

		end

		def addScore( score )
			pos = findPos( score )
			record = RTRecord.new("", score)

			@board[@active].unsetActive
			@board.insert(pos, record)
			@board[pos].setActive

			@num_records +=1
			@text = ""
			@new = pos
			@win.text_input = Gosu::TextInput.new
		end

		def updateRange
			if @num_records > @max_records
				@range = Range.new(@origin, @origin + @max_records - 1)
			else
				@range = Range.new(0, @num_records -1)
			end
			
		end

		def loadLeaderBoard
			file = File.open("#{SAVES}/save1.rt", "r+")

			file.each_line do |line|
				splitted = line.split(';')
				record = RTRecord.new(splitted[0], splitted[1].to_i)
				@board << record
				@num_records += 1
			end

		end

		def saveLeaderBoard
			file = File.open("#{SAVES}/save1.rt", "w+")

			@board.each do |rec|
				file.write("#{rec.to_s}\n")
			end
		end

		def keyboardControl(id)
			case id
			when Gosu::KbRight 
				
				addScore(40)
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
				@win.switchTo(:menu)
			when Gosu::KbReturn
				if @win.text_input != nil
					@board[@new].updateText(@win.text_input.text)
					@new = -2
					@text = ""
					@win.text_input = nil
					saveLeaderBoard
				end
			else
				if @win.text_input != nil
					@board[@new].updateText(@win.text_input.text)
				end
			end
		end


		def button_down(id)
			keyboardControl(id)
		end

		def update
			@win.caption = "Ruby Tower [Leaderboard]"
		end

		def draw
			@back.draw(0, 0, 0)

			@board[@range].each_with_index do |record, i|
				record.draw(i, @win)
			end

			@left.draw( 0, 0, 0)
			@right.draw( WIDTH - 96, 0, 0)
		end
	end
end
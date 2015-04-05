class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	validates :han, presence: true
	validates :pinyin, presence: true
	validates :pinyin_num, presence: true

	def to_node(logged_user_id)
		labelcolor = ApplicationController.helpers.gradient(success_rate(logged_user_id))
		pairs = [['label', self.han || ''], 
			['eng', self.meaning || ''], 
			['pinyin', self.pinyin || ''], 
			['labelcolor', labelcolor], 
			['example', self.han || '']]	
		ApplicationController.helpers.springy_node(pairs)
	end
	def success_rate(logged_user_id)
		guesses = Guess.where(user_id: logged_user_id, word_id: self.id)
		if guesses.empty?
			rate = 0.0
		else
			rate = guesses.first.success_rate
		end
		rate
	end
	def play
		self.han.play "zh"
	end
	def present_in_patterns?(patterns)
		patterns.select{|p| p.include? self.han}.size > 0
	end
	def to_correct_s
			"#{self.han}  #{self.pinyin} (#{self.meaning})"
	end
	def to_wrong_s
			"#{self.han} should be  #{self.pinyin_num} (#{self.meaning})"
	end
	def evaluate(answer)
		answer = norm(answer.strip).to_s
		expected = norm(self.pinyin_num).to_s
		if answer == expected
			correct_points = 2
			flash_data = {success: "Correct: " + self.to_correct_s}
		else
			if strip_tone(answer) == strip_tone(expected)
				correct_points = 1
				flash_data = {warning: "Tone #{answer}, " + self.to_wrong_s}
			else
				correct_points = 0
				flash_data = {danger:  "Wrong #{answer}, " + self.to_wrong_s}
			end
		end
		[correct_points, flash_data]
	end
	def tone_class
		pinyin = self.pinyin_num.strip
		if pinyin.include? ','
			pinyin = pinyin.split(',').first.strip 
		end
		pinyin.gsub(/[a-zA-Z]+/,"").gsub("'","").gsub(" ","")
	end

	private
	def strip_tone(str)
		str.gsub(/[0-5]/, '')
	end
	def norm(str)
		str.capitalize.gsub(' ','')
	end
end


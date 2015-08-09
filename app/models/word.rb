class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	validates :han, presence: true
	validates :pinyin, presence: true
	validates :pinyin_num, presence: true

	def to_colorless_node
		ApplicationController.helpers.springy_node(node_pairs)
	end
	def to_red_node
		pairs = node_pairs
		pairs << ['labelcolor', '#ff5533']
		ApplicationController.helpers.springy_node(pairs)
	end
	def to_node(logged_user_id)
		# set the color depending on the user's knowledge
		labelcolor = ApplicationController.helpers.gradient(success_rate(logged_user_id))
		pairs = node_pairs
		pairs << ['labelcolor', labelcolor]
		ApplicationController.helpers.springy_node(pairs)
	end
	def success_rate(logged_user_id)
		guesses = Guess.where(user_id: logged_user_id, word_id: self.id)
		if guesses.empty?
			rate = 0.0
		else
			user_guess = guesses.first
			rate = user_guess.success_rate
			# penalize the first guess to avoid immediate high rates
			if user_guess.attempts <= 2
				rate = rate.to_f / 2.0
			end
		end
		rate
	end
	def guess_ratio(logged_user_id)
		guesses = Guess.where(user_id: logged_user_id, word_id: self.id)
		if guesses.empty?
			ratio = '0/0'
		else
			guesses.first.ratio
		end
	end
	def update_sound_file
		sound_file =  File.join(Rails.root, "public", "audios", "sound.mp3")
    File.delete(sound_file) if File.exist?(sound_file)
		#  tts gem extends String class with google-tts powered mp3 file generation
		begin
			self.han.to_file("zh", sound_file)
		rescue Exception  
			# Do something meaningful (service currently unavailable)
		end
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
		n_answer = norm(answer.strip).to_s
		n_expected = norm(expected_pinyin)
		if n_answer == n_expected
			correct_points = 2
			flash_data = {success: "Correct: " + self.to_correct_s}
		else
			if strip_tone(n_answer) == strip_tone(n_expected)
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
		pinyin = expected_pinyin
		pinyin.gsub(/[a-zA-Z]+/,"").gsub("'","").gsub(" ","")
	end
	def characters
		self.han.split('')
	end

	def character_decompositions
		char_decompositions = []
		self.characters.each do |char|
			# NOTE decomposition could be precalculated and added to the model
			char_radicals = ApplicationController.helpers.decompose(char, list_id = 1) # 1 for detailed decomp.
			unless char_radicals.nil?
				char_decompositions << {char: char, decomposition: char_radicals.join(', ')}
			end
		end
		char_decompositions 
	end

	private
	def expected_pinyin
		pinyin = self.pinyin_num.strip
		if pinyin.include? ','
			pinyin = pinyin.split(',').first.strip 
		end
		pinyin
	end
	def strip_tone(str)
		str.gsub(/[0-5]/, '')
	end
	def norm(str)
		str.capitalize.gsub(' ','').gsub("'","").gsub('5','')
	end
	def node_pairs
		[
			['label', self.han || ''], 
			['eng', self.meaning || ''], 
			['pinyin', self.pinyin || ''], 
			['example', self.han || '']
		]	
	end
end


class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	validates :pinyin_num, presence: true
	validates :pinyin, presence: true
	
	def to_generic_json
		pairs = [['label', self.han || ''], 
			  	   ['eng', self.meaning || ''], 
				     ['example', self.pinyin || '']]	
		ApplicationController.helpers.springy_node(pairs)
	end
	def success_rate
		rate = 0
		if self.num_attempts > 0
			total_possible_points = self.num_attempts.to_f * 2
			rate = self.num_correct.to_f / total_possible_points
		end
		rate
	end
	def play
		self.han.play "zh"
	end
	def present_in_patterns?(patterns)
		patterns.select{|p| p.include? self.han}.size > 0
	end
	def tone_class
		# TODO test these cases (checchek levels 1-4)
		# several tones     累    | lei4, lei3, lei2   | 4, 3, 2 |
		# space in between  打篮球  | da3 lan2qiu2       | 3 22   
		# ' char  然而   | ran2'er2         | 2'2   |
		# TODO use this to evaluate correctness of pinyin?
		pinyin = self.pinyin_num.strip
		if pinyin.include? ','
			pinyin = pinyin.split(',').first.strip 
		end
		pinyin.gsub(/[a-zA-Z]+/,"").gsub("'","").gsub(" ","")
	end
end

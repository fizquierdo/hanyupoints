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
end

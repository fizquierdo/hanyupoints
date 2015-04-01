class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	validates :pinyin_num, presence: true
	validates :pinyin, presence: true
	
	def to_generic_json
		pairs = [['label', self.han || ''], 
			  	 ['meaning', self.meaning || ''], 
				 ['pinyin', self.pinyin || '']]	
		ApplicationController.helpers.springy_node(pairs)
	end
	def success_rate
		rate = 0
		if self.num_attempts > 0
			rate = self.num_correct.to_f / self.num_attempts.to_f
		end
		rate
	end
end

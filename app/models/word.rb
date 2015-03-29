class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	
	def to_generic_json
		pairs = [['label', self.han || ''], 
			  	 ['meaning', self.meaning || ''], 
				 ['pinyin', self.pinyin || '']]	
		ApplicationController.helpers.springy_node(pairs)
	end
end

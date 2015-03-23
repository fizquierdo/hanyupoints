class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	
	def to_generic_json
		han = self.han || ''
		meaning = self.meaning || ''
		pinyin = self.pinyin || ''
		
		'{label:"'+han+ '",meaning:"' +meaning+ '",pinyin:"' +pinyin+'"},'
	end
end

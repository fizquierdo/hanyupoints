class Word < ActiveRecord::Base
	validates :han, uniqueness: true
	
	def to_generic_json
		'{label:"'+self.han+ '",meaning:"' +self.meaning+ '",pinyin:"' +self.pinyin+'"},'
	end
end

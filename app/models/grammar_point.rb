class GrammarPoint < ActiveRecord::Base
	validates :level, presence: true
	validates :h1, presence: true
	validates :eng, presence: true
	validates :pattern, presence: true
	validates :example, presence: true

	def to_generic_json
		'{eng:"'+self.eng+ '",pattern:"' +self.pattern+ '",example:"' +self.example+'"},'
	end
	def to_path
		path = self.h1
		path += '/' + self.h2 if self.h2
		path += '/' + self.h3 if self.h3
		path
	end
end

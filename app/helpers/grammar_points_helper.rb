module GrammarPointsHelper
	def self.understandable_with(words, threshold = 0.4)
		# lets assume we work only with A levels
		gps = GrammarPoint.where(level: ['A1', 'A2'])
		understandable_gps = []
		gps.each do |gp|
			example_words = gp.example.split(" ").map{|s| s.strip}.select{|s| !s.empty?}
			known_words = example_words.select{|w| words.include? w}
			rate = known_words.size.to_f / example_words.size.to_f
			if rate > threshold
				understandable_gps << gp
			end
		end
		# return sorted?
		understandable_gps 
	end
	private 
	def extract_words(example)
		example.split(" ").map{|s| s.strip}.select{|s| !s.empty?}
	end
end

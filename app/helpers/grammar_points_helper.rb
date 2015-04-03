module GrammarPointsHelper
	def self.understandable_with(words, threshold = 0.4, gp_levels = ['A1', 'A2'])
		# lets assume we work only with A levels
		gps = GrammarPoint.where(level: gp_levels)
		understandable_gps = []
		gps.each do |gp|
			example_words = self.extract_words(gp.example)
			known_words = example_words.select{|w| words.include? w}
			rate = known_words.size.to_f / example_words.size.to_f
			if rate > threshold
				understandable_gps << {gp: gp, rate: rate.to_s}
			end
		end
		# return sorted by the number of known words (least known first)
		understandable_gps.sort_by{|e| e[:rate]}#.map{|e| e[:gp]}
	end
	def self.extract_words(sentence)
		str = sentence.strip
		['。','?', '!',  ',', '？'].each do |d|
			str = str.gsub(d, '')
		end
		str.split(" ").map{|s| s.strip}.select{|s| !s.empty?}
	end
end

module GrammarPointsHelper
	def self.grammar_points_with(word, gp_levels = ['A1', 'A2'])
		GrammarPoint.where(level: gp_levels).select{|gp| gp.pattern.include? word}
	end
	def self.understandable_with(gps, words, threshold = 0.2)
		understandable_examples = []
		gps.each do |gp|
			examples = GrammarPointExample.where(grammar_point_id: gp.id)
			examples.each do |example|
				sentence_words = self.extract_words(example.sentence)
				known_words = sentence_words.select{|w| words.include? w}
				rate = known_words.size.to_f / sentence_words.size.to_f
				if rate >= threshold
					understandable_examples << {example: example, proportion: rate.round(2)}
				end
			end
		end
		# return sorted by the number of known words (least known first)
		understandable_examples.sort_by{|e| e[:proportion]}
	end
	def self.extract_words(sentence)
		str = sentence.strip
		['。','?', '!',  ',', '？'].each do |d|
			str = str.gsub(d, '')
		end
		str.split(" ").map{|s| s.strip}.select{|s| !s.empty?}
	end
end

module WordsHelper
	def self.mastered_words(words)
		words.select{|w| w.success_rate > 0}.map{|w| w.han}
	end
end

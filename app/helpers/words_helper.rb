module WordsHelper
	def self.mastered(words)
		words.select{|w| w.success_rate > 0.7}.sort_by{|w| w.success_rate}.map{|w|w.han}
	end
end

module WordsHelper
	def self.mastered(words, current_user_id)
		words.select{|w| w.success_rate(current_user_id) > 0.7}.sort_by{|w| w.success_rate(current_user_id)}.map{|w|w.han}
	end
end

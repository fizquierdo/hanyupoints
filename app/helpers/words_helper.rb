module WordsHelper
	def self.mastered(words, current_user_id)
		words.select{|w| w.success_rate(current_user_id) > 0.7}\
											.sort_by{|w| w.success_rate(current_user_id)}\
											.map{|w|w.han}
	end
	def self.character_alphabet(words)
		chars = []
		words.each do |w|
			w.split('').each do |ch|
				chars << ch unless chars.include? ch 
			end
		end
		chars
	end
end

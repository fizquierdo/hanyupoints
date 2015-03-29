class FlashcardsController < ApplicationController
	def flashcards
		random_id = rand(Word.count)
		@word = Word.all[random_id]
	end
	def check
		@word = Word.find(params[:id])
		# TODO add tests here, spec for eval is not obvious
		panswer = params[:answer] || 'no_answer'
		answer = norm(panswer).to_s
		expected = norm(@word.pinyin).to_s
		if answer == expected
			# correct answer
			num_correct = @word.num_correct + 1
			flash[:notice] = "Correct: #{@word.han}  #{@word.pinyin}"
		else
			# wrong answer
			num_correct = @word.num_correct 
			if strip_tone(answer) == strip_tone(expected)
				flash[:notice] = "Tone #{answer}, #{@word.han} should be #{@word.pinyin}"
			else
				flash[:notice] = "Wrong #{answer}, #{@word.han} should be #{@word.pinyin}"
			end
		end
		num_attempts = @word.num_attempts + 1
		@word.update_attributes({num_attempts: num_attempts, num_correct: num_correct})
		redirect_to flashcards_url
	end
	private
	def strip_tone(str)
		str.gsub(/[0-5]/, '')
	end
	def norm(str)
		str.capitalize.gsub(' ','')
	end
end

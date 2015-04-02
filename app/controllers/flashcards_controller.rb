class FlashcardsController < ApplicationController
	include WordsHelper
	def flashcards
		# TODO determine the level we play at otherwise
		@hsk_level = 1
		words = Word.where(level: @hsk_level)
		@word = words.sort_by{|w| w.success_rate}.first
		@mastered_words = WordsHelper.mastered(words)
		@understandable_grammar_points = GrammarPointsHelper.understandable_with(@mastered_words)
	end
	def play
		@word = Word.find(params[:id])
		@word.play
		redirect_to flashcards_url
	end
	def check
		@word = Word.find(params[:id])
		@word.play
		answer = params[:answer] || 'no_answer'
		answer = norm(answer).to_s
		expected = norm(@word.pinyin_num).to_s
		if answer == expected
			# correct answer
			num_correct = @word.num_correct + 1
			flash_data = {success: "Correct: #{@word.han}  #{@word.pinyin} (#{@word.meaning})"}
		else
			# wrong answer
			num_correct = @word.num_correct 
			if strip_tone(answer) == strip_tone(expected)
				flash_data = {warning: "Tone #{answer}, #{@word.han} should be #{@word.pinyin_num}  (#{@word.meaning})"}
			else
				flash_data = {danger:  "Wrong #{answer}, #{@word.han} should be #{@word.pinyin}  (#{@word.meaning})"}
			end
		end
		num_attempts = @word.num_attempts + 1
		@word.update_attributes({num_attempts: num_attempts, num_correct: num_correct})
		redirect_to flashcards_url, flash: flash_data
	end
	private
	def strip_tone(str)
		str.gsub(/[0-5]/, '')
	end
	def norm(str)
		str.capitalize.gsub(' ','')
	end
end

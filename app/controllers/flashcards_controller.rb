class FlashcardsController < ApplicationController
	before_action :authenticate_user!
	include WordsHelper
	def flashcards
		# TODO determine the level we are learning according to the user
		@hsk_levels =  ApplicationController.helpers.hsk_levels
		words = Word.where(level: @hsk_levels)
		@word = words.sort_by{|w| w.success_rate(current_user.id)}.first
		@mastered_words = WordsHelper.mastered(words, current_user.id)
		@relevant_grammar_points = GrammarPointsHelper.grammar_points_with(@word.han)
		@understandable_examples = GrammarPointsHelper.understandable_with(@relevant_grammar_points, @mastered_words)
	end
	def play
		# play the sound button
		@word = Word.find(params[:id])
		@word.play
		redirect_to flashcards_url
	end
	def check
		# TODO this does not act on the word model, but on the guess!
		@word = Word.find(params[:id])
		@word.play
		answer = params[:answer] || 'no_answer'
		answer = norm(answer).to_s
		expected = norm(@word.pinyin_num).to_s
		if answer == expected
			correct_points = 2
			flash_data = {success: "Correct: #{@word.han}  #{@word.pinyin} (#{@word.meaning})"}
		else
			if strip_tone(answer) == strip_tone(expected)
				correct_points = 1
				flash_data = {warning: "Tone #{answer}, #{@word.han} should be #{@word.pinyin_num}  (#{@word.meaning})"}
			else
				flash_data = {danger:  "Wrong #{answer}, #{@word.han} should be #{@word.pinyin}  (#{@word.meaning})"}
			end
		end
		save_guess(correct_points)
		redirect_to flashcards_url, flash: flash_data
	end

	private
	def save_guess(correct_points)
		guesses = Guess.where(user: current_user, word: @word)
		if guesses.empty?
			guess = Guess.create({user: current_user, word: @word, attempts: 1, correct: correct_points})
		else
			guess = guesses.first 
			guess.update_attributes({attempts: guess.attempts + 1, correct: guess.correct + correct_points})
		end
	end
	def strip_tone(str)
		str.gsub(/[0-5]/, '')
	end
	def norm(str)
		str.capitalize.gsub(' ','')
	end
end

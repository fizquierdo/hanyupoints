class FlashcardsController < ApplicationController
	before_action :authenticate_user!
	include WordsHelper
	def flashcards
		# TODO from user settings hsk_levels
		@hsk_levels =  ApplicationController.helpers.hsk_levels
		words = Word.where(level: @hsk_levels)
		@word = words.sort_by{|w| w.success_rate(current_user.id)}.first
		@mastered_words = WordsHelper.mastered(words, current_user.id)
		# TODO from user settings grammar_levels
		@relevant_grammar_points = GrammarPointsHelper.grammar_points_with(@word.han)
		@understandable_examples = GrammarPointsHelper.understandable_with(@relevant_grammar_points, @mastered_words)
		@word.update_sound_file
	end
	def check
		@word = Word.find(params[:id])
		answer = params[:answer] || 'no_answer'
		correct_points, flash_data = @word.evaluate(answer)
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
end

class FlashcardsController < ApplicationController
	def flashcards
		random_id = rand(Word.count)
		@word = Word.all[random_id]
	end
	def check
		@word = Word.find(params[:id])
		flash[:notice] = "You wrote #{params[:answer]}, #{@word.han} was #{@word.pinyin}"
		redirect_to flashcards_url
	end
end

class Guess < ActiveRecord::Base
  belongs_to :word
  belongs_to :user

	def success_rate
		# 2 points correct, 1 point tone correct
		self.correct.to_f / (self.attempts.to_f * 2)
	end
	def ratio
		self.correct.to_s + '/' + self.attempts.to_s 
	end

end

class Setting < ActiveRecord::Base
  belongs_to :user

	validates :user_id, presence: true, uniqueness: true
	validates :hsk_level, presence: true, numericality: {less_than_or_equal_to: 6}
	validates :grammar_level, presence: true, numericality: {less_than_or_equal_to: 4}
	
	def to_hsk_levels
		(1..self.hsk_level).to_a
	end

	def to_grammar_levels
		levelmap = {'1' => %w(A1),
								'2' => %w(A1 A2),
								'3' => %w(A1 A2 B1),
								'4' => %w(A1 A2 B1 B2)}
		levelmap[self.grammar_level.to_s]
	end
end

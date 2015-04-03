class GrammarPointExample < ActiveRecord::Base
  belongs_to :grammar_point
  validates :sentence, length: {minimum: 2}
  validates :pinyin, length: {minimum: 2}
end

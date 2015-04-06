require 'test_helper'

class WordTest < ActiveSupport::TestCase
   test "word should not be saved without hanzi" do
		 word = Word.new
		 word[:pinyin] = 'wo3'
		 word[:pinyin_num] = 'wo3'
		 assert_not word.save
   end
   test "word should not be saved without numerical pinyin" do
		 word = Word.new
		 word[:han] = '我'
		 word[:pinyin] = 'wo3'
		 assert_not word.save
   end
   test "word should not be saved without pinyin" do
		 word = Word.new
		 word[:han] = '我'
		 word[:pinyin_num] = 'wo3'
		 assert_not word.save
   end
   test "word should be saved with hanzi and pinyin" do
		 word = words(:one)
		 w_saved = word.save
		 assert w_saved
   end
   test "word should not be saved for duplicated hanzi" do
		 w = Word.new({han:'te', pinyin: 'ta1', pinyin_num: 'ta1'})
		 assert w.save

		 w2 = Word.new({han:'te', pinyin: 'ta3', pinyin_num: 'ta3'})
		 assert_not w2.save
   end

	 # evaluation
   test "correct answer gives 2 points" do
		 w = Word.new({han:'te', pinyin: 'ta1', pinyin_num: 'ta1'})
		 points, msg = w.evaluate('ta1')
		 assert_equal(2, points)
	 end
   test "correct answer even if spaces are present" do
		 w = words(:three)
		 ['ta1ta2', 'ta1 ta2', ' ta1 ta2 '].each do |answer|
				points, msg = w.evaluate(answer)
				assert_equal(2, points)
		 end
	 end
   test "wrong tones but correct word gives 1 point" do
		 w = words(:three)
		 ['tata2', 'ta1ta1', 'tata', 'ta ta'].each do |answer|
				points, msg = w.evaluate(answer)
				assert_equal(1, points)
		 end
	 end
   test "wrong answer gives 0 points" do
		 w = words(:three)
		 ['', ' ', 'tati', 'ta1ti2'].each do |answer|
				points, msg = w.evaluate(answer)
				assert_equal(0, points)
		 end
	 end

	 # tone class
   test "tone class can be identified" do
		 w = words(:three)
	   assert_equal('12', w.tone_class)
		 w = words(:one)
	   assert_equal('3', w.tone_class)
		 w = words(:two)
	   assert_equal('3', w.tone_class)
	 end
   test "tone class is taken from the first if several pinyin available" do
		 w = Word.new({pinyin_num: "lei4, lei3, lei2"})
	   assert_equal('4', w.tone_class)
	 end
   test "tone class is correct in the presence of spaces" do
		 w = Word.new({pinyin_num: "da3 lan2qiu2"})
	   assert_equal('322', w.tone_class)
	 end
   test "tone class ignores ' character" do
		 w = Word.new({pinyin_num: "ran2'er2"})
	   assert_equal('22', w.tone_class)
	 end

end

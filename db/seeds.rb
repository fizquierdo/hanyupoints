# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require 'all_set_grammar_points'

# words
(1..6).to_a.each do |level|
	filename = File.join(Rails.root, "public", "data", "hsk#{level}.txt")
	File.open(filename).each_line do |l|
		simpl, trad, pinyin_num, pinyin, eng = l.rstrip.split("\t")
		Word.create({han: simpl, meaning: eng, pinyin_num: pinyin_num, pinyin: pinyin,level: level})
	end
end

## grammar points
BASE_URL = "http://resources.allsetlearning.com"
levels = %w(A1 A2 B1 B2 C1)
levels.each do |level|
	url_extension = "/chinese/grammar/#{level}_grammar_points"
	grammar_points = AllSetGrammarPoints.extract_gp(BASE_URL, url_extension)
	grammar_points.each do |gp|
		gp_data = gp.to_db
		gp_data[:level] = level
		gp = GrammarPoint.create(gp_data)
		begin
			gp_examples = AllSetGrammarPoints.extract_sentences(gp_data[:link])
			gp_examples.each do |example|
				GrammarPointExample.create(example.merge({grammar_point_id: gp.id}))
			end
			puts "#{level}, #{gp_data[:pattern]}, #{gp_examples.size} examples added"
		rescue
			puts "#{level}, #{gp_data[:pattern]}, skipping examples"
		end
	end
end

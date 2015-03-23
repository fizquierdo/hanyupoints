# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# words
File.open(File.join(Rails.root, "public", "words.txt")).each_line do |l|
	han, meaning, pinyin = l.strip.split(',')
	Word.create({han: han, meaning: meaning, pinyin: pinyin})
end

# connections (words should exist already)
File.open(File.join(Rails.root, "public", "edges.txt")).each_line do |l|
	from, to, color, directional = l.strip.split(',')
	Connection.create({from: from, to: to, color: color, directional: directional})
end

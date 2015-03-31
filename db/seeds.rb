require 'nokogiri'   
require 'open-uri'

module AllSetGrammarPoints
	class GrammarPoint
		attr_reader :path
		def initialize(opts)
			@path = opts[:path]
			@eng = opts[:eng]
			@example = opts[:example]
			@pattern = opts[:pattern]
			@link = opts[:link]
		end
		def to_path
			path = @path[:h1]
			path += '/' + @path[:h2] unless @path[:h2].empty?
			path += '/' + @path[:h3] unless @path[:h3].empty?
			path
		end
		def to_db
			record = {h1: @path[:h1], eng: @eng, pattern: @pattern, example: @example}
			record[:h2] = @path[:h2] unless @path[:h2].empty?
			record[:h3] = @path[:h3] unless @path[:h3].empty?
			record
		end
		def to_s
			@pattern
		end
	end

	def self.extract(url)
		page = Nokogiri::HTML(open(url))
		grammar_points = []
		path = {} # {:h1=>"Parts of Speech", :h2=>"Verbs", :h3=>"Verb phrases"}\t"Yinggai" for should
		page.traverse do |node|
			if node.name == 'h1'
				path = {h1: node.text, h2: '', h3: ''}
			elsif node.name == 'h2'
				raise 'h1 undetected' if path[:h1].empty?
				path[:h2] = node.text
				path[:h3] = ''
			elsif node.name == 'h3'
				raise 'h1 undetected' if path[:h1].empty?
				raise 'h2 undetected' if path[:h2].empty?
				path[:h3] = node.text
			elsif node.name == 'table'
				node.css('tr').each do |row|
					link = ''
					row.css('td').each do |data|
						data.css('a[href]').each{|l| link = l['href']}
					end
					next if link.empty?
			  	    eng, pattern, example = row.text.strip.split("\n")
					grammar_points << GrammarPoint.new({path: path.clone, eng: eng, pattern: pattern, example: example, link: link})
				end
			end
		end
		grammar_points
	end

end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# words

####
## Self-defined words and connections
#File.open(File.join(Rails.root, "public", "words.txt")).each_line do |l|
#	han, meaning, pinyin = l.strip.split(',')
#	Word.create({han: han, meaning: meaning, pinyin: pinyin})
#end
#File.open(File.join(Rails.root, "public", "edges.txt")).each_line do |l|
#	from, to, color, directional = l.strip.split(',')
#	Connection.create({from: from, to: to, color: color, directional: directional})
#end

###
filename = File.join(Rails.root, "public", "data", "hsk1.txt")
words = []
File.open(filename).each_line do |l|
	simpl, trad, pinyin, pinyin, eng = l.rstrip.split("\t")
	words << simpl
	Word.create({han: simpl, meaning: eng, pinyin: pinyin})
end
chars = []
words.each do |w|
	w.split('').each do |ch|
		chars << ch unless chars.include? ch 
	end
end
# show connections
chars.each do |ch|
	words.select{|w| w.include?(ch) and w.size > 1}.each do |w|
		#puts "#{ch}->#{w}"	
		Connection.create({from: ch, to: w, color: '#00A0B0', directional: true})
	end
end

# grammar points
BASE_URL = "http://resources.allsetlearning.com"

levels = %w(A1 A2 B1 B2 C1)
levels.each do |level|
	grammar_points = AllSetGrammarPoints.extract(BASE_URL + "/chinese/grammar/#{level}_grammar_points")
	grammar_points.each do |gp|
		new_gp = gp.to_db
		new_gp[:level] = level
		GrammarPoint.create(new_gp)
	end
end

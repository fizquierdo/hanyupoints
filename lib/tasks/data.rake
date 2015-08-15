
def collect_levels
		word_level = [1, 2]
		gp_levels = %w(A1 A2)
		words = Word.where(level: word_level)
		gps = GrammarPoint.all.select{|gp| gp_levels.include? gp.level}
		[words, gps]
end


namespace :data do

	desc "Show decompositions of each word"
	task decomp: :environment do
		words, gps = collect_levels
		words.each_with_index do |w, i|
			puts w.han + "\t" + w.meaning
			w.characters.each do |ch|
				p ApplicationController.helpers.decompose(ch, list_id = 1)
			end
			break if i > 10
		end
	end

	desc "Show per word wich grammar points are relevant"
	task words: :environment do
		words, gps = collect_levels
		rows = []
		words.each do |w|
			sample_gps = gps.select{|gp| gp.pattern.include? w.han}
			sample_gps = sample_gps.group_by{|gp| gp.level}
			# show counts
			#sample_gps = sample_gps.map{|k,v| {k.to_sym => v.size}}
			## show the patterns
			sample_gps = sample_gps.map{|k,v| {k.to_sym => v.map{|gp|gp.pattern}}}
			unless sample_gps.empty?
				rows << [w.level.to_s, w.han, sample_gps.to_s]
			end
		end
		table = Terminal::Table.new :rows => rows
		puts table.to_s.gsub('|','')
		puts "#{rows.size}/#{words.size} words" 
	end

	desc "Shows per grammar point pattern how many words are at each HSK level"
	task grammar_points: :environment do
		words, gps = collect_levels
		rows = []
		gps.each do |gp|
			pattern = gp.pattern
			# distribution of words in this example
			sample_words = words.select{|w| pattern.include? w.han}\
				.group_by{|w| w.level}\
				.map{|k,v| {k.to_s => v.map{|p| p.han}}}\
				.to_s.gsub('[','').gsub(']','').strip
			rows << [gp.level.to_s, pattern.strip, sample_words]
		end
		table = Terminal::Table.new :rows => rows
		puts table.to_s.gsub('|','')
		puts gps.size.to_s + " grammar points"
	end

	desc "Shows available examples"
	task examples: :environment do
		words, gps = collect_levels
		rows = []
		gps.each do |gp|
			sentences = GrammarPointExample.where(grammar_point_id: gp.id).map{|s| s.sentence}
			puts '=' * 40
			puts gp.level.to_s + " " + gp.pattern.to_s 
			puts '=' * 40
			sentences.each do |sentences|
				puts " " + sentences
			end
		end
	end

	desc "Shows tones"
	task tone_pairs: :environment do
		words = Word.where(level: [1])
		rows = []
		tones = words.group_by{|w| w.tone_class}
		tones.each_pair do |tone, words|
			if tone.size == 2
				rows << [tone, words.size, words.map{|w| w.han}.join(',')]
			end
		end
		table = Terminal::Table.new :rows => rows.sort_by{|w|w[0]}
		puts table.to_s.gsub('|','')
	end

	desc "Shows edges"
	task edges: :environment do
		words = Word.where(level: [1]).map{|w| w.han}
		rows = []
		chars = WordsHelper.character_alphabet(words)
		chars.each do |ch|
			words_with_ch = words.select{|w| w.include? ch and w != ch}
			unless words_with_ch.empty?
				if words.include? ch 
					rows << [ch, words_with_ch.to_s, 'ch'] 
				else
					if words_with_ch.size > 1
						# these characters are not words themselemves, but will cluster other words
						rows << [ch, words_with_ch.to_s, 'link_ch'] 
					end
				end
			end
		end
		table = Terminal::Table.new :rows => rows
		puts table.to_s#.gsub('|','')
	end
end

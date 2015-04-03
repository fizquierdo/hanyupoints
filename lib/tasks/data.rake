
def collect_levels
		word_level = [1, 2]
		gp_levels = %w(A1 A2)
		words = Word.where(level: word_level)
		gps = GrammarPoint.all.select{|gp| gp_levels.include? gp.level}
		[words, gps]
end


namespace :data do
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
			puts gp.level.to_s + " " + gp.pattern.to_s 
			sentences.each do |sentences|
				puts " " + sentences
			end
		end
	end
end

namespace :data do
  desc "Show per word wich grammar points are relevant at each level"
  task words: :environment do
	word_level = 1
	gp_level = %w(A1 A2)
	words = Word.where(level: word_level)
	puts "word: grammar points where this word appears in the example"
	gps = GrammarPoint.all.select{|gp| gp_level.include? gp.level}
	num_words = 0
	words.each do |w|
		sample_gps = gps.select{|gp| gp.example.include? w.han}
		sample_gps = sample_gps.group_by{|gp| gp.level}
		## show counts
		#sample_gps = sample_gps.map{|k,v| {k.to_sym => v.size}}
		## show the patterns
		sample_gps = sample_gps.map{|k,v| {k.to_sym => v.map{|gp|gp.pattern}}}
		unless sample_gps.empty?
			puts "#{w.han}\t#{sample_gps}" 
			num_words += 1
		end
	end
	puts "#{num_words} words at HSK word level #{word_level}, grammar #{gp_level.to_s}" 
  end

  desc "Shows per sentence example how many words are at each HSK level"
  task grammar_points: :environment do
    puts "Distribution of words for each example"
	word_levels = [1, 2]
	gp_levels = %w(A1, A2)
	words = Word.where(level: word_levels)
	gps = GrammarPoint.all.select{|gp| gp_levels.include? gp.level}
	examples = gps.map{|gp| gp.example}
	examples.each do |example|
		# distribution of words in this example
		sample_words = words.select{|w| example.include? w.han}\
							.group_by{|w| w.level}\
							.map{|k,v| {k.to_s => v.map{|p| p.han}}}
		puts "#{example}\t#{sample_words}"
	end
	puts "#{examples.size} examples at HSK word level #{word_levels}, grammar #{gp_levels}" 
  end

end

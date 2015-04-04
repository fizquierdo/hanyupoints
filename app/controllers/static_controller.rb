class StaticController < ApplicationController
	def network
		@words = Word.where(level: [1])
		grammar_network_with_words(@words, 'A1')
	end
	def hsk_network(words)
		all_nodes = words.map{|w| w.to_generic_json}
		all_edges = character_edges(words.map{|w| w.han})
	 	generate_jsonfile(all_nodes, all_edges)
	end
	def hsk_grammar_network(words, grammar_points)
		all_nodes = words.map{|w| w.to_generic_json}
		all_edges = character_edges(words.map{|w| w.han})
	 	generate_jsonfile(all_nodes, all_edges)
	end

	# TODO metaprogramming?
	def grammar_tree_A1
	 	grammar_tree('A1')
	end
	def grammar_tree_A2
	 	grammar_tree('A2')
	end
	def grammar_tree_B1
	 	grammar_tree('B1')
	end
	def grammar_tree_B2
	 	grammar_tree('B2')
	end

	def network_HSK1
		@words = Word.where(level: 1)
		hsk_network(@words)
	end
	def network_HSK2
		@words = Word.where(level: 2)
		hsk_network(@words)
	end
	def network_HSK3
		@words = Word.where(level: 3)
		hsk_network(@words)
	end

	private
	def character_edges(words)
		chars = []
		words.each do |w|
			w.split('').each do |ch|
				chars << ch unless chars.include? ch 
			end
		end
		edges = []
		chars.each do |ch|
			words.select{|w| w.include?(ch) and w.size > 1}.each do |w|
				next unless words.include? ch 
				edges << ApplicationController.helpers.springy_edge(ch, w, directional=true)
			end
		end
		edges
	end
	def grammar_tree(level)
		# Avoid representing twice the same edge
		all_edges = []
		all_nodes = []
		grammar_points = GrammarPoint.where(level: level)
		@num_points = grammar_points.size
		@level = level
		grammar_points.each do |gp| 
			# unique nodes
			all_nodes << gp.to_json_node
			# edges and possibly redundant nodes
			new_nodes, edges = gp.to_json_connections
			edges.each do |edge|
				all_edges << edge unless all_edges.include?(edge)
			end
			new_nodes.each do |node|
				all_nodes << node unless all_nodes.include?(node)
			end
		end
	 	generate_jsonfile(all_nodes, all_edges)
	end
	def grammar_network_with_words(words, level)
		all_edges = []
		all_nodes = []
		# use grammar points we can understand only
		grammar_points = GrammarPoint.where(level: level)
		grammar_points = grammar_points.select{|gp| gp.present_in_words?(words)}
		@num_points = grammar_points.size
		@level = level

		# use only words for which we have a grammar point
		patterns = grammar_points.map{|gp| gp.pattern}
		words    = words.select{|w| w.present_in_patterns?(patterns)}

		# nodes from words
		words.each do |w|
				pairs = [['label', w.han], ['eng', w.meaning]]
				all_nodes << ApplicationController.helpers.springy_node(pairs)
		end
		grammar_points.each do |gp| 
			# nodes grammar points
			all_nodes << gp.to_json_node
			# edges
			words.select{|w| gp.pattern.include? w.han}.each do |w|
				all_edges << ApplicationController.helpers.springy_edge(w.han, gp.short_pattern, directional=true)
			end
		end
	 	generate_jsonfile(all_nodes, all_edges)
	end
	def generate_jsonfile(all_nodes, all_edges)
		# manually generate the springy-formatted json file
		File.open(File.join(Rails.root, "public", "data.json"), 'w') do |f|
			f.puts "{"
			f.puts '"nodes":['
			all_nodes.each do |n|
				f.puts n
			end
			f.puts '],'
			f.puts '"edges":['
			all_edges.each do |e|
				f.puts e
			end
			f.puts ']'
			f.puts "}"
		end
	end
end

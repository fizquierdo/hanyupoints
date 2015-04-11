class StaticController < ApplicationController
	before_action :authenticate_user!, :except => [:home, :grammar_tree_A1] 
	def home
		words = Word.where(level: 1).select{|w| w.han.include? '有'}
		grammar_network_with_words(words, 'A1', user_color = false)
	end
	def tone_network
		@word_levels = [1,2]
		words = Word.where(level: @word_levels)
		tone_pair_network(words)
	end
	def radicals
		# update the data.json file
		@level = ApplicationController.helpers.radicals_hsk_levels
		filename = "radicals_hsk.json"
		src  = File.join(Rails.root, "public", filename)
		dest = File.join(Rails.root, "public", "data.json")
		FileUtils.cp(src, dest)
	end
	def network
		@word_levels = [1,2]
		words = Word.where(level: @word_levels)
		@grammar_levels = ['A1']
		grammar_network_with_words(words, @grammar_levels)
	end
	def hsk_network(words)
		nodes = words.map{|w| w.to_node(current_user.id)}
		#all_edges = character_edges(words.map{|w| w.han})
		edges, new_nodes = character_edges_and_nodes(words.map{|w| w.han})
		nodes += new_nodes
	 	ApplicationController.helpers.generate_jsonfile(nodes, edges)
	end
	def hsk_grammar_network(words, grammar_points)
		all_nodes = words.map{|w| w.to_node(current_user.id)}
		all_edges = character_edges(words.map{|w| w.han})
	 	ApplicationController.helpers.generate_jsonfile(all_nodes, all_edges)
	end

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
		# words are han strings
		# List the alphabet of character in the set of words
		# An edge connects a single-character word with another (longer) word
		chars = WordsHelper.character_alphabet(words)
		edges = []
		chars.each do |ch|
			words.select{|w| w.include?(ch) and w.size > 1}.each do |w|
				next unless words.include? ch 
				edges << ApplicationController.helpers.springy_edge(ch, w, directional=true)
			end
		end
		edges
	end

	def character_edges_and_nodes(words)
		# words are han strings
		# like def character_edges, but if we prefer to insert colorless nodes
		# nodes without colors are added to cluster together words sharing characters
		chars = WordsHelper.character_alphabet(words)
		edges = []
	  nodes = []
		chars.each do |ch|
			words_with_ch = words.select{|w| w.include? ch and w != ch}
			unless words_with_ch.empty?
				if words.include? ch 
					# single-ch word -> word
					words_with_ch.each do |w|
						edges << ApplicationController.helpers.springy_edge(ch, w, directional=true)
					end
				else
					if words_with_ch.size > 1
						# these characters are not words themselemves, but will cluster other words
						nodes << ApplicationController.helpers.springy_node([['label', ch]])
						words_with_ch.each do |w|
							edges << ApplicationController.helpers.springy_edge(ch, w, directional=false)
						end
					end
				end
			end
		end
		[edges, nodes]
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
			all_nodes << gp.to_node
			# edges and possibly redundant nodes
			new_nodes, edges = gp.to_connections
			edges.each do |edge|
				all_edges << edge unless all_edges.include?(edge)
			end
			new_nodes.each do |node|
				all_nodes << node unless all_nodes.include?(node)
			end
		end
	 	ApplicationController.helpers.generate_jsonfile(all_nodes, all_edges)
	end
	def tone_pair_network(words) 
		words = words.select{|w| w.tone_class.size == 2}
		all_nodes = []
		all_edges = []
		# tone nodes and edges 
		(1..4).to_a.each do |tone_start|
			all_nodes << ApplicationController.helpers.springy_node([['label', tone_start.to_s]])
			(1..5).to_a.each do |tone_end|
				tone_pair = tone_start.to_s+tone_end.to_s
				all_nodes << ApplicationController.helpers.springy_node([['label', tone_pair]])
				all_edges << ApplicationController.helpers.springy_edge(tone_start.to_s, tone_pair, directional=false)
			end
		end
		# word nodes
		words.each do |w|
				all_nodes << w.to_node(current_user.id)
		end
		tones = words.group_by{|w| w.tone_class}
		tones.each_pair do |tone, words|
				words.each do |w|
					all_edges << ApplicationController.helpers.springy_edge(tone.to_s, w.han, directional=false)
				end
		end
	 	ApplicationController.helpers.generate_jsonfile(all_nodes, all_edges)
	end
	def grammar_network_with_words(words, level, user_color = true)
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
				if user_color
					all_nodes << w.to_node(current_user.id)
				else
					all_nodes << w.to_colorless_node
				end
		end
		grammar_points.each do |gp| 
			# nodes grammar points
			all_nodes << gp.to_node
			# edges
			words.select{|w| gp.pattern.include? w.han}.each do |w|
				all_edges << ApplicationController.helpers.springy_edge(w.han, gp.short_pattern, directional=true)
			end
		end
	 	ApplicationController.helpers.generate_jsonfile(all_nodes, all_edges)
	end

end

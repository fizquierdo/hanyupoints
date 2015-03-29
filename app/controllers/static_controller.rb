class StaticController < ApplicationController
	def network
		all_nodes = Word.all.map{|w| w.to_generic_json}
		all_edges = Connection.all.map{|c| c.to_generic_json}
	 	generate_jsonfile(all_nodes, all_edges)
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
	def grammar_tree_C1
	 	grammar_tree('C1')
	end

	private
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

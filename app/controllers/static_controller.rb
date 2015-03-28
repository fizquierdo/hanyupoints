class StaticController < ApplicationController
	def network
		# manually generate the springy-formatted json file
		File.open(File.join(Rails.root, "public", "data.json"), 'w') do |f|
			f.puts "{"
			f.puts '"nodes":['
			Word.all.each do |w|
				f.puts w.to_generic_json
			end
			f.puts '],'
			f.puts '"edges":['
			Connection.all.each do |c|
				f.puts c.to_generic_json
			end
			f.puts ']'
			f.puts "}"
		end
	end
	def grammar_tree
		# Avoid representing twice the same edge
		all_edges = []
		all_nodes = []
		GrammarPoint.all.each do |gp| 
			# unique nodes
			all_nodes << gp.to_json_node
			# edges and possibly redundant nodes
			edges, new_nodes = gp.to_json_connections
			edges.each do |edge|
				all_edges << edge unless all_edges.include?(edge)
			end
			new_nodes.each do |node|
				all_nodes << node unless all_nodes.include?(node)
			end
		end

		# manually generate the springy-formatted json file
		# TODO DRY
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

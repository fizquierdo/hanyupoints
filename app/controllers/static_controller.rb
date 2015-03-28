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
		# manually generate the springy-formatted json file
		File.open(File.join(Rails.root, "public", "data.json"), 'w') do |f|
			f.puts "{"
			f.puts '"nodes":['
			GrammarPoint.all.each do |gp|
				f.puts gp.to_generic_json
			end
			f.puts '],'
			f.puts '"edges":['
			#Connection.all.each do |c|
			#	f.puts c.to_generic_json
			#end
			f.puts ']'
			f.puts "}"
		end
	end
end

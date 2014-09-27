class StaticController < ApplicationController
	def network
		render
		@words = Word.all
		@connections = Connection.all
		# here we could generate the json file
		
		File.open(File.join(Rails.root, "data.json"), 'w') do |f|
			f.puts "{"
			# nodes
			f.puts '"nodes":['
			Word.all.each do |w|
				f.puts w.to_generic_json
			end
			f.puts '],'
			# edges
			f.puts '"edges":['
			Connection.all.each do |c|
				f.puts c.to_generic_json
			end
			f.puts ']'
			f.puts "}"
		end
	end
end

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
	def flashcards
		random_id = rand(Word.count)
		@word = Word.all[random_id]
	end
	def check
		@word = Word.find(params[:id])
		flash[:notice] = "You wrote #{params[:answer]}, #{@word.han} was #{@word.pinyin}"
		redirect_to flashcards_url
	end
end

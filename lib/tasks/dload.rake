#encoding: UTF-8

def decompose(character, list_id = 0)
		url = 'http://www.hanzicraft.com/character/' + character.to_s
		url = URI.encode url
		html = open(url)
		page = Nokogiri::HTML(html.read)
		decompositions = []
		page.css("div.decompbox").each_with_index do |box, i|
			# 0 decomposes in tails
			# 1 decomposes in radicals
			# 2 decomposes following some graphical pattern
			begin
				han, decomp = box.text.gsub("\n","").to_s.split('=>')
				decompositions[i] = decomp.strip.split(',').map{|n|n.strip}
			rescue
				decompositions[i] = []
			end
		end
		decompositions[list_id]
end

def build_radical_network(words, radicals)
		all_edges = []
		all_nodes = []
		# nodes: the single-character words
		words.each do |w|
			all_nodes << w.to_red_node
		end
		# edges radical -> char
		radicals.each_pair do |radical, chars|
			# radicals will be black nodes
			all_nodes << ApplicationController.helpers.springy_node([['label', radical]])
			chars.each do |char|
				all_edges << ApplicationController.helpers.springy_edge(radical, char)
			end
		end

		# generate the file representing the network for springy
		ApplicationController.helpers.generate_jsonfile(all_nodes, all_edges, "radicals_hsk.json")
end

namespace :da do
	desc "radical decomp"
	task craft_radicals: :environment do
		#char =	'说'
		levels = ApplicationController.helpers.radicals_hsk_levels
		words = WordsHelper.single_character_words(levels)
		characters = words.map{|w| w.han}

		radicals = {}
		puts "#{characters.size} characters to be decomposed "
		characters.each do |char|
			char_radicals = decompose(char, list_id = 0)
			char_radicals.each do |radical|
				radical.gsub!('No glyph available', 'x')
				if radicals.has_key?(radical)
					radicals[radical] << char
				else
					radicals[radical] = [char]
				end
				print '.'
			end
		end
		puts "#{radicals.keys.size} radicals"
		radicals.each_pair do |radical, chars|
			puts radical + "\t" +  chars.join(' | ')
		end
		build_radical_network(words, radicals)
	end
end

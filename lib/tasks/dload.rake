#encoding: UTF-8


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
			char_radicals = ApplicationController.helpers.decompose(char, list_id = 0)
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

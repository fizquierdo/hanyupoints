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

namespace :da do
	desc "radical decomp"
	task craft_radicals: :environment do
		#char =	'说'
		characters = Word.where(level: 1)\
										 .map{|w| w.han}\
										 .select{|w| w.split('').size == 1}
		radicals = {}
		puts "#{characters.size} characters to be decomposed "
		characters.each do |char|
			char_radicals = decompose(char, list_id = 1)
			char_radicals.each do |radical|
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
	end
end

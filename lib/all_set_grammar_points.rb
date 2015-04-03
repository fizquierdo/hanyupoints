require 'nokogiri'   
require 'open-uri'

module AllSetGrammarPoints
	# TODO test
	class GrammarPoint
		attr_reader :path
		def initialize(opts)
			@path = opts[:path]
			@eng = opts[:eng]
			@example = opts[:example]
			@pattern = opts[:pattern]
			@link = opts[:link]
		end
		def to_path
			path = @path[:h1]
			[:h2, :h3].each do |h|
				path += '/' + @path[h] unless @path[h].empty?
			end
			path
		end
		def to_db
			record = {link: @link, eng: @eng, pattern: @pattern, example: @example}
			[:h1, :h2, :h3].each do |h|
				record[h] = @path[h] unless @path[h].empty?
			end
			record
		end
		def to_s
			@pattern
		end
	end

	def self.extract_sentences(url)
		sentences = []
		page = Nokogiri::HTML(open(url))
		# Each table of sentences is a liju node
		page.css("div.liju").each do |liju_node|
			list_items = liju_node.css("li")
			list_items.each do |li|
				# skip special examples such as 'x' (wrong) or 'o' (correct)
				next unless li['class'].nil?
				sentence = li.text.split('。').first
				pinyin = li.css("span.pinyin").text
				translation = li.css("span.trans").text
				sentences << {sentence: sentence, pinyin: pinyin, translation: translation}
			end
		end
		sentences 
	end

	def self.extract_gp(base_url, extension)
		page = Nokogiri::HTML(open(base_url + extension))
		grammar_points = []
		path = {} 
		page.traverse do |node|
			if node.name == 'h1'
				path = {h1: node.text, h2: '', h3: ''}
			elsif node.name == 'h2'
				raise 'h1 undetected' if path[:h1].empty?
				path[:h2] = node.text
				path[:h3] = ''
			elsif node.name == 'h3'
				raise 'h1 undetected' if path[:h1].empty?
				raise 'h2 undetected' if path[:h2].empty?
				path[:h3] = node.text
			elsif node.name == 'table'
				node.css('tr').each do |row|
					link = ''
					row.css('td').each do |data|
						data.css('a[href]').each{|l| link = l['href']}
					end
					next if link.empty?
			  	    eng, pattern, example = row.text.strip.split("\n")
					grammar_points << GrammarPoint.new({path: path.clone, eng: eng, pattern: pattern, example: example, link: base_url + link})
				end
			end
		end
		grammar_points
	end

end

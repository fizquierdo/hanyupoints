module ApplicationHelper
	# these formats are required by springy
	def springy_node(pairs)
		'{' + pairs.map{|w| w[0].to_s+':"'+w[1]+'"'}.join(',') + '},'
	end
	def springy_edge(from, to, directional=true)
		to   = '"' + to + '"'
		from = '"' + from + '"'
		pairs =[['color', '"#00A0B0"'], ['directional', directional.to_s]]
		properties = '{' + pairs.map{|w| w.join(':')}.join(',') + '}'
		'[' + [from, to, properties].join(',') + '],'
	end
end

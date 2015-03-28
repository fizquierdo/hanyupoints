class GrammarPoint < ActiveRecord::Base
	validates :level, presence: true
	validates :h1, presence: true
	validates :eng, presence: true
	validates :pattern, presence: true
	validates :example, presence: true

	def to_json_node
		pattern = sanitize(self.pattern)
		eng = sanitize(self.eng)
		'{eng:"'+eng+ '",label:"' +pattern+ '",example:"' +self.example+'"},'
	end
	def to_path
		path = self.h1
		path += '/' + self.h2 if self.h2
		path += '/' + self.h3 if self.h3
		path
	end
	def to_json_connections
		pattern = sanitize(self.pattern)
		json_edges = []
		json_nodes = []
		if self.h2
			h2 = sanitize(self.h2)
			json_edges << json_edge(h1, h2)
			json_nodes << json_node(h1)
			json_nodes << json_node(h2)
			if self.h3
				h3 = sanitize(self.h3)
				json_edges << json_edge(h3, pattern)
				json_edges << json_edge(h2, h3)
				json_nodes << json_node(h3)
			else
				json_edges << json_edge(h2, pattern)
			end
		else
			json_edges << json_edge(h1, pattern)
		end
		[json_nodes, json_edges] 
	end
	private
	def json_edge(from, to, directional=false)
		'["' + from + '","' +to+ '",{color:"#00A0B0",directional:'+ directional.to_s+'}],'
	end
	def json_node(label, eng='', example='')
		label = sanitize(label)
		'{eng:"'+eng+ '",label:"' +label+ '",example:"' +self.example+'"},'
	end
	def sanitize(str)
		translator = {'"' => '', 
			          'Subject' => 'Subj.', 
			          'Adjective' => 'Adj.', 
			          'Number' => 'Num.'}
		translator.each_pair do |k, v|
		  str.gsub!(k, v)
		end
		str
	end
end

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
		paths = []
		path_nodes = []
		if self.h2
			h2 = sanitize(self.h2)
			paths << json_path(h1, h2)
			path_nodes << json_node(h1)
			path_nodes << json_node(h2)
			if self.h3
				h3 = sanitize(self.h3)
				paths << json_path(h3, pattern)
				paths << json_path(h2, h3)
				path_nodes << json_node(h3)
			else
				paths << json_path(h2, pattern)
			end
		else
			paths << json_path(h1, pattern)
		end
		[paths, path_nodes] 
	end
	private
	def json_path(from, to, directional=false)
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

class GrammarPoint < ActiveRecord::Base
	validates :level, presence: true
	validates :h1, presence: true
	validates :eng, presence: true
	validates :pattern, presence: true
	validates :example, presence: true

	def to_s
		"#{self.pattern}\t#{self.example}"
	end
	def to_json_node
		eng = sanitize(self.eng)
		url = Rails.application.routes.url_helpers.examples_path(id: self.id)
		json_node(pattern, eng, example, url)
	end
	def to_path
		path = self.h1
		path += '/' + self.h2 if self.h2
		path += '/' + self.h3 if self.h3
		path
	end
	def to_json_connections(include_h1=true)
		pattern = sanitize(self.pattern)
		json_edges = []
		json_nodes = []
		if self.h2
			h2 = sanitize(self.h2)
			if include_h1
				json_edges << json_edge(h1, h2)
				json_nodes << json_node(h1)
			end
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
	def json_edge(from, to, directional=true)
		ApplicationController.helpers.springy_edge(from, to, directional)
	end
	def json_node(label, eng='', example='', url = '')
		label = sanitize(label)
		pairs =[['eng', eng], 
			  	['label', label], 
			  	['url', url], 
				['example', example]]
		ApplicationController.helpers.springy_node(pairs)
	end
	def sanitize(str)
		translations = [
					  ['"'           , ''      ], 
			          ['Subject'     , 'Subj.' ], 
			          ['Questions'   , 'Quests.' ], 
			          ['Question'    , 'Quest.' ], 
			          ['Adjective'   , 'Adj.'  ], 
			          ['Adjectives'  , 'Adjs.' ], 
			          ['Adjective'   , 'Adj.'  ], 
			          ['Adverbs'  	 , 'Advs.' ], 
			          ['Adverb'      , 'Ads.' ], 
			          ['Adjective'   , 'Adj.'  ], 
			          ['Auxiliary'   , 'Aux.'  ], 
			          ['Conjunctions', 'Conjs.'], 
			          ['Conjunction' , 'Conj.' ], 
			          ['Number'      ,'Num.'   ]
        ]
		translations.each do |pair|
		  str.gsub!(pair[0], pair[1])
		end
		str
	end
end

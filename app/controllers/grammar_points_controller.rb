class GrammarPointsController < ApplicationController

  # GET /words
  # GET /words.json
  def index
    @grammar_points = GrammarPoint.all
  end
	def examples
		gp_id = params[:id]
    @grammar_point = GrammarPoint.find(gp_id)
		@examples = GrammarPointExample.where(grammar_point_id: gp_id)
	end
end

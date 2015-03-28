class GrammarPointsController < ApplicationController

  # GET /words
  # GET /words.json
  def index
    @grammar_points = GrammarPoint.all
  end
end

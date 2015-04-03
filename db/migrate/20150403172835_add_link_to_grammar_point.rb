class AddLinkToGrammarPoint < ActiveRecord::Migration
  def change
    add_column :grammar_points, :link, :string
  end
end

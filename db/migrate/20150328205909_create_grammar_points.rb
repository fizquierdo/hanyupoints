class CreateGrammarPoints < ActiveRecord::Migration
  def change
    create_table :grammar_points do |t|
      t.string :level
      t.string :h1
      t.string :h2
      t.string :h3
      t.string :eng
      t.string :pattern
      t.string :example

      t.timestamps
    end
  end
end

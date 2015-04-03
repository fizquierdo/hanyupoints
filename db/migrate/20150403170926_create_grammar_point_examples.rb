class CreateGrammarPointExamples < ActiveRecord::Migration
  def change
    create_table :grammar_point_examples do |t|
      t.references :grammar_point, index: true
      t.string :sentence
      t.string :pinyin
      t.string :translation

      t.timestamps
    end
  end
end

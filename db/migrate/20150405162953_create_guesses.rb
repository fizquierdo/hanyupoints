class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.references :word, index: true
      t.references :user, index: true
      t.integer :attempts
      t.integer :correct

      t.timestamps
    end
  end
end

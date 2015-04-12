class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :user, index: true
      t.integer :hsk_level, :null => false, :default => 1
      t.integer :grammar_level, :null => false, :default => 1

      t.timestamps
    end
  end
end

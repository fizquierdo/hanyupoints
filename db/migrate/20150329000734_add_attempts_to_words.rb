class AddAttemptsToWords < ActiveRecord::Migration
  def change
    add_column :words, :num_attempts, :integer, :null => false, :default => 0
    add_column :words, :num_correct, :integer, :null => false, :default => 0
  end
end

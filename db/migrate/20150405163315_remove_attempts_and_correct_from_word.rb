class RemoveAttemptsAndCorrectFromWord < ActiveRecord::Migration
  def change
    remove_column :words, :num_attempts, :integer
    remove_column :words, :num_correct, :integer
  end
end

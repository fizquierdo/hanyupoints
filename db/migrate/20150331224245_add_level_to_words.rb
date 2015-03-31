class AddLevelToWords < ActiveRecord::Migration
  def change
    add_column :words, :level, :integer
  end
end

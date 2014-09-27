class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :from
      t.string :to
      t.string :color
      t.boolean :directional

      t.timestamps
    end
  end
end

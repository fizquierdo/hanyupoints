class DropConnectionsTable < ActiveRecord::Migration
  def change
	  drop_table :connections
  end
end

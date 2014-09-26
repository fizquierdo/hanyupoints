class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :han
      t.string :pinyin
      t.string :meaning

      t.timestamps
    end
  end
end

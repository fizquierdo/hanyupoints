class AddPinyinNumToWords < ActiveRecord::Migration
  def change
    add_column :words, :pinyin_num, :string
  end
end

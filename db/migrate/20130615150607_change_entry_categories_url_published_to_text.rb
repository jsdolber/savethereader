class ChangeEntryCategoriesUrlPublishedToText < ActiveRecord::Migration
  def up
   change_column :entries, :categories, :text
   change_column :entries, :url, :text
   change_column :entries, :published, :text 
  end

  def down
   change_column :entries, :categories, :string
   change_column :entries, :url, :string
   change_column :entries, :published, :string
  end
end

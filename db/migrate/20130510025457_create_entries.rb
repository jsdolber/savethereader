class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id
      t.string :title
      t.string :summary
      t.string :content
      t.string :categories
      t.string :url
      t.string :published

      t.timestamps
    end
  end
end

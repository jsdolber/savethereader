class ChangeEntriesContentAndSummaryToText < ActiveRecord::Migration
  def up
    change_column :entries, :summary, :text
    change_column :entries, :content, :text
  end

  def down
    change_column :entries, :summary, :string
    change_column :entries, :content, :string
  end
end

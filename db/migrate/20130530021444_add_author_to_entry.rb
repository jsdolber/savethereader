class AddAuthorToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :author, :text
  end
end

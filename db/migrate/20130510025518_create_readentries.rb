class CreateReadentries < ActiveRecord::Migration
  def change
    create_table :readentries do |t|
      t.integer :entry_id
      t.integer :user_id

      t.timestamps
    end
  end
end

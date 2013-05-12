class CreateSubscriptionGroups < ActiveRecord::Migration
  def change
    create_table :subscription_groups do |t|
      t.string :name
      t.string :color

      t.timestamps
    end

    SubscriptionGroup.create :name => "TECH"
    SubscriptionGroup.create :name => "COMICS"
    SubscriptionGroup.create :name => "NEWS"
    SubscriptionGroup.create :name => "BLOGS"

  end
end

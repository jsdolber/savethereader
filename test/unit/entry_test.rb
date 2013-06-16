require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test "don't save without mandatory fields" do
    entry = Entry.new
    assert !entry.save, "saved entry without mandatory fields"
  end

  test "save with mandatory fields" do
    entry = Entry.new(:title => "More news", :url => "http://stackoverflow.com/feeds/page2.html", 
                       :feed_id => feeds(:stackoverflow).id, :guid => "http://stackoverflow.com/feeds/page2-guid.html")
    assert entry.save, "didn't save  with mandatory fields"
  end

  test "no duplicate guid" do
    entry = Entry.new(:title => "More news", :url => "http://stackoverflow.com/feeds/page2.html", 
                       :feed_id => feeds(:stackoverflow).id, :guid => entries(:one).guid)
    assert !entry.save, "saved with duplicate guid"
  end
end

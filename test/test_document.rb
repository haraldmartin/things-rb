require 'test_helper'

class DocumentTest < Test::Unit::TestCase
  def setup
    @things = @@things ||= Things.new(:database => DATABASE_FIXTURE_PATH)
  end
  
  test "should use the specified database if any" do
    IO.expects(:read).with('/path/to/database.xml').returns("foo").at_least_once
    things = Things.new(:database => '/path/to/database.xml')
    assert_equal('/path/to/database.xml', things.database_file)
  end

  test "should use default database unless other is specified" do
    default_db = ENV['HOME'] + '/Library/Application Support/Cultured Code/Things/Database.xml'
    IO.expects(:read).with(default_db).returns("foo").at_least_once
    assert_equal(default_db, Things.new.database_file)
  end
  
  test "should return a parsed Hpricot document" do
    IO.expects(:read).with('/my/db.xml').returns("foo").at_least_once
    things = Things.new(:database => '/my/db.xml')
    assert_equal("Hpricot::Doc", things.database.class.to_s)
    assert_equal "foo", things.database.to_s
  end

  [:today, :inbox, :trash, :logbook, :next].each do |type|
    test "should create a Focus instance for type #{type}" do
      focus = @things.focus(type)
      assert_instance_of(Things::Focus, focus)
    end

    test "should only create one Focus instance for #{type}" do
      focus = @things.focus(type)
      2.times { |i| assert_equal(focus, @things.focus(type)) }
    end

    test %Q{should have a shortcuts to the Focus "#{type}"} do
      Things::Focus.any_instance.stubs(:tasks).returns(%[foo bar baz])
      assert_equal(@things.focus(type).tasks, @things.send(type))
    end
  end
  
  test %Q{Should allow to send options to the focus today} do
    completed = @things.today(:completed => true )
    assert completed.all? { |e| e.title.include?("complete") }
  end
  
  [Things, Things::Document].each do |klass|
    test "should allow a block for #{klass}.new" do
      block = false
      klass.new(:database => DATABASE_FIXTURE_PATH) do |d|
        block = true
        assert_instance_of(Things::Document, d)
      end
      assert(block)
    end
  end
end
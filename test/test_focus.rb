require 'test_helper'
require 'ruby-debug'

class FocusTest < Test::Unit::TestCase
  def setup
    @things = @@things ||= Things.new(:database => DATABASE_FIXTURE_PATH)
    @todays_tasks = [
      "complete today item",
      "today item with notes",
      "complete today item with notes",
      "complete today item with a tag",
      "today item with multiple tags",
      "email bar",
      "today item",
      "today item with content (notes)"
    ]
  end

  test 'should find the Today focus' do
    assert_equal("z124", @things.focus(:today).id)
  end
  
  test "should find the focustype for Today" do
    assert_equal("65536", @things.focus(:today).type_id)
  end
  
  test "should find the focuses" do
    { :inbox       => "z120",
      :trash       => "z138",
      :logbook     => "z127",
      :nextactions => "z141"
    }.each do |name, id|
      assert_equal(id, @things.focus(name).id)
    end
  end
  
  test 'should allow "next" as alias for NextActions focus' do
    focus = Things::Focus.new(:next, stub(:xpath => []))
    assert_equal "FocusNextActions", focus.type_name
  end

  test 'should allow "nextactions" as alias for NextActions focus' do
    focus = Things::Focus.new(:nextactions, stub(:xpath => []))
    assert_equal "FocusNextActions", focus.type_name
  end
  
  test 'should allow "someday" as alias for Maybe focus' do
    focus = Things::Focus.new(:someday, stub(:xpath => []))
    assert_equal "FocusMaybe", focus.type_name
  end

  test "should raise FocusNotFound if the focus isn't found" do
    assert_raise(Things::InvalidFocus) { @things.focus(:invalid_focus) }
  end

  test "should find the same number of tasks as in Today" do
    tasks = @things.focus(:today).tasks
    assert_instance_of(Array, tasks)
    assert_equal(8, tasks.length)
  end
  
  test "should find the tasks' titles" do
    assert_equal(@todays_tasks.sort, @things.today.map(&:title).sort)
  end
  
  test "should sort the tasks by their position" do
    # TODO: tasks with projects/parent have other sorting order but need to 
    # figure out how Things handles that. Therefore skip these tasks for now
    todays_tasks = @todays_tasks.reject { |e| e == 'email bar' }
    assert_equal(todays_tasks, @things.today.reject { |e| e.parent? }.map(&:title))
  end
  
  test "should only find completed tasks when passing :completed => true" do
    complete = @things.focus(:today).tasks(:completed => true)
    assert complete.all? { |e| e.title.include?("complete") }
  end

  test "should not include completed tasks when passing :completed => false" do
    complete = @things.focus(:today).tasks(:completed => false)
    assert !complete.all? { |e| e.title.include?("complete") }
  end
  
  test "include canceled tasks when passing :canceled => true" do
    canceled = @things.focus(:next).tasks(:canceled => true)
    assert canceled.all? { |e| e.title.include?("cancel") }
  end

  test "dont include canceled tasks when passing :canceled => false" do
    canceled = @things.focus(:next).tasks(:canceled => false)
    assert !canceled.all? { |e| e.title.include?("cancel") }
  end
  
  test "should not find canceled nor completed tasks when passing :canceled => false, :completed => false" do
    tasks = @things.focus(:next).tasks(:canceled => false, :completed => false)
    assert_equal 0, tasks.select(&:canceled?).length
    assert_equal 0, tasks.select(&:completed?).length
  end
  
  test "should filter tasks by tag" do
    tasks = @things.focus(:next).tasks(:tag => 'home')
    assert tasks.all? { |e| e.tag?('home') }
  end
  
  test "should not include projects when listing tasks" do
    with_children = @things.focus(:next).tasks.select(&:children?)
    assert_equal 0, with_children.length
  end
end

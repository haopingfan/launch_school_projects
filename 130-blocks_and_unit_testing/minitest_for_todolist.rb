require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

require_relative 'todolist'


class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    first_item = @list.shift
    assert_equal(@todo1, first_item)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    last_item = @list.pop
    assert_equal(@todo3, last_item)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_raise_adding_object
    assert_raises(TypeError) { @list.add('Not todo obejct') }
    assert_raises(TypeError) { @list.add(1) }
  end

  def test_add
    @todo4 = Todo.new("Programming")
    @todos << @todo4
    assert_equal(@todos, @list.add(@todo4))
  end

  def test_item_at
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) { @list.item_at(100) }
  end

  def test_mark_done_at
    @list.mark_done_at(1)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo3.done?)
    assert_raises(IndexError) { @list.mark_done_at(100) }
  end

  def test_mark_undone_at
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_undone_at(1)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo3.done?)
    assert_raises(IndexError) { @list.mark_done_at(100) }
  end

  def test_done!
    @list.done!
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_another_to_s
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each 
    result = []
    @list.each { |todo| result << todo }
    assert_equal(@todos, result)
  end

  def test_each_return  
    result = @list.each { |todo| nil }
    assert_equal(@list, result)
  end

  def test_select
    @todo1.done!
    new_list = TodoList.new(@list.title)
    new_list.add(@todo1)
    result = @list.select {|todo| todo.done? }
    assert_equal(new_list.to_s, result.to_s)
    assert_equal(new_list.title, @list.title)
  end


end
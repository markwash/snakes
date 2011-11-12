require 'helper'

class TestDefaultSnake < Test::Unit::TestCase
  def setup
    @snake = Snake.new
  end

  def test_create_default_snake_length
    assert_equal 1, @snake.length
  end

  def test_create_default_snake_head_position
    assert_equal [0, 0], @snake.head
  end

  def test_create_default_snake_tail_position
    assert_equal [0, 0], @snake.tail
  end

  def test_create_default_snake_segments
    assert_equal 1, @snake.segments.length
  end

  def test_direction
    assert_equal :east, @snake.direction
  end

  def test_turn_cardinal_directions
    [:east, :west, :north, :south].each do |dir|
      @snake.turn(dir)
      assert_equal dir, @snake.direction
    end
  end

  def test_turn_invalid_direction
    assert_raise RuntimeError do
      @snake.turn(:up) # maybe only invalid for now? :-P
    end
  end
    
  def test_move_east
    @snake.turn(:east)
    @snake.move
    assert_equal [1, 0], @snake.head
    assert_equal @snake.head, @snake.tail
  end

  def test_move_west
    @snake.turn(:west)
    @snake.move
    assert_equal [-1, 0], @snake.head
    assert_equal @snake.head, @snake.tail
  end

  def test_move_north
    @snake.turn(:north)
    @snake.move
    assert_equal [0, 1], @snake.head
    assert_equal @snake.head, @snake.tail
  end

  def test_move_south
    @snake.turn(:south)
    @snake.move
    assert_equal [0, -1], @snake.head
    assert_equal @snake.head, @snake.tail
  end

end

class TestSnakeEdgeCases < Test::Unit::TestCase
  def test_create_with_one_point
    snake = Snake.new([3, 4])
    assert_equal [3, 4], snake.head
    assert_equal [3, 4], snake.tail
  end
end

class TestSnakeDefaultDirections < Test::Unit::TestCase
  def test_nothing
  end
end

class TestSingleSegmentSnake < Test::Unit::TestCase
  def setup
    @snake = Snake.new([0, 0], [0, 4])
  end

  def test_length
    assert_equal 5, @snake.length
  end

  def test_head
    assert_equal [0, 4], @snake.head
  end

  def test_tail
    assert_equal [0, 0], @snake.tail
  end

  def test_segments_length
    assert_equal 1, @snake.segments.length
  end

  def test_move_north
    @snake.turn(:north)
    @snake.move
    assert_equal [0, 5], @snake.head
    assert_equal [0, 1], @snake.tail
  end

  def test_turn_south_is_ignored
    @snake.turn(:north)
    @snake.turn(:south)
    assert_equal :north, @snake.direction
  end

end

class TestNorthLyingSnakeMovesEast < Test::Unit::TestCase
  def setup
    @snake = Snake.new([0, 4], [0, 0])
    @snake.turn(:east)
    @snake.move()
  end

  def test_has_two_segments
    assert_equal 2, @snake.segments.length
  end

  def test_length_stays_the_same
    assert_equal 5, @snake.length
  end
end

class TestMultiSegmentSnake < Test::Unit::TestCase
  def setup
    @snake = Snake.new([0, 0], [0, 4], [3, 4], [3, 2])
  end

  def test_length
    assert_equal 10, @snake.length
  end

  def test_head
    assert_equal [3, 2], @snake.head
  end

  def test_tail
    assert_equal [0, 0], @snake.tail
  end

  def test_middle_segment
    assert_equal [1, 4], @snake.segments[1].start
    assert_equal [3, 4], @snake.segments[1].end
  end

  def test_segments_length
    assert_equal 3, @snake.segments.length
  end
end

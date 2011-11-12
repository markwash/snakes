require 'helper'

class TestDefaultSnake < Test::Unit::TestCase
  def test_create_default_snake_length
    snake = Snake.new
    assert_equal 1, snake.length
  end

  def test_create_default_snake_head_position
    snake = Snake.new
    assert_equal [0, 0], snake.head
  end

  def test_create_default_snake_tail_position
    snake = Snake.new
    assert_equal [0, 0], snake.tail
  end

  def test_create_default_snake_segments
    snake = Snake.new
    assert_equal 1, snake.segments
  end

  def test_create_default_snake_segment_0
    snake = Snake.new
    assert_equal [0, 0], snake.segment(0)
  end
end

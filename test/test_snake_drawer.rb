require 'helper'

class FakeScreen
  attr :width
  attr :height

  def initialize(width, height)
    @@width = width
    @@height = height
    @@drawn = {}
  end

  def get(x, y)
    raise "%d, %d out of bounds!" % [x, y] unless in_range?(x, y)
    return @@drawn.fetch([x, y], " ")
  end

  def draw(x, y, value)
    @@drawn[[x, y]] = value if in_range?(x, y)
  end

  protected

  def in_range?(x, y)
    return (x >= 0 and y >= 0 and x < @@width and y < @@height)
  end
end

class TestSnakeDrawer < Test::Unit::TestCase

  def test_create_snake_drawer
    snake = Snake.new
    snake_drawer = SnakeDrawer.new(snake)
  end

  def test_draw_default_snake
    snake = Snake.new
    snake_drawer = SnakeDrawer.new(snake)
    screen = FakeScreen.new(2, 2)
    snake_drawer.draw(screen)
    assert_equal screen.get(0, 0), "O"
    assert_equal screen.get(0, 1), " "
    assert_equal screen.get(1, 0), " "
    assert_equal screen.get(1, 1), " "
  end
end

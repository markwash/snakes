class SnakeDrawer
  attr_reader :snake

  def initialize(snake)
    @snake = snake
  end

  def draw(screen)
    screen.draw(0, 0, "O")
  end
end

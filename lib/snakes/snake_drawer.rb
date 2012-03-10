class SnakeDrawer
  attr_reader :snake

  def initialize(snake)
    @snake = snake
  end

  def draw(screen)
    @snake.points do |pt|
      screen.draw(pt[0], pt[1], "O")
    end
  end
end

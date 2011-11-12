class Snake

  attr_reader :direction
  attr_reader :length
  attr_reader :points
  attr_reader :segments

  def initialize(*points)
    if points.length == 0
      points = [[0, 0], [0, 0]]
    elsif points.length == 1
      points = [points[0], points[0]]
    end
    @points = points
    @segments = SnakeSegments.new(self)
    @length = calculate_length 
    @direction = :east
  end

  def head
    return @points[0]
  end

  def tail
    return @points[-1]
  end

  def move
    if head == tail and @points.length == 2
      move_point(@points[0], @direction)
      move_point(@points[-1], @direction)
      return
    end
    neck_direction = Direction.from_points(*@segments[0])
    @points.unshift(@points[0].clone) if neck_direction != @direction
    move_point(@points[0], @direction)
    tail_direction = Direction.from_points(*@segments[-1])
    move_point(@points[-1], tail_direction)
    @points.pop() if @points[-1] == @points[-2]
  end
    
  def turn(direction)
    raise "Invalid direction!" unless Direction.valid?(direction)
    @direction = direction if direction_currently_possible?(direction)
  end

  protected
  def print_points(points)
    points.each { |x, y| print "(#{x}, #{y}) "}
    puts
  end

  def move_point(pt, direction)
    case direction
    when :east
      pt[0] += 1
    when :west
      pt[0] -= 1
    when :north
      pt[1] += 1
    when :south
      pt[1] -= 1
    end
  end

  def calculate_length
    length = 1
    @segments.each do |pt1, pt2|
      if pt1[0] == pt2[0]:
        diff_index = 1
      elsif pt1[1] == pt2[1]:
        diff_index = 0
      else
        raise "Invalid segment!"
      end
      length += (pt1[diff_index] - pt2[diff_index]).abs
    end
    return length
  end

  def direction_currently_possible?(dir)
    current_angle = Direction.from_points(*@segments[0])
    return dir != Direction.opposite(current_angle)
  end

end

class Direction

  VALID_DIRECTIONS = [:east, :west, :north, :south]
  OPPOSITES = {:east => :west, :west => :east,
               :north => :south, :south => :north}

  def self.valid?(direction)
    VALID_DIRECTIONS.include?(direction)
  end

  def self.from_points(pt1, pt2)
    return :nil if pt1 == pt2
    x1, y1 = pt1
    x2, y2 = pt2
    return :north if x1 == x2 and y1 > y2
    return :south if x1 == x2 and y1 < y2
    return :east if x1 > x2 and y1 == y2
    return :west if x1 < x2 and y1 == y2
    raise "Invalid segment! (#{x1}, #{y1}) -> (#{x2}, #{y2})"
  end

  def self.opposite(direction)
    return OPPOSITES[direction]
  end

  private
  def self.new
  end
end

class SnakeSegments

  attr_reader :points
  
  def initialize(snake)
    @snake = snake
  end

  def length
    return @snake.points.length - 1
  end

  def [](index)
    return [@snake.points[index], @snake.points[index + 1]] if index >= 0
    return [@snake.points[index - 1], @snake.points[index]] if index < 0
  end

  def each
    prev = nil
    @snake.points.each do |point|
      yield [prev, point] if not prev.nil?
      prev = point
    end
  end
end

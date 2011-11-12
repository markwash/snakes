class Snake

  attr_reader :segments
  attr_reader :length
  attr_reader :direction

  def initialize(*points)
    @direction = :east
    points = [[0, 0]] if points.length == 0
    if points.length == 1
      @segments = [Segment.new(points[0], @direction)]
    elsif points.length == 2 and points[0] == points[1]
      @segments = [Segment.new(points[0], @direction)]
    else
      @segments = convert_points_to_segments(points)
    end
    @length = calculate_length()
  end

  def head
    return @segments[-1].end
  end

  def tail
    return @segments[0].start
  end

  def move
    if @direction == head_segment.direction
      head_segment.grow
    else
      new_head = head.clone
      Point.move(new_head, @direction)
      @segments.push(Segment.new(new_head, @direction))
    end

    if tail_segment.length > 1
      tail_segment.shrink
    else
      @segments.shift
    end
  end
    
  def turn(direction)
    raise "Invalid direction!" unless Direction.valid?(direction)
    @direction = direction if direction_currently_possible(direction)
  end

  protected

  def head_segment
    return @segments[-1]
  end

  def tail_segment
    return @segments[0]
  end

  def calculate_length
    length = 0
    @segments.each do |segment|
      length += segment.length
    end
    return length
  end

  def direction_currently_possible(direction)
    return ((head_segment.length == 1) or
            (direction != Direction.opposite(segments[-1].direction)))
  end

  def substitute_default_points_if_necessary(points)
    if points.length == 0
      points = [[0, 0], [0, 0]]
    elsif points.length == 1
      points = [points[0], points[0]]
    end
    return points
  end

  def convert_points_to_segments(points)
    # points are given from tail to head
    segments = []
    prev = nil
    points.each do |pt|
      next if pt == prev
      segments << Segment.from_points(prev, pt) if not prev.nil?
      prev = pt
    end
    segments[1..-1].each do |segment| segment.shrink end
    return segments
  end

end

class Segment

  attr_reader :start
  attr_reader :length
  attr_reader :direction

  def self.from_points(start_pt, end_pt)
    raise "Invalid segment!" unless valid?(start_pt, end_pt)
    length = distance(start_pt, end_pt) + 1
    direction = Direction.from_points(start_pt, end_pt)
    return self.new(start_pt, direction, length)
  end

  def initialize(start, direction, length=1)
    @start = start
    @direction = direction
    @length = length
  end

  def to_s
    x, y = @start
    return "Segment: start:(#{x}, #{y}) #{@direction} #{@length}"
  end

  def end
    pt = @start.clone
    Point.move(pt, @direction, @length - 1)
    return pt
  end

  def grow
    @length += 1
  end

  def shrink
    raise "Can't shrink any more!" if @length == 1
    @length -= 1
    Point.move(@start, @direction)
  end

  protected
  def self.valid?(pt1, pt2)
    return (((pt1[0] == pt2[0]) or (pt1[1] == pt2[1])) and (pt1 != pt2))
  end

  def self.distance(pt1, pt2)
    return (pt1[0] - pt2[0]).abs + (pt1[1] - pt2[1]).abs
  end

end

class Direction

  DIRECTIONS = [:north, :south, :east, :west]
  OPPOSITES = {:north => :south, :south => :north,
               :east => :west, :west => :east}

  def self.from_points(pt1, pt2)
    x1, y1 = pt1
    x2, y2 = pt2
    return :north if y1 < y2
    return :south if y1 > y2
    return :east if x1 < x2
    return :west if x1 > x2
    raise "Invalid points!"
  end

  def self.opposite(direction)
    return OPPOSITES[direction]
  end

  def self.valid?(direction)
    return DIRECTIONS.include?(direction)
  end
  
end

class Point

  def self.move(point, direction, distance=1)
    point[0] += distance if direction == :east
    point[0] -= distance if direction == :west
    point[1] += distance if direction == :north
    point[1] -= distance if direction == :south
  end

end

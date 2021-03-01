# Alternatively use #!/usr/bin/env ruby & cmdline.rb
require 'fileutils'
require 'pry'

def snail(array)
  Snail_kay.run(array)
end

def snail_accepted(array)
  array.empty? ? [] : array.shift + snail(array.transpose.reverse)
end

def snail_charles(number)
  x_max = y_max = number.first.size - 1
  x_min = y_min = 0
  array_size = (x_max + 1)**2
  answer = []

  loop do
    xs = (x_min..x_max).to_a
    y = y_min
    answer += xs.map { |x| number[y][x] }
    y_min += 1 # => push down the top
    return answer if answer.size == array_size

    x = x_max
    ys = (y_min..y_max).to_a
    answer += ys.map { |y| number[y][x] }
    x_max -= 1 # => move the right side inward
    return answer if answer.size == array_size

    xs = (x_min..x_max).to_a.reverse
    y = y_max
    answer += xs.map { |x| number[y][x] }
    y_max -= 1 # => move up the bottom
    return answer if answer.size == array_size

    x = x_min
    ys = (y_min..y_max).to_a.reverse
    answer += ys.map { |y| number[y][x] }
    x_min += 1 # => move the left side in
    return answer if answer.size == array_size
  end
end

require 'json'
require 'set'
class Snail_kay

  def self.run(vector)
    current_loc = {row: 0, column: 0}
    direction = :east
    memory = Set[vector[0][0]]
    move(direction, current_loc, vector, memory, memory.to_a)
  end

  def self.next_direction(current_direction)
    directions = [:east, :south, :west, :north]
    current_idx = directions.find_index(current_direction)
    current_idx + 1 < directions.size ? (directions[current_idx + 1]) : directions[0]
  end

  def self.next_position(direction, current_loc)
    # puts "currently at: #{current_loc.inspect} & facing #{direction}"
    case direction
    when :east
      current_loc.merge({column: current_loc[:column] + 1 })
    when :south
      current_loc.merge({row: current_loc[:row] + 1 })
    when :west
      current_loc.merge({column: current_loc[:column] - 1 })
    when :north
      current_loc.merge({row: current_loc[:row] - 1 })
    end
  end

  def self.valid_position?(possible_next_position, vector)
    vector.size > possible_next_position[:row]\
      && vector[possible_next_position[:row]].size > possible_next_position[:column]
  end

  def self.move(direction, current_loc, vector, memory, answer)
    return answer if answer.size == (vector.size * vector[0].size)
    # puts "move: current_answer: #{answer.inspect}"
    possible_next_position = next_position(direction, current_loc)
    # puts "possible_next_position: #{possible_next_position.inspect} & facing #{direction}"
    if valid_position?(possible_next_position, vector)
      next_number = vector[possible_next_position[:row]][possible_next_position[:column]]
      if ! memory.include? next_number
        answer << next_number
        memory << answer.last
        move(direction, possible_next_position, vector, memory, answer)
      else
        turn_and_move(direction, current_loc, vector, memory, answer)
      end
    else
      turn_and_move(direction, current_loc, vector, memory, answer)
    end
  end
  def self.turn_and_move(direction, current_loc, vector, memory, answer)
    thataway = next_direction(direction)
    # puts "next direction: #{thataway}"
    move(thataway, current_loc, vector, memory, answer)
  end

end

# Fixed tests
# STDERR
# main.rb:31:in `next_position': stack level too deep (SystemStackError)
# 	from main.rb:43:in `move'
# 	from main.rb:61:in `turn_and_move'
# 	from main.rb:52:in `move'
# 	from main.rb:61:in `turn_and_move'
# 	from main.rb:55:in `move'
# 	from main.rb:61:in `turn_and_move'
# 	from main.rb:55:in `move'
# 	from main.rb:61:in `turn_and_move'
# 	 ... 7933 levels...
# 	from /runner/frameworks/ruby/cw-2.rb:55:in `block in describe'
# 	from /runner/frameworks/ruby/cw-2.rb:46:in `measure'
# 	from /runner/frameworks/ruby/cw-2.rb:51:in `describe'
# 	from main.rb:72:in `<main>'
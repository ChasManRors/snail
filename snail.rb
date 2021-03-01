# Alternatively use #!/usr/bin/env ruby & cmdline.rb
require 'fileutils'
require 'pry'
require 'json'
require 'set'

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

def run(vector)
  current_loc = { row: 0, column: 0 }
  direction = :east
  memory = Set[vector[0][0]]
  move(direction, current_loc, vector, memory, memory.to_a)
end

def next_direction(current_direction)
  directions = %i[east south west north]
  current_idx = directions.find_index(current_direction)
  current_idx + 1 < directions.size ? (directions[current_idx + 1]) : directions[0]
end

def next_position(direction, current_loc)
  # puts "currently at: #{current_loc.inspect} & facing #{direction}"
  case direction
  when :east
    current_loc.merge({ column: current_loc[:column] + 1 })
  when :south
    current_loc.merge({ row: current_loc[:row] + 1 })
  when :west
    current_loc.merge({ column: current_loc[:column] - 1 })
  when :north
    current_loc.merge({ row: current_loc[:row] - 1 })
  end
end

def valid_position?(possible_next_position, vector)
  vector.size > possible_next_position[:row]\
    && vector[possible_next_position[:row]].size > possible_next_position[:column]
end

def move(direction, current_loc, vector, memory, answer)
  return answer if answer.size == (vector.size * vector[0].size)

  # puts "move: current_answer: #{answer.inspect}"
  possible_next_position = next_position(direction, current_loc)
  # puts "possible_next_position: #{possible_next_position.inspect} & facing #{direction}"
  if valid_position?(possible_next_position, vector)
    next_number = vector[possible_next_position[:row]][possible_next_position[:column]]
    if !memory.include? next_number
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

def turn_and_move(direction, current_loc, vector, memory, answer)
  thataway = next_direction(direction)
  # puts "next direction: #{thataway}"
  move(thataway, current_loc, vector, memory, answer)
end

def snail(array)
  run(array.join(' '))
end

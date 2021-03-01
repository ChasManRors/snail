# Alternatively use #!/usr/bin/env ruby & cmdline.rb
require 'fileutils'
require 'pry'

class Snail
  def initialize; end

  def snail(number)
    x_max = y_max = number.first.size - 1
    x_min = y_min = 0
    array_size = (x_max + 1)**2
    answer = []

    while true

      xs = (x_min..x_max).to_a
      y = y_min
      answer << xs.map { |x| number[y][x] }
      y_min +=  1 # => push down the top
      return answer.flatten if answer.flatten.size == array_size

      x = x_max
      ys = (y_min..y_max).to_a
      answer << ys.map { |y| number[y][x] }
      x_max -= 1 # => move the right side inward
      return answer.flatten if answer.flatten.size == array_size

      xs = (x_min..x_max).to_a.reverse
      y = y_max
      answer << xs.map { |x| number[y][x] }
      y_max -= 1 # => move up the bottom
      return answer.flatten if answer.flatten.size == array_size

      x = x_min
      ys = (y_min..y_max).to_a.reverse
      answer << ys.map { |y| number[y][x] }
      x_min += 1 # => move the left side in
      return answer.flatten if answer.flatten.size == array_size

    end
  end
end

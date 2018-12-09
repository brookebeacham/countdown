#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'ws2812'
require 'pry'

class DigitDisplay

  NUMBER_OF_LEDS = 30

  tens_zero = [24,25,26,23,21,12,13,14,11,9,0,1,2]
  tens_one = [25,22,13,10,1]
  tens_two = [24,25,26,21,14,13,12,11,0,1,2]

  ones_zero = [27,28,29,20,18,15,17,8,6,3,4,5]
  ones_one = [28,19,16,7,4]
  ones_two = [27,28,29,18,17,16,15,8,3,4,5]
  ones_three = [27,28,29,18,17,16,15,6,3,4,5]
  ones_four = [27,20,15,16,17,29,18,6,5]
  ones_five = [27,28,29,20,15,16,17,6,5,4,3]
  ones_six = [27,28,29,20,15,16,17,8,6,3,4,5]
  ones_seven = [27,28,29,18,17,6,5]
  ones_eight = [27,28,29,20,18,15,16,17,8,6,3,4,5]
  ones_nine = [27,28,29,20,18,15,16,17,6,5]

  VALUES = {
     0 => tens_zero + ones_zero,
     1 => ones_one,
     2 => ones_two,
     3 => ones_three,
     4 => ones_four,
     5 => ones_five,
     6 => ones_six,
     7 => ones_seven,
     8 => ones_eight,
     9 => ones_nine,
    10 => tens_one + ones_zero,
    11 => tens_one + ones_one,
    12 => tens_one + ones_two,
    13 => tens_one + ones_three,
    14 => tens_one + ones_four,
    15 => tens_one + ones_five,
    16 => tens_one + ones_six,
    17 => tens_one + ones_seven,
    18 => tens_one + ones_eight,
    19 => tens_one + ones_nine,
    20 => tens_two + ones_zero,
    21 => tens_two + ones_one,
    22 => tens_two + ones_two,
    23 => tens_two + ones_three,
    24 => tens_two + ones_four,
    25 => tens_two + ones_five
  }

  def initialize(ws, offset, on_color, off_color = nil)
		off_color ||= Ws2812::Color.new(0, 0, 0)
		@ws, @offset, @on_color, @off_color = ws, offset, on_color, off_color
	end

	attr_reader :ws
	attr_accessor :offset, :on_color, :off_color

  def show (value)
    raise ArgumentError, "invalid value" unless VALUES[value]
    wipe
    0.upto(NUMBER_OF_LEDS-1) do |i|
      ws[i+offset] = on_color if VALUES[value].include?(i)
    end
    ws.show
  end

  def wipe
    0.upto(NUMBER_OF_LEDS-1) do |i|
      ws[i+offset] = off_color
    end
    ws.show
  end

end

# Init
n = 50 # total num leds
ws = Ws2812::Basic.new(n, 18) # +n+ leds at pin 18, using defaults
ws.open

black = Ws2812::Color.new(0, 0, 0)
red   = Ws2812::Color.new(0, 0xff, 0)
green = Ws2812::Color.new(0xff, 0, 0)
blue  = Ws2812::Color.new(0, 0, 0xff)

# all set to black/off
ws[(0...n)] = black
ws.show

nbrs = DigitDisplay.new(ws, 20, red)
25.downto(0) do |i|
  nbrs.show(i)
  sleep 10
end

binding.pry

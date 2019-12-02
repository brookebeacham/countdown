#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'ws2812'
require 'pry'

class DigitDisplay

  NUMBER_OF_LEDS = 30

  TENS_ZERO = [24,25,26,23,21,12,13,14,11,9,0,1,2]
  TENS_ONE = [25,22,13,10,1]
  TENS_TWO = [24,25,26,21,14,13,12,11,0,1,2]

  ONES_ZERO = [26,27,28,21,19,14,16,9,7,2,3,4]
  ONES_ONE = [28,19,16,7,4]
  ONES_SOLO = [27,20,15,8,3]
  ONES_TWO = [26,27,28,19,16,15,14,9,2,3,4]
  ONES_THREE = [26,27,28,19,16,15,14,7,4,3,2]
  ONES_FOUR_SOLO = [26,21,14,15,16,28,19,7,4]
  ONES_FOUR = [27,20,15,16,29,18,17,6,5]
  ONES_FIVE = [26,27,28,21,14,15,16,7,4,3,2]
  ONES_SIX = [26,27,28,21,14,15,16,9,7,2,3,4]
  ONES_SEVEN = [26,27,28,19,16,7,4]
  ONES_EIGHT = [26,27,28,21,19,14,15,16,9,7,2,3,4]
  ONES_NINE = [26,27,28,21,19,14,15,16,7,4]

  VALUES = {
     0 => TENS_ZERO + ONES_ZERO,
     1 => ONES_SOLO,
     2 => ONES_TWO,
     3 => ONES_THREE,
     4 => ONES_FOUR_SOLO,
     5 => ONES_FIVE,
     6 => ONES_SIX,
     7 => ONES_SEVEN,
     8 => ONES_EIGHT,
     9 => ONES_NINE,
    10 => TENS_ONE + ONES_ZERO,
    11 => TENS_ONE + ONES_ONE,
    12 => TENS_ONE + ONES_TWO,
    13 => TENS_ONE + ONES_THREE,
    14 => TENS_ONE + ONES_FOUR,
    15 => TENS_ONE + ONES_FIVE,
    16 => TENS_ONE + ONES_SIX,
    17 => TENS_ONE + ONES_SEVEN,
    18 => TENS_ONE + ONES_EIGHT,
    19 => TENS_ONE + ONES_NINE,
    20 => TENS_TWO + ONES_ZERO,
    21 => TENS_TWO + ONES_ONE,
    22 => TENS_TWO + ONES_TWO,
    23 => TENS_TWO + ONES_THREE,
    24 => TENS_TWO + ONES_FOUR,
    25 => TENS_TWO + ONES_FIVE
  }

  def initialize(ws, offset, tens_on_color, ones_on_color, off_color = nil)
		off_color ||= Ws2812::Color.new(0, 0, 0)
		@ws, @offset, @tens_on_color, @ones_on_color, @off_color = ws, offset, tens_on_color, ones_on_color, off_color
	end

	attr_reader :ws
	attr_accessor :offset, :tens_on_color, :ones_on_color, :off_color

  def show (value)
    raise ArgumentError, "invalid value" unless VALUES[value]
    wipe
    0.upto(NUMBER_OF_LEDS-1) do |i|
      ws[i+offset] = choose_on_color(value,i) if VALUES[value].include?(i)
    end
    ws.show
  end

  def wipe
    0.upto(NUMBER_OF_LEDS-1) do |i|
      ws[i+offset] = off_color
    end
    ws.show
  end

  def choose_on_color(value, led)
    if value >= 20
      selected_color = TENS_TWO.include?(led) ? tens_on_color : ones_on_color
    elsif value >= 10
      selected_color = TENS_ONE.include?(led) ? tens_on_color : ones_on_color
    else
      selected_color = ones_on_color
    end
    selected_color
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

# days til xmas
i = 25-Time.now.day

nbrs = DigitDisplay.new(ws, 20, green, red)
nbrs.show(i)
sleep 5
ws.show
ws.show

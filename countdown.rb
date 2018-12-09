#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'ws2812'
require 'pry'

class DigitDisplay

  NUMBER_OF_LEDS = 30

  tens_one = [25,22,13,10,1]
  ones_one = [28,19,16,7,4]

  VALUES = {
     1 => ones_one,
    11 => tens_one + ones_one
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
  end

  def wipe
    0.upto(NUMBER_OF_LEDS-1) do |i|
      ws[i+offset] = off_color
    end
  end

end

# Init
n = 50 # total num leds
ws = Ws2812::Basic.new(n, 18) # +n+ leds at pin 18, using defaults
ws.open

black = Ws2812::Color.new(0, 0, 0)
red   = Ws2812::Color.new(0xff, 0, 0)
green = Ws2812::Color.new(0, 0xff, 0)

# all set to black/off
ws[(0...n)] = black
ws.show

nbrs = DigitDisplay.new(ws, 20, red)
nbrs.show(1)
sleep 10
nbrs.show(11)

binding.pry

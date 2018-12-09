#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'ws2812'

n = 50 # total num leds
black = Ws2812::Color.new(0, 0, 0)
ws[(0...n-1)] = black
ws.show

require 'ruby2d'
require_relative 'Element/Slider.rb'
require_relative 'Element/ButtonList.rb'

set width: 800, height:800
set title: "CircleVis", fullscreen:false, background: '#90b8d2'

mySlider = Slider.new(x: 100, y:100)

myRadios = ButtonList.new(type: 'radio')
myRadios.addOption(x:20, y: 150, name: "yes")
myRadios.addOption(x:20, y: 200, name: "no")

myButtons = ButtonList.new(type: 'checkbox')
myButtons.addOption(x:100, y:150, name: "this")
myButtons.addOption(x:100, y:200, name: "and this")

show

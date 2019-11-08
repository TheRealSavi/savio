require 'ruby2d'
require_relative 'Element/hsv.rb'

view = Square.new(
  x:10,
  y:10,
  size: 400
)
label = Text.new(
  'value',
  x:430, y:10
)

mySlider = Slider.new(
  x:10, y:430,
  min:0,
  max:360,
  length:500
)
mySat = Slider.new(
  x:450, y:80,
  min:0.0,
  max:1.0,
  length:100
)
myVal = Slider.new(
  x:450, y:120,
  min:0.0,
  max:1.0,
  length:100
)

temp = 0
update do
  temp += 1
  temp = temp % 360
  mySlider.setValue(temp)
  hue = hsv2rgb(mySlider.value,mySat.value,myVal.value)
  view.color.r = hue[0]
  view.color.g = hue[1]
  view.color.b = hue[2]
  text = ('%0.2f' % hue[0].to_s) + "," + ('%0.2f' % hue[1].to_s) + "," + ('%0.2f' % hue[2].to_s)
  label.text = text
end
show

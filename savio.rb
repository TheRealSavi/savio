require 'ruby2d'
require_relative 'Element/Slider.rb'
require_relative 'Element/ButtonList.rb'

set width: 800, height:800
set title: "SavIO", fullscreen:false, background: 'black'

label = Text.new(
  'Hi',
  x: 300, y: 100,
  size: 40
)

mySlider = Slider.new(x:100,y:100)
mySlider.setValue(68)

myRadios = ButtonList.new(type: 'radio')
myRadios.addOption(x:20, y: 150, name: "yes")
myRadios.addOption(x:20, y: 200, name: "no", selected: true)

myButtons = ButtonList.new(type: 'checkbox')
myButtons.addOption(x:100, y:150, name: "this", value: "Hello")
myButtons.addOption(x:100, y:200, name: "and this", value: "World", selected:true)


update do

  if myRadios.options["yes"].selected == true
    mySlider.setValue(rand(100))
  end

  mystring = ""
  myButtons.options.each do |name, option|
    if option.selected
      mystring += option.value.to_s
    end
  end
  label.text = mystring

end

show

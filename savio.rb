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

mySlider = Slider.new(displayName: "gay slider", x:100,y:100)
mySlider.setValue(68)

myRadios = ButtonList.new(type: 'radio')
myRadios.addOption(x:20, y: 150, displayName: "hide slider", id: "hide")
myRadios.addOption(x:20, y: 200, displayName: "move left", id: "sl")
myRadios.addOption(x:20, y: 250, displayName: "move right", id: "sr")
myRadios.addOption(x:20, y: 300, displayName: "none", selected: true)

myButtons = ButtonList.new(type: 'checkbox')
myButtons.addOption(x:300, y:200, displayName: "this", value: "Hello", selected: true)
myButtons.addOption(x:300, y:250, displayName: "and this", value: "Hi")
update do

  if mySlider.value == 55
    myButtons.options["this"].select
  end

  if myRadios.options["hide"].selected == true
    mySlider.remove
  else
    mySlider.add
  end

  if myRadios.options["sl"].selected == true
    mySlider.length -= 1
  end

  if myRadios.options["sr"].selected == true
    mySlider.length += 1
  end

  if myButtons.options["and this"].selected == true
    myButtons.options["and this"].displayName = "gay"
    myButtons.options["and this"].y -= 1
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

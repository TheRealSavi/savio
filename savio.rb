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

mySlider = Slider.new(
  displayName: "gay slider",
  x:100,y:100,
  min: 0, max: 99,
  length: 256
)

mySlider.setValue(68)

myRadios = ButtonList.new(type: 'radio')

myRadios.addOption(x:20, y: 150, displayName: "hide slider", id: "hide")

myRadios.addOption(x:20, y: 200, displayName: "move left", id: "sl")
myRadios.addOption(x:20, y: 250, displayName: "move right", id: "sr")
myRadios.addOption(x:20, y: 300, displayName: "none", selected: true)

myButtons = ButtonList.new(type: 'checkbox')
myButtons.addOption(x:300, y:200, displayName: "this", value: "Hello", selected: true)
myButtons.addOption(x:300, y:250, displayName: "and this", value: "Hi")

myButtons.change(optionID:"this", setting: "displayName", value: "goober")

update do
  if mySlider.value == 55
    mySlider.setValue(2)
  end

  if myRadios.selected.include?("hide")
    mySlider.remove
  else
    mySlider.add
  end

  if myRadios.selected.include?("sl")
    mySlider.length -= 1
  end

  if myRadios.selected.include?("sr")
    mySlider.length += 1
  end

  if myButtons.selected.include?("and this")
    myButtons.change(optionID:"and this", setting:"x",
      value: myButtons.view(optionID:"and this", setting:"x")-1
    )
  end

  mystring = ""

  myButtons.optionID.each do |id|
    if myButtons.selected.include?(id)
      mystring += myButtons.view(optionID:id, setting: "value").to_s
    end
  end

  label.text = mystring

end

show

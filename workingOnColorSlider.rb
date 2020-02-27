require_relative 'savio'

colorSlider = ColorSlider.new(x:100, y: 200)
button = Button.new(x:30, y: 30, type: 'clicker', displayName: 'Set Knob Color')

button.onClick do
  colorSlider.knobColor = colorSlider.hex
end

update do
  colorSlider.setValue(colorSlider.value + 1)
end

show()

require 'savio'

$colorSlider = ColorSlider.new(x: 200, y:200)

update do
  puts $colorSlider.hsv
end

show()

require_relative 'savio'
set width: 1680, height:1050
set title: "Asteroids", fullscreen:true, background: '#020f18'

$test = ColorSlider.new(x: 840, y: 350, size: 300, sectors: 64)
ColorSlider.new(x: 120, y: 120, size: 50)

update do
  puts "r: " + ($test.rgb[0] * 255).to_s()
  puts "g: " + ($test.rgb[1] * 255).to_s()
  puts "b: " + ($test.rgb[2] * 255).to_s()
  puts "hex: " + $test.hex
  ColorSlider.sliders.each do |slider|
    if slider.animating == true
      slider.animate
    end
  end
end

show

require_relative 'savio'
set width: 800, height: 800

$circle = Circle.new(x: 400, y: 400, radius: 200, sectors: 128, color: 'blue')
$line = Line.new(
  x1: $circle.x - $circle.radius, y1: $circle.y - $circle.radius + $circle.radius,
  x2: $circle.x + $circle.radius, y2: $circle.y - $circle.radius + $circle.radius,
  color: 'green'
)

$slider1 = Slider.new()

$slider = Slider.new(x: 50, y:100, min: 0, max: 400, length: 400, value: 0, size: 12, displayName: "Distance from top")
$slider2 = Slider.new(x: 50, y:200, min: 0, max: 50, length: 50, value: 0, size: 12, displayName: "Margin from edge")
update do

  margin = $slider2.value

  height = $slider.value
  puts "height:" + height.to_s

  angle = 2 * Math.acos( 1.0 - height / $circle.radius.to_f)
  angle = angle * 180/Math::PI
  puts "angle:" + angle.to_s

  chord = 2 * Math.sqrt(2 * $circle.radius * height - height**2)
  puts "chord:" + chord.to_s

  adjust = ($circle.radius * 2 - (chord )) / 2
  puts "adjust:" + adjust.to_s

  $slider1.x = $circle.x - $circle.radius + adjust + margin
  $slider1.y = $circle.y - $circle.radius + height
  $slider1.length = (chord - margin * 2)

  $line.x1 = $circle.x - $circle.radius + adjust
  $line.y1 = $circle.y - $circle.radius + height
  $line.x2 = $circle.x + $circle.radius - adjust
  $line.y2 = $circle.y - $circle.radius + height

end

show

require_relative 'savio.rb'

set background: '#607564'

$view = Square.new(
  x:10,
  y:10,
  size: 400
)
$label = Text.new(
  'value',
  x:430, y:10
)

$myAngle = Slider.new(
  displayName: "Angle",
  x:10, y:430,
  min:0.0,
  max:360.0,
  length:500,
  value: rand(0.0..360.0)
)
$mySaturation = Slider.new(
  displayName: "Saturation",
  x:450, y:80,
  min:0.0,
  max:1.0,
  length:100,
  value: rand(0.0..1.0)
)
$myValue = Slider.new(
  displayName: "Value",
  x:450, y:120,
  min:0.0,
  max:1.0,
  length:100,
)

$mySettings = ButtonList.new(type: 'checkbox')

$mySettings.addOption(displayName: 'Loop Angle?', x: 450, y: 240, id: 'doLoop')
$mySettings.addOption(displayName: 'Randomize?', x: 450, y: 280, id: 'doRandom')

def updateView()
  hue = hsv2rgb($myAngle.value,$mySaturation.value,$myValue.value)
  $view.color.r = hue[0]
  $view.color.g = hue[1]
  $view.color.b = hue[2]

  text = ('%0.2f' % hue[0].to_s) + "," + ('%0.2f' % hue[1].to_s) + "," + ('%0.2f' % hue[2].to_s)
  $label.text = text
end

update do
  if $mySettings.selected.include?('doLoop')
    $myAngle.setValue(($myAngle.value + 0.25 ) % 360)
  end

  if $mySettings.selected.include?('doRandom')
    $myAngle.setValue(rand(0.0..360.0))
    $mySaturation.setValue(rand(0.0..1.0))
    $myValue.setValue(rand(0.0..1.0))
  end

  updateView()
end

show

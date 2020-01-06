require_relative 'savio'
set width: 1100, height: 800
$buttonManager = ButtonList.new()
$sliderManager = {}

$sidebarButtonManager = ButtonList.new()

def makeSidebar()
  seperatorLine = Line.new(x1: 800, y1: 0, x2: 800, y2: 800)

  templateSlider = Slider.new(x: 830, y: 40, length: 220, draggingEnabled: true, dragType: "duplicate", knobColor: "blue")
  templateButton = $sidebarButtonManager.addOption(x: 830, y: 90, displayName: "Radio ButtonList", id: "j")
  templateButton = $sidebarButtonManager.addOption(x: 830, y: 150, displayName: "Checkbox ButtonList", id: "o")
  inputBox = InputBox.new(x: 830, y: 180, size: 20, draggingEnabled: true, dragType: "duplicate")
  colorPicker = ColorSlider.new(x: 940, y: 300)

  listLine = Line.new(x1: 800, y1: 420, x2: 1100, y2: 420)
  listText = Text.new("ButtonList's : ", x: 810, y: 430)

end

makeSidebar()

update do
  ColorSlider.sliders.each do |slider|
    if slider.animating == true
      slider.animate
    end
  end


end

show()

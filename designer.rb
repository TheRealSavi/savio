require_relative 'savio'
set width: 1100, height: 800

class Sidebar
  attr_accessor :elements, :buttonManager

  def initialize()
    @elements = {}
    @buttonManager = ButtonManager.new(type: "radio")
    @mode = true

    @elements[:lineEdge] = Line.new(
      x1: 800, y1: 0,
      x2: 800, y2: 800
    )

    @elements[:templateSlide] = Slider.new(
      x: 830, y: 40, length: 220,
      draggingEnabled: true, dragType: "duplicate"
    )

    @elements[:templateRadio] = Button.new(
      x: 830, y: 90,
      displayName: "Radio ButtonManager",
      buttonManager: @buttonManager,
      draggingEnabled: true, dragType: "duplicate"
    )

    @elements[:templateCheck] = Button.new(
      x: 830, y: 150,
      displayName: "Checkbox ButtonManager",
      buttonManager: @buttonManager,
      draggingEnabled: true, dragType: "duplicate"
    )

    @elements[:templateInput] = InputBox.new(
      x: 830, y: 180, size: 30,
      activeColor: 'purple',
      draggingEnabled: true, dragType: "duplicate"
    )

    @elements[:templateColor] = ColorSlider.new(
      x: 940, y: 300
    )

    @elements[:lineList] = Line.new(
      x1: 800, y1: 420,
      x2: 1100, y2: 420
    )

    @elements[:lineText] = Text.new("buttonManager's : ",
      x: 810, y: 430
    )
  end

end

$sidebar = Sidebar.new()

update do

  ColorSlider.sliders.each do |slider|
    if slider.animating == true
      slider.animate
    end
  end
end

show()

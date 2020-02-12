require_relative 'savio'
set width: 1100, height: 800

class Sidebar
  attr_accessor :elements, :buttonManagers, :buttonManagersUI

  def initialize()
    @elements = {}
    @buttonManagersUI = []
    @buttonManagers = []
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
      draggingEnabled: false
    )

    @elements[:templateCheck] = Button.new(
      x: 830, y: 150,
      displayName: "Checkbox ButtonManager",
      draggingEnabled: false
    )

    @elements[:templateInput] = InputBox.new(
      x: 830, y: 180, size: 20,
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
  $sidebar.elements[:templateSlide].displayName = $sidebar.elements[:templateInput].value
  $sidebar.elements[:templateCheck].displayName = $sidebar.elements[:templateInput].value + " CB BM"
  $sidebar.elements[:templateRadio].displayName = $sidebar.elements[:templateInput].value + " RD BM"

  if $sidebar.elements[:templateCheck].selected
    $sidebar.elements[:templateCheck].deselect
    $sidebar.buttonManagers.push(ButtonManager.new(type: 'checkbox'))
    $sidebar.buttonManagersUI.push(
      Button.new(
        x: 830, y: $sidebar.buttonManagersUI.count * 30 + 490,
        displayName: $sidebar.elements[:templateCheck].displayName + " : " + $sidebar.buttonManagers.count.to_s,
        buttonManager: $sidebar.buttonManagers[$sidebar.buttonManagers.count-1],
        draggingEnabled: true, dragType: 'duplicate'
      )
    )
  end

  if $sidebar.elements[:templateRadio].selected
    $sidebar.elements[:templateRadio].deselect
    $sidebar.buttonManagers.push(ButtonManager.new(type: 'radio'))
    $sidebar.buttonManagersUI.push(
      Button.new(
        x: 830, y: $sidebar.buttonManagersUI.count * 30 + 490,
        displayName: $sidebar.elements[:templateRadio].displayName + " : " + $sidebar.buttonManagers.count.to_s,
        buttonManager: $sidebar.buttonManagers[$sidebar.buttonManagers.count-1],
        draggingEnabled: true, dragType: 'duplicate'
      )
    )
  end

  $sidebar.buttonManagersUI.each do |button|
    if button.duplicate
      button.duplicate.displayName = $sidebar.elements[:templateInput].value
    end
  end

  ColorSlider.sliders.each do |slider|
    if slider.animating == true
      slider.animate
    end
  end
end

show()

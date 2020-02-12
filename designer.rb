require_relative 'savio'
set width: 1100, height: 800

class Sidebar
  attr_accessor :elements, :buttonManagers, :buttonManagersUI

  def initialize()
    @elements = {}
    @buttonManagersUI = []
    @buttonManagers = []
    @mode = true

    @elements[:settingSize] = Slider.new(
      x: 830, y:750,
      length: 90,
      min: 1, max: 30,
      displayName: "Size",
      value: 10
    )

    @elements[:settingExport] = Button.new(
      x: 990, y:750,
      displayName: "Export"
    )

    @lineEdge = Line.new(
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

    @lineList = Line.new(
      x1: 800, y1: 420,
      x2: 1100, y2: 420
    )

    @lineText = Text.new("buttonManager's : ",
      x: 810, y: 430
    )
  end

end

$sidebar = Sidebar.new()
$stop = false

def export()
  $stop = true
  $sidebar.elements.each do |key, val|
    val.kill
  end
  $sidebar.buttonManagersUI.each do |val|
    val.kill
  end
  toexport = []
  Savio.elements.each do |e|
    obj = []
    obj.push(e.class.name)
    options = {}
    options['x'] = e.x
    options['y'] = e.y
    options['z'] = e.z
    options['size'] = e.size
    options['enabled'] = e.enabled
    options['displayName'] = e.displayName
    case e.class.name
    when "Slider"
      options['length'] = e.length
      options['min'] = e.min
      options['max'] = e.max
      options['value'] = e.value
    when "Button"
      options['selected'] = e.selected
    when "InputBox"
      options['selected'] = e.selected
      options['value'] = e.value
      options['length'] = e.length
      options['height'] = e.height
    end
    parse = options.to_s.gsub(",",";").gsub('"', "")
    obj.push(parse)
    toexport.push(obj)
  end

  out_file = File.new("scene.txt", "w")
  out_file.puts(toexport.to_s.chomp)
  out_file.close
end

update do

  if !$stop

    if $sidebar.elements[:settingExport].selected
      export()
      close()
    end

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


    $sidebar.elements[:templateSlide].size = $sidebar.elements[:settingSize].value
    $sidebar.elements[:templateInput].size = $sidebar.elements[:settingSize].value
    $sidebar.buttonManagersUI.each do |button|
      button.size = $sidebar.elements[:settingSize].value
    end


    ColorSlider.sliders.each do |slider|
      if slider.animating == true
        slider.animate
      end
    end
  end
end

show()

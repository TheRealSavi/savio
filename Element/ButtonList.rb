class ButtonList
  attr_reader :selected, :optionID

  @@buttonLists = []
  def self.buttonLists
    @@buttonLists
  end

  def initialize(args = {})
    @@buttonLists.push(self)

    @type = args[:type] || 'checkbox'
    @options = {}
    @optionID = []
    @selected = []
  end

  def addOption(optionParams)
    newOption = Option.new(optionParams)
    @options[newOption.id] = newOption
    @optionID.push(newOption.id)
    return newOption.id
  end

  def toggle(optionID)
    if @options.has_key?(optionID)
      if @type == 'checkbox'
        if @options[optionID].selected == true
          deselect(optionID)
        else
          select(optionID)
        end
      elsif @type == 'radio'
        select(optionID)
      end
    end
  end

  def select(optionID)
    if @options.has_key?(optionID)
      if @type == 'checkbox'
        @selected.push(optionID)
        @options[optionID].select
      elsif @type == 'radio'
        @options.each do |id, option|
          option.deselect
        end
        @selected.clear
        @selected.push(optionID)
        @options[optionID].select
      end
    end
  end

  def deselect(optionID)
    if @options.has_key?(optionID)
      if @type == 'checkbox'
        @selected.delete(optionID)
        @options[optionID].deselect
      elsif @type == 'radio'
        #Can not deselect a radio
      end
    end
  end

  def touch(optionID)

  end

  def change(args = {})
    if @options.has_key?(args[:optionID])
      @options[args[:optionID]].send(args[:setting]+"=", args[:value])
    end
  end
  def view(args = {})
    if @options.has_key?(args[:optionID])
      return @options[args[:optionID]].send(args[:setting])
    end
  end

  class Option
    attr_accessor :value, :enabled
    attr_reader :x, :y, :z, :size, :selected, :displayName, :id, :shown

    def initialize(args = {})
      @displayName = args[:displayName].to_s || "default"
      @value = args[:value] || 0
      @x = args[:x] || 0
      @y = args[:y] || 0
      @z = args[:z] || 1
      @size = args[:size] || 10
      @baseColor = args[:baseColor] || 'white'
      @selectedColor = args[:selectedColor] || 'blue'
      @labelColor = args[:labelColor] || 'white'
      @selected = args[:selected] || false
      @enabled = args[:enabled] || true
      @id = args[:id] || @displayName

      build()

      if @selected == true
        select()
      else
        @selectCircle.remove
      end
    end

    def x=(x)
      @x = x
      rebuild()
    end
    def y=(y)
      @y = y
      rebuild()
    end
    def z=(z)
      @z = z
      rebuild()
    end
    def size=(size)
      @size = size.abs
      rebuild()
    end
    def displayName=(displayName)
      @displayName = displayName
      rebuild()
    end
    def baseColor=(c)
      @baseColor = c
      rebuild()
    end
    def selectedColor=(c)
      @selectedColor = c
      rebuild()
    end
    def labelColor=(c)
      @labelColor = c
      rebuild()
    end

    def rebuild()
      remove()
      build()
    end

    def select()
      @selectCircle.add
      @selected = true
    end

    def deselect()
      @selectCircle.remove
      @selected = false
    end

    def remove()
      if @shown == false
        return
      end
      @nameLabel.remove
      @baseCircle.remove
      @selectCircle.remove
      @shown = false
    end

    def add()
      if @shown == true
        return
      end
      @nameLabel.add
      @baseCircle.add
      @selectCircle.add
      @shown = true
    end

    def build()
      @shown = true

      @nameLabel = Text.new(
        @displayName.to_s,
        x: @x + @size * 2, y: @y - @size,
        size: @size * 2,
        color: @labelColor
      )
      @baseCircle = Circle.new(
        x: @x, y: @y,
        radius: @size,
        color: @baseColor,
        z: @z
      )
      @selectCircle = Circle.new(
        x: @x, y: @y,
        radius: @size * 0.8,
        color: @selectedColor,
        z: @z+1
      )
    end
  end

end

on :mouse_down do |event|
  if event.button == :left
    ButtonList.buttonLists.each do |buttonList|
      buttonList.optionID.each do |id|
        meShown = buttonList.view(optionID: id, setting: "shown")
        meEnabled = buttonList.view(optionID: id, setting: "enabled")
        meX = buttonList.view(optionID: id, setting: "x")
        meY = buttonList.view(optionID: id, setting: "y")
        meSize = buttonList.view(optionID: id, setting: "size")
        if meShown && meEnabled
          if event.x.between?(meX-meSize,meX+meSize) && event.y.between?(meY-meSize,meY+meSize)
            buttonList.toggle(id)
          end
        end
      end
    end
  end
end

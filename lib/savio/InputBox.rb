module Savio
  class InputBox
    include IORenderable

    attr_accessor :shift
    attr_reader :selected, :value, :length, :height, :displayName

    @@inputBoxs = []
    def self.inputBoxs
      @@inputBoxs
    end

    @@tabIndex = 0

    def initialize(args = {})
      super(args)

      @@inputBoxs.push(self)

      @selected = args[:selected] || false

      @size = args[:size] || 20

      @shift = false

      @value = args[:value] || ""

      @length = args[:length] || @size * 10
      @height = args[:height] || @size * 1.2

      @color = args[:color] || Savio::Colors::White
      @activeColor = args[:activeColor] || Savio::Colors::Green

      @activeTextColor = args[:activeTextColor] || Savio::Colors::White
      @inactiveTextColor = args[:inactiveTextColor] || Savio::Colors::Gray

      build()

      if @shown == false
        remove()
      end

    end

    def remove()
      super()
      @display.remove
      @container.remove
    end

    def add()
      super()
      @display.add
      @container.add
    end

    def color=(color)
      @color = color
      rebuild()
    end
    def activeColor=(color)
      @activeColor = color
      rebuild()
    end
    def activeTextcolor=(color)
      @activeTextcolor = color
      rebuild()
    end
    def inactiveTextColor=(color)
      @inactiveTextColor = color
      rebuild()
    end
    def length=(length)
      @length = length
      rebuild()
    end
    def height=(height)
      @height = height
      rebuild()
    end

    def value=(value)
      @value = value
      if @value == ""
        @display.text = @displayName
      else
        @display.text = @value
      end
    end

    def clear()
      @value = ""
      @display.text = @displayName
    end

    def size=(size)
      @length = size * 10
      @height = size * 1.2
      super(size)
    end

    def tabMover()
      if @@tabIndex >= @@inputBoxs.count
        @@tabIndex = 0
      end

      for i in @@tabIndex..@@inputBoxs.count-1 do
        if @@inputBoxs[i].enabled && @@inputBoxs[i].shown
          @@tabIndex = i
          deselect()
          @@inputBoxs[i].select()
        end
        if @selected
          @@tabIndex = 0
        end
      end
    end

    def addKey(key)
      if key == "space"
        @value += + " "
        updateDisplay()
      elsif key == "return"
        deselect()
      elsif key == "backspace"
        @value = @value[0...-1]
        updateDisplay()
      elsif key.chars.count == 1
        if @shift == true
          key = key.upcase
        end
        @value += key
        updateDisplay()
      elsif key == "tab"
        tabMover()
      else
        puts "SAVIO : I am a work in progress, and the key you pressed couldnt be handled"
        puts "SAVIO : Unknown key : " + key.to_s
      end
    end

    def updateDisplay()
      @display.text = @value + "|"
    end

    def selected=(bool)
      if bool == true
        select()
      elsif bool == false
        deselect()
      end
    end

    def select()
      @selected = true

      @display.text = @value + "|"
      @display.color = @activeTextColor
      @container.color = @activeColor
    end

    def deselect()
      @selected = false

      if @value == ""
        @display.text = @displayName
      else
        @display.text = @value
      end

      @display.color = @inactiveTextColor
      @container.color = @color
    end

    def toggle()
      if @selected
        deselect()
      else
        select()
      end
    end

    def build()
      if @value == ""
        @display = Text.new(@displayName,x: @x + 0.02 * @length,y: @y,z: @z + 1, size: @size, color: @inactiveTextColor)
      else
        @display = Text.new(@value,x: @x + 0.02 * @length,y: @y,z: @z + 1, size: @size, color: @inactiveTextColor)
      end
      @height = @display.height * 1.1

      @container = Rectangle.new(x: @x, y: @y, z: @z, height: @height, width: @length, color: @color)

      @display.y = @container.y + @container.height / 2 - @display.height / 2
    end
  end
end

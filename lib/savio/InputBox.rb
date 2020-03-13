module Savio
  class InputBox
    include IORenderable

    attr_accessor :shift
    attr_reader :selected, :value, :length, :height

    @@inputBoxs = []
    def self.inputBoxs
      @@inputBoxs
    end

    def initialize(args = {})
      @@inputBoxs.push(self)
      super(args)

      @selected = args[:selected] || false

      @size = args[:size] || 20

      @shift = false

      @value = args[:value] || @displayName
      @displayName = @value

      @length = args[:length] || @size * 10
      @height = args[:height] || @size * 1.2

      @color = args[:color] || '#F5F5F5'
      @activeColor = args[:activeColor] || '#5BB36A'

      @activeTextColor = args[:activeTextColor] || '#F5F5F5'
      @inactiveTextColor = args[:inactiveTextColor] || '#757575'

      build()
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
      @displayName = @value
      @display.text = @value
    end

    def size=(size)
      @length = size * 10
      @height = size * 1.2
      super(size)
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

      if @value == @displayName
        @value = ""
      end

      @display.text = @value + "|"
      @display.color = @activeTextColor
      @container.color = @activeColor
    end

    def deselect()
      @selected = false

      if @value == ""
        @value = @displayName
      end

      @display.text = @value
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
      @shown = true

      @display = Text.new(@value,x: @x,y: @y,z: @z + 1, size: @size, color: @inactiveTextColor)
      @height = @display.height * 1.1

      @container = Rectangle.new(x: @x, y: @y, z: @z, height: @height, width: @length, color: @color)

      @display.y = @container.y + @container.height / 2 - @display.height / 2
    end
  end
end

class InputBox < IORenderable
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

    @shift = false

    @value = args[:value] || @displayName
    @displayName = @value

    @length = args[:length] || @size * 10
    @height = args[:height] || @size * 1.2

    @color = args[:color] || 'gray'
    @activeColor = args[:activeColor] || 'green'

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
  def length=(length)
    @length = length
    rebuild()
  end
  def height=(height)
    @height = height
    rebuild()
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

  def select()
    @selected = true

    if @value == @displayName
      @value = ""
    end

    @display.text = @value + "|"
    @container.color = @activeColor
  end

  def deselect()
    @selected = false

    if @value == ""
      @value = @displayName
    end

    @display.text = @value
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

    @display = Text.new(@value,x: @x,y: @y,z: @z + 1, size: @size)
    @container = Rectangle.new(x: @x, y: @y, z: @z, height: @height, width: @length, color: @color)
  end
end

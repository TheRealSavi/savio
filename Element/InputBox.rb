class InputBox < IORenderable
attr_reader :selected, :value, :length, :height

  @@inputBoxs = []
  def self.inputBoxs
    @@inputBoxs
  end

  def initialize(args = {})
    @@inputBoxs.push(self)
    super(args)

    @selected = args[:selected] || false
    @value = @displayName
    @length = @size * 10
    @height = @size * 1.2

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

  def addKey(key)
    if key == "space"
      @value += + " "
    elsif key == "return"
      @selected = false
    elsif key == "backspace"
      @value = @value[0...-1]
    elsif key.chars.count == 1
      @value += key
    else
      puts "unknown key : " + key.to_s
    end
    updateDisplay()
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
    @container.color = 'green'
  end

  def deselect()
    @selected = false

    if @value == ""
      @value = @displayName
    end

    @display.text = @value
    @container.color = 'gray'
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
    @container = Rectangle.new(x: @x, y: @y, z: @z, height: @height, width: @width, color: 'gray')
  end
end

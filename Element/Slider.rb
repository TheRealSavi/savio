class Slider
  attr_accessor :enabled
  attr_reader :x, :y, :length, :min, :max, :z, :size, :value, :displayName, :id, :shown

  @@sliders = []
  def self.sliders
    @@sliders
  end

  def initialize(args = {})
    @@sliders.push(self)

    @x = args[:x]             || 0
    @y = args[:y]             || 0
    @length = args[:length]   || 100
    @min = args[:min]         || 0
    @max = args[:max]         || 100
    @z = args[:z]             || 1
    @size = args[:size]       || 10
    @value = args[:value]     || rand(@min..@max)
    @enabled = args[:enabled] || true
    @showValue = args[:showValue] || true
    @displayName = args[:displayName] || "default"
    @id = args[:id] || @displayName.to_s

    @labelColor  = args[:labelColor]  || '#F5F5F5'
    @sliderColor = args[:sliderColor] || '#757575'
    @knobColor   = args[:knobColor]   || '#5BB36A'

    build()
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
  def length=(length)
    @length = length.clamp(1, Window.width-@x)
    rebuild()
  end
  def labelColor=(c)
    @labelColor = c
    rebuild()
  end
  def sliderColor=(c)
    @sliderColor = c
    rebuild()
  end
  def knobColor=(c)
    @knobColor = c
    rebuild()
  end
  def showValue=(state)
    @showValue = state
    rebuild()
  end

  def moveKnob(x)
    if x.between?(@x, @x+@length)
      @knob.x = x

      to_max = @max
      to_min = @min
      from_max = @x + @length
      from_min = @x
      pos = @knob.x
      @value = (((to_max - to_min) * (pos - from_min)) / (from_max - from_min) + to_min)
      if @showValue == true
        @label.text = @value
      end
    end
  end

  def setValue(value)
    if value.between?(@min, @max)
      to_max = @x + @length
      to_min = @x
      from_max = @max.to_f
      from_min = @min.to_f
      pos = value
      knobX = (((to_max - to_min) * (pos - from_min)) / (from_max - from_min) + to_min)
      @value = value
      if @showValue == true
        @label.text = @value
      end
      @knob.x = knobX
    end
  end

  def remove()
    if @shown == false
      return
    end
    @sliderLine.remove
    @knob.remove
    @label.remove
    @nameLabel.remove
    @shown = false
  end

  def add()
    if @shown == true
      return
    end
    @sliderLine.add
    @knob.add
    @label.add
    @nameLabel.add
    @shown = true
  end

  def rebuild()
    remove()
    build()
  end

  def build()
    @shown = true

    @sliderLine = Line.new(
      x1: @x, y1: @y,
      x2: @x+@length, y2: @y,
      width: @size,
      color: @sliderColor,
      z: @z
    )

    @knob = Circle.new(
      x: @x, y: @y,
      radius: @size * 1.2,
      color: @knobColor,
      z: @z+1
    )

    @label = Text.new(
      @value.to_s,
      x: @x + @length + @size, y: @y - @size * 1.75,
      size: @size * 2.5,
      color: @labelColor,
      z: @z+1
    )

    @nameLabel = Text.new(
      @displayName.to_s,
      x: @x, y: @y - @size * 3 - @size,
      size: @size * 2.5,
      color: @labelColor,
      z: @z+2
    )
  setValue(@value)

  if @showValue == false
    @label.remove
  end
  end
end

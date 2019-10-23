class Slider
  attr_reader :x, :y, :size, :value

  @@sliders = []
  def self.sliders
    @@sliders
  end

  def initialize(args)
    @@sliders.push(self)

    @x = args[:x]           || 0
    @y = args[:y]           || 0
    @length = args[:length] || 100
    @min = args[:min]       || 0
    @max = args[:max]       || 100
    @z = args[:z]           || 1
    @size = args[:size]     || 10
    @value = args[:value]   || @min
    @name = args[:name]     || "label"

    @labelColor  = args[:labelColor]  || 'black'
    @sliderColor = args[:sliderColor] || 'black'
    @knobColor   = args[:knobColor]   || 'green'

    build()
    setValue(@value)
  end

  def moveKnob(x)
    if x.between?(@x, @x+@length)
      @knob.x = x

      to_max = @max
      to_min = @min
      from_max = @x + @length
      from_min = @x
      pos = @knob.x
      @value = ((to_max - to_min) * (pos - from_min)) / (from_max - from_min) + to_min

      updateLabel()
    end
  end

  def setValue(value)
    if value.between?(@min, @max)
      to_max = @x + @length
      to_min = @x
      from_max = @max
      from_min = @min
      pos = value
      knobX = ((to_max - to_min) * (pos - from_min)) / (from_max - from_min) + to_min
      moveKnob(knobX)
    end
  end

  def updateLabel
    @label.remove
    @label = Text.new(
      @value.to_s,
      x: @x + @length + @size, y: @y - @size * 1.25,
      size: @size * 2.5,
      color: @labelColor,
      z: @z+1
    )
    @label.add
  end

  def build()
    @sliderLine = Line.new(
      x1: @x, y1: @y,
      x2: @x+@length, y2: @y,
      width: @size,
      color: @sliderColor,
      z: @z
    )

    @knob = Circle.new(
      x: @x, y: @y,
      radius: @size * 1.5,
      color: @knobColor,
      z: @z+1
    )

    @label = Text.new(
      @value.to_s,
      x: @x + @length + @size, y: @y - @size * 1.25,
      size: @size * 2.5,
      color: @labelColor,
      z: @z+1
    )

    @nameLabel = Text.new(
      @name.to_s,
      x: @x, y: @y - @size * 2.5 - @size,
      size: @size * 2.5,
      color: @labelColor,
      z: @z+2
    )
  end
end

on :mouse do |event|
  if event.button == :left && event.type == :down
    @dragging = true
  end
  if event.button == :left && event.type == :up
    @dragging = false
  end
  if @dragging == true
    Slider.sliders.each do |slider|
      if event.y.between?(slider.y-slider.size,slider.y+slider.size)
        slider.moveKnob(event.x)
      end
    end
  end
end

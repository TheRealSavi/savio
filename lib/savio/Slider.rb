module Savio
  class Slider
    include IORenderable

    attr_reader :length, :min, :max, :size, :value

    @@sliders = []
    def self.sliders
      @@sliders
    end

    def initialize(args = {})
      @@sliders.push(self)
      super(args)

      @length = args[:length]   || 100
      @min = args[:min]         || 0
      @max = args[:max]         || 100

      @value = args[:value]     || rand(@min..@max)
      @showValue = args[:showValue] || true

      @labelColor  = args[:labelColor]  || '#F5F5F5'
      @sliderColor = args[:sliderColor] || '#757575'
      @knobColor   = args[:knobColor]   || '#5BB36A'

      build()
    end

    def length=(length)
      @length = length.clamp(1, Window.width-@x)
      rebuild()
    end
    def showValue=(state)
      @showValue = state
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
    def min=(x)
      @min = x
      setValue(@value)
    end
    def max=(x)
      @max = x
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
        @value = (((to_max - to_min) * (pos - from_min)) / (from_max - from_min) + to_min)
        if @showValue == true
          @label.text = @value.round(2).to_s
        end
      end
    end

    def value=(value)
      setValue(value)
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
          @label.text = @value.round(2).to_s
        end
        @knob.x = knobX
      else
        setValue(@min)
      end
    end

    def remove()
      super()
      @sliderLine.remove
      @knob.remove
      @label.remove
      @nameLabel.remove
    end

    def add()
      super()
      @sliderLine.add
      @knob.add
      @label.add
      @nameLabel.add
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
end

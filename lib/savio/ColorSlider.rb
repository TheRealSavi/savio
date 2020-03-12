module Savio
  class ColorSlider
    include IORenderable

    attr_reader :value, :baseColor, :knobColor, :textColor, :sectors, :optionsShown, :animating

    @@colorSliders = []
    def self.colorSliders
      @@colorSliders
    end

    def initialize(args = {})
      args[:size] = args[:size] || 80
      super(args)
      @@colorSliders.push(self)

      @value = args[:value] || rand(0..360)
      @baseColor = args[:baseColor] || 'white'
      @knobColor = args[:baseColor] || 'gray'
      @textColor = args[:textColor] || 'black'
      @sectors = args[:sectors] || 64

      @optionsShown = false
      @steps = 0
      @animating = false

      @radiusStep = 0
      @yStep = 0

      build()
    end

    def baseColor=(c)
      @baseColor = c
      rebuild()
    end
    def knobColor=(c)
      @knob.color = c
    end
    def textColor=(c)
      @textColor = c
      rebuild()
    end

    def remove()
      super()
      @innerCircle.remove
      @outerCircle.remove
      @knob.remove
      @mySaturation.remove
      @myValue.remove
    end

    def add()
      super()
      @innerCircle.add
      @outerCircle.add
      @knob.add
      @mySaturation.add
      @myValue.add
    end

    def animate()
      animatorThread = Thread.new do
        12.times do
          sleep(1 / 60)
          @steps += 1
          @innerCircle.radius += @radiusStep
          @innerCircle.y += @yStep
          if @steps >= 12
            @steps = 0
            @radiusStep = 0
            @yStep = 0
            @animating = false
          end
        end
      end
    end

    def calculateStep(desire, start, steps)
      delta = desire.to_f - start.to_f
      step = delta/steps
      return step
    end

    def showOptions()
      if @optionsShown == false
        @optionsShown = true

        @steps = 0
        @radiusStep = 0
        @yStep = 0
        @animating = false

        @radiusStep = calculateStep(0.25 * @size, @innerCircle.radius, 12)
        @yStep = calculateStep(@y - @size + 0.35 * @size, @innerCircle.y, 12)
        @animating = true
        animate()
      end
    end

    def hideOptions()
      if @optionsShown == true
        @optionsShown = false

        @steps = 0
        @radiusStep = 0
        @yStep = 0
        @animating = false

        @radiusStep = calculateStep(@size * 0.95, @innerCircle.radius, 12)
        @yStep = calculateStep(@y, @innerCircle.y, 12)
        @animating = true
        animate()
      end
    end

    def setValue(angle)
      @knob.x = (@size).to_f * Math.cos((angle.to_f % 360.0) * Math::PI/180.0) + @x.to_f
      @knob.y = (@size).to_f * Math.sin((angle.to_f % 360.0) * Math::PI/180.0) + @y.to_f
      @value = angle

      hue = Savio.hsv2rgb(@value % 360,@mySaturation.value,@myValue.value)
      @innerCircle.color.r = hue[0]
      @innerCircle.color.g = hue[1]
      @innerCircle.color.b = hue[2]
    end

    def rgb()
      return Savio.hsv2rgb(@value % 360,@mySaturation.value,@myValue.value)
    end

    def hsv()
      return [@value % 360, @mySaturation.value, @myValue.value]
    end

    def hex()
      return ("#%02x%02x%02x" % [rgb()[0]*255,rgb()[1]*255,rgb()[2]*255])
    end

    def chord(placement)
      margin = 20
      height = @size * placement
      angle = 2 * Math.acos( 1.0 - height / @size.to_f)
      angle = angle * 180/Math::PI
      chord = 2 * Math.sqrt(2 * @size * height - height**2)
      adjust = (@size * 2 - chord) / 2
      return Struct.new(:margin, :height, :angle, :chord, :adjust).new(margin,height,angle,chord,adjust)
    end

    def build()
      @shown = true

      @innerCircle = Circle.new(
        x: @x, y: @y,
        radius: @size * 0.95,
        color: 'black',
        z: @z + 4,
        sectors: @sectors
      )

      @outerCircle = Circle.new(
        x: @x, y: @y,
        radius: @size,
        color: @baseColor,
        z: @z,
        sectors: @sectors
      )

      @knob = Circle.new(
        x: @x + @size, y: @y,
        radius: @size * 0.15,
        color: @knobColor,
        z: @z + 5,
        sectors: @sectors
      )

      placement = chord(1.0)
      @mySaturation = Slider.new(
        displayName: "Saturation",
        labelColor: @textColor,
        x:@x - @size + placement.adjust + placement.margin,
        y:@y - @size + placement.height,
        z:@z + 1,
        min:0.0,
        max:1.0,
        length:(placement.chord - placement.margin * 2),
        size: @size * 0.06,
        showValue: false
      )

      placement = chord(1.3)
      @myValue = Slider.new(
        displayName: "Value",
        labelColor: @textColor,
        x:@x - @size + placement.adjust + placement.margin,
        y:@y - @size + placement.height,
        z: @z + 1,
        min:0.0,
        max:1.0,
        length:(placement.chord - placement.margin * 2),
        size: @size * 0.06,
        showValue: false
      )
      @myValue.showValue=false
      @mySaturation.showValue=false

      setValue(@value)
    end
  end
end

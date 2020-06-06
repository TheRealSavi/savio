module Savio
  class ColorSlider
    include IORenderable

    attr_reader :baseColor, :knobColor, :textColor, :sectors, :optionsShown, :animating

    @@colorSliders = []
    def self.colorSliders
      @@colorSliders
    end

    def initialize(args = {})
      args[:size] = args[:size] || 80
      super(args)
      @@colorSliders.push(self)

      @color = args[:color] || HsvColor.new(rand(0..360), rand(0.0..1.0),rand(0.0..1.0))

      @baseColor = args[:baseColor] || Savio::Colors::White
      @knobColor = args[:baseColor] || Savio::Colors::Gray
      @textColor = args[:textColor] || Savio::Colors::Black
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
      @saturationSlider.remove
      @valueSlider.remove
    end

    def add()
      super()
      @innerCircle.add
      @outerCircle.add
      @knob.add
      @saturationSlider.add
      @valueSlider.add
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

      @color = HsvColor.new(angle % 360, @saturationSlider.value, @valueSlider.value)

      rgb = RgbColor.newFromHSV(@color)
      @innerCircle.color.r = rgb[0]
      @innerCircle.color.g = rgb[1]
      @innerCircle.color.b = rgb[2]
    end

    def rgb()
      return RgbColor.newFromHSV(@color)
    end

    def hsv()
      return HsvColor.new(@color[0],@color[1],@color[2])
    end

    def hex()
      rgb = RgbColor.newFromHSV(@color)
      return ("#%02x%02x%02x" % [rgb[0]*255,rgb[1]*255,rgb[2]*255])
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
      @saturationSlider = Slider.new(
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
      @valueSlider = Slider.new(
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
      @valueSlider.showValue=false
      @saturationSlider.showValue=false

      @valueSlider.onChange do
        @color = HsvColor.new(angle % 360, @saturationSlider.value, @valueSlider.value)
      end

      @saturationSlider.onChange do
        @color = HsvColor.new(angle % 360, @saturationSlider.value, @valueSlider.value)
      end

      setValue(@color[0])
    end
  end
end

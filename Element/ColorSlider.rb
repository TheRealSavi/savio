class ColorSlider
  attr_reader :size, :x, :y, :z, :value, :enabled, :shown, :baseColor, :knobColor, :textColor, :sectors, :optionsShown, :animating

  @@sliders = []
  def self.sliders
    @@sliders
  end

  def initialize(args = {})
    @@sliders.push(self)

    @size = args[:size] || 80
    @x = args[:x] || 100
    @y = args[:y] || 100
    @z = args[:z] || 1
    @value = args[:value] || rand(0..360)
    @enabled = args[:enabled] || true
    @baseColor = args[:baseColor] || 'white'
    @knobColor = args[:baseColor] || 'gray'
    @textColor = args[:textColor] || 'black'
    @sectors = args[:sectors] || 128

    @optionsShown = false
    @steps = 0
    @radiusStep = 0
    @yStep = 0
    @animating = false

    build()
  end

  def animate()
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

    end
  end

  def setValue(angle)
    @knob.x = (@size).to_f * Math.cos((angle.to_f % 360.0) * Math::PI/180.0) + @x.to_f
    @knob.y = (@size).to_f * Math.sin((angle.to_f % 360.0) * Math::PI/180.0) + @y.to_f
    @value = angle

    hue = hsv2rgb(@value % 360,@mySaturation.value,@myValue.value)
    @innerCircle.color.r = hue[0]
    @innerCircle.color.g = hue[1]
    @innerCircle.color.b = hue[2]
  end

  def rgb()
    return hsv2rgb(@value % 360,@mySaturation.value,@myValue.value)
  end

  def hsv()
    return [@value % 360, @mySaturation.value, @myValue.value]
  end

  def hex()
    return ("#%02x%02x%02x" % [rgb()[0]*255,rgb()[1]*255,rgb()[2]*255])
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

    @mySaturation = Slider.new(
      displayName: "Saturation",
      labelColor: @textColor,
      x:@x - @size * 0.7, y:@y, z: @z + 1,
      min:0.0,
      max:1.0,
      length:@size * 1.40,
      size: @size * 0.06,
      showValue: false
    )
    @myValue = Slider.new(
      displayName: "Value",
      labelColor: @textColor,
      x:@x - @size * 0.7, y:@y * 1.2, z: @z + 1,
      min:0.0,
      max:1.0,
      length:@size * 1.40,
      size: @size * 0.06,
      showValue: false
    )
    @myValue.showValue=false
    @mySaturation.showValue=false
  end
end

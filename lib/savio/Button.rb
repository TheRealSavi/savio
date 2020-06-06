module Savio
  class Button
    include IORenderable

    attr_accessor :value, :enforceManager
    attr_reader :selected, :buttonManager, :style, :length, :height, :type, :timeLastClicked, :cooldownTime

    @@buttons = []
    def self.buttons
      @@buttons
    end

    def initialize(args = {})
      super(args)

      @@buttons.push(self)

      @baseColor = args[:baseColor] || Savio::Colors::White
      @selectedColor = args[:selectedColor] || Savio::Colors::Blue
      @labelActiveColor = args[:labelActiveColor] || Savio::Colors::White
      @labelInactiveColor = args[:labelInactiveColor] || Savio::Colors::White

      @cooldownTime = args[:cooldownTime] || 0.0
      @timeLastClicked = 0.0

      @selected = args[:selected] || false

      @buttonManager = args[:buttonManager] || nil
      @enforceManager = args[:enforceManager] || true

      @type = args[:type] || 'toggle'
      if @type != 'toggle' && @type != 'clicker'
        @type = 'toggle'
      end

      @style = args[:style] || 'badge'
      if @style != 'box' && @style != 'badge'
        @style = 'badge'
      end

      if @style == 'box'
        @size *= 2
        @labelActiveColor = args[:labelActiveColor] || Savio::Colors::White
        @labelInactiveColor = args[:labelInactiveColor] || Savio::Colors::Gray
      end

      @length = args[:length] || @size * 10
      @height = args[:height] || @size * 2

      @onClick = Proc.new {}

      build()
    end

    def size=(size)
      @length = size * 10
      @height = size * 2
      super(size)
    end
    def type=(newType)
      if newType == 'toggle' || newType == 'clicker'
        @type = newType
      end
    end
    def style=(style)
      if style == 'box' || style == 'badge'
        @style = style
        rebuild()
      end
    end

    def cooldownTime=(cooldown)
      @cooldownTime = cooldown.to_f
    end

    def baseColor=(c)
      @baseColor = c
      rebuild()
    end
    def selectedColor=(c)
      @selectedColor = c
      rebuild()
    end
    def labelColor=(c)
      @labelColor = c
      rebuild()
    end

    def selected=(bool)
      if bool == true
        select()
      elsif bool == false
        deselect()
      end
    end

    def onClick(&proc)
      @onClick = proc
    end

    def buttonManager=(newManager)
      if @buttonManager != nil
        if newManager.class.name != 'Savio::ButtonManager'
          raise ArgumentError, 'Given object ' + newManager.to_s + ' is not a ButtonManager. Must be of type ButtonManager'
        end
        @buttonManager.removeButton(self, false)
      end

      if newManager != nil
        @buttonManager = newManager
        if @buttonManager.buttons.include?(self) != true
          @buttonManager.addButton(self)
        end
      else
        @buttonManager = nil
      end
    end

    def select(enforce = @enforceManager)
      if Time.now.to_f - @timeLastClicked.to_f >= @cooldownTime.to_f
        @timeLastClicked = Time.now.to_f
        click()
        if enforce == true && @buttonManager != nil
          @buttonManager.select(self)
        else
          @selectCircle.add
          @nameLabel.color = @labelActiveColor
          @selected = true
          if @type == 'clicker'
            fade = Thread.new {
              @selectCircle.add
              @nameLabel.color = @labelActiveColor
              sleep(0.06)
              @selectCircle.remove
              @nameLabel.color = @labelInactiveColor
            }
            deselect(enforce)
          end
        end
      end
    end

    def deselect(enforce = @enforceManager)
      if enforce == true && @buttonManager != nil
        @buttonManager.deselect(self)
      else
        @selectCircle.remove
        @nameLabel.color = @labelInactiveColor
        @selected = false
      end
    end

    def toggle(enforce = @enforceManager)
      if @selected
        deselect(enforce)
      else
        select(enforce)
      end
    end

    def remove()
      super()
      @nameLabel.remove
      @baseCircle.remove
      @selectCircle.remove
    end

    def add()
      super()
      @nameLabel.add
      @baseCircle.add
      @selectCircle.add
      if @selected
        select()
      else
        deselect()
      end
    end

    def click()
      @onClick.call()
    end

    def build()
      @shown = true
      case @style
      when 'badge'
        @baseCircle = Circle.new(
          x: @x, y: @y,
          radius: @size,
          color: @baseColor,
          z: @z
        )
        @selectCircle = Circle.new(
          x: @x, y: @y,
          radius: @size * 0.8,
          color: @selectedColor,
          z: @z+1
        )
        @nameLabel = Text.new(
          @displayName.to_s,
          x: @x + @size * 2, y: @y - @size * 1.5,
          size: @size * 2,
          color: @labelInactiveColor,
          z: @z
        )
        @nameLabel.y = @baseCircle.y - @baseCircle.radius / 4 - @nameLabel.height / 2
      when 'box'
        @baseCircle = Rectangle.new(
          x: @x, y: @y,
          height: @height, width: @length,
          color: @baseColor,
          z: @z
        )
        @selectCircle = Rectangle.new(
          x: @x + (@height * 0.1), y: @y + (@height * 0.1),
          height: @height - (@height * 0.2), width: @length - (@height * 0.2),
          color: @selectedColor,
          z: @z+1
        )
        @nameLabel = Text.new(
          @displayName.to_s,
          x: @x, y: @y,
          size: @size,
          color: @labelInactiveColor,
          z: @z+2
        )
        @nameLabel.x = @baseCircle.x + @baseCircle.width / 2 - @nameLabel.width / 2
        @nameLabel.y = @baseCircle.y + @baseCircle.height / 2 - @nameLabel.height / 2
      end

      if @buttonManager == nil
        if @selected
          select()
        else
          deselect()
        end
      else
        if @buttonManager.class.name != 'Savio::ButtonManager'
          raise ArgumentError, 'Given object ' + @buttonManager.to_s + ' is not a ButtonManager. Must be of type ButtonManager'
        end
        @buttonManager.addButton(self)

        if @selected
          @buttonManager.select(self)
        else
          @buttonManager.deselect(self)
        end
      end

    end
  end
end

class Button < IORenderable
  attr_accessor :value
  attr_reader :selected, :buttonManager

  @@buttons = []
  def self.buttons
    @@buttons
  end

  def initialize(args = {})
    super(args)

    @@buttons.push(self)

    @value = args[:value] || 0

    @baseColor = args[:baseColor] || '#F5F5F5'
    @selectedColor = args[:selectedColor] || '#00B3EC'
    @labelColor = args[:labelColor] || '#F5F5F5'

    @selected = args[:selected] || false

    @buttonManager = args[:buttonManager] || nil

    build()

    if @buttonManager == nil
      if @selected
        select()
      else
        deselect()
      end
    else
      @buttonManager.addButton(self)

      if @selected
        @buttonManager.select(self)
      else
        @buttonManager.deselect(self)
      end
    end
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

  def buttonManager=(newManager)
    if @buttonManager != nil
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

  def select()
    @selectCircle.add
    @selected = true
  end

  def deselect()
    @selectCircle.remove
    @selected = false
  end

  def toggle()
    if @selected
      deselect()
    else
      select()
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
  end

  def build()
    @shown = true

    @nameLabel = Text.new(
      @displayName.to_s,
      x: @x + @size * 2, y: @y - @size * 1.5,
      size: @size * 2,
      color: @labelColor
    )
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
  end
end

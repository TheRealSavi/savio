class Button < IORenderable
  attr_accessor :value, :enforceManager
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

    @enforceManager = args[:enforceManager] || true

    @type = args[:type] || 'toggle'
    if @type != 'toggle' || @type != 'clicker'
      @type = 'toggle'
    end

    @onClick = Proc.new {}

    build()
  end

  def type=(newType)
    if newType == 'toggle' || newType == 'clicker'
      @type = newType
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

  def onClick(&proc)
    @onClick = proc
  end

  def buttonManager=(newManager)
    if @buttonManager != nil
      if newManager.class.name != 'ButtonManager'
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
    click()
    if enforce == true && @buttonManager != nil
      @buttonManager.select(self)
    else
      @selectCircle.add
      @selected = true
      if @type == 'clicker'
        deselect(enforce)
      end
    end
  end

  def deselect(enforce = @enforceManager)
    if enforce == true && @buttonManager != nil
      @buttonManager.deselect(self)
    else
      @selectCircle.remove
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

    @nameLabel = Text.new(
      @displayName.to_s,
      x: @x + @size * 2, y: @y - @size * 1.5,
      size: @size * 2,
      color: @labelColor,
      z: @z
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

    if @buttonManager == nil
      if @selected
        select()
      else
        deselect()
      end
    else
      if @buttonManager.class.name != 'ButtonManager'
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

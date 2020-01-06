class IORenderable
  attr_accessor :enabled, :allowDrag, :draggingEnabled
  attr_reader :x, :y, :z, :size, :enabled, :id, :shown, :displayName

  def initialize(args = {})
    @x = args[:x]             || 0
    @y = args[:y]             || 0
    @z = args[:z]             || 1
    @size = args[:size]       || 10
    @enabled = args[:enabled] || true
    @id = args[:id] || @displayName.to_s

    @displayName = args[:displayName] || "default"

    @draggingEnabled = args[:draggingEnabled] || false
    @dragType = args[:dragType] || "move"
    @isDragging = false
    @allowDrag = false
  end

  def remove()
    if @shown == false
      return
    end
    @shown = false
  end

  def add()
    if @shown == true
      return
    end
    @shown = true
  end

  def rebuild()
    remove()
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
  def dragType=(type)
    if type == "move" || type == "duplicate"
      @dragType = type
    end
  end

  def drag(x, y)
    case @dragType
    when "move"
      if @isDragging == false
        @grabFixX = (x - @x).abs
        @grabFixY = (y - @y).abs
        @isDragging = true
      end
      if @isDragging == true
        @x = x - @grabFixX
        @y = y - @grabFixY
        rebuild()
      end
    when "duplicate"
      if @isDragging == false
        @grabFixX = (x - @x).abs
        @grabFixY = (y - @y).abs

        classType = Object.const_get(self.class.name)

        @duplicate = classType.new(self.context)
        @duplicate.enabled = false
        @duplicate.draggingEnabled = false
        @duplicate.dragType = "move"
        @isDragging = true
      end
      if @isDragging == true
        @duplicate.enabled = false
        @duplicate.draggingEnabled = false
        @duplicate.x = x - @grabFixX
        @duplicate.y = y - @grabFixY
      end
    end
  end

  def context()
    self.instance_variables.map do |attribute|
      key = attribute.to_s.gsub('@','').intern
      [key, self.instance_variable_get(attribute)]
    end.to_h
  end

  def endDrag()
    if @isDragging
      if @dragType == "duplicate"
        @duplicate.draggingEnabled = true
        @duplicate.enabled = true
        @duplicate.allowDrag = false
      end
      @isDragging = false
      @allowDrag = false
    end
  end
end

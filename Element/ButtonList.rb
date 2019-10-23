class ButtonList
  attr_accessor :options, :selected

  @@buttonLists = []
  def self.buttonLists
    @@buttonLists
  end

  class Option
    attr_reader :x, :y, :size, :selected, :name
    def initialize(args)
      @name = args[:name] || "default"
      @value = args[:value] || 0
      @x = args[:x] || 0
      @y = args[:y] || 0
      @z = args[:z] || 1
      @size = args[:size] || 10
      @baseColor = args[:baseColor] || 'white'
      @selectedColor = args[:selectedColor] || 'blue'
      @labelColor = args[:labelColor] || 'black'
      @selected = false
    end

    def select()
      if @selected == true
        @selectCircle.remove
        @selected = false
      else
        @selectCircle.add
        @selected = true
      end
    end

    def deselect()
      @selectCircle.remove
      @selected = false
    end

    def build()
      @nameLabel = Text.new(
        @name.to_s,
        x: @x + @size * 2, y: @y - @size,
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
      @selectCircle.remove
    end
  end

  def initialize(args)
    @@buttonLists.push(self)

    @type = args[:type] || 'checkbox'
    @options = {}
    @selected = []
  end

  def addOption(optionParams)
    newOption = Option.new(optionParams)
    @options[newOption.name] = newOption
    newOption.build()
  end

  def select(option)
    if @type == 'checkbox'
      if option.selected == true
        @selected.delete(option)
      else
        @selected.push(option)
      end
      option.select
    elsif @type == 'radio'
      @selected.each do |i|
        i.deselect
      end
      @selected.clear
      @selected.push(option)
      option.select
    end
  end
end

on :mouse_down do |event|
  if event.button == :left
    ButtonList.buttonLists.each do |buttonList|
      buttonList.options.each do |name, button|
        if event.x.between?(button.x-button.size,button.x+button.size) && event.y.between?(button.y-button.size,button.y+button.size)
          buttonList.select(button)
        end
      end
    end
  end
end

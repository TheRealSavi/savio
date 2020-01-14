class ButtonManager
  attr_reader :selected, :buttons

  @@buttonManagers = []
  def self.buttonManagers
    @@buttonManagers
  end

  def initialize(args = {})
    @@buttonManagers.push(self)

    @buttons = []
    @selected = []

    @type = args[:type] || 'radio'

    if @type != 'checkbox' && @type != 'radio'
      raise ArgumentError, 'ButtonManager type ' + @type.to_s + ' is invalid. Must be radio or checkbox'
    end

  end

  def type=(type)
    if type == 'radio' || type == "checkbox"
      @type = type
    else
      raise ArgumentError, 'ButtonManager type ' + type.to_s + ' is invalid. Must be radio or checkbox'
    end
  end

  def addButton(button)
    if button.class.name != 'Button'
      raise ArgumentError, 'Given object ' + button.to_s + ' is not a Button. Must be of type Button'
    end
    button.deselect(false)
    @buttons.push(button)
    if button.buttonManager != self
      button.buttonManager = self
    end
  end

  def removeButton(button, overwrite = true)
    if @buttons.include?(button)
      @buttons.delete(button)
      if @selected.include?(button)
        @selected.delete(button)
      end
      if overwrite == true
        button.buttonManager = nil
      end
    else
      raise ArgumentError, ('Could not find button ' + button.to_s + ' in buttonManager')
    end
  end

  def toggle(button)
    if @buttons.include?(button)
      if @type == 'checkbox'
        if button.selected
          deselect(button)
        else
          select(button)
        end
      elsif @type == 'radio'
        select(button)
      end
    else
      raise ArgumentError, ('Could not find button ' + button.to_s + ' in buttonManager')
    end
  end

  def select(button)
    if @buttons.include?(button)
      if @type == 'checkbox'
        @selected.push(button)
        button.select(false)
      elsif @type == 'radio'
        @buttons.each do |i|
          i.deselect(false)
        end
        @selected.clear
        @selected.push(button)
        button.select(false)
      end
    else
      raise ArgumentError, ('Could not find button ' + button.to_s + ' in buttonManager')
    end
  end

  def deselect(button)
    if @buttons.include?(button)
      if @type == 'checkbox'
        @selected.delete(button)
        button.deselect(false)
      elsif @type == 'radio'
        @selected.delete(button)
        button.deselect(false)
      end
    else
      raise ArgumentError, ('Could not find button ' + button.to_s + ' in buttonManager')
    end
  end

end

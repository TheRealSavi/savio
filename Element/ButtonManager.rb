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
      raise ArgumentError, 'ButtonList type ' + @type.to_s + ' invalid. Must be radio or checkbox'
    end

  end

  def type=(type)
    if type == 'radio' || type == "checkbox"
      @type = type
    end
  end

  def addButton(button)
    button.deselect
    @buttons.push(button)
    if !button.buttonManager == self
      button.buttonManager = self
    end
  end

  def removeButton(button)
    @buttons.delete(button)
    if @selected.include?(button)
      @selected.delete(button)
    end
    button.buttonManager = nil
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
      raise ArgumentError, ('could not find button ' + button.to_s + ' in buttonManager')
    end
  end

  def select(button)
    if @buttons.include?(button)
      if @type == 'checkbox'
        @selected.push(button)
        button.select
      elsif @type == 'radio'
        @buttons.each do |i|
          i.deselect
        end
        @selected.clear
        @selected.push(button)
        button.select
      end
    else
      raise ArgumentError, ('could not find button ' + button.to_s + ' in buttonManager')
    end
  end

  def deselect(button)
    if @buttons.include?(button)
      if @type == 'checkbox'
        @selected.delete(button)
        button.deselect
      elsif @type == 'radio'
        #Can not deselect a radio
      end
    else
      raise ArgumentError, ('could not find button ' + button.to_s + ' in buttonManager')
    end
  end

end

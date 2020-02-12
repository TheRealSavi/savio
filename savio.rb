require 'ruby2d'

class Savio

  def self.makeBool(value)
    case value
      when true, 'true', 1, '1', 't' then true
      when false, 'false', nil, '', 0, '0', 'f' then false
    else
      return "no"
    end
  end

  def self.guessType(value)
    if value.to_i.to_s == value
      return "int"
    elsif value.to_f.to_s == value
      return "float"
    elsif value == "true" || value == "false"
      return "bool"
    else
      return "str"
    end
  end

  def self.listening
    @@listening
  end

  @@elements = []
  def self.elements
    @@elements
  end

  def self.addElement(element)
    @@elements.push(element)
  end

  def self.removeElement(element)
    @@elements.delete(element)
  end
  def self.listen
    @@listening = true
  end

  def self.stop
    @@listening = false
  end

  def self.hide
    @@elements.each do |e|
      e.remove
    end
  end

  def self.unhide
    @@elements.each do |e|
      e.add
    end
  end
end

Savio.listen

require_relative 'Element/IORenderable.rb'
require_relative 'Element/InputBox.rb'
require_relative 'Element/Slider.rb'
require_relative 'Element/Button.rb'
require_relative 'Element/ButtonManager.rb'
require_relative 'Element/hsv2rgb.rb'
require_relative 'Element/ColorSlider.rb'
require_relative 'Element/io.rb'

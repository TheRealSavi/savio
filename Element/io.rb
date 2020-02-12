#Adding ability to sense dragging
on :mouse do |event|
  if Savio.listening

    if @dragging == nil
      @dragging = {}
    end
    if event.type == :down
      @dragging[event.button] = true
    end
    if event.type == :up
      @dragging[event.button] = false
    end

  end
end

#Button Handler
on :mouse do |event|
  if Savio.listening

    if @dragging[:right] == false
      Button.buttons.each do |button|
        if button.draggingEnabled
          button.endDrag()
        end
      end
    end

    if @dragging[:right] == true
      Button.buttons.each do |button|

        if button.draggingEnabled
          if event.x.between?(button.x-button.size,button.x+button.size) && event.y.between?(button.y-button.size,button.y+button.size)
            button.allowDrag = true
          end
          if button.allowDrag
            button.drag(event.x, event.y)
          end
        end
      end
    end

    if @dragging[:left] == true
      Button.buttons.each do |button|

        if button.shown && button.enabled
          if event.x.between?(button.x-button.size,button.x+button.size) && event.y.between?(button.y-button.size,button.y+button.size)
            if button.buttonManager == nil
              button.toggle
            else
              button.buttonManager.toggle(button)
            end
          end
        end

      end
    end

  end
end

#Slider Handler
on :mouse do |event|
  if Savio.listening

    if @dragging[:right] == false
      Slider.sliders.each do |slider|
        if slider.draggingEnabled
          slider.endDrag()
        end
      end
    end

    if @dragging[:right] == true
      Slider.sliders.each do |slider|

        if slider.draggingEnabled
          if event.y.between?(slider.y-slider.size,slider.y+slider.size) && event.x.between?(slider.x,slider.x+slider.length)
            slider.allowDrag = true
          end
          if slider.allowDrag
            slider.drag(event.x, event.y)
          end
        end

      end
    end

    if @dragging[:left] == true
      Slider.sliders.each do |slider|

        if slider.shown && slider.enabled
          if event.y.between?(slider.y-slider.size,slider.y+slider.size)
            slider.moveKnob(event.x)
          end
        end

      end
    end

  end
end

#Inputbox Handler
on :mouse do |event|
  if Savio.listening

    if @dragging[:right] == false
      InputBox.inputBoxs.each do |inputBox|
        if inputBox.draggingEnabled
          inputBox.endDrag()
        end
      end
    end

    if @dragging[:right] == true
      InputBox.inputBoxs.each do |inputBox|

        if inputBox.draggingEnabled
          if event.y.between?(inputBox.y,inputBox.y+inputBox.height) && event.x.between?(inputBox.x,inputBox.x+inputBox.length)
            inputBox.allowDrag = true
          end
          if inputBox.allowDrag
            inputBox.drag(event.x, event.y)
          end
        end

      end
    end

    if @dragging[:left] == true
      InputBox.inputBoxs.each do |inputBox|

        if inputBox.shown && inputBox.enabled
          if event.y.between?(inputBox.y,inputBox.y+inputBox.height) && event.x.between?(inputBox.x,inputBox.x+inputBox.length)
            inputBox.select
          else
            inputBox.deselect
          end
        end

      end
    end

  end
end

on :key do |event|
  if Savio.listening

    InputBox.inputBoxs.each do |inputBox|
      if inputBox.selected
        if event.type == :down
          if event.key == "left shift"
            inputBox.shift = true
          else
            inputBox.addKey(event.key)
          end
        elsif event.type == :up && event.key == "left shift"
          inputBox.shift = false
        end
      end
    end

  end
end

#ColorPicker Handler
on :mouse do |event|
  if Savio.listening

    if @dragging[:left] == true
      ColorSlider.sliders.each do |slider|
        if slider.shown && slider.enabled

          distance = (event.x-slider.x.to_f) ** 2 + (event.y-slider.y.to_f) ** 2
          distance = Math.sqrt(distance)

          if distance <= slider.size.to_f * 0.7
            slider.showOptions
          else
            slider.hideOptions
          end

          if distance >= slider.size * 0.90 && distance <= slider.size * 1.15
            if event.x - slider.x == 0
              event.x += 0.01
            end
            angle = Math.atan((event.y.to_f - slider.y.to_f) / (event.x.to_f - slider.x.to_f)).to_f
            angle = angle.to_f * 180.0/Math::PI

            if (event.x.to_f - slider.x.to_f) < 0
              angle += 180.0
            end
            if event.y.to_f - slider.y.to_f < 0 && (event.x.to_f - slider.x.to_f) > 0
              angle += 360.0
            end

            slider.setValue(angle.to_f)
          end
        end
      end
    end

  end
end

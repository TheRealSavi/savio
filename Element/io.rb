#ButtonList Handler
on :mouse_down do |event|
  if event.button == :left
    ButtonList.buttonLists.each do |buttonList|
      buttonList.optionID.each do |id|
        button = buttonList.touch(id)
        if button[:shown] && button[:enabled]
          if event.x.between?(button[:x]-button[:size],button[:x]+button[:size]) && event.y.between?(button[:y]-button[:size],button[:y]+button[:size])
            buttonList.toggle(id)
          end
        end
      end
    end
  end
end

#Slider Handler
on :mouse do |event|
  if event.button == :left && event.type == :down
    @dragging = true
  end
  if event.button == :left && event.type == :up
    @dragging = false
  end
  if @dragging == true
    Slider.sliders.each do |slider|
      if slider.shown && slider.enabled
        if event.y.between?(slider.y-slider.size,slider.y+slider.size)
          slider.moveKnob(event.x)
        end
      end
    end
  end
end

#ColorPicker Handler
on :mouse do |event|
  if event.button == :left && event.type == :down
    @dragging = true
  end
  if event.button == :left && event.type == :up
    @dragging = false
  end

  if @dragging == true
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

#Animation Handler

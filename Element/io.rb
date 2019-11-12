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

# SavIO

### What is it?
##### SavIO is a **ruby2d** add-on that adds IO objects
---
Objects:
  * Sliders - done
  * Buttons
    * Normal
    * Radio - done
    * Checkbox - done
  * Color Picker
  * Text Input

---
Documentation:

## Sliders:
---
```
require savio
mySlider = Slider.new()
```
  * **Values**
    * mySlider.x >> returns sliders x position in the window
    * mySlider.y >> returns sliders y position in the window
    * mySlider.size >> returns the sliders size
    * mySlider.value >> returns sliders value
  * **Methods**
    1. mySlider.moveKnob(**x**)  
      moves knob to an x position in the window, must be within x and x+length of slider  
    2. mySlider.setValue(**value**)  
      sets the value of the slider, must be within min and max of the slider  
    3. mySlider.updateLabel()  
      updates the label that shows the value of the slider. _is called automatically when slider value is updated_
    4. mySlider.build()  
      builds the slider by creating all the ruby2d objects. _is called automatically when slider is created_
  * **Creating**
    * x : the x position of the slider in the window _default 0_
    * y : the y position of the slider in the window _default 0_
    * length : the length of the slider in the window _default 100_
    * min : the minimum value of the slider _default 0_
    * max : the maximum value of the slider _default 100_
    * z : the z position of the slider in the window _default 1_
    * size : the size of the slider in the window _default 10_
    * value : the default value of the slider _default minimum value_
    * name : the label above the slider _default "label"_
    * labelColor : color of the name and value labels _default black_
    * sliderColor : color of the slider line _default black_
    * knobColor : color of the sliders knob _default green_
  * **Example**
    ```
    require "savio"   
    mySlider = Slider.new() >> Returns default Slider object  
    mySlider = Slider.new(x: 100, y:50) >> Returns default slider object but at 100,50  
    mySlider = Slider.new(x:100,y:50,length:800,min: 0.0,max: 50.0,value: 14,size: 12,name: "Max Speed") >> Returns a mostly customized slider object  
    ```
  * **Preview**
    ![Image](preview.png "icon")

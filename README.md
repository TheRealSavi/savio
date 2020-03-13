# | *Sav***IO**
[![Gem Version](https://badge.fury.io/rb/savio.svg)](https://badge.fury.io/rb/savio)
## What is it?

SavIO is an input/output library created to be used with **Ruby2D**. It adds multiple ways for the user to interact with your application, including :

 - Sliders
 - Buttons
 - Text Input
 - Color Picker (Work In Progress)

## How to install?

Easy! do:

    gem install savio

then in your program do:

    require "savio"

## How do they work?


 Good question! Part of the goal when developing SavIO was to make it as **intuitive** and **simple** as possible, while also being highly **versatile**, **powerful**, and **customizable**.

# | ALL OBJECTS
#### All SavIO objects inherit these basic properties.

#### You can access an array of all SavIO Objects by using Savio.elements
##### Example:

    Savio.elements.each do |element|
	    element.x += 1 #Moves all elements over by 1 pixel
    end

##### SavIO Commands:
    Savio.hide         #This will hide all elements
    Savio.unhide       #This will bring them all back
    Savio.stop         #This stops the mouse and keyboard event listeners
    Savio.listen       #Starts the mouse and keyboard event listeners
    Savio.listening    #returns true or false if its listening or not


## **Creation:**

    myAwesomeOBJECT = OBJECTNAME.new(params)

### Params:

all SavIO object's parameters are optional, if it is not defined then it will use the default.

| Variable | Description | Default |
|--|--|--|
| x | The x position | 0
| y | The y Position | 0
| z | The z Position | 1
| size | The scaling value | 10
| enabled | If the object can be interacted with by the user | true
| displayName | The name of the object | ""
| draggingEnabled | If the object itself can be moved around the window | false
| dragType | "move" or "duplicate" If draggingEnabled is true, this is what happens when it drags | "move"
| shown | If the object is shown or not | true

### Example:

`myAwesomeOBJECT = OBJECTNAME.new(x: 100, y: 30, z:2, size: 13, displayName: "Swag")`


### Methods:
----
| Method | Description |
|--|--|
|.remove() | removes the object from the screen |
| .add() | adds the object back to the screen |
|.rebuild() | rebuilds the object |
|.context() | returns a hash with all the variables that make the object |

# | Sliders:
**On top of** all the basic parameters and methods a **Slider** can **also** use these:

### Params:
| Variable | Description | Default |
|--|--|--|
|length | How long the slider is | 100
|min | The minimum value of the slider | 0
|max | The maximum value of the slider | 100
|value| The value of the slider | Random between min and max
|style|'knob' or 'fill' changes the style the slider is shown with|'knob' |
|showValue| If the value label should be shown| true
|labelColor| The color of the labels| '#F5F5F5'
|sliderColor| Color of the slider line | '#757575'
|knobColor| Color of the sliders knob | '#5BB36A'

### Example:

    slippyTheSlider = Slider.new(x: 830, y: 40, length: 220, draggingEnabled: true, dragType: "duplicate")

### Methods:
----
| Method | Description |
|--|--|
|.moveKnob(**x**) | Moves the knob to that **x** pixel location on the screen and finds and sets equivalent value for the slider |
|.setValue(**value**)|Sets the sliders value to that value and moves the knob there (same as .value=)|
| .value = **value** | Sets the sliders value to that **value** and moves the knob there (same as .setValue)|

### Basic Usage:

    if slippyTheSlider.value == 69
	    puts "nice"
    end

# | Buttons:
**On top of** all the basic parameters and methods a **Button** can **also** use these:

### Params:
| Variable | Description | Default |
|--|--|--|
|value | Anything you want to be tied to the button | 0
|selected | Whether the button is selected or not | false
|type | Whether the button will act normally('toggle') or instantly deselect itself('clicker') | 'toggle'
|style|'box' or 'badge'. Determines the style the button should be rendered with| 'badge'
|length|Only used for the 'box' style. Determines the length of the button| @size * 10
|height|Only used for the 'box' style. Determines the height of the button| @size * 1.2
|cooldownTime|Time needed to wait in seconds until the button may be clicked again| 0.0
|buttonManager | The manager that controls this button | nil
|enforceManager| When a manager is defined, whether the manager should force this button to follow its rule | true
|baseColor| Color shown when the button is deselected| '#F5F5F5'
|selectedColor|Color shown when the button is selected | '#00B3EC'
|labelColor| Color of the buttons displayName label | '#F5F5F5'

### Example:

    clickyBob = Button.new(
      x: 830, y: 90,
      displayName: "Enable Bob?",
      selectedColor: "purple",
      type : 'clicker'
    )
-----
    anotherButton = Button.new(
      x: 830, y: 150,
      displayName: "Enable flux capacitors?",
    )


### Methods:
----
| Method | Description |
|--|--|
|.select(*enforce*) | Selects the button. if left empty *enforce* will be the buttons **@enforceManager** state. when true the manager will enforce its rule on the button. when false, the button will perform as if it were not controlled. |
|.deselect(*enforce*) | Deselects the button. *enforce* works the same as .select() *(see above)* |
|.toggle(*enforce*) | Toggles the buttons Selection state. *enforce* works the same as .select() *(see above)*
|.selected = **bool** | Selects or deselects the button whether given true or false |
|.timeLastClicked| returns the unix time of the last click
| .onClick | Takes in a proc that will be ran every time the button gets selected (See example and basic usage)|

### Basic Usage:

    clickyBob.onClick do
	    puts "Bob is now enabled! Hi Bob!"
    end
-----
    if anotherButton.selected == true do
      puts "Flux capacitors now enabled"
    end

# | ButtonManager:
Now I'm sure after reading how a **button** works you're saying, "What in the hell is a **manager**?"

## Let me explain, it's **very simple**.
A **ButtonManager** is a simple and easy way to **manage a group of multiple buttons**.  More specifically, it **controls** the state of **all the buttons** in its group **depending on** the state of **all the other buttons** in its group.

## This is not considered a standard SavIO Object and does not inherit the typical parameters and methods.

### Creation:

    theSwagMaster = ButtonManager.new(type: "checkbox")


### Params:
| Param |Description  | Default|
|--|--|--|
| type | either "radio" or "checkbox" Decides how the manager should control its buttons | "radio"

### Methods:
----
| Method | Description |
|--|--|
|.addButton(**button**) | Adds the **button** to the group of buttons controlled by the manager. This is done automatically when a buttons **@buttonManager** is set to the manager. If called this way however, it will also automatically set the buttons **@buttonManager** to this manager, so they will always be linked.|
|.removeButton(**button**, *overwrite*) | Removes the **button** from the group of buttons controlled by the manager. This is done automatically when a buttons **@buttonManager** is changed or removed. *overwrite* is not required and is automatically set to true. When true, this will overwrite the **button**'s **@buttonManager** and set it to nil. When false it will not overwrite the buttons **@buttonManager**. **It is highly recommended not to change this since** it will desynchronize the button and manager and cause issues. It is used internally to prevent recursion when removed the manager from the **button** rather than from the **manager**
|.toggle(**button**) | Toggles the **button** according to the rule of the manager. This is done automatically by the **button** when **button**.toggle() is called and this manager is used. This is true also for .select() and .deselect().
| .select(**button**) | Selects the **button** according to the rule of the manager.
| .deselect(**button**) | Deselects the **button** according to the rule of the manager |

### Variables :
|Variable|Description  | Type |
|--|--|--|
| buttons |an array of all the buttons that are controlled by this manager  |array |
| selected | an array of all the buttons that are currently selected and in control of this manager | array |


### Basic Usage:

    theSwagMaster.selected.each do |button|
	    puts button.to_s + " Is currently selected!"
    end
--

    if theSwagMaster.selected.include?(button)
	    puts "This button is currently selected!"
    end

# | InputBox:
**On top of** all the basic parameters and methods an **InputBox** can **also** use these:
### Params:
| Variable | Description | Default |
|--|--|--|
|selected | Whether it is currently focused | false
|value | The current text input in the field | **@displayName**
|displayName | The value shown in the text field when nothing is in it. AKA the default value. if a value was specified, this will be overwritten with it. | **@value** or "Default"
|length| The length of the text box | **@size** * 10
|width| The width of the text box| **@size** * 1.2
|color| The color of the box when not focused| '#F5F5F5'
|activeColor|The color of the box when focused | '#5BB36A'
|activeTextColor| The color of the text when focused | '#F5F5F5'
|inactiveTextColor| The color of the text when not focused | '#757575'

### Example:

    askMeAnything = InputBox.new(
      x: 830, y: 180, size: 30,
      activeColor: 'purple',
      displayName: "What would you like to ask?"
    )

### Methods:
----
| Method | Description |
|--|--|
|.addKey(**key**) | Simulates a key input of given **key** |
| .updateDisplay() | Adds the line follower marker to the text box |
|.select() | Focuses the text box and lets you type in it |
|.deselect() | Loses focus of the text box and finalizes value|
|.toggle() | Toggles the selection value of the text box |
|.selected=(**bool**) | Selects or deselects the text box based on the **bool**  |

### Basic Usage:

    if askMeAnything.value == "Favorite Color?"
	    puts "Purple"
    end

# | ColorSlider:
These technically work but I'm not done with them so for now I wont bother with documentation.

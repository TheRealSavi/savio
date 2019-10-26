Slider      

Constructor Args :      
{x: int, y: int, length: int, min: int, max: int, z: int, size: int, value: int, enabled:bool, displayName: string, id: string, labelColor: color, sliderColor: color, knobColor: color}      

Modifiable variables :      
.enabled = bool      
.x = int      
.y = bool      
.z = bool      
.size = int      
.displayName = string      
.length = int (between 1 and the edge from x)      
.labelColor = Ruby2D.Color Object      
.sliderColor = Ruby2D.Color Object      
.knobColor = Ruby2D.Color Object      

Returnable variables :      
.enabled > bool      
.x > int      
.y > int      
.length > int      
.min > int      
.max > int      
.z > int      
.size > int      
.value > int      
.displayName > string      
.id > string      
.shown > bool      

Methods :      

.moveKnob(int)      
Moves knob the x position in the window      

.setValue(int)      
Sets the sliders value from min to max      

.remove()      
Hides the slider      

.add()      
Shows the slider      

.rebuild()      
Rebuilds the slider      

.build()      
Initializes slider objects      

-----------      

ButtonList      

Constructor Args :      
{type: string}      

Returnable variables :      
.options > Hash of Options {id, option}      
.selected > Array of selected Options      

Methods:      

.addOption(Option Constructor)      
Adds an option to the ButtList      

.toggle(Option)      
Toggles the state of the Option      

.select(Option)      
Selects the Option      

.deselect(Option)      
Deselects the Option (only for checkboxs)      

------------      

Option      

Constructor Args :      
{displayName: string, value: any, x: int, y: int, z: int, size: int, baseColor: color, selectedColor: color, labelColor: color, selected: bool, enabled: bool, id: string}      

Modifiable variables :      
.value = any      
.enabled = bool      
.x = int      
.y = int      
.z = int      
.size = int      
.displayName = string      
.baseColor = Ruby2D.Color Object      
.selectedColor = Ruby2D.Color Object      
.labelColor = Ruby2D.Color Object      

Returnable variables :      
.value > any      
.enabled > bool      
.x > int      
.y > int      
.z > int      
.size > int      
.selected > bool      
.displayName > string      
.id > string      
.shown > bool      

Methods :      

.select()      
Selects option      

.deselect()      
Deselects option      

.remove()      
Hides option      

.add()      
Shows option      

.build()      
Initializes button objects      

.rebuild()      
rebuilds the button      

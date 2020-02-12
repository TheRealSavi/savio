require_relative 'savio'
set width: 800, height: 800
scene = Scene.new('scene.txt', 'blue')

update do
  scene.elements[3].length = scene.elements[0].value.to_i
  scene.elements[3].min = scene.elements[1].value.to_i
  scene.elements[3].max = scene.elements[2].value.to_i
  if scene.elements[4].selected
    scene.remove()
  end
end

show()

require_relative 'savio'
set width: 800, height: 800
scene = Scene.new('scene.txt', 'blue')

scene.elements[4].type = 'clicker'
scene.elements[4].onClick do
  scene.remove()
end

update do
  scene.elements[3].length = scene.elements[0].value.to_i
  scene.elements[3].min = scene.elements[1].value.to_i
  scene.elements[3].max = scene.elements[2].value.to_i
end

show()

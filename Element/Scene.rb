class Scene
  attr_accessor :elements
  def initialize(file, color = 'black')
    @file = file
    @color = color
    show()
  end

  def show()
    @bg = Square.new(x: 0, y: 0, z: 999, size: Window.width+1, color: @color)
    @elements = []
    content = File.read(@file)
    content = content.gsub('[', "").gsub(']', "").gsub('"',"").chomp.split(",")

    (content.count-1).times do |i|
      if (i % 2) == 0
        classType = Object.const_get(content[i].gsub(" ",""))
        hash = content[i+1].gsub(';', ',').gsub('"',"").chomp
        pairs = hash.split(",").to_s.gsub('"',"").chomp
        keypair = pairs.split("=>").to_s.gsub('"',"").chomp
        new = keypair.gsub('{', "").gsub('}', "").gsub('[', "").gsub(']', "").gsub('"',"").gsub(" ","").chomp.split(",")
        build = {}
        (new.count-1).times do |j|
          if (j % 2) == 0
            case Savio.guessType(new[j+1].chomp)
            when "int"
              value = new[j+1].chomp.to_i
            when "float"
              value = new[j+1].chomp.to_f
            when "str"
              value = new[j+1].chomp.to_s
            when "bool"
              value = Savio.makeBool(new[j+1].chomp)
            end
            build[new[j].intern] = value
          end
        end
        puts "SCENE: " + @file.to_s + build.to_s
        @elements.push(classType.new(build))
      end
    end
    @elements.each do |e|
      e.z = 1000
    end
  end

  def remove()
    @bg.remove
    @elements.each do |e|
      e.kill()
    end
  end
end

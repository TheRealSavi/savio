RgbColor = Struct.new(:r, :g, :b) do
  def self.newFromHSV(hsv)
    rgb = hsv.to_rgb()
    return RgbColor.new(rgb.r,rgb.g,rgb.b)
  end
  def to_hsv()
    max = [r, g, b].max
    min = [r, g, b].min
    delta = max - min
    v = max

    if (max != 0.0)
      s = delta / max
    else
      s = 0.0
    end

    if (s == 0.0)
      h = 0.0
    else
      if (r == max)
        h = 0 + (g - b) / delta
      elsif (g == max)
        h = 2 + (b - r) / delta
      elsif (b == max)
        h = 4 + (r - g) / delta
      end

      h *= 60.0

      if (h < 0)
        h += 360.0
      end
    end
    return HsvColor.new(h,s,v)
  end
end
HsvColor = Struct.new(:h, :s, :v) do
  def self.newFromRGB(rgb)
    hsv = rgb.to_hsv()
    return HsvColor.new(hsv.h,hsv.s,hsv.v)
  end
  def to_rgb()
    hue = h.to_f
    saturation = s.to_f
    value = v.to_f

    chroma = (value * saturation).to_f
    hPrime = hue/60.0
    x = (chroma * (1 - (hPrime % 2 - 1).abs)).to_f

    if 0 <= hPrime && hPrime < 1
      rgb = [chroma, x, 0]
    elsif 1 <= hPrime && hPrime < 2
      rgb = [x, chroma, 0]
    elsif 2 <= hPrime && hPrime < 3
      rgb = [0, chroma, x]
    elsif 3 <= hPrime && hPrime < 4
      rgb = [0, x, chroma]
    elsif 4 <= hPrime && hPrime < 5
      rgb = [x, 0, chroma]
    elsif 5 <= hPrime && hPrime < 6
      rgb = [chroma, 0, x]
    else
      rgb = [0,0,0]
    end

    match = (value - chroma).to_f

    rgb[0] = (rgb[0] + match).to_f
    rgb[1] = (rgb[1] + match).to_f
    rgb[2] = (rgb[2] + match).to_f

    return RgbColor.new(rgb[0],rgb[1],rgb[2])
  end
end


rgb1 = RgbColor.new(0.7, 1.0, 0.85)
hsv1 = HsvColor.new(150, 0.3, 1.0)

hsv2 = HsvColor.newFromRGB(rgb1)
rgb2 = RgbColor.newFromHSV(hsv1)

rgb3 = hsv1.to_rgb
hsv3 = rgb1.to_hsv

puts rgb1
puts rgb2
puts rgb3

puts hsv1
puts hsv2
puts hsv3

#<struct RgbColor r=0.7, g=1.0, b=0.85>
#<struct RgbColor r=0.7, g=1.0, b=0.85>
#<struct RgbColor r=0.7, g=1.0, b=0.85>
#<struct HsvColor h=150, s=0.3, v=1.0>
#<struct HsvColor h=150.0, s=0.30000000000000004, v=1.0>
#<struct HsvColor h=150.0, s=0.30000000000000004, v=1.0>

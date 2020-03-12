module Savio
  def self.hsv2rgb(hue, saturation, value)

    hue = hue.to_f
    saturation = saturation.to_f
    value = value.to_f

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

    return rgb
  end
end

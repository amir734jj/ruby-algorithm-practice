def fast_multiply(x, y)
  if x.to_s.length >= 4 && y.to_s.length >= 4
    sign = find_sign(x, y)

    x = x.abs
    y = y.abs
    m = find_m(x, y)
    b_m = 10**m
    x1, x0 = x.divmod(b_m)
    y1, y0 = y.divmod(b_m)

    z2 = fast_multiply(x1, y1)
    z0 = fast_multiply(x0, y0)
    z1 = fast_multiply((x0 - x1), (y1 - y0)) + z2 + z0
    result = z2 * (b_m**2) + z1 * (b_m**1) + z0 * (b_m**0)
    result * sign
  else
    x * y
  end
end

def find_m(x, y)
  num_length_fun = ->(z) { z.to_s.length / 2 + 1 }
  x_length = num_length_fun.call x
  y_length = num_length_fun.call y

  [x_length, y_length].min
end

def find_sign(x, y)
  ((x >= 0 && y >= 0) || (x <= 0 && y <= 0)) ? 1 : -1
end

puts fast_multiply(-12311111666644444444444444444444444444444444466666565645, 6756645454434444444444444444444545455454545589)
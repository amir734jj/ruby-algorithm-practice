def longest_common_substring(a, b)
  buffer = ''
  a.split('').each do |c1|
    b.split('').each do |c2|
      if c1 == c2
        buffer += c1
      elsif buffer.length > 0
        puts buffer
        buffer = ''
      else
        buffer = ''
      end
    end
  end
end

longest_common_substring('0ABCDE0', "0BCD0")
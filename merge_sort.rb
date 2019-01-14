# @param [Array<Number>] arr
# @return Array<Number>
def merge_sort(arr)
  if arr.length > 1
    mid = (arr.length / 2).to_int

    left_arr = arr.slice(0, mid)
    right_arr = arr.slice(mid, arr.length)

    merge_sort left_arr
    merge_sort right_arr

    i = j = k = 0

    while i < left_arr.length && j < right_arr.length
      if left_arr[i] < right_arr[j]
        arr[k] = left_arr[i]
        i += 1
      else
        arr[k] = right_arr[j]
        j += 1
      end

      k += 1
    end

    while i < left_arr.length
      arr[k] = left_arr[i]
      i += 1
      k += 1
    end

    while j < right_arr.length
      arr[k] = right_arr[j]
      j += 1
      k += 1
    end
  end

  arr

end

puts merge_sort([5, 4, 3, 2, 1])
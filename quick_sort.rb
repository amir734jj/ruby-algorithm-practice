def swap(arr, i, j)
  temp = arr[i]
  arr[i] = arr[j]
  arr[j] = temp
  arr
end

def partition(arr, low, high)
  i = (low - 1)
  pivot = get_pivot(arr)

  (low..high).each do |j|
    if arr[j] <= pivot
      i += 1
      swap(arr, i, j)
    end

    swap(arr, i + 1, high)
    i + 1
  end
end

def get_pivot(arr)
  array[array.length - 1]
end

def quick_sort_rec(arr, low, high)
  if low < high
    partition_index = partition(arr, low, high)
    quick_sort_rec(arr, low, partition_index - 1)
    quick_sort_rec(arr, partition_index + 1, high)
  end

  arr
end

def quick_sort(arr)
  quick_sort_rec(arr, 0, arr.length)
end

puts quick_sort([5, 4, 3, 2, 1])
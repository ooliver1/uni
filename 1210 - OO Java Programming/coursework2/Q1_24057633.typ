= Quick Sort

== Q1A

=== Output

#image("./images/Q1A_output.png", width: 500pt)

=== Pseudocode

```
function quickSort(arr, low, high)
    if low < high then
        pivot_index = partition(arr, low, high)
        quickSort(arr, low, pivot_index - 1)
        quickSort(arr, pivot_index + 1, high)
    end if
end function

function partition(arr, low, high)
    pivot = arr[high]
    swap(arr, pivotIndex, high)
    i = low - 1
    for j = low to high - 1 do
        if arr[j] <= pivot then
            i = i + 1
            temp = arr[i]
            arr[i] = arr[j]
            arr[j] = temp
        end if
    end for
    temp = arr[i + 1]
    arr[i + 1] = arr[high]
    arr[high] = temp
    return i + 1
end function

function swap(arr, i, j)

end function
```

== Q1B

=== Output

#image("./images/Q1B_output.png", width: 350pt)

== Q1C

For testing my sorting algorithms, I decided on performing enough iterations to reach a 500ms runtime, and at minimum 5 iterations. I chose this to ensure that the results were not skewed by any anomaly, and that `System.currentTimeMillis()` was accurate enough to measure the time taken.

I decided to use insertion sort for the small subarrays because it is more efficient for small data sets compared to quicksort. The threshold I used was 10 elements, which seemed like a good starter value.

For deciding the pivot, I originally used random selection, as it helps to avoid the worst-case scenarios such as a fully sorted list having completely unbalanced partitions. This provided the following results:

#image("./images/Q1C-random_output.png", width: 300pt)

I then tried the 'median-of-three' method, which selects the median of the first, middle, and last elements as the pivot. This provides a better estimate of the true median and helps to balance the partitions. The results were as follows:

#image("./images/Q1C-median_output.png", width: 300pt)

This provides about a 20% improvement over the random selection method for the largest list sizes, and more for smaller sizes. I moved on to experimenting with the threshold for switching to insertion sort, first by increasing it to 15:

#image("./images/Q1C-large_output.png", width: 300pt)

This showed to be a worse choice, as the runtime was higher than the 10 element threshold. I then tried a threshold of 5, which provided the following results:

#image("./images/Q1C-small_output.png", width: 300pt)

This also seems to be a worse choice, as the runtime is also higher than the 10 element threshold. This shows that the threshold of 10 is a good balance between quick sort and insertion sort, as it provides the best performance for all list sizes.

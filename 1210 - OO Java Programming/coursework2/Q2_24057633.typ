= Circular Queue

== `enqueue`

When the queue is full, the `enqueue` method creates a new array of double the original size. Elements must be copied over as java's basic arrays do not allow length modification. This is quite inefficient but is the only way to do it well with this template. The front index is then set to 0 and the queue reference is updated to the new array.

The end index is calculated by adding the number of elements to the front index, and wrapping around if it exceeds the length of the queue. The new element is then added to the queue at this index, and the number of elements is incremented.
The time complexity of this method is O(n) in the worst case, as it requires copying all elements to a new array. The space complexity is O(n) as well, as it creates a new array of double the size of the original queue.

== `dequeue`

The `dequeue` method first checks if the queue is empty, and throws an exception if it is. The element at the front index is removed and set to null, and the front index is incremented by 1, wrapping around if it exceeds the length of the queue. The number of elements is decremented.

The time complexity of this method is O(1) as it only requires updating the front index and decrementing the number of elements. The space complexity is O(1) as it does not create any new objects or arrays.

== Output

#image("./images/Q2_output.png", width: 250pt)

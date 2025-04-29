import java.util.ArrayList;

public class HybridQuickSort {
    private static void quickSortImpl(ArrayList<Integer> arr, int low, int high) {
        if (high - low <= 5) {
            insertionSort(arr, low, high);
            return;
        }

        if (low < high) {
            int pivot_index = partition(arr, low, high);
            quickSortImpl(arr, low, pivot_index - 1);
            quickSortImpl(arr, pivot_index + 1, high);
        }
    }

    private static void insertionSort(ArrayList<Integer> arr, int low, int high) {
        for (int i = low + 1; i <= high; i++) {
            int key = arr.get(i);
            int j = i - 1;
            while (j >= low && arr.get(j) > key) {
                arr.set(j + 1, arr.get(j));
                j--;
            }
            arr.set(j + 1, key);
        }
    }

    public static void quickSort(ArrayList<Integer> arr) {
        quickSortImpl(arr, 0, arr.size() - 1);
    }

    private static int partition(ArrayList<Integer> arr, int low, int high) {
        // Median of three pivot selection
        int mid = low + (high - low) / 2;
        int pivotIndex = medianOfThree(arr, low, mid, high);
        int pivot = arr.get(pivotIndex);

        // Move pivot to the end
        swap(arr, pivotIndex, high);

        int i = (low - 1);
        for (int j = low; j < high; j++) {
            if (arr.get(j) <= pivot) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, high);
        return i + 1;
    }

    private static int medianOfThree(ArrayList<Integer> arr, int low, int mid, int high) {
        int a = arr.get(low);
        int b = arr.get(mid);
        int c = arr.get(high);

        if ((a > b) != (a > c)) {
            return low;
        } else if ((b > a) != (b > c)) {
            return mid;
        } else {
            return high;
        }
    }

    private static void swap(ArrayList<Integer> arr, int i, int j) {
        int temp = arr.get(i);
        arr.set(i, arr.get(j));
        arr.set(j, temp);
    }
}

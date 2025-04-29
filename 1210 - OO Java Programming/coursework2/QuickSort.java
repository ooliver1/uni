import java.util.ArrayList;

public class QuickSort {
    public static String truncateArray(ArrayList<Integer> arr) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < Math.min(arr.size(), 10); i++) {
            sb.append(arr.get(i)).append(" ");
        }
        if (arr.size() > 10) {
            sb.append("... ");
        }
        for (int i = Math.max(0, arr.size() - 10); i < arr.size(); i++) {
            sb.append(arr.get(i)).append(" ");
        }
        return sb.toString();
    }

    private static void quickSortImpl(ArrayList<Integer> arr, int low, int high) {
        if (low < high) {
            int pivot_index = partition(arr, low, high);
            quickSortImpl(arr, low, pivot_index - 1);
            quickSortImpl(arr, pivot_index + 1, high);
        }
    }

    public static void quickSort(ArrayList<Integer> arr) {
        quickSortImpl(arr, 0, arr.size() - 1);
    }

    private static int partition(ArrayList<Integer> arr, int low, int high) {
        // Random pivot selection to avoid worst-case scenarios
        int pivotIndex = low + (int) (Math.random() * (high - low + 1));
        int pivot = arr.get(pivotIndex);

        // Move pivot to the end
        int temp = arr.get(pivotIndex);
        arr.set(pivotIndex, arr.get(high));
        arr.set(high, temp);

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

    private static void swap(ArrayList<Integer> arr, int i, int j) {
        int temp = arr.get(i);
        arr.set(i, arr.get(j));
        arr.set(j, temp);
    }
}

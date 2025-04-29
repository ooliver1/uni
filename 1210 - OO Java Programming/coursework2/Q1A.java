import java.util.ArrayList;

public class Q1A {
    protected static int ITEM_COUNTS[] = { 1000, 5000, 10000, 50000, 75000, 100000, 500000 };

    public static void main(String[] args) {
        ArrayList<ArrayList<Integer>> days = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            days.add(new ArrayList<>());
        }

        // Generate random items for each day
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < ITEM_COUNTS[i]; j++) {
                days.get(i).add((int) (Math.random() * 499000) + 1000);
            }
        }
        // Sort each day's items using quicksort
        for (int i = 0; i < 7; i++) {
            System.out.println("Before sorting day " + (i + 1) + ": " + QuickSort.truncateArray(days.get(i)));
            QuickSort.quickSort(days.get(i));
            System.out.println("After sorting day " + (i + 1) + ": " + QuickSort.truncateArray(days.get(i)));
        }
    }
}

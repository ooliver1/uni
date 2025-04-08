/*
Consider a manufacturing company, XYZ that runs 24 hours and 7 days operational. The
company produces a very large number of items per week. In a week from Monday to Sunday, it
produces 1000, 5000, 10000, 50000, 75000, 100000 and 500000 items, respectively.

You are expected to create an Integer ArrayList and store the items (randomly generated) for the
week – so you will have 7 different ArrayList storing items accordingly. Now, you are required to
randomly generate items from 1000 to 500000 for each day as stated above.

Now think about the logic of applying the Quicksort algorithm and first write its pseudocode. Once
you’re done, convert your pseudocode into a Java code and run your code successfully.
 */

import java.util.ArrayList;

public class QuickSort {
    protected static int ITEM_COUNTS[] = { 1000, 5000, 10000, 50000, 75000, 100000, 500000 };

    public static void main(String[] args) {
        ArrayList<ArrayList<Integer>> days = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            days.add(new ArrayList<>());
        }

        // Generate random items for each day
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < ITEM_COUNTS[i]; j++) {
                days.get(i).add((int) (Math.random() * 500000) + 1000);
            }
        }
        // Sort each day's items using quicksort
        for (int i = 0; i < 7; i++) {
            System.out.println("Before sorting day " + (i + 1) + ": " + days.get(i));
            quickSort(days.get(i), 0, days.get(i).size() - 1);
            System.out.println("After sorting day " + (i + 1) + ": " + days.get(i));
        }
    }

    private static void quickSort(ArrayList<Integer> arr, int low, int high) {
    }
}

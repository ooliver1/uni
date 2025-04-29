import java.util.ArrayList;

public class Q1B {
    protected static int TEST_COUNTS[] = { 1000, 5000, 10000, 50000, 75000, 100000, 500000 };

    public static void main(String[] args) {
        ArrayList<ArrayList<Integer>> days = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            days.add(new ArrayList<>());
        }

        // Random list testing.
        System.out.println("Random\n======");
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < TEST_COUNTS[i]; j++) {
                days.get(i).add((int) (Math.random() * 500000) + 1000);
            }
        }
        doTest(days);

        // Sorted list testing.
        System.out.println("\nSorted\n======");
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < TEST_COUNTS[i]; j++) {
                days.get(i).add(j);
            }
        }
        doTest(days);

        // Reverse sorted list testing.
        System.out.println("\nReverse sorted\n======");
        for (int i = 0; i < 7; i++) {
            for (int j = TEST_COUNTS[i] - 1; j >= 0; j--) {
                days.get(i).add(j);
            }
        }
        doTest(days);
    }

    private static void doTest(ArrayList<ArrayList<Integer>> days) {
        for (int i = 0; i < 7; i++) {
            // Copy list to avoid modifying the original
            ArrayList<Integer> day = new ArrayList<>(days.get(i));
            long startTime = System.currentTimeMillis();
            int iterations = 0;
            long elapsedTime = 0;

            do {
                QuickSort.quickSort(day);
                iterations++;
                elapsedTime = System.currentTimeMillis() - startTime;
                // Minimum of 5 iterations, at least 1000ms.
            } while (elapsedTime < 1000 || iterations < 5);

            System.out.println("Random list of size " + TEST_COUNTS[i] + " took " +
                    elapsedTime + " ms for "
                    + iterations + " iterations (" + (elapsedTime / iterations) + " ms per iteration)");
        }
    }
}

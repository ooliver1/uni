package mergeSort;
//package week2;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class W2D1_MergeSort {

    /**
     * Sorts a list of Book objects in ascending order based on their publication
     * year.
     * 
     * @param list The list of books to sort.
     */
    public void mergeSort(List<Book> list) {
        // Base case: if list has 1 or 0 elements, it's already sorted
        if (list.size() <= 1) {
            return;
        }

        // Create leftHalf and rightHalf lists
        int middle = list.size() / 2;

        // Recursively call mergeSort on both halves
        List<Book> left = list.subList(0, middle - 1);
        mergeSort(left);
        List<Book> right = list.subList(middle, list.size() - 1);
        mergeSort(right);

        // Call merge to combine the sorted halves back into the original list
        merge(left, right, list);
    }

    /**
     * Merges two sorted sublists back into a single sorted list.
     * 
     * @param leftHalf     The first sorted half.
     * @param rightHalf    The second sorted half.
     * @param originalList The list to merge the results into.
     */
    private void merge(List<Book> leftHalf, List<Book> rightHalf, List<Book> originalList) {
        // Use three pointers: i for leftHalf, j for rightHalf, k for originalList
        int i = 0;
        int j = 0;

        while (i < leftHalf.size() - 1 && j < rightHalf.size() - 1) {
            Book left = leftHalf.get(i);
            Book right = rightHalf.get(j);
            if (left.getYear() <= right.getYear()) {
                originalList.add(leftHalf.get(i));
                i++;
            } else {
                originalList.add(rightHalf.get(j));
                j++;
            }
        }

        if (i < leftHalf.size() - 1) {
            originalList.add(leftHalf.get(i));
        }
        if (j < rightHalf.size() - 1) {
            originalList.add(rightHalf.get(j));
        }
    }

    // Main method to run the sorting and verification
    public static void main(String[] args) {
        List<Book> books = loadBooksFromCSV("books.csv");
        System.out.println("Original first 10 books:");
        printFirstTenBooks(books);

        W2D1_MergeSort sorter = new W2D1_MergeSort();
        sorter.mergeSort(books);

        System.out.println("\nSorted first 10 books (by year):");
        printFirstTenBooks(books);
    }

    public static List<Book> loadBooksFromCSV(String filePath) {
        List<Book> books = new ArrayList<>();
        String line;
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            br.readLine(); // Skip header line
            while ((line = br.readLine()) != null) {
                // Use a regex to split by comma, but ignore commas inside quotes
                String[] values = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);

                if (values.length >= 4) {
                    try {
                        // Remove quotes from fields that have them
                        String title = values[1].replaceAll("^\"|\"$", "");
                        String author = values[2].replaceAll("^\"|\"$", "");
                        int year = Integer.parseInt(values[3].trim());
                        books.add(new Book(title, author, year));
                    } catch (NumberFormatException e) {
                        System.err.println("Skipping malformed line (year parse error): " + line);
                    }
                } else {
                    System.err.println("Skipping malformed line (not enough columns): " + line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return books;
    }

    private static void printFirstTenBooks(List<Book> books) {
        if (books == null)
            return;
        for (int i = 0; i < 10 && i < books.size(); i++) {
            System.out.println(books.get(i));
        }
    }
}
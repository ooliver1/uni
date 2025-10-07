import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

public class W2D1_MergeSort_test {
    private W2D1_MergeSort mergeSort;
    private List<Book> books;

    @BeforeEach
    void setUp() {
        this.books = W2D1_MergeSort.loadBooksFromCSV("/home/oliver/Documents/pwogwamming/all/uni/2307 - OO, Algorithms and Data Structures/task1/example/books.csv"); // Ensure the file path is correct
    }

    @Test
    void testMergeSort() {
        // Sort the books by year
        mergeSort.mergeSort(this.books);

        // Verify that the books are sorted by year
        for (int i = 0; i < this.books.size() - 1; i++) {
            assertTrue(this.books.get(i).getYear() <= this.books.get(i + 1).getYear(),
                    "Books are not sorted by year");
        }
    }
}

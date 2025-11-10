import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class BookTester {
    private List<Book> records = new ArrayList<>();
    private static final String COMMA = ",";

    public void addBook(Book book) {
        records.add(book);
    }

    public String sequentialSearch(Book query) {
        for (Book book : records) {
            if (book.getISBN() == query.getISBN()) {
                return "Found";
            }
        }

        return "Not Found";
    }

    public String sequentialSearch(Integer query) {
        for (Book book : records) {
            if (book.getISBN() == query) {
                return "Found";
            }
        }

        return "Not Found";
    }

    public List<Book> booksByAuthor(String author) {
        List<Book> books = new ArrayList<>();
        for (Book book : records) {
            if (book.getAuthors().contains(author)) {
                books.add(book);
            }
        }

        return books;
    }

    public void selectionSort() {
        for (int i = 0; i < records.size() - 2; i++) {
            Integer smallest_isbn_index = i;
            Integer smallest_isbn_value = records.get(0).getISBN();

            for (int n = i; n < records.size() - 1; n++) {
                Integer isbn = records.get(n).getISBN();
                if (isbn < smallest_isbn_value) {
                    smallest_isbn_index = n;
                    smallest_isbn_value = isbn;
                }
            }

            // swap
            Book temp = records.get(i);
            records.set(i, records.get(smallest_isbn_index));
            records.set(smallest_isbn_index, temp);
        }
    }

    protected Integer binarySearchImpl(Integer query, int low, int high) {
        if (low > high) {
            return -1;
        }

        Integer middle_index = (low + high) / 2;
        Integer middle = records.get(middle_index).getISBN();

        if (middle == query) {
            return middle_index;
        } else if (query < middle) {
            return binarySearchImpl(query, low, middle_index - 1);
        } else {
            return binarySearchImpl(query, middle + 1, high);
        }
    }

    public Integer binarySearch(Integer query) {
        return binarySearchImpl(query, 0, records.size() - 1);
    }

    protected Integer partition(List<Book> array, int left, int right) {
        Book pivot = array.get(right);
        int i = left - 1;

        for (int j = left; j < right; j++) {
            if (array.get(j).getISBN() <= pivot.getISBN()) {
                i++;

                Book temp = array.get(i);
                array.set(i, array.get(j));
                array.set(j, temp);
            }
        }

        Book temp = array.get(i + 1);
        array.set(i + 1, array.get(right));
        array.set(right, temp);

        return i + 1;
    }
    public void quickSort() {
        quickSortImpl(records, 0, records.size() - 1);
    }

    protected void quickSortImpl(List<Book> array, int left, int right) {
        if (left < right) {
            int pivotIndex = partition(array, left, right);
            quickSortImpl(array, left, pivotIndex - 1);
            quickSortImpl(array, pivotIndex + 1, right);
        }
    }

    public static void main(String[] args) {
        BookTester tester = new BookTester();

        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("books.csv"));
            reader.readLine(); // header

            String line;
            Book book;

            Integer ISBN;
            List<String> authors;
            String title;
            Integer year;

            while ((line = reader.readLine()) != null) {
                String[] values = line.split(COMMA);
                authors = new ArrayList<String>();
                authors.add(values[2]);

                ISBN = Integer.parseInt(values[0]);
                title = values[1];
                year = Integer.parseInt(values[3]);

                book = new Book(title, authors, ISBN, year);
                tester.addBook(book);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return;
        } catch (Exception e) {
            e.printStackTrace();
            return;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

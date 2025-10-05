import java.util.List;

public class Book {
    private String title;
    private List<String> authors;
    private Integer ISBN;
    private Integer year;

    public Book(String title, List<String> authors, Integer ISBN, Integer year) {
        this.title = title;
        this.authors = authors;
        this.ISBN = ISBN;
        this.year = year;
    }

    public String getTitle() {
        return title;
    }

    public List<String> getAuthors() {
        return authors;
    }

    public Integer getISBN() {
        return ISBN;
    }

    public Integer getYear() {
        return year;
    }
}
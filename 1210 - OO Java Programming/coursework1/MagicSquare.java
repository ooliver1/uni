public class MagicSquare {
    private int[][] grid;
    private int size;
    private int row;
    private int column;

    public MagicSquare(int size) {
        this.size = size;
        grid = new int[size][size];

        row = 0;
        column = size / 2;

        grid[row][column] = 1;

        for (int i = 2; i <= size * size; i++) {
            int newRow = (row - 1 + size) % size;
            int newColumn = (column - 1 + size) % size;

            if (grid[newRow][newColumn] == 0) {
                row = newRow;
                column = newColumn;
            } else {
                row = (row + 1) % size;
            }

            grid[row][column] = i;
        }
    }

    public int getSize() {
        return size;
    }

    public String format() {
        int padding = (int) Math.log10(size * size) + 1;

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[i].length; j++) {
                sb.append(String.format("%" + padding + "d", grid[i][j]));
                sb.append(" ");
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}

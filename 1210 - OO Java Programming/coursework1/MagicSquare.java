public class MagicSquare {
    private int[][] grid;
    private int size;
    private int row;
    private int column;

    protected enum Direction {
        UP, DOWN, LEFT, RIGHT;
    };

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

    public void shuffle() {
        for (int i = 0; i < size * size; i++) {
            int row1 = (int) (Math.random() * size);
            int column1 = (int) (Math.random() * size);
            int row2 = (int) (Math.random() * size);
            int column2 = (int) (Math.random() * size);

            int temp = grid[row1][column1];
            grid[row1][column1] = grid[row2][column2];
            grid[row2][column2] = temp;
        }
    }

    public void swap(int row, int column, Direction direction) {
        int newRow = row;
        int newColumn = column;

        switch (direction) {
            case UP:
                newRow--;
                break;
            case DOWN:
                newRow++;
                break;
            case LEFT:
                newColumn--;
                break;
            case RIGHT:
                newColumn++;
                break;
        }

        if (newRow == -1) {
            newRow = size - 1;
        } else if (newRow == size) {
            newRow = 0;
        }

        if (newColumn == -1) {
            newColumn = size - 1;
        } else if (newColumn == size) {
            newColumn = 0;
        }

        int temp = grid[row][column];
        grid[row][column] = grid[newRow][newColumn];
        grid[newRow][newColumn] = temp;
    }

    public boolean isMagic() {
        int magicNumber = (size * (size * size + 1)) / 2;

        for (int i = 0; i < size; i++) {
            int rowSum = 0;
            int columnSum = 0;

            for (int j = 0; j < size; j++) {
                rowSum += grid[i][j];
                columnSum += grid[j][i];
            }

            if (rowSum != magicNumber || columnSum != magicNumber) {
                return false;
            }
        }

        int diagonalSum1 = 0;
        int diagonalSum2 = 0;

        for (int i = 0; i < size; i++) {
            diagonalSum1 += grid[i][i];
            diagonalSum2 += grid[i][size - i - 1];
        }

        return diagonalSum1 == magicNumber && diagonalSum2 == magicNumber;
    }
}

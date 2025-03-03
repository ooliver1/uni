public class MagicSquareGenerator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java MagicSquareGenerator <size>");
            return;
        }

        int size = Integer.parseInt(args[0]);
        if (size < 1 || size % 2 == 0) {
            System.out.println("Size must be a positive odd number.");
            return;
        }

        int[][] magicSquare = new int[size][size];

        int row = 0;
        int column = size / 2;

        for (int i = 1; i <= size * size; i++) {
            // Add another size to ensure this is not negative.
            int newRow = (row - 1 + size) % size;
            int newColumn = (column + 1) % size;
            
            if (magicSquare[newRow][newColumn] != 0) {
                newRow = (row + 1) % size;
                newColumn = column;
            }

            magicSquare[row][column] = i;
            row = newRow;
            column = newColumn;
        }

        System.out.print(display(magicSquare));
    }

    private static String display(int[][] magicSquare) {
        int padding = (int) Math.log10(magicSquare.length * magicSquare.length) + 1;

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < magicSquare.length; i++) {
            for (int j = 0; j < magicSquare[i].length; j++) {
                sb.append(String.format("%" + padding + "d", magicSquare[i][j]));
                sb.append(" ");
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}
public class MagicSquareGenerator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java MagicSquareGenerator <size>");
            return;
        }

        int size = Integer.parseInt(args[0]);
        int[][] magicSquare = new int[size][size];

        int row = 1;
        int column = (size + 1) / 2;

        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                magicSquare[i][j] = 0;
            }
        }
        magicSquare[row - 1][column - 1] = 1;

        for (int i = 2; i < Math.pow(size, 2); i++) {
            if (magicSquare[row - 1][column - 1] == 0) {
                row--; column--;
            } else {
                row++;
            }

            if (row == 0) {
                row = size;
            }
            if (column == 0) {
                column = size;
            }
            if (row == size + 1) {
                row = 1;
            }
            if (column == size + 1) {
                column = 1;
            }

            System.out.println(row + " " + column);
            magicSquare[row-1][column-1] = i;
        }

        System.out.print(display(magicSquare));
    }

    private static String display(int[][] magicSquare) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < magicSquare.length; i++) {
            for (int j = 0; j < magicSquare[i].length; j++) {
                sb.append(magicSquare[i][j]);
                sb.append(" ");
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}

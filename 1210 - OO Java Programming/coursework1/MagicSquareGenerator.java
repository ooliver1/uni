/// Run javac *.java to compile all Java files in the directory
/// Run java MagicSquareGenerator <size> to run the program

import java.util.Scanner;

public class MagicSquareGenerator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java MagicSquareGenerator <size>");
            return;
        }

        int size = Integer.parseInt(args[0]);

        if (size < 3) {
            System.out.println("Size must be at least 3.");
            return;
        }
        if (size % 2 == 0) {
            System.out.println("Size must be odd.");
            return;
        }
        if (size > 15) {
            System.out.println("Size must be less than or equal to 15.");
            return;
        }

        MagicSquare magicSquare = new MagicSquare(size);

        int swaps = 0;
        Scanner scanner = new Scanner(System.in);

        magicSquare.shuffle();
        while (!magicSquare.isMagic()) {
            System.out.println(magicSquare.format());
            System.out.println("Not a magic square. Enter row, column and direction (up, down, left, right) to swap:");
            String input = scanner.nextLine();

            String[] splitInput = input.split(" ");

            if (splitInput.length != 3) {
                System.out.println("Invalid input. Please enter row, column and direction, with spaces inbetween.");
                continue;
            }

            String rowString = splitInput[0];
            String columnString = splitInput[1];
            String directionString = splitInput[2].toUpperCase();

            int row;
            try {
                row = Integer.parseInt(rowString);
            } catch (NumberFormatException e) {
                System.out.println("Invalid row. Please enter a number.");
                continue;
            }

            int column;
            try {
                column = Integer.parseInt(columnString);
            } catch (NumberFormatException e) {
                System.out.println("Invalid column. Please enter a number.");
                continue;
            }

            MagicSquare.Direction direction;
            try {
                direction = MagicSquare.Direction.valueOf(directionString);
            } catch (IllegalArgumentException e) {
                System.out.println("Invalid direction. Please enter up, down, left or right.");
                continue;
            }

            row -= 1;
            column -= 1;

            magicSquare.swap(row, column, direction);
            swaps++;

            System.out.println();
        }

        System.out.println(magicSquare.format());
        System.out.println("Magic square generated after " + swaps + " swaps.");
        scanner.close();
    }
}
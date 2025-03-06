public class MagicSquareGenerator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java MagicSquareGenerator <size>");
            return;
        }

        int size = Integer.parseInt(args[0]);
        MagicSquare magicSquare = new MagicSquare(size);

        System.out.print(magicSquare.format());
    }
}
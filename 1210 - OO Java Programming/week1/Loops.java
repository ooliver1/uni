public class Loops {
    public static void main(String args[]) {
        for (int i = 1; i <= 5; i++) {
            System.out.println(i);
        }

        for (int i = 1; i <= 15; i++) {
            System.out.print(String.format("%d, ", i));
        }
        System.out.println();

        for (int i = 15; i >= 1; i--) {
            System.out.print(String.format("%d, ", i));
        }
        System.out.println();

        for (int i = 5; i <= 45; i += 5) {
            System.out.print(String.format("%d, ", i));
        }
        System.out.println();
    }
}

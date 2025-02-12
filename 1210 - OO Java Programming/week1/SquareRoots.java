import java.lang.Math;

public class SquareRoots {
    public static void main(String args[]) {
        for (int i = 1; i <= 20; i++) {
            System.out.println(String.format("The square root of %d is %.2f", i, Math.sqrt(i)));
        }
    }
}

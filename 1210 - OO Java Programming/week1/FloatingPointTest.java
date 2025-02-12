public class FloatingPointTest {
    public static void main(String args[]) {
        float f = 1.36f;
        double d = 1.36;
        System.out.println(f == d);
        float qf = 1 / 49f;
        System.out.println(qf * 49);
        double qd = 1 / 49d;
        System.out.println(qd * 49);
    }
}

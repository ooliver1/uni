import java.util.Scanner;
// package import missing

public class RewriteNumber {
	public static void main( String args[] ) {
		Scanner in = new Scanner( System.in );

		System.out.println( "Enter an integer between 0 and 9" );
		int num = in.nextInt();

		String numWord = switch (num) {
			case 0 -> "zero";
			case 1 -> "one";
			case 2 -> "two";
			case 3 -> "three";
			case 4 -> "four";
			case 5 -> "five";
			case 6 -> "six";
			case 7 -> "seven";
			case 8 -> "eight";
			case 9 -> "nine";
			default -> "Invalid number";
		};

		System.out.println( "You entered: " + numWord );

		in.close();
	}
}

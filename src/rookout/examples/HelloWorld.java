package rootkout.examples;

public class HelloWorld {  
    public static void main(String args[]) throws Exception {
        int count = 0;
        while(true) {
            System.out.println(new java.util.Date() + " - " + ++count + " sleeping for 1 sec....");
            Thread.sleep(1000);
        }
    }  
}  

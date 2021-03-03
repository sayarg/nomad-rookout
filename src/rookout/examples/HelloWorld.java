package rootkout.examples;

public class HelloWorld {  
    public static void main(String args[]) throws Exception {
        while(true) {
            System.out.println(new java.util.Date() + " - sleeping for 1 sec....");
            Thread.sleep(1000);
        }
    }  
}  

package rootkout.examples;

public class HelloWorld {  
    public static void main(String args[]) throws Exception {
        int count = 0;
        boolean b = true;
        
        while(b) {
            foo(++count);
            Thread.sleep(1000);
        }
    }  
    
    public static void foo(int count) {
        System.out.println(new java.util.Date() + " - " + count + " sleeping for 1 sec....");
    }
}  

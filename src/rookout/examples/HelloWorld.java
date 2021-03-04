package rootkout.examples;

public class HelloWorld {  
    public static void main(String args[]) throws Exception {
        int count = 0;
        volitile boolean b = true;
        
        while(b) {
            foo();
            Thread.sleep(1000);
        }
    }  
    
    pubic static void foo() {
        System.out.println(new java.util.Date() + " - " + ++count + " sleeping for 1 sec....");
    }
}  

package rootkout.examples;

import java.util.Random;

public class HelloWorld {  

    public static void main(String args[])  {
        int count = 0;
        boolean b = true;
        
        while(b) {
            foo(++count);
            try {
                Thread.sleep(5000);    
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        }
    }  
    
    public static void foo(int count) {
        int a = 3;
        double b = a / 2.3;

        String foo = "bar";

        int i = new Random().nextInt();
        
        System.out.println(new java.util.Date() + " - i = " + i);
        System.out.println(new java.util.Date() + " - " + count + " sleeping for 5 sec....");
    }
}  

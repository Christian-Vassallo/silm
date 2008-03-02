package net.swordcoast.sternenfall;


import java.io.OutputStream;

public class StringOutputStream extends OutputStream {

        // This buffer will contain the stream
        protected StringBuffer buf = new StringBuffer();

        public StringOutputStream() {}

        public void close() {}

        public void flush() {
        		//System.out.println("flush");
                // Clear the buffer
                // buf.delete(0, buf.length());
        }

        public void write(byte[] b) {
                String str = new String(b);
                System.out.println("Writing stuff ..");
                this.buf.append(str);
        }
        
        public void write(byte[] b, int off, int len) {
                String str = new String(b, off, len);
                System.out.println("Writing stuff .. 2");
                this.buf.append(str);
        }

        public void write(int b) {
                String str = Integer.toString(b);
                System.out.println("Writing stuff .. 3");
                this.buf.append(str);
        }

        public String toString() {
        	//System.out.println("tostr");
                return buf.toString();
        }

}

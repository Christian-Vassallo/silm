package net.swordcoast.sternenfall;


import java.io.IOException;
import java.io.OutputStream;

public class MyByteArrayOutputStream extends OutputStream {
		protected byte[] buf;

		int pos;
		
        public MyByteArrayOutputStream(int bufsize) {
        	buf = new byte[bufsize];
        	pos = 0;
        }

        public void close() {}

        public void flush() {
        }

        public void write(byte[] b) {
                System.out.println("Writing stuff ..");
                System.arraycopy(b, 0, buf, pos, b.length);
                pos += b.length;
        }
        
        public void write(byte[] b, int off, int len) {
                System.out.println("Writing stuff .. 2");
                throw new UnsupportedOperationException();
        }



        public String toString() {
                return buf.toString();
        }
        
        public void write(int b) throws IOException {
        	buf[pos++] = (byte)b;
        }
}

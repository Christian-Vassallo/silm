package org.jl.nwn.bif;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.WritableByteChannel;

import org.jl.nwn.resource.*;

/**
 * read only representation of a bif file
 */
class BifFile {
    private RandomAccessFile raf;
    private FileChannel fc;
    private int size; // number of resources in this file
    
    public BifFile( File f ) throws IOException{
        raf = new RandomAccessFile( f, "r" );
        fc = raf.getChannel();
        raf.seek( 0x08 );
        size = readIntLE( raf );
    }
    
    public InputStream getEntry( int idx ) throws IOException{
        if ( ( idx < 0 ) | ( idx >= size ) )
            throw new IndexOutOfBoundsException( "Resource index out of bounds : " + idx );
        raf.seek( 0x14 + idx * 0x10  );
        int keyfileID = readIntLE( raf );
        int offset = readIntLE( raf );
        int length = readIntLE( raf );
        int type = readIntLE( raf );
        //System.out.println( bifFile );
        //System.out.println( "offset : " + Integer.toHexString( offset ) );
        //System.out.println( "length : " + Integer.toHexString( length ) );
        //System.out.println( Integer.toHexString( idx ) );
        return new RafInputStream( raf, offset, offset + length );
        //return new ByteBufferInputStream( channel.map( FileChannel.MapMode.READ_ONLY, offset, length ) );
    }
    
    public int getEntrySize( int idx ){
        if ( ( idx < 0 ) | ( idx >= size ) )
            throw new IndexOutOfBoundsException( "Resource index out of bounds : " + idx );
        try {
            raf.seek( 0x14 + (idx * 0x10) + 8 );
            return readIntLE( raf );
        } catch (IOException ioex){
            System.err.println(ioex);
            ioex.printStackTrace();
        }        
        return 0;
    }
    
    public void transferEntryToChannel( int entryIndex, WritableByteChannel c ) throws IOException{
        if ( ( entryIndex < 0 ) | ( entryIndex >= size ) )
            throw new IndexOutOfBoundsException( "Resource index out of bounds : " + entryIndex );
        raf.seek( 0x14 + entryIndex * 0x10  );
        int keyfileID = readIntLE( raf );
        int offset = readIntLE( raf );
        int length = readIntLE( raf );
        int type = readIntLE( raf );
        fc.transferTo( offset, length, c );
    }
    
    public void transferEntryToFile( int entryIndex, File file ) throws IOException{
        FileOutputStream fos = new FileOutputStream(file);
        FileChannel c = fos.getChannel();
        transferEntryToChannel( entryIndex, c );
        c.force(true);
        c.close();
        fos.close();
    }
    
    public MappedByteBuffer getEntryAsBuffer( int idx ) throws IOException{
        if ( ( idx < 0 ) | ( idx >= size ) )
            throw new IndexOutOfBoundsException( "Resource index out of bounds : " + idx );
        raf.seek( 0x14 + idx * 0x10  );
        int keyfileID = readIntLE( raf );
        int offset = readIntLE( raf );
        int length = readIntLE( raf );
        int type = readIntLE( raf );
        return fc.map(FileChannel.MapMode.READ_ONLY, offset, length);
    }
    
    private static int readIntLE( RandomAccessFile raf ) throws IOException{
        return	raf.readUnsignedByte() |
                (raf.readUnsignedByte() << 8)  |
                (raf.readUnsignedByte() << 16) |
                (raf.readUnsignedByte() << 24);
    }
    
    public void close() throws IOException{
        fc.close();
        raf.close();
    }
    
}

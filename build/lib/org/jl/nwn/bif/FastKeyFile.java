package org.jl.nwn.bif;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Comparator;
import java.util.Iterator;
import java.util.TreeMap;

import org.jl.nwn.resource.*;
/**
 * read only representation of a key file
 */
public class FastKeyFile extends KeyFile{
    
    private File file;
    
    protected String[] bifs;
    
    //protected TreeMap<KeyFileEntry, Integer> entryMap;
    //protected Map<KeyFileEntry, Integer> entryMap;
    
    public FastKeyFile(File key) throws IOException {
        //bifs = new java.util.Vector();
        System.out.println(".key file : " + key);
        FileInputStream in = null;
        FileChannel fc = null;
        try{
            file = key;
            in = new FileInputStream(key);
            fc = in.getChannel();
            MappedByteBuffer mbb =
                    fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());
            //mbb.load();
            mbb.order(ByteOrder.LITTLE_ENDIAN);
            mbb.position(8);
            int bifEntries = mbb.getInt();
            int resourceCount = mbb.getInt();
            int bifOffset = mbb.getInt();
            int resourceOffset = mbb.getInt();
            
            //mbb.position( bifOffset );
            byte[] buf = new byte[100]; // should be large enough for a single bif file name
            
            bifs = new String[ bifEntries ];
            for (int i = 0; i < bifEntries; i++) {
                mbb.position(bifOffset + i * 0x0C);
                int bifSize = mbb.getInt();
                int bifNameOffset = mbb.getInt();
                int bifNameLength = mbb.getShort();
                mbb.position(bifNameOffset);
                mbb.get(buf, 0, bifNameLength);
                // seems that bifNameLength includes the terminating \0
                bifs[i] = new String(buf, 0, bifNameLength - 1).replace('\\',File.separatorChar);
                //System.out.println( bifs[i] );
            }
            mbb.position(resourceOffset);
            entryMap = new TreeMap<ResourceID, Integer>(KeyFileEntryComparator);
            //entryMap = new HashMap<ResourceID, Integer>(resourceCount);
            for (int i = 0; i < resourceCount; i++) {
                //byte[] bytes = new byte[16];
                //mbb.get(bytes);
                //entryMap.put(new KeyFileEntry(bytes,mbb.getShort()),mbb.getInt());
                entryMap.put(new KeyFileEntry(
                        mbb.order(ByteOrder.BIG_ENDIAN).getLong(),
                        mbb.getLong(),
                        mbb.order(ByteOrder.LITTLE_ENDIAN).getShort()),mbb.getInt());
            }
        } finally{
            if ( in!=null ) in.close();
            if ( fc != null ) fc.close();
        }
    }
    
    
    /**
     * @param resName resource name
     * @param resType resource type
     * @return BifID of the resource or -1 if no such resource is found
     */
    @Override public int lookup(String resName, short resType) {
        try {
            byte[] b1 = new byte[16];
            byte[] b2 = resName.getBytes("US-ASCII");
            System.arraycopy(b2,0,b1,0,b2.length);
            searchKey = new KeyFileEntry( b1, (short) resType );
            //searchKey = new KeyFileEntry( resName.getBytes("US-ASCII"), (short) resType );
        } catch (UnsupportedEncodingException ex) {
            ex.printStackTrace();
        }
        Integer bifID = entryMap.get(searchKey);
        return (bifID == null) ? -1 : bifID.intValue();
    }
    
    /**
     * @param bifID
     * @return String bif name in platform dependent representation ( i.e.
     * with apropriate file name separator )
     */
    public String getBifName(int bifID) {
        return bifs[bifID >> 20];
    }
    
    public String getFileName() {
        return file.getName();
    }
    
    public Iterator<ResourceID> getResourceIDs() {
        return entryMap.keySet().iterator();
    }
    
    public static void main(String[] args) throws Exception {
        args = new String[]{ "/windows/e/spiele/NeverwinterNights/nwn/chitin.key",
                "/windows/e/spiele/NeverwinterNights/nwn/chitin.key", "spells.2da", "spell.2da" };
        long t1 = System.currentTimeMillis();
        FastKeyFile kTest = new FastKeyFile(new File(args[0]));
        long t2 = System.currentTimeMillis();
        KeyFile kOld = new KeyFile(new File(args[0]));
        long t3 = System.currentTimeMillis();
        System.out.printf("time : %d, %d\n", t2-t1, t3-t2);
        
        
        for ( int i = 1; i < args.length; i++ ){
            try {
            //searchKey.setID(new ResourceID(resName, resType));
            ResourceID resID = ResourceID.forFileName(args[i]);
            byte[] b1 = new byte[16];
            byte[] b2 = resID.getName().getBytes("US-ASCII");
            System.arraycopy(b2,0,b1,0,b2.length);
            kTest.searchKey = kTest.new KeyFileEntry( b1, (short)resID.getType() );
            } catch (UnsupportedEncodingException ex) {
                ex.printStackTrace();
            }            
            System.out.printf( "contains %s : %b\n", kTest.searchKey, kTest.entryMap.keySet().contains(kTest.searchKey));
        }
        
    }

     public class KeyFileEntry extends ResourceID{
        //protected byte[] bytes = new byte[16];        
        protected  long loBytes, hiBytes;
        protected short type;

        protected KeyFileEntry(){
        }
        
        public KeyFileEntry( long hi, long lo, short type ){
            hiBytes = hi;
            loBytes = lo;
            this.type = type;
        }        
        
        public KeyFileEntry( byte[] resrefBytes, short type ){
            ByteBuffer b = ByteBuffer.wrap(resrefBytes);
            hiBytes = b.getLong();
            loBytes = b.getLong();
            this.type = type;
        }
        @Override public short getType(){
            return type;
        }
        /*
        protected byte[] getBytes(){
            return bytes;
        }
        */
        @Override public String getName(){
            ByteBuffer b = ByteBuffer.allocate(16);
            b.putLong(hiBytes);
            b.putLong(loBytes);
            return new String(b.array()).trim();
        }
        public String toString(){
            return getName() + "." + ResourceID.getExtensionForType(type);
        }
        @Override public int compareTo(Object o) {
            if ( o instanceof KeyFileEntry )
                return KeyFileEntryComparator.compare(this, o);
            else
                return super.compareTo(o);
        }
        
        // this hashCode() implementation violates the contract
        // with respect to the super class ResourceID : 
        // a ResourceID object may be equal to a KeyFileEntry object
        // but have a different hash code
        @Override public int hashCode(){
            return ((int)hiBytes + (int)loBytes + type);
        }
        
        @Override public boolean equals(Object o){
            if ( o==this ) return true;
            if ( o instanceof KeyFileEntry )
                return ((KeyFileEntry)o).hiBytes == hiBytes &&
                        ((KeyFileEntry)o).loBytes == loBytes &&
                        ((KeyFileEntry)o).type == type;
            if ( o instanceof ResourceID )
                return ((ResourceID)o).equals(this);
            return false;
        }
    }

    protected KeyFileEntry searchKey = new KeyFileEntry();
     
    final Comparator KeyFileEntryComparator = new Comparator<KeyFileEntry>(){
        public int compare(KeyFileEntry o1, KeyFileEntry o2){
            long l = o1.hiBytes - o2.hiBytes;
            if ( l == 0 ){
                l = o1.loBytes - o2.loBytes;
                return l==0? 0 : l<0? -1 : 1;
            }
            else
                return l<0? -1 : 1;
            // comparing the signum bit shouldn't be neccessary
            // since resnames only contain chars < 128
            /*
            if ( o1.hiBytes < 0 )
                if ( o2.hiBytes >= 0 )
                    return 1;
                else {
                    if ( o1.hiBytes != o2.hiBytes )
                        return ( o1.hiBytes < o2.hiBytes )? -1 : 1;
                }
            else {
                if ( o2.hiBytes < 0 )
                    return -1;
                else {
                    if ( o1.hiBytes != o2.hiBytes )
                        return ( o1.hiBytes < o2.hiBytes )? -1 : 1;
                }
            }
            if ( o1.loBytes < 0 )
                if ( o2.loBytes >= 0 )
                    return 1;
                else {
                    if ( o1.loBytes != o2.loBytes )
                        return ( o1.loBytes < o2.loBytes )? -1 : 1;
                }
            else {
                if ( o2.loBytes < 0 )
                    return -1;
                else {
                    if ( o1.loBytes != o2.loBytes )
                        return ( o1.loBytes < o2.loBytes )? -1 : 1;
                }                
            }
            return o1.getType() - o2.getType();
             */
        }
    };
    
}

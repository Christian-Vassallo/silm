package org.jl.nwn.bif;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import org.jl.nwn.resource.*;/**
 * read only representation of a key file
 */
public class KeyFile {
    
    private File file;
    
    protected String[] bifs;
    
    protected Map<ResourceID, Integer> entryMap = new TreeMap();
    
    protected KeyFile(){}
    
    public KeyFile(File key) throws IOException {
        //bifs = new java.util.Vector();
        FileInputStream in = null;
        try{
            file = key;
            in = new FileInputStream(key);
            FileChannel fc = in.getChannel();
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
            //int bit21 = 1 << 20;
            for (int i = 0; i < resourceCount; i++) {
                mbb.get(buf, 0, 16);
                String resName = (new String(buf, 0, 16)).trim();
                //short type = mbb.getShort();
                //int bifID = mbb.getInt();
                entryMap.put(
                        new ResourceID(resName, mbb.getShort()),
                        mbb.getInt());
                //System.out.println( resName );
                //entries.add( new ResourceEntry( resName, type, bifID >> 20, bifID % bit21 ) );
            }
        } finally{ if ( in!=null ) in.close(); }
        
    }
    
    /**
     * @param resName resource name
     * @param resType resource type
     * @return BifID of the resource or -1 if no such resource is found
     */
    public int lookup(String resName, short resType) {
        Integer bifID =
                (Integer) entryMap.get(new ResourceID(resName, resType));
        return (bifID == null) ? -1 : bifID.intValue();
    }
    
    /**
     * @param bifID
     * @return bif name in platform dependent representation ( i.e.
     * with apropriate file name separator )
     */
    public String getBifName(int bifID) {
        return bifs[bifID >> 20];
    }
    
    public static int getBifIndex(int bifID) {
        return bifID % (1 << 20);
    }
    
    public String getFileName() {
        return file.getName();
    }
    
    public Iterator getResourceIDs() {
        return entryMap.keySet().iterator();
    }
    
    public static void main(String[] args) throws Exception {
        KeyFile k = new KeyFile(new File(args[0]));
        Iterator it = k.getResourceIDs();
        String white16 = "                ";
        String zero = "0x0000";
        String hex = "";
        while (it.hasNext()) {
            ResourceID id = (ResourceID) it.next();
            hex = Integer.toHexString(id.getType());
            hex = zero.substring(0, 6 - hex.length()) + hex;
            int bifID = k.lookup(id.getName(), id.getType());
            System.out.println(
                    id.getName()
                    + white16.substring(id.getName().length())
                    + " "
                    + ResourceID.type2extensionMap.get(new Integer(id.getType()))
                    + " ("
                    + hex
                    + ")  "
                    + k.getBifName(bifID)
                    + " [" + ( bifID % (1<<20) ) + "]"
                    );
        }
    }
    
}

package org.jl.nwn.resource;

import java.io.File;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

/*
 * ResourceIDs can have a length of 16 characters in NWN1 and 32 in NWN2,
 * this class doesn't care about the length, except when creating ResourceIDs
 * from file names where the name is truncated to 32 characters.
 */
public class ResourceID implements Comparable {
    private String name;
    private short type;
    
    public static final Map<String, Short> extension2typeMap =
            new TreeMap<String, Short>();
    
    public static final Map<Short, String> type2extensionMap =
            new TreeMap<Short, String>();
    
    public static final Comparator<ResourceID> COMPARATOR =
            new Comparator<ResourceID>(){
        public int compare(ResourceID o1, ResourceID o2) {
            int r = o1.getName().compareTo(o2.getName());
            return r == 0 ?
                o1.getType() - o2.getType() :
                r;
        }
    };
    
    public static final Comparator<ResourceID> TYPECOMPARATOR =
            new Comparator<ResourceID>(){
        public int compare(ResourceID o1, ResourceID o2) {
            int r = o1.getType() - o2.getType();
            return r == 0 ?
                o1.getName().compareTo(o2.getName()) :
                r;
        }
    };
    
    public static final short TYPE_RES = 0x0000;
    public static final short TYPE_BMP = 0x0001;
    public static final short TYPE_MVE = 0x0002;
    public static final short TYPE_TGA = 0x0003;
    public static final short TYPE_WAV = 0x0004;
    public static final short TYPE_PLT = 0x0006;
    public static final short TYPE_INI = 0x0007;
    public static final short TYPE_BMU = 0x0008;
    public static final short TYPE_MPG = 0x0009;
    public static final short TYPE_TXT = 0x000A;
    public static final short TYPE_PLH = 0x07D0;
    public static final short TYPE_TEX = 0x07D1;
    public static final short TYPE_MDL = 0x07D2;
    public static final short TYPE_THG = 0x07D3;
    public static final short TYPE_FNT = 0x07D5;
    public static final short TYPE_LUA = 0x07D7;
    public static final short TYPE_SLT = 0x07D8;
    public static final short TYPE_NSS = 0x07D9;
    public static final short TYPE_NCS = 0x07DA;
    public static final short TYPE_MOD = 0x07DB;
    public static final short TYPE_ARE = 0x07DC;
    public static final short TYPE_SET = 0x07DD;
    public static final short TYPE_IFO = 0x07DE;
    public static final short TYPE_BIC = 0x07DF;
    public static final short TYPE_WOK = 0x07E0;
    public static final short TYPE_2DA = 0x07E1;
    public static final short TYPE_TLK = 0x07E2;
    public static final short TYPE_TXI = 0x07E6;
    public static final short TYPE_GIT = 0x07E7;
    public static final short TYPE_BTI = 0x07E8;
    public static final short TYPE_UTI = 0x07E9;
    public static final short TYPE_BTC = 0x07EA;
    public static final short TYPE_UTC = 0x07EB;
    public static final short TYPE_DLG = 0x07ED;
    public static final short TYPE_ITP = 0x07EE;
    public static final short TYPE_BTT = 0x07EF;
    public static final short TYPE_UTT = 0x07F0;
    public static final short TYPE_DDS = 0x07F1;
    public static final short TYPE_UTS = 0x07F3;
    public static final short TYPE_LTR = 0x07F4;
    public static final short TYPE_GFF = 0x07F5;
    public static final short TYPE_FAC = 0x07F6;
    public static final short TYPE_BTE = 0x07F7;
    public static final short TYPE_UTE = 0x07F8;
    public static final short TYPE_BTD = 0x07F9;
    public static final short TYPE_UTD = 0x07FA;
    public static final short TYPE_BTP = 0x07FB;
    public static final short TYPE_UTP = 0x07FC;
    public static final short TYPE_DTF = 0x07FD;
    public static final short TYPE_GIC = 0x07FE;
    public static final short TYPE_GUI = 0x07FF;
    public static final short TYPE_CSS = 0x0800;
    public static final short TYPE_CCS = 0x0801;
    public static final short TYPE_BTM = 0x0802;
    public static final short TYPE_UTM = 0x0803;
    public static final short TYPE_DWK = 0x0804;
    public static final short TYPE_PWK = 0x0805;
    public static final short TYPE_BTG = 0x0806;
    public static final short TYPE_UTG = 0x0807;
    public static final short TYPE_JRL = 0x0808;
    public static final short TYPE_SAV = 0x0809;
    public static final short TYPE_NDB = 0x0810; //script debug info
    public static final short TYPE_UTW = 0x080A;
    public static final short TYPE_4PC = 0x080B;
    public static final short TYPE_SSF = 0x080C;
    public static final short TYPE_HAK = 0x080D;
    public static final short TYPE_NWM = 0x080E;
    public static final short TYPE_BIK = 0x080F;
    public static final short TYPE_PTM = 0x0811;
    public static final short TYPE_PTT = 0x0812;
    public static final short TYPE_ERF = 0x270D;
    public static final short TYPE_BIF = 0x270E;
    public static final short TYPE_KEY = 0x270F;
    
    static {
        ResourceID.extension2typeMap.put("res", TYPE_RES);
        ResourceID.extension2typeMap.put("bmp", TYPE_BMP);
        ResourceID.extension2typeMap.put("mve", TYPE_MVE);
        ResourceID.extension2typeMap.put("tga", TYPE_TGA);
        ResourceID.extension2typeMap.put("wav", TYPE_WAV);
        ResourceID.extension2typeMap.put("plt", TYPE_PLT);
        ResourceID.extension2typeMap.put("ini", TYPE_INI);
        ResourceID.extension2typeMap.put("bmu", TYPE_BMU);
        ResourceID.extension2typeMap.put("mpg", TYPE_MPG);
        ResourceID.extension2typeMap.put("txt", TYPE_TXT);
        ResourceID.extension2typeMap.put("plh", TYPE_PLH);
        ResourceID.extension2typeMap.put("tex", TYPE_TEX);
        ResourceID.extension2typeMap.put("mdl", TYPE_MDL);
        ResourceID.extension2typeMap.put("thg", TYPE_THG);
        ResourceID.extension2typeMap.put("fnt", TYPE_FNT);
        ResourceID.extension2typeMap.put("lua", TYPE_LUA);
        ResourceID.extension2typeMap.put("slt", TYPE_SLT);
        ResourceID.extension2typeMap.put("nss", TYPE_NSS);
        ResourceID.extension2typeMap.put("ncs", TYPE_NCS);
        ResourceID.extension2typeMap.put("ndb", TYPE_NDB);
        ResourceID.extension2typeMap.put("mod", TYPE_MOD);
        ResourceID.extension2typeMap.put("are", TYPE_ARE);
        ResourceID.extension2typeMap.put("set", TYPE_SET);
        ResourceID.extension2typeMap.put("ifo", TYPE_IFO);
        ResourceID.extension2typeMap.put("bic", TYPE_BIC);
        ResourceID.extension2typeMap.put("wok", TYPE_WOK);
        ResourceID.extension2typeMap.put("2da", TYPE_2DA);
        ResourceID.extension2typeMap.put("tlk", TYPE_TLK);
        ResourceID.extension2typeMap.put("txi", TYPE_TXI);
        ResourceID.extension2typeMap.put("git", TYPE_GIT);
        ResourceID.extension2typeMap.put("bti", TYPE_BTI);
        ResourceID.extension2typeMap.put("uti", TYPE_UTI);
        ResourceID.extension2typeMap.put("btc", TYPE_BTC);
        ResourceID.extension2typeMap.put("utc", TYPE_UTC);
        ResourceID.extension2typeMap.put("dlg", TYPE_DLG);
        ResourceID.extension2typeMap.put("itp", TYPE_ITP);
        ResourceID.extension2typeMap.put("btt", TYPE_BTT);
        ResourceID.extension2typeMap.put("utt", TYPE_UTT);
        ResourceID.extension2typeMap.put("dds", TYPE_DDS);
        ResourceID.extension2typeMap.put("uts", TYPE_UTS);
        ResourceID.extension2typeMap.put("ltr", TYPE_LTR);
        ResourceID.extension2typeMap.put("gff", TYPE_GFF);
        ResourceID.extension2typeMap.put("fac", TYPE_FAC);
        ResourceID.extension2typeMap.put("bte", TYPE_BTE);
        ResourceID.extension2typeMap.put("ute", TYPE_UTE);
        ResourceID.extension2typeMap.put("btd", TYPE_BTD);
        ResourceID.extension2typeMap.put("utd", TYPE_UTD);
        ResourceID.extension2typeMap.put("btp", TYPE_BTP);
        ResourceID.extension2typeMap.put("utp", TYPE_UTP);
        ResourceID.extension2typeMap.put("dtf", TYPE_DTF);
        ResourceID.extension2typeMap.put("gic", TYPE_GIC);
        ResourceID.extension2typeMap.put("gui", TYPE_GUI);
        ResourceID.extension2typeMap.put("css", TYPE_CSS);
        ResourceID.extension2typeMap.put("ccs", TYPE_CCS);
        ResourceID.extension2typeMap.put("btm", TYPE_BTM);
        ResourceID.extension2typeMap.put("utm", TYPE_UTM);
        ResourceID.extension2typeMap.put("dwk", TYPE_DWK);
        ResourceID.extension2typeMap.put("pwk", TYPE_PWK);
        ResourceID.extension2typeMap.put("btg", TYPE_BTG);
        ResourceID.extension2typeMap.put("utg", TYPE_UTG);
        ResourceID.extension2typeMap.put("jrl", TYPE_JRL);
        ResourceID.extension2typeMap.put("sav", TYPE_SAV);
        ResourceID.extension2typeMap.put("utw", TYPE_UTW);
        ResourceID.extension2typeMap.put("4pc", TYPE_4PC);
        ResourceID.extension2typeMap.put("ssf", TYPE_SSF);
        ResourceID.extension2typeMap.put("hak", TYPE_HAK);
        ResourceID.extension2typeMap.put("nwm", TYPE_NWM);
        ResourceID.extension2typeMap.put("bik", TYPE_BIK);
        ResourceID.extension2typeMap.put("ptm", TYPE_PTM);
        ResourceID.extension2typeMap.put("ptt", TYPE_PTT);
        ResourceID.extension2typeMap.put("erf", TYPE_ERF);
        ResourceID.extension2typeMap.put("bif", TYPE_BIF);
        ResourceID.extension2typeMap.put("key", TYPE_KEY);
        Iterator it = ResourceID.extension2typeMap.keySet().iterator();
        while (it.hasNext()) {
            String key = (String) it.next();
            ResourceID.type2extensionMap.put(ResourceID.extension2typeMap.get(key), key);
        }
    }
    
    protected ResourceID(){}
    
    public ResourceID(String name, short type){
        //System.out.println( name + " ("+type+")" );
        this.name = name;
        this.type = type;
    }
    public ResourceID(String name, String ext){
        setType(ResourceID.getTypeForExtension( ext ));
        setName(name);
    }
    
    public int compareTo(Object o) {
        ResourceID id = (ResourceID) o;
        int s = getName().compareToIgnoreCase(id.getName());
        return (s == 0) ? getType() - id.getType() : s;
    }
    
    public boolean equals( Object o ){
        return compareTo(o)==0;
    }
    
    public int hashCode(){
        return getName().hashCode() + getType();
    }
    
    /**
     * @return filename for this resource ID
     * */
    public String toString(){
        return getName() + "." + ResourceID.getExtensionForType( getType() );
    }
    
    /**
     * @return filename for this resource ID
     * */
    public String toFileName(){
        return toString();
    }
    
    public static ResourceID forFile( File file ){
        return ( forFileName(file.getName()) );
    }
    
    public static ResourceID forFileName( String fname ){
        fname = fname.toLowerCase();
        
        StringBuffer sb = new StringBuffer();
        for ( int i = 0; i < fname.length(); i++ ){
            char c = fname.charAt(i);
            if ( Character.isLetterOrDigit( c ) || c=='_' || c=='.' )
                sb.append( fname.charAt(i) );
        }
        fname = sb.toString();
        
        int last = fname.lastIndexOf('.');
        int first = fname.indexOf('.');
        String ext = (last==-1)?"txt":fname.substring( last+1 );
        String name = (first==-1)?
            fname.substring( 0, Math.min(fname.length(),32) )
            :fname.substring( 0, Math.min(first,32) );
        return new ResourceID( name, ext );
    }
    
    /**
     * @return the int value representing the type given by the parameter or -1 if the extension is not known
     * */
    public static short getTypeForExtension(String extension) {
        Short type = extension2typeMap.get(extension);
        return (type == null) ? -1 : type.shortValue();
    }
    
    public static String getExtensionForType(short type) {
        return type2extensionMap.get(type);
    }
    
    private void setName(String name) {
        this.name = name;
    }
    
    public String getName() {
        return name;
    }
    
    public String getExtension(){
        return getExtensionForType(type);
    }
    
    /**
     * @return resource file name ( name + extension )
     */
    public String getNameExt() {
        return name + "." + getExtensionForType(type);
    }
    
    private void setType(short type) {
        this.type = type;
    }
    
    public short getType() {
        return type;
    }
    
}

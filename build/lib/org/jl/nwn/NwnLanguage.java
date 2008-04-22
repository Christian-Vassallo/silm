package org.jl.nwn;

import java.util.Arrays;
import java.util.Collections;
import java.util.EnumMap;
import java.util.List;

public enum NwnLanguage{
    
    TOKENID( "GffToken", -1 ),
    
    ENGLISH( "English", 0 ),
    FRENCH( "French", 1 ),
    GERMAN( "German", 2 ),
    ITALIAN( "Italian", 3 ),
    SPANISH( "Spanish", 4 ),
    POLISH( "Polish", 5 ),
    UNKNOWNNWN2( "UnknownNwn2(RU?)", 6 ),
    
    KOREAN( "Korean", 128 ),
    CHIN_TRAD( "Chinese, Traditional", 129 ),
    CHIN_SIMP( "Chinese, Simplified", 130 ),
    JAPANESE( "Japanese", 131 );
    
    private String name;
    private int code;
    
    public static final List<NwnLanguage> LANGUAGES;
    
    private NwnLanguage( String name, int code ){
        this.name=name;
        this.code=code;
    }
    
    public String getName(){
        return name;
    }
    
    public int getCode(){
        return code;
    }
    
    public String getEncoding(Version v){
        return encodingMap.get(v==null?Version.getDefaultVersion():v).get(this);
    }
    
    public String getEncoding(){
        return encodingMap.get(Version.getDefaultVersion()).get(this);
    }
    
    public String toString(){
        return name;
    }
    
    public static NwnLanguage forCode( int code ){
        for ( NwnLanguage l : NwnLanguage.values() )
            if ( l.getCode() == code )
                return l;
        throw new Error(
                "Error : unsupported language, language code : "
                + code );
    }
    
    public static void setEncoding(NwnLanguage l, Version v, String enc){
        encodingMap.get(v).put(l, enc);
    }
    
    private static EnumMap<Version, EnumMap<NwnLanguage, String>>
            encodingMap = new EnumMap(Version.class);
    
    static{
        EnumMap<NwnLanguage, String> nw1map = new EnumMap(NwnLanguage.class);
        nw1map.put( ENGLISH, "windows-1252" );
        nw1map.put( FRENCH, "windows-1252" );
        nw1map.put( GERMAN, "windows-1252" );
        nw1map.put( ITALIAN, "windows-1252" );
        nw1map.put( SPANISH, "windows-1252" );
        nw1map.put( POLISH, "windows-1250" );
        nw1map.put( UNKNOWNNWN2, "windows-1250" );
        
        nw1map.put( KOREAN, "MS949" );
        nw1map.put( CHIN_TRAD, "MS950" );
        nw1map.put( CHIN_SIMP, "MS936" );
        nw1map.put( JAPANESE, "MS932" );
        
        nw1map.put( TOKENID, "UTF-8" );
        
        EnumMap<NwnLanguage, String> nw2map = new EnumMap(NwnLanguage.class);
        nw2map.put( ENGLISH, "UTF-8" );
        nw2map.put( FRENCH, "UTF-8" );
        nw2map.put( GERMAN, "UTF-8" );
        nw2map.put( ITALIAN, "UTF-8" );
        nw2map.put( SPANISH, "UTF-8" );
        nw2map.put( POLISH, "UTF-8" );
        nw2map.put( UNKNOWNNWN2, "UTF-8" );
        
        nw2map.put( KOREAN, "UTF-8" );
        nw2map.put( CHIN_TRAD, "UTF-8" );
        nw2map.put( CHIN_SIMP, "UTF-8" );
        nw2map.put( JAPANESE, "UTF-8" );
        
        nw2map.put( TOKENID, "UTF-8" );
        
        encodingMap.put(Version.NWN1, nw1map);
        encodingMap.put(Version.NWN2, nw2map);
        
        String enc = null;
        if ( ( enc = System.getProperty( "tlkedit.charsetOverride" )) != null ){
            String[] values = enc.split(";");
            try{
                for ( int p = 0; p < values.length; p++ ){
                    String[] triple = values[p].split(":");
                    Version v = Enum.valueOf(Version.class, triple[0]);
                    NwnLanguage l = forCode( Integer.parseInt(triple[1]) );
                    String encoding = triple[2];
                    encodingMap.get(v).put(l, encoding);
                    System.out.printf("encoding for %s (%s) set to %s\n",
                            l.getName(), v, encoding);
                }
            } catch ( Throwable t ){
                System.err.println(
                        "invalid format for tlkedit.encodingOverride : " +
                        enc);
                System.err.println(t);
            }
        }
        
        LANGUAGES = Collections.unmodifiableList( Arrays.asList( values() ) );
    }
}

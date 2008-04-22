package org.jl.nwn;

public enum Version {
    NWN1, NWN2;
    
    private static Version defaultVersion = NWN1;
    
    static{
        String defName = System.getProperty("tlkedit.defaultNwnVersion", "NWN1");
        defName = defName.toUpperCase();
        try {
            defaultVersion = Enum.valueOf(Version.class, defName);
        } catch (IllegalArgumentException iae) {
            System.err.println("Invalid version : " + defName );
        }
    }
    
    public static Version getDefaultVersion() {
        return defaultVersion;
    }

    public static void setDefaultVersion(Version aDefaultVersion) {
        defaultVersion = aDefaultVersion;
    }
}

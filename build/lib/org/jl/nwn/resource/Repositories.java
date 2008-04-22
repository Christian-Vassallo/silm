package org.jl.nwn.resource;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import org.jl.nwn.bif.BifRepository;
import org.jl.nwn.erf.ErfFile;

/**
 * Singleton registry for open repositories, also contains factory methods for opening
 * repositories
 */
public final class Repositories {
    
    private static Repositories instance;
    private HashMap<Descriptor, NwnRepository> repositories;
    
    private static Object lock = new Object();
    
    /** Creates a new instance of Repositories */
    private Repositories(){
        repositories = new HashMap<Descriptor, NwnRepository>();
    }
    
    public static Repositories getInstance(){
        if ( instance == null )
            synchronized ( lock ){
              if ( instance == null )
                  instance = new Repositories();
            }
        return instance;
    }
    
    private class Descriptor{
        Class rClass;
        File[] files;
        
        private Descriptor( Class c, File[] files ){
            this.rClass = c;
            this.files = files;
        }
        
        @Override public int hashCode(){
            return Arrays.deepHashCode(files)
            + rClass.hashCode();
        }
        
        @Override public boolean equals(Object o){
            return ( o instanceof Descriptor )
            && ((Descriptor)o).rClass.equals(rClass)
            && Arrays.deepEquals( files, ((Descriptor)o).files );
        }
    }
    
    public BifRepository getBifRepository( File baseDir, String[] keyfiles ) throws IOException{
        File[] files = keyfiles == null ?
            new File[]{baseDir}:
            new File[1+keyfiles.length];
        if ( keyfiles != null )
            for ( int i = 0; i < keyfiles.length; i++ ){
                File key = new File(baseDir, keyfiles[i]);
                if ( !key.exists() || key.isDirectory() ){
                    throw new FileNotFoundException( "Keyfile not found : " + keyfiles[i] ); 
                }
                files[1+i] = key;
            }
        Descriptor d = new Descriptor( BifRepository.class, files );
        NwnRepository r = repositories.get(d);
        if ( r == null ){
            r = keyfiles == null ?
                new BifRepository(baseDir) :
                new BifRepository( baseDir, keyfiles );
            repositories.put( d, r );
        }
        return (BifRepository) r;
    }
    
    public ErfFile getErfRepository( File erf ) throws IOException{
        Descriptor d = new Descriptor( ErfFile.class, new File[]{erf} );
        NwnRepository r = repositories.get(d);
        if ( r == null ){
            r = new ErfFile(erf);
            repositories.put( d, r );
        }
        return (ErfFile) r;
    }
    
    protected void register( NwnRepository rep, File[] files ){
        Descriptor d = new Descriptor( rep.getClass(), files );
        repositories.put(d, rep);
    }
    
}

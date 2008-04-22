/*
 * Created on 02.01.2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package org.jl.nwn.resource;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Set;
import java.util.TreeSet;

/**
 * Chain of responsibility for Repositories.
 */
public class NwnChainRepository extends AbstractRepository {
    
    private NwnRepository[] repositories;
    //private NwnRepository r2;
    
    public NwnChainRepository( NwnRepository ... repositories ){
        if ( repositories == null || repositories.length == 0 )
            throw new IllegalArgumentException("Repository list must not be empty or null : " + repositories);
        this.repositories = repositories;
    }
    
    public static NwnRepository chainRespositories( NwnRepository ... reps ){
        return new NwnChainRepository(reps);
    }
    
        /* (non-Javadoc)
         * @see org.jl.nwn.resource.NwnRepository#getResource(org.jl.nwn.resource.ResourceID)
         */
    public InputStream getResource(ResourceID id) throws IOException {
        InputStream is = null;
        for ( int i = 0; i < repositories.length && is == null; i++ )
            is = repositories[i].getResource(id);
        return is;
    }
    
    public java.nio.ByteBuffer getResourceAsBuffer(ResourceID id) throws IOException, UnsupportedOperationException {
        java.nio.ByteBuffer retValue = null;
        for ( int i = 0; i < repositories.length && retValue == null; i++ )
            retValue = repositories[i].getResourceAsBuffer(id);
        return retValue;
    }
    
        /* (non-Javadoc)
         * @see org.jl.nwn.resource.NwnRepository#getResourceLocation(org.jl.nwn.resource.ResourceID)
         */
    public File getResourceLocation(ResourceID id) {
        File f = null;
        for ( int i = 0; i < repositories.length && f == null; i++ )
            if ( repositories[i].contains(id) )
                return repositories[i].getResourceLocation(id);
        return f;
    }
    
        /* (non-Javadoc)
         * @see org.jl.nwn.resource.NwnRepository#contains(org.jl.nwn.resource.ResourceID)
         */
    public boolean contains(ResourceID id) {
        boolean found = false;
        for ( int i = 0; i < repositories.length && !found; i++ )
            found = repositories[i].contains(id);
        return found;
    }
    
    private NwnRepository findRepository( ResourceID id ){
        for ( int i = 0; i < repositories.length; i++ )
            if (repositories[i].contains(id))
                return repositories[i];
        return null;
    }
    
    public Set getResourceIDs(){
        Set s = new TreeSet();
        for ( int i = 0; i < repositories.length; i++ )
            s.addAll( repositories[i].getResourceIDs() );
        return Collections.unmodifiableSet( s );
    }
    
    public int getResourceSize( ResourceID id ){
        NwnRepository r = findRepository(id);
        return r != null ?
            r.getResourceSize(id) :
            0;
    }

    /**
     * Get OutputStream for writing to the first NwnRepository in the chain.
     */
    public java.io.OutputStream putResource(ResourceID id) throws IOException, UnsupportedOperationException {
        return repositories[0].putResource(id);
    }
    
    /**
     * A NwnChainRepository is writable if the first NwnRepository of the chain
     * is writable.
     * @return true iff the first repository is writable
     */
    public boolean isWritable() {
        return repositories[0].isWritable();
    }
    
    
    
}

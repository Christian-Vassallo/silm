package org.jl.nwn.editor;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NoSuchObjectException;
import java.rmi.NotBoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import javax.swing.UIManager;
import org.jl.nwn.Version;

interface Edit extends Remote {
    public void load( File f ) throws RemoteException;
}

public class EditorServer extends UnicastRemoteObject implements Edit{
    
    public static String name = "//127.0.0.1/tlkeditor";
    
    private static int registryPort = 1099;
    
    private EditorFrameX editor;
    
    public EditorServer( EditorFrameX ed, final String name ) throws RemoteException {
        this.editor = ed;
        ed.addWindowListener(new WindowAdapter(){
            public void windowClosed(WindowEvent e) {
                super.windowClosed(e);
                boolean success = false;
                try {
                    success = UnicastRemoteObject.unexportObject(EditorServer.this, true);
                } catch (NoSuchObjectException ex) {
                    ex.printStackTrace();
                }
                try {
                    Naming.unbind(name);
                } catch (MalformedURLException ex) {
                    ex.printStackTrace();
                } catch (RemoteException ex) {
                    ex.printStackTrace();
                } catch (NotBoundException ex) {
                    ex.printStackTrace();
                }
                System.out.println(success);
            }
        });
    }
    
    public void load( File f ) throws RemoteException{
        System.out.println( "loading "+f.getAbsolutePath() );
        editor.openFile( f, Version.getDefaultVersion() );
    }
    
    private static EditorServer newServer(String name) throws RemoteException, MalformedURLException{
        EditorFrameX ef = new EditorFrameX();
        EditorServer ed = new EditorServer( ef, name );
        Naming.rebind( name, ed );
        return ed;
    }
    
    public static void main( String[] args ) throws Exception{
        if ( System.getProperty("swing.defaultlaf") == null )
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        System.out.println(UIManager.getCrossPlatformLookAndFeelClassName());
        int argsStart = 0;
        if ( args.length > 0 && args[0].startsWith( "-port=" )  ){
            registryPort = Integer.parseInt( args[0].substring( 6 ) );
            argsStart = 1;
        }
        name = "//127.0.0.1:"+registryPort+"/tlkeditor";
        
        try{
            LocateRegistry.createRegistry( registryPort );
        } catch ( RemoteException re ){
            System.out.println( re );
        }
        Edit ed = null;
        
        try {
            ed = ( Edit ) Naming.lookup( name );
            Naming.unbind(name);
            //System.out.println(UnicastRemoteObject.unexportObject(ed, true));
            //System.out.println("server found");
        } catch (NotBoundException nbe) {
            ed = newServer(name);
        } catch ( Exception e ){
            System.out.println( e.getMessage() ); e.printStackTrace();
        }
        
        for ( int i = argsStart; i < args.length; i++ ){
            ed.load( (new File( args[i] )).getAbsoluteFile() );
        }
        return;
    }
    
}

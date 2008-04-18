package net.swordcoast.sternenfall;


import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

import org.progeeks.nwn.gff.Struct;
import org.progeeks.nwn.io.gff.GffReader;
import org.progeeks.nwn.io.gff.GffWriter;
import org.progeeks.nwn.io.xml.GffXmlReader;
import org.progeeks.nwn.io.xml.GffXmlWriter;

public class Convert {
	
	static String gffToXml(String name, byte[] gff) throws IOException {
		InputStream is = new ByteArrayInputStream(gff);
		GffReader r = new GffReader(is);
		OutputStream ostr = new StringOutputStream();
		OutputStreamWriter out = new OutputStreamWriter(ostr);
		
		GffXmlWriter xmlwriter = new GffXmlWriter(name,
				r.getHeader().getType(), r.getHeader().getVersion(), out);
		try {
			xmlwriter.writeStruct(r.readRootStruct());
		} finally {
			r.close();
			xmlwriter.close();
		}

		return ostr.toString();
	}
	
	

	static byte[] XmlToGff(String xml, boolean compressGff) throws Exception {
		GffXmlReader xmlReader = new GffXmlReader();
		InputStreamReader istrr = new InputStreamReader(new ByteArrayInputStream(xml.getBytes()));
		BufferedReader bIn = new BufferedReader(istrr, 65536);
		
		ByteArrayOutputStream ostr = new ByteArrayOutputStream();

		try {
		
			// Read the XML file
			Object obj;
			try {
				obj = xmlReader.readObject(bIn);
			} catch (Exception ee) {
				System.out.println(ee.toString());
				throw ee;
			}
			
			if (!(obj instanceof Struct)) {
				throw new RuntimeException("Invalid XML GFF: " + obj);
			}
			
			//System.out.println("writer?");
			Struct root = (Struct) obj;
			
			GffWriter out = new GffWriter(xmlReader.getType(), xmlReader
					.getVersion(), ostr);
			//System.out.println("writer 2");
			out.setShouldCompress(compressGff);
			//System.out.println("writer 3");
			out.writeStruct(root);
			
		} finally {
			
			bIn.close();
		}
		//System.out.println("len is " + ostr.toString().length());
		return ostr.toByteArray();

	}
	
	
	/*public static void main(String[] a) throws Exception {
		int buf = 2 << 16;
		//File f = new File("/tmp/ad_pillar_dlg.dlg");
		File f = new File("/tmp/test.uti");
		FileInputStream fIn = new FileInputStream( f );
        BufferedInputStream bIn = new BufferedInputStream( fIn, buf );
        byte[] bsf = new byte[buf];
        int sz = bIn.read(bsf);
        String str = new String(bsf,0, sz);
        String ret = gffToXml("testname", bsf);
        System.out.println("Strlen = " + str.length() + ", bufsize = " + buf + ", retlen = " + ret.length());
        System.out.println(ret);
        
        byte[] back = XmlToGff(ret, false);
        
        System.out.println("ret2len = " + back.length);
        
	}*/
	/*	
	public static void main(String[] a) throws IOException {
		int buf = 2 << 16;
		File f = new File("/tmp/test.utc.xml");
		FileInputStream fIn = new FileInputStream( f );
        BufferedInputStream bIn = new BufferedInputStream( fIn, buf );
        byte[] bsf = new byte[buf];
        int sz = bIn.read(bsf);
        String str = new String(bsf,0, sz);
        

        byte[] raf = XmlToGff(str, true);
        
        System.out.println("Strlen = " + str.length() + ", bufsize = " + buf + ", retlen = " + raf.length);
        
        File ft = new File("/tmp/out.utc");
        FileOutputStream fos = new FileOutputStream(ft);
        
        fos.write(raf);
        fos.close();
	}*/
	
}

/*
 * GffTreeCellRenderer.java
 *
 * Created on 15. Mai 2005, 13:17
 */

package org.jl.nwn.gff.editor;

import java.awt.Component;
import java.util.Locale;
import javax.swing.Icon;
import javax.swing.JTree;
import javax.swing.tree.DefaultTreeCellRenderer;
import org.jdesktop.swingx.treetable.TreeTableModel;
import org.jl.nwn.NwnLanguage;
import org.jl.nwn.gff.CExoLocSubString;
import org.jl.nwn.gff.Gff;
import org.jl.nwn.gff.GffCExoLocString;
import org.jl.nwn.gff.GffField;
import org.jl.swing.UIDefaultsX;


/**
 *
 * @author
 */
public class GffTreeCellRenderer extends DefaultTreeCellRenderer{
    
    protected JTree tree;
    
    protected TreeTableModel ttm;
    protected static final UIDefaultsX uid = new UIDefaultsX();
    
    protected String male, female;
    
    static {
        uid.addResourceBundle("org.jl.nwn.gff.editor.uidefaults",
                Locale.getDefault(),
                GffTreeCellRenderer.class.getClassLoader()
                );
    }
    
    /** Creates a new instance of GffTreeCellRenderer */
    public GffTreeCellRenderer( TreeTableModel ttm ){
        super();
        this.ttm = ttm;
    }
    
    public Component getTreeCellRendererComponent(
            JTree tree,
            Object value,
            boolean selected,
            boolean expanded,
            boolean leaf,
            int row,
            boolean hasFocus) {
        //sb.delete(0, sb.length());
        String text = ttm.getValueAt(value, 0).toString();
        super.getTreeCellRendererComponent(
                tree,
                text,
                selected,
                expanded,
                leaf,
                row,
                hasFocus);
        this.tree = tree;
        GffField field = (GffField) value;
        if ( male == null ){
            male = getFont().canDisplay('\u2642') ?
                String.valueOf('\u2642') : "male";
            female = getFont().canDisplay('\u2640') ?
                String.valueOf('\u2640') : "female";
        }
        //setText( text );
        //setText( sb.toString() );
        if ( field.getType() == GffCExoLocString.SUBSTRINGTYPE ){
            CExoLocSubString sub = (CExoLocSubString) field;
            int code = sub.language.getCode();
            StringBuilder sb = new StringBuilder(sub.language.getName());
            sb.append(" ").append(sub.gender == 0? male : female);
            setText(sb.toString());
            //setText( sub.language.getName() + " " + sub.gender == 0? male : female );
            if (code == NwnLanguage.ENGLISH.getCode() )
                setIcon( uid.getIcon("flag.canada") );
            else if (code == NwnLanguage.GERMAN.getCode() )
                setIcon( uid.getIcon("flag.germany") );
            else if (code == NwnLanguage.FRENCH.getCode() )
                setIcon( uid.getIcon("flag.france") );
            else if (code == NwnLanguage.ITALIAN.getCode() )
                setIcon( uid.getIcon("flag.italy") );
            else if (code == NwnLanguage.SPANISH.getCode() )
                setIcon( uid.getIcon("flag.spain") );
            else if (code == NwnLanguage.POLISH.getCode() )
                setIcon( uid.getIcon("flag.poland") );
            else if (code == NwnLanguage.KOREAN.getCode() )
                setIcon( uid.getIcon("flag.korea") );
            else if (code == NwnLanguage.JAPANESE.getCode() )
                setIcon( uid.getIcon("flag.japan") );
            else if (code == NwnLanguage.CHIN_SIMP.getCode() )
                setIcon( uid.getIcon("flag.china") );
            else if (code == NwnLanguage.CHIN_TRAD.getCode() )
                setIcon( uid.getIcon("flag.china") );
        } else
            setIcon( getIconForType(field.getType()) );
        //if (field instanceof GffInteger)	text = field.toString();
        validate();
        return this;
    }
    
    public static Icon getIconForType( byte type ){
        Icon i = null;
        if (type == Gff.STRUCT)
            i = uid.getIcon("gffstruct.icon");
        else if (type == Gff.LIST)
            i = uid.getIcon("gfflist.icon");
        else if ( type < 9 && type != 7 ){
            i = uid.getIcon("gffnumber.icon");
        } else if (type == Gff.VOID)
            i = uid.getIcon("gffvoid.icon");
        else
            i = uid.getIcon("gffstring.icon");
        return i;
    }
    
}

package mac_econ.applet;

import java.awt.*;
import java.lang.*;
import mac_econ.graph.*;

public class GraphPanel extends Panel{

    int height, width;
    GraphManager gmGeorge;
    
    
	public GraphPanel(GraphManager gmBoss){ // don't know if this constructor is needed, or if the super() is needed.
		super();
	    gmGeorge = gmBoss;
	    width = 600;
	    height = 500;
	    
	}
	
	public void paint(Graphics g){
	    g.setColor(Color.white);
		g.fillRect(0, 0, width, height);
		g.setColor(Color.black);
		//System.out.println("here ---->4");
		/*try{
			gmGeorge.forecastPaint(g);
		}catch (Exception e){System.out.println(e+" - gp.forecastPaint failed");}
		*/
		try{
			while(!(gmGeorge.graphPaint(g))){
		    		g.setColor(Color.white);
				g.fillRect(0, 0, width, height);
				g.setColor(Color.black);
			}
		} catch(Exception e){System.out.println(e + " graphPaint failed");}
		g.dispose(); // we shall have to see what this does
	}
}

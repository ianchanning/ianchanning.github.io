package mac_econ.applet;

import java.awt.*;
import java.lang.*;
import mac_econ.graph.*;

public class ForecastPanel extends Panel{

    int height, width;
    GraphManager gmGeorge;
    
    
	public ForecastPanel(GraphManager gmBoss){ // don't know if this constructor is needed, or if the super() is needed.
		super();
	    gmGeorge = gmBoss;
	    width = 600;
	    height = 500;
	    
	}
	
	public void paint(Graphics g){
	    g.setColor(Color.white);
		g.fillRect(0, 0, width, height);
		g.setColor(Color.black);
		
		try{
			gmGeorge.forecastPaint(g);
			//{
		    //		g.setColor(Color.white);
			//	g.fillRect(0, 0, width, height);
			//	g.setColor(Color.black);
			//}
		} catch(Exception e){System.out.println(e + " fp.forecastPaint failed");}
		g.dispose();
	}
}

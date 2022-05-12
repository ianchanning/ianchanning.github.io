package mac_econ.model;

import java.awt.*;
import java.util.Vector;
import java.lang.*;
import mac_econ.function.*;
import mac_econ.graph.*;


public class ModelManager implements Equations{

	public ModelManager(){
	}
	
// 	returns vector of strings of graph names for this model	
	public Vector select(int modelID){
		Vector vGraphNames = new Vector();
		for (int i=0; i < saaaGraphs[modelID-1].length; i++){
			vGraphNames.addElement(saaaGraphs[modelID-1][i][0]);
		}
		return vGraphNames;
	}
	
	public String[] select(int modelID, int eqnID){
	    return saaaGraphs[modelID-1][eqnID-1];
    }	
	
	public boolean select(int modelID, int eqnID, GraphManager gmGeorge){
	    Curve c1 = new mac_econ.model.model1.YDCurve();
	    Curve c2 = c1;
	    switch(modelID){
	    	case 1:
	    		switch(eqnID){
	    			case 1: c2 = new mac_econ.model.model1.ConsumptionCurve();
	    			break;
	    			
	    			default:System.out.print("modelID=0, eqnID error");
	    			break;
	    		}
	    	break;
	    	
	    	case 2:
	    		switch(eqnID){
	    		
	    			case 1: c2 = new mac_econ.model.model2.ConsumptionCurve2();
	    			break;
	    			
	    			default:System.out.print("modelID=0, eqnID error");
	    			break;
	    		}
	    	break;
	    	
	    	case 3:
	    		switch(eqnID){
	    			case 1:	c1 = new mac_econ.model.model3.ISCurve();
					c2 = new mac_econ.model.model3.LMCurve();
	    			break;
	    			default:System.out.print("modelID=2, eqnID error");
	    			break;
	    		}
	    	break;  	
	    	
	    	default:System.out.println("other curves not yet implemented");
	    	break;	
	    }
	    
	    gmGeorge.setCurves(c1, c2);
	    return true;
	}
	
//	public getintArray
}
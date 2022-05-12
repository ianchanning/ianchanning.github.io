
package mac_econ.graph;

import java.awt.*;
import java.applet.*;
import java.util.Vector;
import java.lang.*;
import mac_econ.validation.*;
import mac_econ.model.*;
import mac_econ.applet.*;
import mac_econ.model.model3.*;
import mac_econ.estimation.*;

public class GraphManager{
    /*  -- graphAndAxes will probably get renamed Axes which will only 
        -- focus on drawing the axes and any labels, values with them.
        -- Curves cCurve1 and cCurve2 are the straight line graphs which hold 
        -- their values in the respective model package. 
    */
	protected Graph graphAndAxes;
	public Curve 	cCurve1;
	public Curve    cCurve2;
	protected float   fStartX = 0f;
	protected float   fEndX = 1000f;
	protected boolean curvesSet;
	protected boolean forecastSet;
	public String	  sCurve1Name = " ";
	public String	  sCurve2Name = " ";
	public String	  sXAxisLabel;
	public String	  sYAxisLabel;
	Vector		  vYModel;
	
	
   	public GraphManager(){
	    graphAndAxes = new Graph();
	    cCurve1 = new mac_econ.model.model1.YDCurve();
	    cCurve2 = cCurve1;
	    curvesSet = false;
	    forecastSet = false;
	    vYModel = new Vector();
	    sXAxisLabel = "Y";
	    sYAxisLabel = "D";                                   
	}
	 
	/*public GraphManager(String sTitle){
	    graphAndAxes = new Graph(sTitle);
	    cCurve1 = new mac_econ.model.model1.YDCurve();
	    cCurve2 = cCurve1;
	    curvesSet = false;                                    
	    forecastSet = false;
	    //faYActual = Regression.faYVal;
	    //faYModel = Regression.faYVal;                                    
	}*/

	public boolean requestNewGraph(float yCutA, float yCutB, float gradient){
	    ValidationManager vManager = new ValidationManager();
		if (vManager.validate(yCutA, yCutB, gradient)){ return true;}
		else return false;
	}
	
	public boolean setAxisLabels(String sXLabel, String sYLabel){
		sXAxisLabel = sXLabel;	
		sYAxisLabel = sYLabel;
		return true;
	}
			
	public boolean setCurves(Curve newC1){
		cCurve1 = newC1;
		cCurve2 = newC1;
		curvesSet = true;
		return true;
	}
	
	public boolean setCurves(Curve newC1, Curve newC2){
		cCurve1 = newC1;
		cCurve2 = newC2;
		curvesSet = true;
		return true;	
	}
	
	public boolean setRange(float fNewStart, float fNewEnd){
		fStartX = fNewStart;
		fEndX = fNewEnd;
		return true;
	}
	
	public boolean setForecast(float[] faYM){
		vYModel.removeAllElements();
		
		for (int i=0; i<faYM.length; i++){
			Float tempFloat = new Float(faYM[i]);
			vYModel.addElement(tempFloat);
		} 
		System.out.println("gm.setForecast");
		forecastSet = true;
		return true;
	}
	
	
	public boolean graphPaint(Graphics g){
	    	float[] faYPts = new float[2];
	    	float[] faEqmPt = new float[2];
		String	sXLabel, sYLabel;	    
//	    	graphAndAxes.axesPaint(g);
	    	if (curvesSet){
	    		faYPts = cCurve1.getPoints(fStartX, fEndX); // get y values 
	    		Graph gCurve1 = new Graph(fStartX, faYPts[0], fEndX, faYPts[1]);
//	        	addLabel(g, 0, iaPts[0], String.valueOf(iaPts[0]));
	    	
	        	faYPts = cCurve2.getPoints(fStartX, fEndX);
	        	Graph gCurve2 = new Graph(fStartX, faYPts[0], fEndX, faYPts[1]);
            		System.out.println("Virtual fEndY Curve2 "+faYPts[1]+" Virtual fStartY Curve2 "+faYPts[0] );
//	        	addLabel(g, 0, iaPts[0], String.valueOf(iaPts[0]));
	    
	    		faEqmPt = gCurve1.calcEqmPtWith(gCurve2);
	    		Graph gEqmLine = gCurve1.scaleWith(gCurve2);
    	    		gCurve1.axesPaint(g);
    	    		
    	    		g.setColor(Color.red);
    	    		gCurve1.plotGraph(g);
    	    		gCurve1.addYAxisMark(g, -25, sCurve1Name, 5, -5);
    	    		
    	    		g.setColor(Color.blue);
	    		gCurve2.plotGraph(g);
    	    		gCurve2.addYAxisMark(g, -40, sCurve2Name, 5, -5);
    	    		
    	    		g.setColor(Color.black);
    	    		gEqmLine.plotGraph(g);
    	    		gEqmLine.setEnd(gCurve1.getOriginX(), gEqmLine.getStartY());
    	    		gEqmLine.plotGraph(g);
    	    		gEqmLine.addXAxisMark(g, gEqmLine.getStartX());
    	    		gCurve1.addYAxisMark(g, gEqmLine.getStartY()); // eqm Y-point
            		gCurve1.addXAxisMark(g, 400f, String.valueOf(fEndX));
        		gCurve1.addAxisLabels(g, sXAxisLabel, sYAxisLabel);
			if(faEqmPt[0] > fEndX){
				fEndX *=2;
				return false;
			}
			else if(faEqmPt[0] < ((0.5f)*fEndX)){
				fEndX *=(0.5f);
				return false;
			}
			else return true;
		}
		return true;    
	}
	
	public boolean forecastPaint(Graphics g){
		
		Regression myRegression = new Regression();
		float[] temp = myRegression.getArray();
		float[] tempInv = myRegression.getInvArray();
		float[] tempGov = myRegression.getGovArray();
		
		for (int z=0; z<temp.length-1; z++){
		   System.out.println(temp[z]);
		} //end for  

		Graph gLinePlot = new Graph();
		Graph gLinePlot1 = new Graph();
		Graph gLinePlotI = new Graph();
		Graph gLinePlotG = new Graph();
		//faYActual = Regression.faYVal;
		if (forecastSet){
			gLinePlot.addYAxisMark(g, 50, String.valueOf(100f));
			gLinePlot.addYAxisMark(g, 100, String.valueOf(200f));
			gLinePlot.addYAxisMark(g, 150, String.valueOf(300f));
			gLinePlot.addYAxisMark(g, 200, String.valueOf(400f));
			gLinePlot.addYAxisMark(g, 250, String.valueOf(500f));
			gLinePlot.addYAxisMark(g, 300, String.valueOf(600f));
			
			gLinePlot.axesPaint(g);
			gLinePlot.addAxisLabels(g, "Year", "GDP (£ billion)");
			
			for (int i=0; i<vYModel.size()-1; i++){
				g.setColor(Color.red);
				//gLinePlot = new Graph((float)(i*10), (temp[i])/2f, (float)((i+1)*10), (temp[i+1])/2f);
				gLinePlot.setStart((float)(i*10), (temp[i])/2f);
				gLinePlot.setEnd((float)((i+1)*10), (temp[i+1])/2f);
				gLinePlot.plotGraph(g);
				
				g.setColor(Color.blue);
				gLinePlotI.setStart((float)(i*10), (tempInv[i])/2f);
				gLinePlotI.setEnd((float)((i+1)*10), (tempInv[i+1])/2f);
				gLinePlotI.plotGraph(g);
				
				g.setColor(Color.green);
				gLinePlotG.setStart((float)(i*10), (tempGov[i])/2f);
				gLinePlotG.setEnd((float)((i+1)*10), (tempGov[i+1])/2f);
				gLinePlotG.plotGraph(g);
				
				g.setColor(Color.black);
//				gLinePlot1 = new Graph((float)(i*10), (((Float)(vYModel.elementAt(i))).floatValue())/2f, (float)((i+1)*10), (((Float)(vYModel.elementAt(i+1))).floatValue())/2f);
				gLinePlot1.setStart((float)(i*10), (((Float)(vYModel.elementAt(i))).floatValue())/2f);
				gLinePlot1.setEnd((float)((i+1)*10), (((Float)(vYModel.elementAt(i+1))).floatValue())/2f);
				gLinePlot1.plotGraph(g);
				gLinePlot1.addXAxisMark(g, (float)((i+1)*10), " ");
				if (i%10 == 0){gLinePlot1.addXAxisMark(g, (float)((i+1)*10), String.valueOf(1960+i));}
			}
			return true;		
		}

		return false;
	}
	public boolean resetEndX(){
		fEndX = 1000f;
		return true;
	}
		
	
	
	public boolean setCurveValues(Vector vValues, int modelID, int eqnID){// the vector needs to be a vector of floats
	    switch(modelID){
	    	case 1:
	    		switch(eqnID){
	    		
	    			case 1: 
	    				sCurve1Name = "D = Y";
	    				sCurve2Name = "C = C_0 + C_y * Y";
	    				((mac_econ.model.model1.ConsumptionCurve)cCurve2).setValues(vValues);
					sXAxisLabel = "GDP (£ billion)";
					sYAxisLabel = "Demand (£ billion)";
	    			break;
	    			
	    			default:
	    				System.out.print("modelID=1, eqnID error");
	    				break;
	    		}
	    		break;
	    	case 2:
	    		switch(eqnID){
	    		
	    			case 1: 
	    				sCurve1Name = "D = Y";
	    				sCurve2Name = "C = C_0 + C_y * Y";
					sXAxisLabel = "GDP (£ billion)";
					sYAxisLabel = "Demand (£ billion)";
	    				((mac_econ.model.model2.ConsumptionCurve2)cCurve2).setValues(vValues);
	    			break;
	    			
	    			default:
	    				System.out.print("modelID=2, eqnID error");
	    				break;
	    		}
	    		break;
	    	case 3:
	    		switch(eqnID){
	    			case 1:
					sCurve1Name = "IS";
					sCurve2Name = "LM";
					sXAxisLabel = "GDP (£ billion)";
					sYAxisLabel = "Interest Rate (%)";
	    				((mac_econ.model.model3.ISCurve)cCurve1).setValues(vValues);
					((mac_econ.model.model3.LMCurve)cCurve2).setValues(vValues);
					break;
	    			default:
	    				System.out.print("modelID=2, eqnID error");
	    				break;
	    		}
	    		break;  	
	    	default:
	    		System.out.println("other curves not yet implemented");
	    		break;	
	    }
	    return true;
	}	
}


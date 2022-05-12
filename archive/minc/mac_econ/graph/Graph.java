package mac_econ.graph;

import java.util.*;
import java.awt.*;
import java.lang.*;
  
public class Graph{
	
	protected float	    fDrawingOriginX = 80;   // -- actual origin
	protected float	    fDrawingOriginY = 420;
	protected float	    fStartX;	// -- virtual starting point
	protected float	    fStartY;
	protected float	    fEndX;	// -- virtual end point
	protected float	    fEndY;
	public String       sLabel;
	protected float     fXScale = 1;
	protected float     fYScale = 1;
	
	protected float     fOriginX;
	protected float     fOriginY;
	protected float	    fEqmX = 0;
	protected float     fEqmY = 0;
    
    public Graph(){	// -- default values
		this("default", 0, 0, 400, 400, 0, 0);
    }
    
    public Graph(String sLbl){
		this(sLbl, 0, 0, 400, 400, 0, 0);
    }
    
    public Graph(String sLbl, float sX, float sY, float eX, float eY){
		this(sLbl, sX, sY, eX, eY, 0, 0);
	}
    
    public Graph(float sX, float sY, float eX, float eY){
		this("default", sX, sY, eX, eY, 0, 0);
	}
    
    public Graph(String sLbl, float sX, float sY, float eX, float eY, float oX, float oY){
		sLabel = sLbl;
		fOriginX = oX;
		fOriginY = oY;
		fStartX = sX;
		fStartY = sY;
		fEndX = eX;
		fEndY = eY;
	}
    
	public boolean setStart(float newXSt, float newYSt){
		fStartX = newXSt;
		fStartY = newYSt;
		return true;
	}
	
	public float getStartX(){
		return fStartX;
	}
	
	public float getStartY(){
		return fStartY;
	}
	
	public boolean setEnd(float newXLim, float newYLim){
		fEndX = newXLim;
		fEndY = newYLim;
		return true;
	}
	
	public float getEndX(){
		return fEndX;
	}
	
	public float getEndY(){
		return fEndY;
	}
	
	
	public boolean setVirtualOrigin(float newXOri, float newYOri){
		fOriginX = newXOri;
		fOriginY = newYOri;
		return true;
	}
	
	public boolean setDrawingOrigin(float newXOri, float newYOri){
		fDrawingOriginX = newXOri;
		fDrawingOriginY = newYOri;
		return true;
	}
	
	public float getOriginX(){
		return fOriginX;
	}
	
	public float getOriginY(){
		return fOriginY;
	}
	
	public float getXScale(){
		return fXScale;
	}
	
	public float getYScale(){
		return fYScale;
	}
	
	public float getEqmX(){
		return fEqmX;
	}
	
	public float getEqmY(){
		return fEqmY;
	}
	
	public boolean plotGraph(Graphics g){
    
		g.drawLine(rnd(fDrawingOriginX+fStartX), rnd(fDrawingOriginY-fStartY), rnd(fDrawingOriginX+fEndX), rnd(fDrawingOriginY-fEndY));
		System.out.println("EndY "+fEndY+" EndX "+fEndX);
		return true;
	}
	
	public boolean plotGraph(Graphics g, int iColour){
    
		g.drawLine(rnd(fDrawingOriginX+fStartX), rnd(fDrawingOriginY-fStartY), rnd(fDrawingOriginX+fEndX), rnd(fDrawingOriginY-fEndY));
		System.out.println("EndY "+fEndY+" EndX "+fEndX);
		return true;
	}
	
	public boolean plotGraphWithLabel(Graphics g){
    
	    plotGraph(g);
	    g.drawString(sLabel, rnd(fDrawingOriginX)+20, rnd(fDrawingOriginY)+20); 
		return true;
	}
	
	public boolean axesPaint(Graphics g){
		g.drawLine(rnd(fDrawingOriginX), rnd(fDrawingOriginY-fOriginY), rnd(fDrawingOriginX+400f), rnd(fDrawingOriginY-fOriginY)); // -- x-axis
		g.drawLine(rnd(fDrawingOriginX+fOriginX), rnd(fDrawingOriginY), rnd(fDrawingOriginX+fOriginX), rnd(fDrawingOriginY-400f)); // -- y-axis
		return true;
	}
    
    	public boolean addXAxisMark(Graphics g, float fVal){  
		g.drawLine(rnd(fDrawingOriginX+fVal), rnd(fDrawingOriginY-fOriginY), rnd(fDrawingOriginX+fVal), rnd(fDrawingOriginY-fOriginY)+5);
		g.drawString(sLabel, rnd(fDrawingOriginX+fVal)-15, rnd(fDrawingOriginY-fOriginY)+25);
		return true;
	}
	
    	public boolean addXAxisMark(Graphics g, float fVal, String sVal){  
		g.drawLine(rnd(fDrawingOriginX+fVal), rnd(fDrawingOriginY-fOriginY), rnd(fDrawingOriginX+fVal), rnd(fDrawingOriginY-fOriginY)+5);
		g.drawString(sVal, rnd(fDrawingOriginX+fVal)-15, rnd(fDrawingOriginY-fOriginY)+25);
		return true;
	}

    	public boolean addYAxisMark(Graphics g, float fVal){  
		g.drawLine(rnd(fDrawingOriginX), rnd(fDrawingOriginY-fVal), rnd(fDrawingOriginX)-5, rnd(fDrawingOriginY-fVal));
		g.drawString(sLabel, rnd(fDrawingOriginX)-65, rnd(fDrawingOriginY-fVal)+5);
		return true;
	}
	public boolean addYAxisMark(Graphics g, float fVal, String sVal){  
		g.drawLine(rnd(fDrawingOriginX), rnd(fDrawingOriginY-fVal), rnd(fDrawingOriginX)-5, rnd(fDrawingOriginY-fVal));
		g.drawString(sVal, rnd(fDrawingOriginX)-65, rnd(fDrawingOriginY-fVal)+5);
		return true;
	}
	
	public boolean addYAxisMark(Graphics g, float fVal, String sVal, int iXPos, int iYPos){  
		g.drawLine(rnd(fDrawingOriginX), rnd(fDrawingOriginY-fVal), rnd(fDrawingOriginX)-5, rnd(fDrawingOriginY-fVal));
		g.drawString(sVal, rnd(fDrawingOriginX)+iXPos, rnd(fDrawingOriginY-fVal)-iYPos);
		return true;
	}
	
	public boolean addAxisLabels(Graphics g, String sXLabel, String sYLabel){
		g.drawString(sXLabel, rnd(fDrawingOriginX+400f)-100, rnd(fDrawingOriginY-fOriginY)+40);
		g.drawString(sYLabel, rnd(fDrawingOriginX)-50, rnd(fDrawingOriginY-400));
		return true;
	}	
	public float[] calcEqmPtWith(Graph g){ //Will calculate intersection point of 2 equations.
	    
	   	int	iEqmXPoint, iEqmYPoint;
		float	fEqmXPoint, fEqmYPoint, x1, x2, x3, x4, y1, y2, y3, y4;//, fXScale, fYScale;
		x1 = fStartX;
		x2 = fEndX;
		x3 = g.getStartX();
		x4 = g.getEndX();
		y1 = fStartY;
		y2 = fEndY;
		y3 = g.getStartY();
		y4 = g.getEndY();
		System.out.println(x1+" "+x2+" "+x3+" "+x4);
		System.out.println(y1+" "+y2+" "+y3+" "+y4);
//		y = m1*x + c
//		y = m2*x + d 
//		intersect => x = d-c / m1-m2
		float d = y3 - ((y4-y3)*x3/(x4-x3));
		float c = y1 - ((y2-y1)*x1/(x2-x1));
		float m1 = (y2-y1)/(x2-x1);
		float m2 =  (y4-y3)/(x4-x3);
		fEqmXPoint = (d - c) / (m1 - m2);      
		float test1 = d-c;
		float test2 = m1-m2;
		System.out.println("d: "+d+" c: "+c+" m1: "+m1+" m2 "+m2+" d-c:"+test1+" m1-m2:"+test2);
		fEqmYPoint = m1*fEqmXPoint+c;
		System.out.println(" fEqmX: "+fEqmXPoint+" fEqmY: "+fEqmYPoint);
		
		float[] faEqmPt = {fEqmXPoint, fEqmYPoint};
		fEqmX = fEqmXPoint;
		fEqmY = fEqmYPoint;
		return faEqmPt;
		
	}
	
	public Graph scaleWith(Graph g){ //Will calculate intersection point of 2 equations.
	    	
//	    	calcEqmPtWith(g);
		float	x1, x2, x3, x4, y1, y2, y3, y4;
		float	fMaxY, fMinY;
		float	fMaxX, fMinX;
	    	
	    	x1 = fStartX;
		x2 = fEndX;
		x3 = g.getStartX();
		x4 = g.getEndX();
		y1 = fStartY;
		y2 = fEndY;
		y3 = g.getStartY();
		y4 = g.getEndY();
        	
        	fMinY = Math.min(Math.min(y1, y2), Math.min(y3, y4));
		fMaxY = Math.max(Math.max(y1, y2), Math.max(y3, y4));  
		fMinX = Math.min(Math.min(x1, x2), Math.min(x3, x4));
		fMaxX = Math.max(Math.max(x1, x2), Math.max(x3, x4));  
		System.out.println("minY "+fMinY+" maxY "+fMaxY);

		fXScale = 400f / (fMaxX - fMinX);
		fYScale = 400f / (fMaxY - fMinY);

		fStartX = x1*fXScale;
		fStartY = (y1-fMinY)*fYScale;
		fEndX = x2*fXScale;
		fEndY = (y2-fMinY)*fYScale;
		fOriginY = (fOriginY-fMinY)*fYScale;
//		fEqmX = fEqmXPoint;
//		fEqmY = fEqmYPoint;
		sLabel = String.valueOf(fEqmY);
		
		g.setStart(x3*fXScale, (y3-fMinY)*fYScale);
		g.setEnd(x4*fXScale, (y4-fMinY)*fYScale);
		g.setVirtualOrigin(fOriginX, fOriginY);
		
		
		Graph eqmLine = new Graph(String.valueOf(rnd(fEqmX)), fEqmX*fXScale, (fEqmY-fMinY)*fYScale, fEqmX*fXScale, fOriginY, fOriginX, fOriginY);
		return eqmLine;
	}
	
	// having problems with negative numbers 
	
	/*public float[] getActualParams(){
		float[] faActParams = new float[4];
		faActParams[0] = fDrawingOriginX + fStartX;
		faActParams[1] = fDrawingOriginY - fStartY;
		faActParams[2] = fDrawingOriginX + fEndX;
		faActParams[3] = fDrawingOriginY - fEndY;
		
		return faActParams;
	}
	
	public boolean rescaleY(){
		float fMinY, fMaxY;
		fMinY = Math.min(Math.min(y1, y2), Math.min(y3, y4));
		fMaxY = Math.max(Math.max(y1, y2), Math.max(y3, y4));  
		
		fYScale = 400f / (fMaxY - fMinY);
		
		
		return true;
	}*/
	
	/*public void rescale(float fGivenMinY, float fGivenMaxY){ // to be possibly implemented later allows user to select range
		float fMinY = fGivenMinY;
		float fMaxY = fGivenMaxY;
	}*/

	
	public int rnd(float f){
	    return Math.round(f);
	} 
}

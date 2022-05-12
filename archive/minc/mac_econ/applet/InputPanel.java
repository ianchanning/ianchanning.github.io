package mac_econ.applet;

import java.applet.*;
import java.awt.*;
import java.lang.*;
import java.util.Vector;
import mac_econ.graph.*;
import mac_econ.function.*;
import mac_econ.model.*;

public class InputPanel extends Panel implements MacroConstants{
    	int[]       	iaCrv1; 
	boolean[]   	baCrv1; 
	int[]       	iaCrv2; 
	boolean[]   	baCrv2;
	Panel		pDisplay = new Panel();
	Panel		pM1G1 = new Panel();
//	Panel		pM1G2 = new Panel();
	Panel		pM2G1 = new Panel();
//	Panel		pM2G2 = new Panel();
	Panel		pM3G1 = new Panel();
//	Panel		pM3G2 = new Panel();
	Panel		pM4G1 = new Panel();
//	Panel		pM4G2 = new Panel();
	Panel[]		paInputs = {pDisplay, pM1G1, pM2G1, pM3G1, pM4G1};
	Panel		pShowing = paInputs[0];
	CardLayout	cl;
	    
	public InputPanel(){ // don't know if this constructor is needed, or if the super() is needed.
		super();
	}
    	
    	public InputPanel(CardLayout clNew){
    		super(clNew);
    		cl = clNew;
    		paInputs[0].add(new TextArea("Select Equation\nnext line", 3, 15, TextArea.SCROLLBARS_NONE));
    		add("0", paInputs[0]);
    		/*changeInputs(paInputs[0], 0, 1);
//    		add(pM1G1);// -- what is the difference between add & addLayoutComponent ???
    		addLayoutComponent(paInputs[0], "M1G1");
    		changeInputs(paInputs[0], 1, 1);
//    		add(pM2G1);
    		addLayoutComponent(paInputs[0], "M2G1");
    		changeInputs(paInputs[0], 2, 1);
//    		add(pM3G1);
    		addLayoutComponent(paInputs[0], "M3G1");
    		changeInputs(paInputs[3], 3, 1);
//    		add(paInputs[3]);
    		addLayoutComponent(paInputs[3], "M4G1");*/
    		try{
    		for (int i = 1; i < paInputs.length; i++){
    			try{
    			changeInputs(paInputs[i], i, 1); //array index is i+1 due to paInputs[0] being blank panel
    			}catch(Exception e){System.out.println(e+" failed in InputPanel.changeInputs");}	
   			cl.addLayoutComponent(paInputs[i], String.valueOf(i));
    			add(String.valueOf(i),paInputs[i]);
    		}
    		}catch(Exception e){System.out.println(e+" :Input initialise error");}
    	}	
    	/*public void paint(Graphics g){ -- failed attempts to get components to repaint cardlayout being used
	super.paint(g);
	}
    
    	public void update(Graphics g){
    	super.update(g);
    	}*/
    	public boolean changeInputs(Panel pThis, int modelID, int eqnID){    
//    	public boolean changeInputs(int modelID, int eqnID){
		pThis.removeAll();
	    
        	switch(modelID){
		    	case 1:
		    		switch(eqnID){
		    		
		    			case 1: iaCrv1 = Curve.iaM1Crv1;
		    				baCrv1 = Curve.baM1Crv1;
		    				iaCrv2 = Curve.iaM1Crv2;
		    				baCrv2 = Curve.baM1Crv2;
		    			break;
		    				
		    			default:System.out.print("modelID=0, eqnID="+eqnID+" error in changeInputs");
		    				iaCrv1 = Curve.iaM1Crv1;
		    				baCrv1 = Curve.baM1Crv1;
		    				iaCrv2 = Curve.iaM1Crv2;
		    				baCrv2 = Curve.baM1Crv2;
		    			break;
		    		}
		    	break;
		    			
		    	case 2:
		    		switch(eqnID){
		    			case 1:	iaCrv1 = Curve.iaM2Crv1;
		    				baCrv1 = Curve.baM2Crv1;
		    				iaCrv2 = Curve.iaM2Crv2;
		    				baCrv2 = Curve.baM2Crv2;
		    			break;
		    			
		    			default:System.out.print("modelID=0, eqnID="+eqnID+" error in changeInputs");
		    				iaCrv1 = Curve.iaM1Crv1;
		    				baCrv1 = Curve.baM1Crv1;
		    				iaCrv2 = Curve.iaM1Crv2;
		    				baCrv2 = Curve.baM1Crv2;
		    			break;
		    		}
		    	break;
		    		
		    	case 3:
		    		switch(eqnID){
		    			case 1:	iaCrv1 = Curve.iaM3Crv1;
		    				baCrv1 = Curve.baM3Crv1;
	    					iaCrv2 = Curve.iaM3Crv2;
	    					baCrv2 = Curve.baM3Crv2;
	    				break;
	    				    
	    				default:System.out.print("modelID=2, eqnID error in changeInputs");
	    					iaCrv1 = Curve.iaM1Crv1;
	    					baCrv1 = Curve.baM1Crv1;
	    					iaCrv2 = Curve.iaM1Crv2;
	    					baCrv2 = Curve.baM1Crv2;
	    				break;
	    			}
	    		break;
	    			
		    	case 4:
		    		switch(eqnID){
		    			case 1:	iaCrv1 = Curve.iaM4Crv1;
		    				baCrv1 = Curve.baM4Crv1;
	    					iaCrv2 = Curve.iaM4Crv2;
	    					baCrv2 = Curve.baM4Crv2;
	    				break;
	    				    
	    				default:System.out.print("modelID=2, eqnID error in changeInputs");
	    					iaCrv1 = Curve.iaM1Crv1;
	    					baCrv1 = Curve.baM1Crv1;
	    					iaCrv2 = Curve.iaM1Crv2;
	    					baCrv2 = Curve.baM1Crv2;
	    				break;
	    			}
	    		break;
	    			  	
	    		default:
	    			System.out.println("other curves not yet implemented");
	    			iaCrv1 = Curve.iaM1Crv1;
	    			baCrv1 = Curve.baM1Crv1;
	    			iaCrv2 = Curve.iaM1Crv2;
	    			baCrv2 = Curve.baM1Crv2;
	    		break;	
	    	}
	    	pThis.setLayout(new GridLayout(iaCrv1.length+iaCrv2.length-4, 2));
	    
	    	addInputs(pThis, iaCrv1, baCrv1);
	    	addInputs(pThis, iaCrv2, baCrv2);
	    	return true;    
	}
    	public void addInputs(Panel pThis, int[] ia, boolean[] ba){	
//    	public void addInputs(int[] ia, boolean[] ba){
	    	Label lInput;
	    	TextField tfInput;
	    	for(int i = 2; i < ia.length; i++){
	        	/*
	        	lInput.setText(saConstLbls[ia[i]]);
	        	if (!ba[i]){tfInput.setEditable(false);}
	        	else{tfInput.setEditable(true);}
	        	tfInput.setText(String.valueOf(daConstVals[ia[i]]));    //-- note that this commented out section
	        	add(Input);                                             //-- continually overwrites the Label and TextField
	        	add(tfInput);						//-- and just actually adds the last instance of the array
	        	*/                                         
	        	pThis.add(new Label(String.valueOf(saConstLbls[ia[i]])));
            		tfInput = new TextField(String.valueOf(daConstVals[ia[i]]),4);
            		tfInput.setColumns(5);
//           		tfInput.addActionListener(this);
//            		tfInput.setEditable(ba[i]);
//          		if(ba[i]){tfInput.setBackground(Color.gray);}
//         		else {tfInput.setBackground(Color.white);}
            		pThis.add(tfInput);
	        	System.out.println("added inputs "+saConstLbls[ia[i]]);
        	}
    	}
    	public boolean changeShowing(int Graph){
    		pShowing = paInputs[Graph];
    		return true;
    	}
    	
    	public Vector getInputs(){
    		if (pShowing == pM2G1){System.out.println("inputPanel.pShowing is pM1G1");} 
    		Component[] CaResult = pShowing.getComponents();
//  	  	float[] faResult = new float[CaResult.length]; 
    		Vector vResult = new Vector();
    		for (int i = 1; i < CaResult.length; i+=2){
    		    try{
    			TextField tfResult = (TextField)(CaResult[i]);
    			Float FResult = new Float(tfResult.getText());
    			vResult.addElement(FResult);
    			}catch(ClassCastException e){System.out.println(e + " ip.getInputs() failed");}
//  	  		faResult[i] = FResult.floatValue();
		}
		return vResult;
    	}
    	
    	/*public void actionPerformed(ActionEvent ae){
//		-- test for just pressing return in input boxes    			
	}*/
}	

/* -- failed earlier idea
	Vector output format
	1 - String[] saEqns
	2 - number of vars in longest equation 
	3 - no of vars in equation 1
	4 - label of e1var1
	5 - input box of e1var1
	6 - label of e1var2
	...
	i - length of equation 2
	i+1 - label of e2var1
	i+2 - input box of e2var1
	...
	n - ending object??? -- probably not needed. 
	*/
	/* -- the following demonstrates the ability to add actionlisteners to vector elements
	Vector vInputBoxes = new Vector();
	vInputBoxes.addElement(inputA);
	vInputBoxes.addElement(inputB);
	vInputBoxes.addElement(inputC);
	
	for(int i = 0; i < vInputBoxes.size(); i++){
		((TextField)vInputBoxes.elementAt(i)).addActionListener(this);
	}*/
	    /*int presentIndex = 0;
//	    Vector vInputs = new Vector();
//      vInputs = mmMike.select(modelID-1, equationID-1);
//	    vInputs = gManager.requestGraph(modelID-1, equationID-1);
	    
	    Panel pInputBox = new Panel(new GridLayout());
    	GridLayout glInputgrid = new GridLayout();
	    glInputgrid.setRows(saEqnsUsed.length);
//	    pInputBox.GridLayout.setRows(saEqnsUsed.length);
	    int maxNoOfVars =  ((Integer)vInputs.elementAt(presentIndex)).intValue();// second element = length of longest eqn
	    glInputgrid.setColumns(2 * maxNoOfVars);
	    pInputBox.setLayout(glInputgrid);
	    presentIndex++;// now points to length of first eqn
	    while (presentIndex < (2 * maxNoOfVars) + 2){
	        int thisEqnLength = ((Integer)vInputs.elementAt(presentIndex)).intValue();
	        for (int i = presentIndex+1; i < presentIndex + 2*thisEqnLength; i+=2){
    		    pInputBox.add((Label)vInputs.elementAt(i));
	    	    pInputBox.add((TextField)vInputs.elementAt(i+1));
	        }
	        presentIndex += thisEqnLength;
	    }*/
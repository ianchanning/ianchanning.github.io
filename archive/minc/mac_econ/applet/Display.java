package mac_econ.applet;

import java.util.Vector; // if you take all util classes gets ambiguous result for List (there is an interface util.List)
import java.applet.*;
import java.awt.*;
import java.lang.*;
import java.awt.event.*;
import mac_econ.graph.*;
import mac_econ.model.*;
import mac_econ.estimation.*;
  
public class Display extends Applet implements ActionListener, ItemListener{

  int		        width;
  int		        height;
  int		        leftMargin;
  int		        topMargin;
  Vector	        vInputValues;
  String		sReturnVal;
  boolean           	bWithForecasting;
  float[] 		faY_Fcast;
	
//-- for GUI --
  public GraphManager   gmGeorge;
  public ModelManager   mmMike;
  CardLayout		cl;
  CardLayout		cl2;
  Panel		        pInput;
  Panel		        pGraph;
  Panel		      	pSelector;
  Panel			pEquations;
  Panel			pForecasting;
  Panel			pGraphs;
  ForecastPanel		fpDisplay;
  GraphPanel            gpDisplay;
  InputPanel            ipInputBoxes;
  TextField             tfInputA; // 
  TextField 	        tfInputB; // 
  TextField 	        tfInputC; // 
  TextField 	        tfInputD; // Debugging Window
  TextArea		taEqnExpl;
  Label                 lInputsTitle;
  Label			lStartAdvice;
  Label			lFrom, lTo, lForecast;
  Checkbox		cbIncludeQ; 
  Choice	        cModelSelector;
  Choice	        cEquationSelector;
  List		        lstEquations;
  Button 		btnPlot;
  Button		btnForecast;
  
  /*public void start() {
  }

  public void stop() {
  }
  */
  public void run() {
    resize( leftMargin + width + leftMargin, topMargin + height + topMargin);
  }


  public void init() {
  	
  	width 			= 900;
  	height 			= 700;
  	leftMargin 		= 1;
  	topMargin 		= 1;
  	vInputValues 		= new Vector();
  	bWithForecasting 	= false; 
	Regression tempRes 	= new Regression();
	faY_Fcast = tempRes.getArray();

// 	-- for GUI --
	gmGeorge 		= new GraphManager();
	mmMike 			= new ModelManager();
  	cl 			= new CardLayout();
  	cl2			= new CardLayout();
  	pInput 			= new Panel(new BorderLayout());
  	pGraph 			= new Panel();
  	pSelector 		= new Panel();
  	pEquations 		= new Panel(new BorderLayout());
  	pForecasting		= new Panel();
  	pGraphs			= new Panel(cl2);
  	fpDisplay		= new ForecastPanel(gmGeorge);
  	gpDisplay 		= new GraphPanel(gmGeorge);
  	ipInputBoxes 		= new InputPanel(cl);
  	tfInputA 		= new TextField(4); // 
  	tfInputB 		= new TextField(4); // 
  	tfInputC 		= new TextField(4); // 
  	tfInputD 		= new TextField(10); // Debugging Window
  	taEqnExpl		= new TextArea("Simultaneous Equations\nused in model", 2, 20, TextArea.SCROLLBARS_NONE);
  	lInputsTitle 		= new Label("Input Area");
  	lStartAdvice 		= new Label("Select Model First");
  	lFrom			= new Label("Estimation Years --  From", Label.RIGHT);
  	lTo			= new Label(" To", Label.RIGHT);
  	lForecast		= new Label("Forecast Horizon", Label.RIGHT);
  	cbIncludeQ		= new Checkbox("Include Forecasting", false);
  	
  	cModelSelector 		= new Choice();
  	cEquationSelector 	= new Choice();
  	lstEquations 		= new List(15, false);
 	btnPlot 		= new Button("Plot Graph");
 	btnForecast		= new Button("Model/Forecast");
	
 	/*  -- for some reason the browsers will not resize applet at init(), nor are the choice boxes resized after repaint();
	    -- need to investigate 
	    -- placing the resize method in the run method appears to work... nope - need to do it in javascript
	*/
	setLayout(new BorderLayout());
	
	btnPlot.addActionListener(this);
	btnForecast.addActionListener(this);
	
	
	cModelSelector.add("Select Model");
	cModelSelector.add("Model1");
	cModelSelector.add("Model2");
	cModelSelector.add("Model3");
//	cModelSelector.add("Model4");
	cModelSelector.addItemListener(this);
	
	cEquationSelector.add("Graph Selector");
	cEquationSelector.addItemListener(this);
	
	lstEquations.add("Eqns List");
	
	pSelector.setLayout(new FlowLayout());
	pSelector.add(lStartAdvice);	
	pSelector.add(cModelSelector);
	pSelector.add(cEquationSelector);
//	pSelector.add(lstEquations);
//	pSelector.add(AssmptnChkBox); -- maybe there should be an explanation rather than assumptions
	
//	pInput.add("North", lInputsTitle);
    	tfInputD.setText("Inputs");
    	pInput.add("North", tfInputD);
	pInput.add("South", btnPlot);
	pInput.add("Center", ipInputBoxes);
	
	pEquations.add("North", taEqnExpl);
	pEquations.add("Center", lstEquations);
	
	tfInputA.setText("1960");
	tfInputB.setText("1970");
	tfInputC.setText("1980");
	
	pForecasting.add(btnForecast);
	pForecasting.add(cbIncludeQ);
	pForecasting.add(lFrom);
	pForecasting.add(tfInputA);
	pForecasting.add(lTo);
	pForecasting.add(tfInputB);
	pForecasting.add(lForecast);
	pForecasting.add(tfInputC);
	
	pGraphs.add("1", gpDisplay);
	pGraphs.add("2", fpDisplay);
		
    	add("West", pInput);
    	add("Center", pGraphs);
    	add("North", pSelector);
    	add("East", pEquations);
	add("South", pForecasting);
	 
  }// -- end of init()

//To get the data out of the text field, check for an event.
//-- The following is for when the 'Plot Graph' button is clicked
  public void actionPerformed(ActionEvent act){
    
    int modelID = cModelSelector.getSelectedIndex();
	int equationID = cEquationSelector.getSelectedIndex();
	float[] faFcastResult = new float[3];
	float C_0 = 1f;
    float C_y = 1f;
    float fYFcast = 1f;
    Button btnPressed = (Button)(act.getSource());
    
    
    //showStatus("start of Display.actionPerformed");
	if (cbIncludeQ.getState()){
		if (modelID==1 || modelID ==2){
			//showStatus("here ---->5");
			try{
			faFcastResult = forecast(modelID);
			}catch(Exception e){System.out.println(e+"- forecast failed in actionPerformed");
					showStatus("Forecast input value error");}
			tfInputD.setText("Y Forecast = "+String.valueOf(faFcastResult[0]));
		}	
	}
	if(btnPressed.getLabel()=="Model/Forecast"){
    	cl2.next(pGraphs);
    	}
    
	sReturnVal = "false"; //output if plotGraph has been performed
	Vector vNewVals = new Vector();
    	try{
	    	vNewVals = ipInputBoxes.getInputs();
	}catch (Exception e){System.out.println(e+" Number exception in 'actionPerformed()'");} 
//	if(gmGeorge.requestNewGraph(investment, autConsumption, gradient)){ //-- will add back in after all is working
	
		/*vInputValues.addElement(Finvestment);
		vInputValues.addElement(FautConsumption);
		vInputValues.addElement(Fgradient);
        }*/
        try{
        sReturnVal = String.valueOf(gmGeorge.setCurveValues(vNewVals, modelID, equationID));
        }catch (Exception e){System.out.println(e + " failed to setCurveValues in 'actionPerformed()'");
                            showStatus(e + "setCurveValues failed");
        }
		gpDisplay.repaint();
		fpDisplay.repaint();
		//fpDisplay.repaint();
		//showStatus("here --->8");
		vNewVals.removeAllElements();
  }// -- end of actionPerformed
  
//-- The following allows selection of model and displays available equations
  public void itemStateChanged(ItemEvent Itm){
	
	int modelID = cModelSelector.getSelectedIndex();
	int equationID = cEquationSelector.getSelectedIndex();
	Vector vInputs = new Vector();
	tfInputD.setText(((Choice)Itm.getItemSelectable()).getItem(0)); //-- debugging --	
	
	if (modelID == 0){
	    cEquationSelector.removeAll();
	    cEquationSelector.add("Equation Selector");
	    pSelector.repaint();
	}
	else if ((Choice)Itm.getItemSelectable() == cEquationSelector && redrawEqnList(modelID, equationID) && equationID != 0){
	    tfInputD.setText("modelID="+modelID+", eqnID = "+String.valueOf(equationID));
	    if(mmMike.select(modelID, equationID, gmGeorge)){
//	    pInput.remove(ipInputBoxes);
//	    ipInputBoxes.changeInputs(modelID, equationID);
//	    pInput.add("Center", ipInputBoxes);
	    ipInputBoxes.changeShowing(modelID);
	    cl.show(ipInputBoxes, String.valueOf(modelID));
	    pInput.repaint();
//	    gpDisplay.repaint();
	    }
	}
	else {
	    tfInputD.setText("Selecting Model in Display.ItemStateChanged");
	    try{
	        if(redrawEqnSelector(modelID) && redrawEqnList(modelID, equationID)){
	            tfInputD.setText("modelID = "+String.valueOf(modelID)+", eqnID = "+String.valueOf(equationID));
	            pSelector.repaint();
	        }
	    }catch(Exception e){System.out.println(e + "failed to redraw equations, modelID="+modelID);}
	}
  }

	
  public boolean redrawEqnSelector(int modelID){
        
    cEquationSelector.removeAll(); // -- clear equations choice
    Vector vEqn = new Vector();
    try{
        vEqn = mmMike.select(modelID);
        cEquationSelector.add("Select Graph"); // -- use this so that the user is forced to select a graph
	    for (int i = 0; i < vEqn.size(); i++){
	    	cEquationSelector.add((String)vEqn.elementAt(i));
	    }
	}catch (Exception e){System.out.println(e + "- mmMike could not select the equation vector with modelID="+modelID);}
    return true;
  }
  
  public boolean redrawEqnList(int modelID, int equationID){
	
	lstEquations.removeAll();
	if (equationID == 0){
		lstEquations.add("EqnList");
	}
    else{
    	try{
		String[] saEqnsUsed = mmMike.select(modelID, equationID);//modelIDs start from 1, array indexes start from 0
        	for (int i = 0; i < saEqnsUsed.length; i++){
		    lstEquations.add(saEqnsUsed[i]);
	    	}
	}catch (Exception e){System.out.println(e + " mmMike could not select String[]");}
    }
    return true;
  }
  
  public float[] forecast(int model){
  	Integer IMyA = new Integer(tfInputA.getText());
	Integer IMyB = new Integer(tfInputB.getText());
	Integer IMyC = new Integer(tfInputC.getText());
	float fY_Fcast = 0f;
	float C_0 = 0f;
	float C_y = 0f;
	showStatus(" ");	
	Regression TSLSEstimation = new Regression(IMyA.intValue()-1960, IMyB.intValue()-1960);
	try{
	    	
		switch(model){
			case 1:
				float[] faEst1 = TSLSEstimation.twoSLS();
				fY_Fcast = TSLSEstimation.forecast(faEst1[0], faEst1[1], IMyC.intValue()-1960);
				float[] CCoeffs = TSLSEstimation.calcCoeffs(faEst1[0], faEst1[1]);
	    			C_0 = CCoeffs[0];
	    			C_y = CCoeffs[1];
   			    	tfInputD.setText("C_0="+CCoeffs[0]+", C_y="+CCoeffs[1]);
   			    	tfInputD.setText("Y Forecast = "+String.valueOf(fY_Fcast));
				for (int i = IMyA.intValue()-1960; i<40;i++){
					float fYFcast1 = TSLSEstimation.forecast(faEst1[0], faEst1[1], i);
					//System.out.println(model+" "+i+" "+fYFcast1);
					//System.out.println("1 "+fYFcast1);
					faY_Fcast[i]=fYFcast1;
				}
				gmGeorge.setForecast(faY_Fcast);

			break;
			case 2:
				float[] faEst2 =  TSLSEstimation.biVariateTwoSLS();
				
				fY_Fcast = TSLSEstimation.forecast(faEst2[0], faEst2[1], faEst2[2], IMyC.intValue()-1960);
			    	tfInputD.setText("Y Forecast = "+String.valueOf(fY_Fcast));
				for (int i = IMyA.intValue()-1960; i<40;i++){
					float fYFcast2 = TSLSEstimation.forecast(faEst2[0], faEst2[1], faEst2[2], i);   
					//System.out.println(fYFcast2);
					faY_Fcast[i]=fYFcast2;
					//System.out.println("2 "+fYFcast1);
				}
				gmGeorge.setForecast(faY_Fcast);
			break;
			default:
			showStatus(String.valueOf(model)+" - default switch case in Display.forecast");
			break;
		}   

/*		for (int i = 0; i<39;i++){
			float fYFCast = TSLSEstimation.forecast(faEst[0], faEst[1], IMyA.intValue()-1960);   
			System.out.println(i+" "+fYFCast);
			tfInputD.setText("Y Forecast = "+String.valueOf(fYFCast));
	    }*/

	}catch (Exception e){showStatus("Least Squares error, check input values");}
    	
    float[] faResult = {fY_Fcast, C_0, C_y};
    return faResult;
  }
}

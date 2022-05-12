package mac_econ.model.model1;

import java.util.*;
import mac_econ.function.*;
import mac_econ.model.*;

public class ConsumptionCurve extends Curve implements MacroConstants{

    public String sName = "Consumption";
    public float[] vars = new float[iaM1Crv2.length-2];

    public ConsumptionCurve(){
    	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM1Crv2[i]];
	}
    }

    public float computeYCut(){
	// I + C_0 + eC
	return vars[0] + vars[1] + vars[3];//--ignoring error term for now 
    }
    
    public float computeYCut(float i){
	vars[0] = i; 
	return computeYCut();
    }
    
    public  float computeGradient(){
        // C_y
        return vars[2];
    }
    
    public boolean reset(){
    	for(int i = 2; i < iaM1Crv2.length; i++){
		vars[i-2] = daConstVals[iaM1Crv2[i]];
	}
	return true; 
    }	
    
    public boolean setValues(Vector vNewValues){
        try{
            for (int i = 0; i < vNewValues.size(); i++){
                vars[i] = ((Float)(vNewValues.elementAt(i))).floatValue();    
            }
        }catch (Exception e){System.out.println(e+" mac_econ.model.model1.failed to set ConsumptionCurve values");} 
        return true;
    }
}

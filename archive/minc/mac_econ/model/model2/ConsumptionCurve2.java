package mac_econ.model.model2;

import java.util.*;
import mac_econ.function.*;
import mac_econ.model.*;

public class ConsumptionCurve2 extends Curve implements MacroConstants{

    public String sName = "Consumption";
    public float[] vars = new float[iaM2Crv2.length-2];

    public ConsumptionCurve2(){
    	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM2Crv2[i]];
	}
    }

    public float computeYCut(){
	// I + G + C_0 + C_y*TR - C_y*t_0 + C_y*(1 - t_y)*Y + eC
	return vars[0] + vars[1] + vars[2] + vars[3]*vars[4] - vars[3]*vars[5] + vars[7];//--ignoring error term for now 
    }
    
    public float computeYCut(float i){
	vars[0] = i; 
	return computeYCut();
    }
    
    public  float computeGradient(){
        // C_y(1 - t_y) 
        return vars[3]*(1 - vars[6]);
    }
    
    public boolean reset(){
    	for(int i = 2; i < iaM2Crv2.length; i++){
		vars[i-2] = daConstVals[iaM1Crv2[i]];
	}
	return true; 
    }	
    
    public boolean setValues(Vector vNewValues){
        try{
            for (int i = 0; i < vNewValues.size(); i++){
                vars[i] = ((Float)(vNewValues.elementAt(i))).floatValue();    
            }
        }catch (Exception e){System.out.println(e+" mac_econ.model.model2.failed to set ConsumptionCurve values");} 
        return true;
    }
}

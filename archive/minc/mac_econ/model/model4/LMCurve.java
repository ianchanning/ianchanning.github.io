package mac_econ.model.model4;

import java.util.*;
import mac_econ.function.*;
import mac_econ.model.*;

public class LMCurve extends Curve implements MacroConstants{
    
    public String sName = "LM";
    public float[] vars = new float[iaM4Crv2.length-2];
    public LMCurve(){
	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM4Crv2[i]];
	} 
    }
    
    public float computeYCut(){
	// 1/M_r * m - eM
	return (1/vars[0]) * vars[1] - vars[3]; 
    }
    
    public float computeYCut(float mNew){
	vars[1] = mNew; 
	return computeYCut();
    }
    
    public  float computeGradient(){
        // -M_y/M_r
        float fLMGrad = -(vars[2]/vars[0]);
        System.out.println("LMGrad "+fLMGrad);
        return fLMGrad;
    }
    
    public boolean reset(){
    	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM3Crv2[i]];
	}
	return true; 
    }
    
    public boolean setValues(Vector vNewValues){
        try{
            for (int i = 0; i < vars.length; i++){
                vars[i] = ((Float)vNewValues.elementAt(iaM3Crv1.length-2+i)).floatValue();
                System.out.println("LMNewValues"+i+"="+vars[i]);    
            }
        }catch (Exception e){System.out.println(e+" failed to set LMCurve values");} 
        return true;
    }
   /*public String[] equations(){
        return 0;
    }*/

}

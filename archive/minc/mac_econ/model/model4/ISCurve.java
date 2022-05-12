package mac_econ.model.model4;

import java.util.Vector;
import mac_econ.function.*;
import mac_econ.model.*;

public class ISCurve extends Curve implements MacroConstants{
	
    public String  sName = "IS";
    public float[] vars = new float[iaM4Crv1.length-2];
    public ISCurve(){
	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM4Crv1[i]];
	} 
    }

    public float computeYCut(){
	//-1/I_R(0)*(C_0(1) + I_0(2) + G(3) - C_y(4) * t_0(5) + C_y(4) * TR(6)-eC(8)-eI(9))
	
	float fYCut = (-1/vars[0]) * (vars[1]+vars[2]+(vars[3]-(vars[4]*vars[5]))+(vars[4]*vars[6]))-vars[8]-vars[9]; 
    return fYCut;
    }
	
    public float computeYCut(float g, float t0, float tr){
	vars[3] = g;
	vars[5] = t0;
	vars[6] = tr;	
	return computeYCut();
    }
    
    public boolean reset(){
    	for(int i = 2; i < vars.length+2; i++){
		vars[i-2] = daConstVals[iaM3Crv1[i]];
	} 
    	return true;	
    }
    
    public float computeGradient(){
        //1/I_r(0)*(1-C_y(4)(1-t_y(7)))
        float fGrad = (1/vars[0])*(1-vars[4]*(1-vars[7]));
    	System.out.println("ISGrad"+fGrad);
    	return fGrad;
    }
    
    public float computeGradient(float ty){
    	vars[7] = ty;
    	return computeGradient();	
    }
    
    public boolean setValues(Vector vNewValues){
        try{
            for (int i = 0; i < vars.length; i++){
                vars[i] = ((Float)vNewValues.elementAt(i)).floatValue();    
            }
        }catch (Exception e){System.out.println(e+" failed to set ISCurve values");} 
        return true;
    }
    /*public String[] equations(){
        return {"a"};
    }*/

}

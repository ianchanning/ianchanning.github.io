package mac_econ.model.model1;

import java.util.*;
import mac_econ.function.*;
import mac_econ.model.*;

public class YDCurve extends Curve implements MacroConstants{

	
    public YDCurve(){
	
    }
	
    public float computeYCut(){
	return 0; 
    }
    
    public float computeGradient(){
        return 1;
    }
    
    public boolean reset(){
    	return true;
    }
    /*public String[] equations(){
        return 0;
    }*/
}

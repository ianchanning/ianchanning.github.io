package mac_econ.validation;

import java.awt.*;
import java.applet.*;
//import mac_econ.graph.*;

public class ValidationManager{
	
	float zeroIncomeDemand = 1;
	float cY = 2;
	
	public ValidationManager(){
	}
	
	public boolean validate(float yCutA, float yCutB, float gradient){ 
		Limits gphLimits = new Limits();
		if (((yCutA+yCutB) <= gphLimits.getLimit(zeroIncomeDemand)) && (gradient < gphLimits.getLimit(cY))){return true;}
		else return false;
	}
}


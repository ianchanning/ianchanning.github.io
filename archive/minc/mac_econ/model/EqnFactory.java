package mac_econ.model;

import java.util.*;
import mac_econ.function.*;

public class EqnFactory{
	
//	String sTest = "D = C + I";
	/*
	-- format of equations taken to be -- 
	-- endogenous = var1 + var2 + ... + varN + varN+1 * endogenous -- ok for model 1
	-- we want to extract vars
	*/	
	public EqnFactory(){
	}
	
	public Vector dismantle(String sEqn){
		int lastIndex = 0;
		int vars = 0;
		Vector vVars = new Vector();
		String sVar;
		
		sVar = sEqn.substring(lastIndex, sEqn.indexOf("=")).trim(); //might want to include endogenous vars soon
		lastIndex = sEqn.indexOf("=");
		while (lastIndex < sEqn.lastIndexOf("+")){
			sVar = sEqn.substring(lastIndex, sEqn.indexOf("+", lastIndex)).trim();
			lastIndex = sEqn.indexOf("+", lastIndex);
			vars++;
			vVars.addElement(sVar);
		} 
		String sGradient = (sEqn.substring(lastIndex, sEqn.indexOf("*"))).trim();
		vVars.addElement(sGradient);
		return vVars;
	}


}

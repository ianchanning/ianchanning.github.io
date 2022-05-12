package mac_econ.function;

import java.lang.*;
import java.util.*;

public interface Equations{
	
	/* -- Please note Delta/delta to differentiate between 
	capital/lower case greek letters
	x. = dx/dt - might use this notation
	*/  

	public static final String	sM1equ1  = new String("D = C + I");
	public static final String	sM1equ2  = new String("C = C_0 + C_y * Y");
	public static final String	sM1equ3  = new String("Y = D");
//	public static final String	sM1equ4  = new String("dY/dt = alpha*(Y - D)");
	
	
	public static final String	sM2equ1  = new String("D = C + I + G"); 
	public static final String	sM2equ2  = new String("C = C_0 + C_y * YD"); 
	public static final String	sM2equ3  = new String("YD = Y + TR - T"); 
	public static final String	sM2equ4  = new String("T = t_0 + t_y * Y"); 
	public static final String	sM2equ5  = new String("psbr = G + TR - T"); 
	public static final String	sM2equ6  = new String("Y = D"); 
	public static final String	sM2equ7  = new String("dY/dt = alpha*(D - Y)");
	
	public static final String	sM3equ1  = new String("D = C + I + G"); 
	public static final String	sM3equ2  = new String("C = C_0 + C_y * YD"); 
	public static final String	sM3equ3  = new String("I = I_0 + I_r * r"); 
	public static final String	sM3equ4  = new String("Y = D"); 
	public static final String	sM3equ5  = new String("YD = Y + TR - T"); 
	public static final String	sM3equ6  = new String("T = t_0 + t_y * Y"); 
	public static final String	sM3equ7  = new String("psbr = G + TR - T"); 
	public static final String	sM3equ8  = new String("m_d = M_y * Y + M_r * r"); 
	public static final String	sM3equ9  = new String("m_d = m"); 
	public static final String	sM3equ10 = new String("dY/dt = alpha_1*(D - Y)");
	public static final String	sM3equ11 = new String("dY/dt = alpha_2*(m_d - m)");
	
	public static final String	sM4equ1  = new String("D = C + I + G"); 
	public static final String	sM4equ2  = new String("C = C_0 + C_y * YD + C_v * v_-1"); 
	public static final String	sM4equ3  = new String("I = I_0 + I_r * r"); 
	public static final String	sM4equ4  = new String("Y = D"); 
	public static final String	sM4equ5  = new String("YD = Y + TR - T"); 
	public static final String	sM4equ6  = new String("T = t_0 + t_y * Y"); 
	public static final String	sM4equ7  = new String("psbr = G + TR - T"); 
	public static final String	sM4equ8  = new String("m_d = M_y * Y + M_r * r + M_v * v_-1"); 
	public static final String	sM4equ9  = new String("m_d = m"); 
	public static final String	sM4equ10 = new String("v = m + b");
	public static final String	sM4equ11 = new String("Delta_b + Delta_m = psbr");
	 
	public static final String	sM6equ1  = new String("D = C + I + G"); 
	public static final String	sM6equ2  = new String("C = C_y * YD + C_v * (V / P)"); 
	public static final String	sM6equ5  = new String("YD = (1 - t) * Y - p_e * (m + b)"); 
	public static final String	sM6equ3  = new String("I = I_y * Y + I_r * (r - p_e)"); 
	public static final String	sM6equ4  = new String("D = Y"); 
	public static final String	sM6equ6  = new String("m = M / P = M_y * Y + M_r * r + M_v * (m + b)"); 
	public static final String	sM6equ7  = new String("V = M + B"); 
	public static final String	sM6equ8  = new String("p = beta * w + (1 - beta) * pm"); 
	public static final String	sM6equ9  = new String("u = uu + u_y * (Y - YY)"); 
	public static final String	sM6equ10 = new String("dm/dt + db/dt = G - t_y * Y - p * (m + b)");
	public static final String	sM6equ11 = new String("dp_e/dt = gamma * (p - p_e)");
	

	public static final String[]   	saModel1 = {sM1equ1, sM1equ2, sM1equ3/*, sM1equ4*/};
	public static final String[]   	saModel2 = {sM2equ1, sM2equ2, sM2equ3, sM2equ4, sM2equ5, sM2equ6, sM2equ7};
	public static final String[]   	saModel3 = {sM3equ1, sM3equ2, sM3equ3, sM3equ4, sM3equ5, sM3equ6, sM3equ7, sM3equ8, sM3equ9, sM3equ10, sM3equ11};
	public static final String[]   	saModel4 = {sM4equ1, sM4equ2, sM4equ3, sM4equ4, sM4equ5, sM4equ6, sM4equ7, sM4equ8, sM4equ9, sM4equ10, sM4equ11};
	public static final String[]   	saModel6 = {sM6equ1, sM6equ2, sM6equ3, sM6equ4, sM6equ5, sM6equ6, sM6equ7, sM6equ8, sM6equ9, sM6equ10, sM6equ11};
	
	public static final String[][] 	saaModels = {saModel1, saModel2, saModel3, saModel4, saModel6};
	
	/*public static final String	sM1G1    = new String();
	public static final String	sM2G1    = sM1G1;
	public static final String	sM3G1    = new String("IS-LM");
	public static final String	sM3G2    = new String();
	public static final String	sM4G1    = sM3G1;
	public static final String	sM4G2    = sM3G2;
	public static final String	sM6G1    = sM3G1;
	public static final String	sM6G2    = new String();
	public static final String	sM6G3    = new String("LP");
	public static final String	sM6G4    = new String("LP-BS");
	public static final String	sM6G5    = new String("SP-BS");
	*/

	public static final String[]      saM1G1 = {"Supply-Demand", sM1equ1, sM1equ2, sM1equ3};
	public static final String[]      saM2G1 = {"Supply-Demand", sM2equ1, sM2equ2, sM2equ3, sM2equ4};
	public static final String[]      saM3G1 = {"IS-LM", sM3equ1, sM3equ2, sM3equ3, sM3equ4, sM3equ5, sM3equ6, sM3equ8, sM3equ9};
	public static final String[]      saM3G2 = {"PSBR", sM3equ6, sM3equ7};
	public static final String[]      saM4G1 = {"IS-LM", sM4equ1, sM4equ2, sM4equ3, sM4equ4, sM4equ5, sM4equ6, sM4equ8, sM4equ9};
	public static final String[]      saM4G2 = {"PSBR", sM4equ6, sM4equ7};
	public static final String[]      saM6G1 = {"IS-LM", sM6equ1, sM6equ2, sM6equ3, sM6equ4, sM6equ5, sM6equ6, sM6equ8, sM6equ9};
	public static final String[]      saM6G2 = {"SP", sM6equ6, sM6equ7};
	public static final String[]      saM6G3 = {"LP", sM6equ1, sM6equ2, sM6equ3, sM6equ4, sM6equ5, sM6equ6, sM6equ8, sM6equ9};
	public static final String[]      saM6G4 = {"LP-BS", sM6equ6, sM6equ7};
	public static final String[]      saM6G5 = {"SP-BS", sM6equ1, sM6equ2, sM6equ3, sM6equ4, sM6equ5, sM6equ6, sM6equ8, sM6equ9};
	
	public static final String[][]    saaM1Graphs = {saM1G1};
	public static final String[][]    saaM2Graphs = {saM2G1};
	public static final String[][]    saaM3Graphs = {saM3G1};
	public static final String[][]    saaM4Graphs = {saM4G1};
	public static final String[][]    saaM6Graphs = {saM6G1, saM6G2, saM6G3, saM6G4, saM6G5};
	
   	public static final String[][][]  saaaGraphs = {saaM1Graphs, saaM2Graphs, saaM3Graphs, saaM4Graphs, saaM6Graphs};
   	
	/*public Equations(){
	}

	public Vector getEquations(int modelNumber){
		
		Vector vEquations  = new Vector();
		vEquations.addElement(saaModels[modelNumber]);
		return vEquations;
	}
	
	public Vector getEquations(int model, int graph){
	    Vector vEquations = new Vector();
	    vEquations.addElement(saaaGraphs[model][graph]);
	    return vEquations;
	}*/
}


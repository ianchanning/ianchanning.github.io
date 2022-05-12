package mac_econ.model;

import java.awt.*;
import java.util.Vector;
import mac_econ.function.*;

public  abstract class Curve{
	
	static boolean   		f = false;
    	static boolean   		t = true;
    	public static int[] 		iaM1Crv1 = {1, 2};//D = Y
    	public static boolean[] 	baM1Crv1 = {f, f};
    	public static int[] 		iaM1Crv2 = {1, 2, 8, 4, 5, 36}; //D = I + C_0 + C_y * Y + eC
    	public static boolean[] 	baM1Crv2 = {f, f, t, f, f, t};
    	
    	public static int[] 		iaM2Crv1 = {1, 2};//D = Y
    	public static boolean[] 	baM2Crv1 = {f, f};
    	public static int[] 		iaM2Crv2 = {1, 2, 8, 7, 4, 5, 17, 14, 15, 36}; //D = I + G + C_0 + C_y*TR - C_y*t_0 + C_y*(1 - t_y)*Y + eC
    	public static boolean[] 	baM2Crv2 = {f, f, t, t, f, f, t,  t,  t,  t};
    	
    	public static int[] 		iaM3Crv1 = {1, 11, 10, 4, 9, 7, 5, 14, 17, 15, 36, 37}; //r = -1/I_r*(C_0+I_0+G-C_y*t_0+C_y*TR) + 1/I_r*(1-C_y*(1-t_y))*Y - (eC + eI)
    	public static boolean[] 	baM3Crv1 = {f, f,  f,  f, f, t, f, t,  t,  t,  t,  t};
    	public static int[]		iaM3Crv2 = {1, 11, 19, 21, 18, 38}; //r = 1/M_r*m - M_y/M_r*Y - (eM) -- M_r only stored once
    	public static boolean[] 	baM3Crv2 = {f, f,  f,  t,  f,  t};
// model 4 needs to be worked on    	
    	public static int[] 		iaM4Crv1 = {1, 11, 10, 4, 9, 7, 5, 14, 17, 15, 36, 37}; //-- need to add in C_v, v_-1 r = -1/I_r*(C_0+I_0+G-C_y*t_0+C_y*TR) + 1/I_r*(1-C_y*(1-t_y))*Y -(C_v/I_r)v_-1 - (eC + eI)
    	public static boolean[] 	baM4Crv1 = {f, f,  f,  f, f, t, f, t,  t,  t,  t,  t};
    	public static int[]		iaM4Crv2 = {1, 11, 19, 21, 18, 38}; //-- need to add in M_v r = 1/M_r*m - M_y/M_r*Y - M_v/M_r - (eM) -- M_r only stored once
    	public static boolean[] 	baM4Crv2 = {f, f,  f,  t,  f,  t};

	int model1 = 1;
	int model2 = 2;
	int model3 = 3;
	int model4 = 4;
	public String sName;
	
	
	public Curve(){
	}
	
	public abstract float computeYCut();
	
	//public float computeYCut(float v1){};
	
//	public float computeYCut(float v1, float v2){};
	
//	public float computeYCut(float v1, float v2, float v3){};
	
//	public float resetYCut(){};
	
	public abstract float computeGradient();
	
//	public float computeGradient(float v1){};

//	public float computeGradient(float v1, float v2){};
	
//	public float computeGradient(float v1, float v2, float v3){};
	
//	float resetGradient(){};
	/*public Vector getEquations(int model){
	
	}*/
	public abstract boolean reset();

    	public abstract boolean setValues(Vector vNewValues);

    	public float[] getPoints(float startX, float endX){
//	    int[] iaPoints = new int[2];
	    float[] faPoints = new float[2];
	    faPoints[0] = (this.computeYCut())+(startX)*(this.computeGradient());// should I need to check the float values
	    faPoints[1] = (this.computeYCut())+(endX)*(this.computeGradient());
	    System.out.println("gradient "+this.computeGradient()+"virtualEndY"+faPoints[1]);
//	    iaPoints[0] = Math.round(faPoints[0]); // need an int from Math.round, which requires float input, shouldn't lose any precision
//	    iaPoints[1] = Math.round(faPoints[1]);
	    return faPoints;
	}
	
}

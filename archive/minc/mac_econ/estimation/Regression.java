package mac_econ.estimation;

import java.util.*;
import java.awt.*;
import java.lang.*;
//import ptolmey.math.*
  
public class Regression{
    	int iDateFrom;
    	int iDateTo;
    	public final int[] iaDate = {1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979, 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000};	
//	Investment 1990 prices
    	public final float[] faIVal = {45.55f, 46.27f, 43.47f, 46.07f, 57.22f, 56.61f, 56.17f, 59.33f, 63.92f, 63.42f, 67.69f, 68.03f, 85.95f, 85.55f, 71.88f, 80.16f, 79.87f, 81.56f, 84.71f, 71.09f, 63.07f, 66.29f, 72.17f, 78.04f, 80.28f, 83.05f, 91.63f, 110.99f, 116.53f, 105.78f, 86.56f, 81.65f, 81.72f, 88.39f, 94.09f, 94.1f, 100.87f, 107.34f, 105.26f, 110.88f};	
//	GDP 1990 prices
    	public final float[] faYVal = {244.59f, 252.76f, 255.48f, 265.29f, 280.0f, 287.08f, 292.53f, 299.06f, 311.59f, 318.13f, 347.0f, 354.08f, 366.61f, 391.67f, 386.22f, 385.68f, 394.39f, 403.11f, 417.27f, 428.71f, 421.63f, 416.18f, 422.72f, 437.43f, 448.87f, 464.66f, 484.82f, 506.06f, 531.12f, 542.56f, 544.74f, 533.85f, 531.12f, 542.02f, 565.44f, 581.24f, 593.77f, 614.47f, 628.63f, 635.71f, 650.42f};

//	float[] faCVal = {}
//m1_uk
//"M0, millions of Pounds Sterling" 1990 prices
//			   1969																															    					1998			
	public final float[] faM1Val = {3993.0f, 4206.0f, 4425.0f, 5053.0f, 5593.0f, 6452.0f, 7186.0f, 7988.0f, 9122.0f, 10362.0f, 11620.0f, 12243.0f, 12555.0f, 12948.0f, 13849.0f, 14615.0f, 15161.0f, 15945.0f, 16633.0f, 18040.0f, 19006.0f, 19491.0f, 20085.0f, 20581.0f, 21729.0f, 23322.0f, 24539.0f, 26153.0f, 27797.0f, 29350.0f};

//tax_uk
//billions of Pounds Sterling; 1990 prices
//			   1970																												    					1999			
	public final float[] faTaxVal= {105.49f, 101.98f, 94.59f, 99.48f, 104.28f, 105.29f, 106.88f, 106.82f, 103.48f, 108.89f, 113.0f, 114.45f, 116.67f, 117.67f, 118.05f, 124.07f, 125.08f, 131.58f, 143.4f, 153.54f, 150.89f, 134.53f, 117.38f, 106.24f, 114.78f, 126.13f, 128.25f, 138.87f, 152.13f, 148.76f};

//gov_uk
//billions of Pounds Sterling; 1990 prices
//			    1960																																									2000
	public final float[] faGovVal = {41.21f, 43.06f, 44.51f, 45.81f, 47.04f, 49.11f, 51.13f, 54.9f, 56.08f, 55.54f, 61.76f, 64.92f, 68.62f, 72.86f, 79.16f, 86.41f, 87.43f, 83.55f, 84.73f, 85.87f, 91.18f, 92.53f, 93.68f, 96.89f, 98.42f, 98.23f, 102.29f, 104.45f, 103.39f, 103.45f, 106.06f, 109.14f, 110.45f, 109.15f, 111.25f, 112.1f, 112.66f, 110.55f, 111.69f, 114.47f, 116.45f};

//int_uk
//%
//		          1960	 61	62	63	64	65   66	   67	68    	69	70    71   72	 73	 74																						    1998
	public final float[] faIRVal= {5.77f, 6.28f, 5.9f, 5.43f, 5.98f, 6.56f, 6.94f, 6.8f, 7.55f, 9.04f, 9.22f, 8.9f, 8.9f, 10.71f, 14.77f, 14.39f, 14.43f, 12.72f, 12.47f, 12.99f, 13.78f, 14.74f, 12.88f, 10.8f, 10.69f, 10.62f, 9.87f, 9.47f, 9.36f, 9.58f, 11.08f, 9.92f, 9.12f, 7.87f, 8.05f, 8.25f, 8.1f, 7.09f, 5.45f};
// Bank of E Base Rate data from 1970-00 %{7.25f, 6.5f, 6.0f, 7.9f, 9.2f, 12.1f, 10.8f, 10.8f, 11.6f, 8.9f, 9.0f, 14.0f, 15.0f, 14.2f, 11.8f, 9.9f, 10.0f, 12.5f, 10.9f, 9.4f, 9.5f, 14.0f, 11.9f, 8.4f, 5.6f, 5.6f, 6.5f, 5.9f, 6.7f, 6.9f, 5.4f, 5.9f}

	public Regression(){	// -- default values
		iDateFrom = 0;
		iDateTo = faIVal.length;
	}
    
	public Regression(int iFrom, int iTo){
		iDateFrom = iFrom;
		iDateTo = iTo;
    	}
    
    
 	public float[] getArray() {
		return faYVal;
	}
	
	public float[] getInvArray(){
		return faIVal;
	}
	
	public float[] getGovArray(){
		return faGovVal;
	}
	
	public float forecast(float fPi0, float fPi1, int iFCastDate){
		return fPi0 + fPi1*faIVal[iFCastDate];
	}
	
	public float forecast(float fPi0, float fPi1, float fPi2, int iFCastDate){
		return fPi0 + fPi1*faIVal[iFCastDate] + fPi2*faGovVal[iFCastDate];
	}
	
	
	public float[] calcCoeffs(float fPi0, float fPi1){
		float C_y = (fPi1 - 1f)/fPi1;
		float C_0 =  fPi0/fPi1;
		float[] faCoeffs = {C_0, C_y};
		return faCoeffs;
	} 
	
	public float sum(float[] faInput){
		float fResult = 0f;
		for (int i=0; i<faInput.length; i++){
			fResult += faInput[i];
		}
		return fResult;	
	}
	
	public float sum2(float[] faInput1, float[] faInput2){
		float fSum = 0f;
		for (int i=0; i<faInput1.length; i++){
			fSum += faInput1[i]*faInput2[i];
		}
		return fSum;
	}
	
	public float[] twoSLS(float[] faIndep,  float[] faDep){
	
		float[] faI = new float[iDateTo-iDateFrom];
		float[] faY = new float[iDateTo-iDateFrom];
	 
		for (int i=iDateFrom; i<iDateTo; i++){
			faI[i-iDateFrom] = faIndep[i];
		 	faY[i-iDateFrom] = faDep[i];
		}  	
		float fMeanI = sum(faI)/faI.length;
		float fMeanY = sum(faY)/faY.length;
//		System.out.println("fMeanI = "+fMeanI);
//		System.out.println("fMeanY = "+fMeanY);
		 
		float fNumerator = 0f;
		float fDenominator = 0f;
		 	
		for (int i=0; i<faI.length; i++){
		 	fNumerator = fNumerator+((faI[i]-fMeanI)*(faY[i]-fMeanY));
		 	fDenominator = fDenominator+((faI[i]-fMeanI)*(faI[i]-fMeanI));
		}
	 
		float fPiHat1 = fNumerator/fDenominator;
		float fPiHat0 = fMeanY - fPiHat1*fMeanI;	
		float[] faResult = {fPiHat0, fPiHat1};
		return faResult;
	}
	
	
	public float[] twoSLS(){
	
		float[] faI = new float[iDateTo-iDateFrom];
		float[] faY = new float[iDateTo-iDateFrom];
	 
		for (int i=iDateFrom; i<iDateTo; i++){
			faI[i-iDateFrom] = faIVal[i];
		 	faY[i-iDateFrom] = faYVal[i];
		}  	
		float fMeanI = sum(faI)/faI.length;
		float fMeanY = sum(faY)/faY.length;
//		System.out.println("fMeanI = "+fMeanI);
//		System.out.println("fMeanY = "+fMeanY);
		 
		float fNumerator = 0f;
		float fDenominator = 0f;
		 	
		for (int i=0; i<faI.length; i++){
		 	fNumerator = fNumerator+((faI[i]-fMeanI)*(faY[i]-fMeanY));
		 	fDenominator = fDenominator+((faI[i]-fMeanI)*(faI[i]-fMeanI));
		}
	 
		float fPiHat1 = fNumerator/fDenominator;
		float fPiHat0 = fMeanY - fPiHat1*fMeanI;	
		float[] faResult = {fPiHat0, fPiHat1};
		return faResult;
	}
	
	public float[] biVariateTwoSLS(){
		
		float[] faG = new float[iDateTo-iDateFrom];
		float[] faI = new float[iDateTo-iDateFrom];
		float[] faY = new float[iDateTo-iDateFrom];
	 	
		for (int i=iDateFrom; i<iDateTo; i++){
			faG[i-iDateFrom] = faGovVal[i];
			faI[i-iDateFrom] = faIVal[i];
		 	faY[i-iDateFrom] = faYVal[i];
		}
		float fMeanG = sum(faG)/faG.length;  	
		float fMeanI = sum(faI)/faI.length;
		float fMeanY = sum(faY)/faY.length;
	
		float fNumerator1 = 0f;
		float fNumerator2 = 0f;
		float fDenominator = 0f;
		
		float[] faX1 = new float[faI.length];
		float[] faX2 = new float[faI.length];
		float[] faYi = new float[faI.length];
				
		for (int i=0; i<faI.length; i++){
			float fX1 = faI[i]-fMeanI;
			float fX2 = faG[i]-fMeanG;
			float fY = faY[i]-fMeanY;
			
			faX1[i] = fX1;
			faX2[i] = fX2;
			faYi[i] = fY;
		}	 
		
		fNumerator1 = sum2(faYi, faX1)*sum2(faX2, faX2) - sum2(faYi, faX2)*sum2(faX1, faX2);
		fNumerator2 = sum2(faYi, faX2)*sum2(faX1, faX1) - sum2(faYi, faX1)*sum2(faX1, faX2);
		fDenominator = sum2(faX1, faX1)*sum2(faX2, faX2) - sum2(faX1, faX2)*sum2(faX1, faX2);
		
		float fPiHat1 = fNumerator1/fDenominator;
		float fPiHat2 = fNumerator2/fDenominator;
		float fPiHat0 = fMeanY - fPiHat1*fMeanI - fPiHat2*fMeanG;
		
		float[] faResult = {fPiHat0, fPiHat1, fPiHat2};
		return faResult;	
	}
		
	
	
}














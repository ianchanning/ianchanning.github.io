package mac_econ.validation;


public class Limits{

	private float zeroIncomeDemand;
	private float cY;
	
	Limits(){
		zeroIncomeDemand = 150;
		cY = 1; 
	}
	
	public Limits(float newY, float newGrad){
		zeroIncomeDemand = newY;
		cY = newGrad;
		
	}
	
	public float getLimit(float limit){
		if (limit == 1){return zeroIncomeDemand;}
		else if(limit == 2){return cY;}
		else return 0;
	}
}
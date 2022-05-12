package mac_econ.function;

public interface MacroConstants {

	// -- Model 1 - Model 4 --
	
	
	public static final float D = 100f; //Demand, ie 100% F
	public static final float Y = 100f; //real GDP/income, ie 100% F
	
	public static final float C = 65f; //real consumer expenditure F
	public static final float C_y = 0.94f; //Should be 0.35 marginal propensity to consume F
	public static final float C_0 = 0f; // Consumer spending at zero income -- unknown?? F
	public static final float C_r = -25f; // F
	
	public static final float G = 152f; // Government spending - fiscal policy T
	
	public static final float I = 156f; // real gross investment expenditure T
	public static final float I_0 = 12.5f; // (should be 12.5)investment at zero output -- unknown?? F
	public static final float I_r = -5f; // investment sensitivity to ir changes F
	
	public static final float r = 0.1f; // (should be 0.1 = 10%)interest rate - ir on Gov. bonds T
	
	public static final float YD = 75f; // real disposable income; F
	public static final float T = 25f; // total tax revenues, in real terms F
	public static final float t_0 = -10.0f; // tax rate at zero income -- unknown?? T
	public static final float t_y = 0.40f; //(should be 0.25)tax rate sensitivity to changes in income T
	
	public static final float psbr = 0f; // public sector borrowing requirement F
	public static final float TR = 0f; // Transfer Repayments T
	
	public static final float m = 3f; //real money stock -- made up T?
	public static final float b = 297f; //real stock of gov bonds - made up T?
	public static final float v = 300f; //v = m + b F
	public static final float v_1 = 0f; //capital in previous period
	
	public static final float M_y = 0.105f; //F
	public static final float M_r = -5f; //F
	public static final float M_v = 0.001f; //F
	
	// -- Model 6 --
	
//	public static final float m = 150f; // real money stock = M/P-- made up F
//	public static final float b = 150f; // real stock of gov bonds = B/P - made up
//	public static final float v = 300f; // real private sector wealth

	public static final float M = 150f; // nominal money stock -- made up T
	public static final float B = 150f; // nominal stock of gov bonds - made upT
	public static final float V = 300f; // nominal private sector wealth F

//	public static final float M_y = 0.075f; //F
//	public static final float M_r = -50f; //F
//	public static final float M_v = 0.001f; //F

	public static final float P = 1f; // Price producer index; T
	public static final float p = 0f; // actual inflation rate; F
	public static final float p_e = 0f; // expected inflation in period t with information in t-1 F
	public static final float PM = 1f; // price of imports in domestic currency T
	public static final float pm = 0f; // (change in PM)/PM F
	public static final float W = 1f; //nominal wage rate T
	public static final float w = 0; //(change in W)/W - wage inflation F

	public static final float YY = 100f; // full level capacity of output or potential output T
//	public static final float ;
	
	public static final float eC = 0f;//-61.25f;  // error term??
	public static final float eI = 0f;//14.75f;  // error term??
	public static final float eM = 0f;//-5.2f;  // error term??
	public static final float ePSBR = 0.04f; // error term??
    
//  indexes                                     {0     1       2      3      4      5      6      7     8      9       10    11    12      13      14     15   16      17      18     19   20     21    22    23      24     	25     26     27   28      29     30    31     32     33     34    35     36   37     38     39	
    public static final float[]   daConstVals = {0,    Y,      D,     C,     C_0,   C_y,   C_r,   G,    I,     I_0,   I_r,   r,    YD,    T,     t_0,   t_y,   psbr,   TR,   M_y,   M_r,   M_v,   m,    b,    v,      v_1,    	M,     B,     V,     P,   p,      p_e,   PM,   pm,    W,     w,     YY,   eC,    eI,  eM,    ePSBR};
    public static final String[]  saConstLbls = {"0", "Y",    "D",   "C",   "C_0", "C_y", "C_r", "G",  "I",   "I_0", "I_r", "r",  "YD",  "T",   "t_0", "t_y", "psbr", "TR", "M_y", "M_r", "M_v", "m",  "b",  "v",     "v_-1",	"M",   "B",   "V",   "P", "p",    "p_e", "PM", "pm",  "W",   "w",   "YY",  "eC", "eI", "eM", "ePSBR"};
//    public static final String[]  saConstLbls = {"0", "GDP (Y)",    "Demand (D)",   "Consumption (C)",   "Min Consumption (C_0)", "Spend/Save Ratio (C_y)", "C_r", "G",  "Investment (I)",   "I_0", "I_r", "Interest rate (r)",  "Disp Income (YD)",  "Taxes (T)",   "t_0", "Marg Tax Rate (t_y)", "psbr", "Transfer Repayments (TR)", "M_y", "M_r", "M_v", "Money Supply (m)",  "b",  "v",    "Nom Money Supply (M)",   "B",   "V",   "P", "p",    "p_e", "PM", "pm",  "W",   "w",   "YY",  "Consumption error (eC)", "Investment error (eI)", "Monetary error (eM)", "ePSBR"};
//  public static final Boolean[] baConstEdit = {false, false, false, false, false, false, true, false, false, false, true, false, false, true,  true,  false,  true, false, false, false, true, true, false,  false, false, false, true, false, false, true, false, true,  false, true, false, true, true, true, true};  
/*    
    public static final boolean   f = false;
    public static final boolean   t = true;
    public static final int[] 	  iaM1Line1 = {1, 2}//Y = D
    public static final boolean[] baM1Line1 = {f, f};
    public static final int[] 	  iaM1Line2 = {1, 2, 8, 4, 5}; //D = I + C_0 + C_y * Y
    public static final boolean[] baM1Line2 = {f, f, t, f, f};
    public static final int[] 	  iaM3Line1 = {1, 2, 8, 4, 5}; //D = I + C_0 + C_y * Y
    public static final boolean[] baM3Line1 = {f, f, t, f, f};
*/
/*
Gov Spending £Billion
1960	41.21
1961	43.06
1962	44.51
1963	45.81
1964	47.04
1965	49.11
1966	51.13
1967	54.9
1968	56.08
1969	55.54
1970	61.76
1971	64.92
1972	68.62
1973	72.86
1974	79.16
1975	86.41
1976	87.43
1977	83.55
1978	84.73
1979	85.87
1980	91.18
1981	92.53
1982	93.68
1983	96.89
1984	98.42
1985	98.23
1986	102.29
1987	104.45
1988	103.39
1989	103.45
1990	106.06
1991	109.14
1992	110.45
1993	109.15
1994	111.25
1995	112.1
1996	112.66
1997	110.55
1998	111.69
1999	114.47
2000	116.45*/
} 
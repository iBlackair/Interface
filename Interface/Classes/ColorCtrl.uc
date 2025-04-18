class ColorCtrl extends UICommonAPI;

static final function Name RGBToHSV(Color RGB, out HSVColor Output)
{
	local float Max;
	local float Min;
	local float Chroma;
	local HSVColor HSV;
 
	Min = FMin(FMin(RGB.R, RGB.G), RGB.B);
	Max = FMax(FMax(RGB.R, RGB.G), RGB.B);
	Chroma = Max - Min;
 
	if(Chroma != 0.0f)
	{
		if (RGB.R == Max)
		{
			HSV.H = (RGB.G - RGB.B) / Chroma;
 
			if(HSV.H < 0.0f)
				HSV.H += 6.0f;
		}
		else if (RGB.G == Max)
			HSV.H = ((RGB.B - RGB.R) / Chroma) + 2.0f;
		else if (RGB.B == Max)
			HSV.H = ((RGB.R - RGB.G) / Chroma) + 4.0f;
 
		HSV.H *= 60.0f;
		HSV.S = Chroma / Max;
	}
 
	HSV.V = Max / 255.0f;
	HSV.A = RGB.A;
	
	Output = HSV;
 
	return GetColorNameRange( HSV.H, HSV.S, HSV.V );
}

static final function Name GetColorNameRange(float Hue, float Sat, float Value)
{
	if ( 0.0f < Hue && Hue < 360.0f )
	{
		if (0.0f < Sat && Sat < 1.0f && Value < 0.1f)
			return 'BLACK';
	}
	if (0.0f < Hue && Hue < 360.0f)
	{
		if (Sat < 0.15f && Value > 0.65f)
			return 'WHITE';
	}
	if (0.0f < Hue && Hue < 360.0f)
	{
		if (Sat < 0.15f && 0.1f < Value && Value < 0.65f)
			return 'GRAY';
	}		
	if (Hue < 11.0f && Hue > 351.0f)
	{
		if (Sat > 0.7f && Value > 0.1f)
			return 'RED';
	}
	if (310.0f < Hue && Hue < 351.0f)
	{
		if (Sat > 0.15f && Value > 0.1f)
			return 'PINK';
	}
	if (Hue < 11.0f && Hue > 351.0f)
	{
		if (Sat < 0.7f && Value > 0.1f)
			return 'PINK';
	}
	if (11.0f < Hue && Hue < 45.0f)
	{
		if (Sat > 0.15f && Value > 0.75f)
			return 'ORANGE';
	}
	if (11.0f < Hue && Hue < 45.0f)
	{
		if (Sat > 0.15f && 0.1f < Value && Value < 0.75f)
			return 'BROWN';
	}
	if (45.0f < Hue && Hue < 64.0f)
	{
		if (Sat > 0.15f && Value > 0.1f)
			return 'YELLOW';
	}
	if (64.0f < Hue && Hue < 150.0f)
	{
		if (Sat > 0.15f && Value > 0.1f)
			return 'GREEN';
	}
	if (150.0f < Hue && Hue < 180.0f)
	{
		if (Sat > 0.15f && Value > 0.1f)
			return 'CYAN';
	}
	if (180.0f < Hue && Hue < 255.0f)
	{
		if (Sat > 0.15f && Value > 0.1f)
			return 'BLUE';
	}
	if (255.0f < Hue && Hue < 310.0f)
	{
		if (Sat > 0.5f && Value > 0.1f)
			return 'PURPLE';
	}
	if (255.0f < Hue && Hue < 310.0f)
	{
		if (0.15f < Sat && Sat < 0.5f && Value > 0.1f)
			return 'PINK';
	}
}

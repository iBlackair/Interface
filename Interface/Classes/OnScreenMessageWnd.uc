class OnScreenMessageWnd extends UIScriptEx;
var string currentwnd1;
var bool onshowstat1;
var bool onshowstat2;
var int timerset1;
var int globalAlphavalue1;
var int globalAlphavalue2;
var int globalDuration;
var int droprate;
var int moveval;
var int moveval2;
var string MovedWndName;
var int m_TimerCount;
var bool linedivided;

var WindowHandle OnScreenMessageWnd1;

//var WindowHandle OnScreenMessageWnd2;
//var WindowHandle OnScreenMessageWnd3;
//var WindowHandle OnScreenMessageWnd4;
//var WindowHandle OnScreenMessageWnd5;
//var WindowHandle OnScreenMessageWnd6;
//var WindowHandle OnScreenMessageWnd7;
//var WindowHandle OnScreenMessageWnd8;
//var WindowHandle OnScreenMessageWnd9;


enum Mstate
{
	FADE_IN, 
	FADE_MIDDLE, 
	FADE_OUT, 
	FADE_NONE 
};

var WindowHandle	handlearr[10]; //1 ~ 9 ���� 0�� �������� 
var int AlphaValues[10];	//���İ��� �����Ұ�
var int DropValues[10]; //����ġ
var int LifeTimes[10];
var Mstate states[10];



function resetByIdx(int idx)
{
	m_hOwnerWnd.KillTimer(idx);
	AlphaValues[idx] = 0;
	DropValues[idx] = 0;
	LifeTimes[idx] = 0;
	states[idx] = Mstate.FADE_NONE;	
}

function initAll()
{	
	local int idx;
	for(idx = 0; idx < 10; idx++)
	{
		handlearr[idx] = GetWindowHandle("OnScreenMessageWnd" $ idx);
		AlphaValues[idx] = 0;
		DropValues[idx] = 0;
		LifeTimes[idx] = 0;
		states[idx] = Mstate.FADE_NONE;
		m_hOwnerWnd.KillTimer(idx);
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowScreenMessage);
	RegisterEvent(EV_ShowScreenNPCZoomMessage);
	RegisterEvent(EV_SystemMessage);
	registerEvent( EV_GamingStateExit );
}

function OnLoad()
{
	initAll();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
		
	// ������ �ڵ� �ޱ�
	if(CREATE_ON_DEMAND==0)
	{
		OnScreenMessageWnd1 = GetHandle( "OnScreenMessageWnd1" );
//		OnScreenMessageWnd2 = GetHandle( "OnScreenMessageWnd2" );
//		OnScreenMessageWnd3 = GetHandle( "OnScreenMessageWnd3" );
//		OnScreenMessageWnd4 = GetHandle( "OnScreenMessageWnd4" );
//		OnScreenMessageWnd5 = GetHandle( "OnScreenMessageWnd5" );
//		OnScreenMessageWnd6 = GetHandle( "OnScreenMessageWnd6" );
//		OnScreenMessageWnd7 = GetHandle( "OnScreenMessageWnd7" );
//		OnScreenMessageWnd8 = GetHandle( "OnScreenMessageWnd8" );
//		OnScreenMessageWnd9 = GetHandle( "OnScreenMessageWnd9" );
	}
	// ���ο� �ڵ� �ޱ�!!
	else
	{
		OnScreenMessageWnd1 = GetWindowHandle( "OnScreenMessageWnd1" );
//		OnScreenMessageWnd2 = GetWindowHandle( "OnScreenMessageWnd2" );
//		OnScreenMessageWnd3 = GetWindowHandle( "OnScreenMessageWnd3" );
//		OnScreenMessageWnd4 = GetWindowHandle( "OnScreenMessageWnd4" );
//		OnScreenMessageWnd5 = GetWindowHandle( "OnScreenMessageWnd5" );
//		OnScreenMessageWnd6 = GetWindowHandle( "OnScreenMessageWnd6" );
//		OnScreenMessageWnd7 = GetWindowHandle( "OnScreenMessageWnd7" );
//		OnScreenMessageWnd8 = GetWindowHandle( "OnScreenMessageWnd8" );
//		OnScreenMessageWnd9 = GetWindowHandle( "OnScreenMessageWnd9" );
	}

	// Old code
	//ResetAllMessage();

	// New code - �ε� �� �������� ������ �ǽɵǾ� window ó�� �κ��� �����մϴ� - 2008/12/04 ���ر�
	globalAlphavalue1 = 0;
	globalAlphavalue2 = 255;
	currentwnd1 = "";
	onshowstat1 = false;
	onshowstat2 = false;

	timerset1 = 0;
	moveval = 0;
	moveval2 = 0;
	globalAlphavalue1 = 0;
	globalAlphavalue2 = 255;
	m_TimerCount = 0;

	//ShowMsg(2, "Hello World! This is Choonsik Moon", 3000, 11, 0, 1, 255, 255, 255);
	//ShowMsg(8,"Hello World! Hello World! Hello World!#Hello World!", 3000, 11, 0, 0);

}



function OnTimer(int TimerID)
{

	local int idx;
	idx = TimerID;
		
	if(states[idx] == Mstate.FADE_IN)
	{
		AlphaValues[idx] += DropValues[idx];
		if(AlphaValues[idx] >= 255)
		{
			AlphaValues[idx] = 255;
			states[idx] = Mstate.FADE_MIDDLE;
			m_hOwnerWnd.KillTimer(idx);
			m_hOwnerWnd.SetTimer(idx, LifeTimes[idx]);
			
		}

		handlearr[idx].SetAlpha(AlphaValues[idx]);
	}
	else if(states[idx] == Mstate.FADE_MIDDLE)
	{
		states[idx] = Mstate.FADE_OUT;
		m_hOwnerWnd.KillTimer(idx);
		m_hOwnerWnd.SetTimer(idx, 30);
	}
	else if(states[idx] == Mstate.FADE_OUT)
	{
		AlphaValues[idx] -= DropValues[idx];
		if(AlphaValues[idx] <= 0)
		{
			AlphaValues[idx] = 0;
			states[idx] = Mstate.FADE_NONE;
			m_hOwnerWnd.KillTimer(idx);

			handlearr[idx].HideWindow();
			
		}	

		handlearr[idx].SetAlpha(AlphaValues[idx]);
	}
	else if(states[idx] == Mstate.FADE_NONE)
	{
		//do nothing
	}

}

function OnHide()
{
	
}

function ResetAllMessage()
{
	local int i;
	local Color DefaultColor;
	local string wndname;

	DefaultColor.R = 255;
	DefaultColor.G = 255;
	DefaultColor.B = 255;
	
	globalAlphavalue1 = 0;
	globalAlphavalue2 = 255;
	
	currentwnd1 = "";
	onshowstat1 = false;
	onshowstat2 = false;
	// Set DefaultColor for all the Screen Messages
	OnScreenMessageWnd1.HideWindow();
//	OnScreenMessageWnd2.HideWindow();
//	OnScreenMessageWnd3.HideWindow();
//	OnScreenMessageWnd4.HideWindow();
//	OnScreenMessageWnd5.HideWindow();
//	OnScreenMessageWnd6.HideWindow();
//	OnScreenMessageWnd7.HideWindow();
//	OnScreenMessageWnd8.HideWindow();
//	OnScreenMessageWnd9.HideWindow();
		
	for (i = 1; i <= 8; ++i )
	{
		wndname = "OnScreenMessageWnd" $ i;
	
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBox" $ i , DefaultColor);
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBox" $ i $ "-1" , DefaultColor);
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBoxsm" $ i  , DefaultColor);
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBoxsm" $ i $ "-1" , DefaultColor);
	}
	//��� �̹��� ���� ��ġ ����
	
	//if (linedivided == true)
		//class'UIAPI_WINDOW'.static.Move("OnScreenMessageWnd2.texturetype2", 0, -30, 0);
		
}

function ShowMsg(int WndNum, string TextValue, int Duration, int Animation, int fonttype, int backgroundtype, int ColorR, int ColorG, int ColorB, optional bool bUseNpcZoom)
{
	local string WndName;
	local string TextBoxName;
	//local string ShadowBoxName;
	local string TextBoxName2;
	//local string ShadowBoxName2;
	local string TextValue1;
	local string TextValue2;
	local string CurText;
	local string 	SmallBoxName1;
	local string 	SmallBoxName2;
	
	local color FontColor;

	local int i;
	local int j;
	local int LengthTotal;
	//local int LengthSum;
	local int TotalLength;
	local int TextOffsetTotal1;
	
	//local int TextOffsetTotal2;
	
	j = 1;
	TotalLength =  Len(TextValue);
	TextValue1 = "";
	TextValue2 = "";
	linedivided = false; 
	
	FontColor.R = ColorR;
	FontColor.G = ColorG;
	FontColor.B = ColorB;
	
	//~ debug ("totalval" @ TextValue);
	
	//Debug ("CurrentL:"@ Len(TextValue));
	
	for (i=1; i <= TotalLength; ++i)
	{
		LengthTotal = Len(TextValue) - 1;
		CurText = Left(TextValue, 1);
		TextValue = Right(TextValue, LengthTotal);
		
		if(CurText =="`")
		{
			CurText = "";
		}
		
		if(CurText =="#")
		{
			CurText = "";
			j = 2;
			linedivided = true;
		}
		
		 if (j == 1)
		 {
			TextValue1 = TextValue1 $ CurText;
		 }
		else
		{
			TextValue2 = TextValue2 $ CurText;
		}
	}


	//~ debug (TextValue1);
	//~ debug (TextValue2);
		
	WndName = "OnScreenMessageWnd" $ WndNum;
	TextBoxName = WndName $ ".TextBox" $ WndNum;
	//ShadowBoxName = WndName $".TextBox" $ WndNum $ "-0";
	TextBoxName2 = WndName $ ".TextBox" $ WndNum $ "-1";
	//ShadowBoxName2 = WndName $".TextBox" $ WndNum $ "-1-0";
	SmallBoxName1 = WndName $".TextBoxsm" $ WndNum;
	SmallBoxName2 = WndName $".TextBoxsm" $ WndNum $ "-1";
	
	
	//debug("TBN:" $ TextBoxName $ Duration $ Animation);
	currentwnd1 = WndName;
	

	class'UIAPI_TEXTBOX'.static.SetTextColor( TextBoxName , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( TextBoxName2 , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( SmallBoxName1 , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( SmallBoxName2 , FontColor);

	if (fonttype == 0)
	{
	class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
	//class'UIAPI_TEXTBOX'.static.SetText(ShadowBoxName,TextValue1);
	class'UIAPI_TEXTBOX'.static.SetText(TextBoxName,TextValue1);
	//class'UIAPI_TEXTBOX'.static.SetText(ShadowBoxName2,TextValue2);
	class'UIAPI_TEXTBOX'.static.SetText(TextBoxName2,TextValue2);
	class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName1,"");
	class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName2,"");
	}
	else if (fonttype == 1)
	{
	class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
	//class'UIAPI_TEXTBOX'.static.SetText(ShadowBoxName,"");
	class'UIAPI_TEXTBOX'.static.SetText(TextBoxName,"");
	//class'UIAPI_TEXTBOX'.static.SetText(ShadowBoxName2,"");
	class'UIAPI_TEXTBOX'.static.SetText(TextBoxName2,"");
	class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName1,TextValue1);
	class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName2,TextValue2);
	}	
	
	if (WndNum == 2)
	{
		if (moveval != 0)
		{
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, 1 * moveval, 0);
		//class'UIAPI_WINDOW'.static.Move(MovedWndName$".texturetype1", -1 * moveval2, 0);
		//class'UIAPI_WINDOW'.static.Move(MovedWndName$".texturetype2", -1 * moveval2, 0);
		}
		MovedWndName = WndName;
		//moveval = ((TextOffsetTotal1/2)*25);
		moveval2 = ((TextOffsetTotal1/2)*29);
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, -1 * moveval, 0);
		if (backgroundtype == 1)
		{			
			class'UIAPI_WINDOW'.static.ShowWindow(MovedWndName$".texturetype1");
			//class'UIAPI_WINDOW'.static.ShowWindow(MovedWndName$".texturetype2");
			
			//if (linedivided == true)
				//class'UIAPI_WINDOW'.static.Move(MovedWndName$".texturetype2", 0, 30, 0);
			
			//class'UIAPI_WINDOW'.static.Move(MovedWndName$".texturetype1", -1 * moveval2, 0);
			//class'UIAPI_WINDOW'.static.Move(MovedWndName$".texturetype2",  -1 * moveval2, 0);
		}
		else 
		{
			class'UIAPI_WINDOW'.static.HideWindow(MovedWndName$".texturetype1");
			//class'UIAPI_WINDOW'.static.HideWindow(MovedWndName$".texturetype2");
		}
		
	}
	
	else if (WndNum == 5)
	{
		if (moveval != 0)
		{
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, 1 * moveval, 0);
		}
		MovedWndName = WndName;
		//moveval = ((TextOffsetTotal1/2)*30);
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, -1 * moveval, 0);
	}
	
	else if (WndNum == 7)
	{
		if (moveval != 0)
		{
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, 1 * moveval, 0);
		}
		MovedWndName = WndName;
		//moveval = ((TextOffsetTotal1/2)*30);
		//class'UIAPI_WINDOW'.static.Move(MovedWndName, -1 * moveval, 0);
	} 
	
	else 
	{
		moveval = 0;
	}
	
	
	onshowstat1 = true;
	onshowstat2 = false;
	globalDuration = Duration;
	switch (Animation)
	{
		case 0:
			droprate = 255;
		break;
		case 1:
			droprate = 25;
		break;
		case 11:
			droprate = 15;
		break;
		case 12:
			droprate = 25;
		break;
		case 13:
			droprate = 35;
		break;
	}
	resetByIdx(WndNum);
	
	DropValues[WndNum] = droprate;
	states[WndNum] = Mstate.FADE_IN;

	if ( !bUseNpcZoom )
	{
		LifeTimes[WndNum] = Duration;
		m_hOwnerWnd.SetTimer(WndNum, 30);
	}
}



function OnEvent( int a_EventID, String a_Param )
{
	local int msgtype;
	local int msgno;
	local int windowtype;	
	local int fontsize;
	local int fonttype;
	local int msgcolor;
	local int msgcolorR;
	local int msgcolorG;
	local int msgcolorB;
	local int shadowtype;
	local int backgroundtype;
	local int lifetime;
	local int animationtype;
	local int SystemMsgIndex;
	local string msgtext;
	local string ParamString1;
	local string ParamString2;

	// event show screen message
	if( a_EventID == EV_ShowScreenMessage )
	{
		ParseInt( a_Param, "MsgType", msgtype );
		ParseInt( a_Param, "MsgNo", msgno );
		ParseInt( a_Param, "WindowType", windowtype );
		ParseInt( a_Param, "FontSize", fontsize );
		ParseInt( a_Param, "FontType", fonttype );
		
		ParseInt( a_Param, "MsgColor", msgcolor );
		if (!ParseInt( a_Param, "MsgColorR", msgcolorR ))
			msgcolorR = 255;
		if (!ParseInt( a_Param, "MsgColorG", msgcolorG ))
			msgcolorG = 255;
		if (!ParseInt( a_Param, "MsgColorB", msgcolorB ))
			msgcolorB = 255;
		ParseInt( a_Param, "ShadowType", shadowtype );
		ParseInt( a_Param, "BackgroundType", backgroundtype );
		ParseInt( a_Param, "LifeTime", lifetime );
		ParseInt( a_Param, "AnimationType", animationtype );
		ParseString( a_Param, "Msg", msgtext );

		ResetAllMessage();
		if ( msgtype == 0 )
			msgtext =  GetSystemMessage(msgno);

		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, msgcolorR, msgcolorG, msgcolorB);
	}
	
	// event show screen NPC zoom message
	if(a_EventID == EV_ShowScreenNPCZoomMessage)
	{
		ParseInt( a_Param, "MsgType", msgtype );
		ParseInt( a_Param, "MsgNo", msgno );
		ParseInt( a_Param, "WindowType", windowtype );
		ParseInt( a_Param, "FontSize", fontsize );
		ParseInt( a_Param, "FontType", fonttype );
		
		if( ParseInt( a_Param, "MsgColor", msgcolor ) )
		{
			// if msgcolor is black then convert white
			if( msgcolor == 0 )
			{
				msgcolor = 16777215;			
			}		
		
			msgcolorR = (msgcolor&16711680)>>16;
			msgcolorG = (msgcolor&65280)>>8;
			msgcolorB = (msgcolor&255);
		}
		else
		{
			if (!ParseInt( a_Param, "MsgColorR", msgcolorR ))
				msgcolorR = 255;
			if (!ParseInt( a_Param, "MsgColorG", msgcolorG ))
				msgcolorG = 255;
			if (!ParseInt( a_Param, "MsgColorB", msgcolorB ))
				msgcolorB = 255;
		}
		
		ParseInt( a_Param, "ShadowType", shadowtype );
		ParseInt( a_Param, "BackgroundType", backgroundtype );
		ParseInt( a_Param, "LifeTime", lifetime );
		ParseInt( a_Param, "AnimationType", animationtype );
		ParseString( a_Param, "Msg", msgtext );		
		
		ResetAllMessage();
		
		//
		switch( msgtype )
		{
		case 0:
			//
			msgtext =  GetSystemMessage(msgno);
			break;
			
		case 1:
			// do nothing.
			break;
			
		case 2:
			// if msgtype is 2 then, it's mean that continue word. 
			msgtext = msgtext $ "...";
			break;
			
		default:
			break;
		}
		
		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, msgcolorR, msgcolorG, msgcolorB, true);
	}
	
	if( a_EventID == EV_SystemMessage )
	{
		ParseInt ( a_Param, "Index", SystemMsgIndex );
		ParseString ( a_Param, "Param1", ParamString1 );
		ParseString ( a_Param, "Param2", ParamString2 );
		//debug("SystemMsg Param1:" $ ParamString1);
		//debug("SystemMsg Param2:" $ ParamString2);
		ValidateSystemMsg( SystemMsgIndex, ParamString1, ParamString2 );
	}
	if ( a_EventID == EV_GamingStateExit )
	{
		Clear();
	}
}

function Clear()		// clear this Script
{
	initAll();
	globalAlphavalue1 = 0;
	globalAlphavalue2 = 255;
	currentwnd1 = "";
	onshowstat1 = false;
	onshowstat2 = false;

	timerset1 = 0;
	moveval = 0;
	moveval2 = 0;
	globalAlphavalue1 = 0;
	globalAlphavalue2 = 255;
	m_TimerCount = 0;
	OnScreenMessageWnd1.HideWindow();
}

function ValidateSystemMsg(int Index, string StringTxt1, string StringTxt2)
{
	
	local SystemMsgData SystemMsgCurrent;
	local int windowtype;	
	local int fonttype;
	local int backgroundtype;
	local int lifetime;
	local int animationtype;
	local string msgtext;
	local Color TextColor;
	
	GetSystemMsgInfo( Index, SystemMsgCurrent);
	
	
	if ( SystemMsgCurrent.WindowType != 0 )
	{
		windowtype = SystemMsgCurrent.WindowType; 
		msgtext = SystemMsgCurrent.OnScrMsg;
		msgtext = MakeFullSystemMsg( msgtext, StringTxt1, StringTxt2 );
		lifetime = (SystemMsgCurrent.LifeTime * 1000);
		animationtype = SystemMsgCurrent.AnimationType;
		fonttype = SystemMsgCurrent.FontType;
		backgroundtype = SystemMsgCurrent.backgroundtype;
		TextColor = SystemMsgCurrent.FontColor;
		
		if (TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0 )
		{
			TextColor.R = 255;
			TextColor.G = 255; 
			TextColor.B = 255; 
		}
		else if (TextColor.R == 176 && TextColor.G == 155 && TextColor.B == 121 )
		{
			TextColor.R = 255;
			TextColor.G = 255; 
			TextColor.B = 255; 
		}
		
		//Debug ("ColorR:" @ TextColor.R );
		//Debug ("ColorG:" @ TextColor.G );
		//Debug ("ColorB:" @ TextColor.B );
		                       
		
		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, TextColor.R, TextColor.G, TextColor.B);

	}
}
defaultproperties
{
}

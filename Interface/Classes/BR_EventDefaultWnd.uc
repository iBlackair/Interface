class BR_EventDefaultWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle EventDefaultBtn1; 
var ButtonHandle EventDefaultBtn2; 
var ButtonHandle EventDefaultBtn3; 
var TextBoxHandle EventTitle; 

var int eventID;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_EventChristmasShow ); // BR_EVENT_CHRISTMAS_2009
	RegisterEvent( EV_BR_EventValentineShow ); // BR_EVENT_VALENTINE_2010
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	local int result;
	result = BR_GetShowEventUI();
	if(result==0)
	{
		if(Me.IsShowWindow()){Me.HideWindow();}		
	}
	else
	{		
		if(!Me.IsShowWindow()){Me.ShowWindow();}
	}	
}

function Initialize()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_EventDefaultWnd" );
		EventDefaultBtn1 = ButtonHandle ( GetHandle( "BR_EventDefaultWnd.EventDefaultBtn1" ) );
		EventDefaultBtn2 = ButtonHandle ( GetHandle( "BR_EventDefaultWnd.EventDefaultBtn2" ) );
		EventDefaultBtn3 = ButtonHandle ( GetHandle( "BR_EventDefaultWnd.EventDefaultBtn3" ) );
		EventTitle = TextBoxHandle ( GetHandle( "BR_EventDefaultWnd.EventTitle" ) );
	}
	else {
		Me = GetWindowHandle( "BR_EventDefaultWnd" );		
		EventDefaultBtn1 = GetButtonHandle ( "BR_EventDefaultWnd.EventDefaultBtn1" );
		EventDefaultBtn2 = GetButtonHandle ( "BR_EventDefaultWnd.EventDefaultBtn2" );
		EventDefaultBtn3 = GetButtonHandle ( "BR_EventDefaultWnd.EventDefaultBtn3" );
		EventTitle = GetTextBoxHandle ( "BR_EventDefaultWnd.EventTitle" );
	}
}

function OnEvent( int Event_ID, string param )
{
	local int Show;
	
	switch( Event_ID )
	{		
	case EV_BR_EventChristmasShow : 
		eventID=20091225;
		ParseInt(param, "Show", Show ); 
		ShowMyWindow(Show, 6029);		
		EventTitle.SetText(GetSystemString(5046));
		EventDefaultBtn1.SetTexture( "BranchSys.UI.Br_rudolf_gift_normal", "BranchSys.UI.Br_rudolf_gift_click", "BranchSys.UI.Br_rudolf_gift_over" );
		EventDefaultBtn2.SetTexture( "BranchSys.UI.Br_santa_gift_nomal", "BranchSys.UI.Br_santa_gift_click", "BranchSys.UI.Br_santa_gift_over" );
		// EventDefaultBtn3.SetTexture( "L2UI_ct1.SystemMenuWnd.SystemMenuWnd_df_Help", "L2UI_ct1.SystemMenuWnd.SystemMenuWnd_df_Help_Down", ""); // ����ǥ ��ư �⺻ ����
		break;
	case EV_BR_EventValentineShow : 
		eventID=20100214;
		ParseInt(param, "Show", Show ); 
		ShowMyWindow(Show, 6037);		
		// ��ư 3�� ��� �⺻ ����
		break;		
	}
}

function ShowMyWindow( int Show, int Msg )
{
	if(Show==0)
	{
		if(Me.IsShowWindow()){Me.HideWindow();}		
	}
	else
	{		
		if(!Me.IsShowWindow()){Me.ShowWindow();}
		AddSystemMessage( Msg );
	}	
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "EventDefaultBtn1": 		
		OnEventDefaultBtn1Click();
		break;
	case "EventDefaultBtn2":
		OnEventDefaultBtn2Click();
		break;
	case "EventDefaultBtn3":
		OnEventDefaultBtn3Click();
		break;
	}
}

function OnEventDefaultBtn1Click()
{
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd1"))
	{
		HideWindow("BR_EventHtmlWnd1");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd1");		
		if(eventID==20091225)
		{
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_santa000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5044));
		}
		else if(eventID==20100214)
		{
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_necklace000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5061));
		}
		ExecuteEvent(EV_BR_EventCommonHtml1, strParam);
	}

}

function OnEventDefaultBtn2Click()
{
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd2"))
	{
		HideWindow("BR_EventHtmlWnd2");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd2");	
		if(eventID==20091225)
		{
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_rudolf000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5043));
		}
		else if(eventID==20100214)
		{	
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_drop000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5062));
		}
		ExecuteEvent(EV_BR_EventCommonHtml2, strParam);
	}

}

function OnEventDefaultBtn3Click()
{	
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd3"))
	{
		HideWindow("BR_EventHtmlWnd3");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd3");	
		if(eventID==20091225)
		{
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_reward000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5045));
		}
		else if(eventID==20100214)
		{	
			ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_help000.htm");
			ParamAdd(strParam, "Title", GetSystemString(5063));
		}
		ExecuteEvent(EV_BR_EventCommonHtml3, strParam);
	}
}
defaultproperties
{
}

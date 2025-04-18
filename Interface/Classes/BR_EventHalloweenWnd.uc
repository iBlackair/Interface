class BR_EventHalloweenWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle Today;

var int WindowState;
// 0 : BR_EventHalloweenTodayWnd Hide ����
// 1 : BR_EventHalloweenTodayWnd �� ���� ��� �����ְ� �ִ� ����
// 2 : BR_EventHalloweenTodayWnd �� ���� ��� �����ְ� �ִ� ����

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_EventHalloweenShow );
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_EventHalloweenWnd" );
		Today = GetHandle( "BR_EventHalloweenTodayWnd" );
	}
	else {
		Me = GetWindowHandle( "BR_EventHalloweenWnd" );
		Today = GetWindowHandle( "BR_EventHalloweenTodayWnd" );
		
	}
	WindowState = 0;
}

function OnEvent( int Event_ID, string param )
{
	local int Show;
	
	switch( Event_ID )
	{		
	case EV_BR_EventHalloweenShow : 
		ParseInt(param, "Show", Show ); 
		if(Show==0)
		{
			if(Me.IsShowWindow()){Me.HideWindow();}		
		}
		else
		{		
			if(!Me.IsShowWindow()){Me.ShowWindow();}
			AddSystemMessage(6027); // [�ҷ��� �̺�Ʈ �Ⱓ�Դϴ�]
		}	
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "EventHalloweenBtn1": // ���� ���
		OnEventHalloBtnRankClick(2, 1);
		break;
	case "EventHalloweenBtn2": // ���� ���
		OnEventHalloBtnRankClick(1, 2);
		break;
	case "EventHalloweenBtn3":
		OnEventHalloBtnHelpClick();
		break;
	}
}

function OnEventHalloBtnRankClick(int me, int other)
{
	if(IsShowWindow("BR_EventHalloweenTodayWnd")) {
		if(WindowState == me) { // ���� �����̸� â�� ����
			HideWindow("BR_EventHalloweenTodayWnd");
			WindowState = 0; 
		}		
		else if(WindowState == other) { // �ٸ� ������ �̹� �������� ������
			Today.KillTimer( 200901 );
			RequestBR_EventRankerList(20091031, me-1, 1); // â�� �״�� �ΰ�, �ؽ�Ʈ ���븸 ��ü (�̺�ƮID, ����:0/����:1, ��ŷ)
			WindowState = me; 
			Today.SetTimer( 200901, 7000 ); // ������ �ٲ�Ƿ� ���ο� 7�� Ÿ�̸Ӹ� ������
		}
	}
	else {		
		RequestBR_EventRankerList(20091031, me-1, 1);
		ShowWindowWithFocus("BR_EventHalloweenTodayWnd");			
		WindowState = me; 
	}

}

function OnEventHalloBtnHelpClick()
{	
	local string strParam;	

	if(IsShowWindow("BR_EventHtmlWnd1"))
	{
		HideWindow("BR_EventHtmlWnd1");		
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWnd1");		
		ParamAdd(strParam, "FilePath", "..\\L2text\\br_eventhalloween000.htm");
		ParamAdd(strParam, "Title", GetSystemString(5036));
		ExecuteEvent(EV_BR_EventCommonHtml1, strParam);
	}
}
defaultproperties
{
}

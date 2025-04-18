class PVPCounterTrigger extends UIScriptEx;

var WindowHandle Me;
var ButtonHandle Btn_PVPWnd;
var WindowHandle PVPDetailedWnd;

function OnRegisterEvent()
{
	registerEvent( EV_PVPMatchRecord );
}

function OnLoad()
{
	InitializeCOD();

	Me.HideWindow();
}

function InitializeCOD()
{
	Me = GetWindowHandle("PVPCounterTrigger");
	Btn_PVPWnd = GetButtonHandle("PVPCounterTrigger.Btn_PVPWnd");
	PVPDetailedWnd = GetWindowHandle("PVPDetailedWnd");
}


function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_PVPMatchRecord:
		HandlePVPMatchRecord(a_Param);
		break;
	}
}

function HandlePVPMatchRecord(string Param)
{
	local int CurrentState;
	//~ local int BlueTeamTotalKillCnt;
	//~ local int RedTeamTotalKillCnt;
	
	ParseInt(Param, "CurrentState", CurrentState );
	//~ ParseInt(Param, "BlueTeamTotalKillCnt", BlueTeamTotalKillCnt);
	//~ ParseInt(Param, "RedTeamTotalKillCnt", RedTeamTotalKillCnt);
	
	switch (CurrentState)
	{
		case 0:
			//������
			Me.ShowWindow();
			break;
		//~ case 1:
			//~ //��� ��
			//~ break;
		case 2:
			//�������
			Me.HideWindow();
			break;
	}
}

function OnClickButton( string Name )
{
	//~ debug ("Button Clicked1");
	switch( Name )
	{
		case "Btn_PVPWnd": 
			//~ debug("Trigger PVPCounterWnd");
			PVPDetailedWnd.ShowWindow();
			RequestPVPMatchRecord();
			break;
	}
}
defaultproperties
{
}

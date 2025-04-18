
class BirthdayAlarmBtn extends UICommonAPI;

var WindowHandle Me;
var WindowHandle BirthdayAlarmWnd;
var ButtonHandle btnItemPop;

function OnRegisterEvent()
{
	RegisterEvent( EV_BirthdayItemAlarm);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
}

function Initialize()
{
	
		Me = GetHandle( "BirthdayAlarmBtn" );
		BirthdayAlarmWnd = GetHandle( "BirthdayAlarmWnd" );
		btnItemPop = ButtonHandle ( GetHandle( "BirthdayAlarmBtn.btnItemPop" ) );
	
	
	//btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2313)));	// ����. �����̾� �������� �����Ͽ����ϴ�.
}

function InitializeCOD()
{
		Me = GetWindowHandle( "BirthdayAlarmBtn" );
		BirthdayAlarmWnd = GetWindowHandle( "BirthdayAlarmWnd" );
		btnItemPop = GetButtonHandle ("BirthdayAlarmBtn.btnItemPop" );
	
}

// ��ư�� Ŭ���ϸ� �˸�â �˾�
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "btnItemPop":
			if(!BirthdayAlarmWnd.IsShowWindow()) 
			BirthdayAlarmWnd.ShowWindow();
			Me.HideWindow();
			Me.SetWindowSize( 0 , 32);	//�������� ũ�⸦ ���������ش�. 
			break;
	}
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string a_param)
{
	switch(Event_ID)
	{
		case EV_BirthdayItemAlarm:
			Me.SetWindowSize( 32 , 32);	//�������� ũ�⸦ ���������ش�. 
			ShowWindowWithFocus("BirthdayAlarmBtn");
			btnItemPop.ShowWindow();
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("BirthdayAlarmBtn.btnItemPop", 0);
			//AddSystemMessage(2313);	
		break;
	}
}

//���°� ���� ��� ������ �ݾ��ش�.
function OnExitState( name a_NextStateName )
{
	Me.SetWindowSize( 0 , 32);	//�������� ũ�⸦ ���������ش�. 
	Me.HideWindow();	
}
defaultproperties
{
}

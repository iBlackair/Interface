class BirthdayAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle BirthDayItem;
var TextBoxHandle itemAlarmTxt;
var ButtonHandle btnOK;

function OnRegisterEvent()
{
	RegisterEvent( EV_BirthdayItemAlarm );
	
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

function OnShow()
{

	
}
function Initialize()
{
	
		Me = GetHandle( "BirthdayAlarmWnd" );
		BirthDayItem = TextureHandle ( GetHandle( "BirthDayItem" ) );
		itemAlarmTxt = TextBoxHandle ( GetHandle( "itemAlarmTxt" ) );
		btnOK = ButtonHandle ( GetHandle( "btnOK" ) );
	

}

function InitializeCOD()
{
		Me = GetWindowHandle( "BirthdayAlarmWnd" );
		BirthDayItem = GetTextureHandle ( "BirthdayAlarmWnd.BirthDayItem" );
		itemAlarmTxt = GetTextBoxHandle ( "BirthdayAlarmWnd.itemAlarmTxt" );
		btnOK = GetButtonHandle ( "BirthdayAlarmWnd.btnOK" );
}

function Load()
{

}
function OnEvent(int Event_ID, String param)
{
	switch( Event_ID )
	{
		case EV_BlockStateTeam:
		break;
		
	}

}
function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnOK":
		Me.HideWindow();
		break;
	}
}

//���°� ���� ��� ������ �ݾ��ش�.
function OnExitState( name a_NextStateName )
{
	Me.HideWindow();
}
defaultproperties
{
}

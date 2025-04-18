class ProgressBox extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle btnCancle;
var TextBoxHandle txtProgress;

var bool		m_bInUse;
var string		m_strTargetScript;		// �ش� ���α׷��� �ڽ��� ȣ���� ��ũ��Ʈ�� �����Ѵ�. 
var string		m_strEditMessage;		// ���α׷��� �ڽ��� �ڸ�Ʈ

var ProgressCtrlHandle m_hProgressBoxprogressCtrl;

function OnRegisterEvent()
{
	RegisterEvent(EV_SystemMessage);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	Initialize();
	Load();

}

function Initialize()
{
	m_strTargetScript = "";
	m_bInUse = false;

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "ProgressBox" );
		btnCancle = ButtonHandle ( GetHandle( "ProgressBox.btnCancle" ) );
		txtProgress = TextBoxHandle ( GetHandle( "ProgressBox.txtProgress" ) );
	}
	else
	{
		Me = GetWindowHandle( "ProgressBox" );
		btnCancle = GetButtonHandle ( "ProgressBox.btnCancle" );
		txtProgress = GetTextBoxHandle ( "ProgressBox.txtProgress" );

		m_hProgressBoxprogressCtrl=GetProgressCtrlHandle("ProgressBox.progressCtrl");
	}
}

function Load()
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnCancle":
		OnbtnCancleClick();
		break;
	}
}

function OnbtnCancleClick()
{	

	if (m_strTargetScript == "AttributeEnchantWnd")
	{
		m_hProgressBoxprogressCtrl.Reset();
		Me.HideWindow();
		m_bInUse = false;
		ShowWindow("AttributeEnchantWnd");
	}
	
}

// �ش� ���α׷��� �ڽ��� �θ��� �Լ�
function ShowDialog( string message, string target, int time )
{
	if( m_bInUse )
	{
		//debug("Error!! ProgressBox in Use");
		return;
	}
	
	// ���α׷��� Ÿ���� ������ �ȵȴٴ°�..
	if( time == 0)
	{
		//debug("Error!! Need Progress Time");
		return;		
	}
	
	// ���α׷��� �ٸ� ���� �� �ʱ�ȭ.
	m_hProgressBoxprogressCtrl.SetProgressTime( time );
	m_hProgressBoxprogressCtrl.Reset();
		
	// �����츦 �����ش�. 
	Me.ShowWindow();
	m_hProgressBoxprogressCtrl.Start();
	SetMessage( message );
	
	Me.SetFocus();

	m_strTargetScript = target;
	m_bInUse = true;
}

// ���̾�α��� �ð��� ������
function OnProgressTimeUp( string strID )
{
	//~ local ItemEnchantWnd scriptItemEnchant;
	//local AttributeEnchantWnd scriptAttributeEnchant;
	
	//�ð��� �ٵǸ� ĵ�� ��ư�� Ȯ�� ��ư�� �ȴ�. 
	//class'UIAPI_BUTTON'.static.SetButtonName("ProgressBox.btnCancle", 1337);
	
	if( strID == "progressCtrl" )
	{
		//HandleCancel();
		
		//My comment to evade progress awaiting (c) Merc
	}
}

function SetMessage( string strMessage )
{
	class'UIAPI_TEXTBOX'.static.SetText( "ProgressBox.txtProgress", strMessage );
}

function OnEvent( int a_EventID, String a_Param )
{
	local int SystemMsgIndex;
	local string ParamString1;
	local string ParamString2;
	
	if( a_EventID == EV_SystemMessage )
	{
		ParseInt ( a_Param, "Index", SystemMsgIndex );
		ParseString ( a_Param, "Param1", ParamString1 );
		ParseString ( a_Param, "Param2", ParamString2 );
		
		if (SystemMsgIndex > 61 && SystemMsgIndex < 66)
		{
			DialogShow(DIALOG_Modalless, DIALOG_Notice, MakeFullSystemMsg( GetSystemMessage( SystemMsgIndex ), ParamString1, ParamString2 ) );
		}
	}
}
defaultproperties
{
}

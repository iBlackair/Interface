class FlightShipCtrlWnd extends UIScriptEx;

// ������
const MAX_ShortcutPerPage = 12;	// 12ĭ�� ������ �����Ѵ�. 
const FSShortcutPage = 11;		// �������� 11�� �������� ����Ѵ�. 
const Relative_Altitude = 4000;	// �� ��ǥ�迡 +a �ϴ� ��

const SelectTex_X = -5;
const SelectTex_Y = -5;

// ���� ����
var WindowHandle Me;
var WindowHandle ShortcutWnd;

var	CheckBoxHandle 	Chk_EnterChatting;	//shortcut assign wnd�� ����ä�� ��� üũ�ڽ�.
var	TextBoxHandle	AltitudeTxt;		//�� �ؽ�Ʈ�ڽ�
var	TextureHandle	SelectTex;			// ���õ� �������� �˷��ִ� �ؽ���

var	ButtonHandle	UpButton;			// �� ���
var	ButtonHandle	DownButton;		// �� �ϰ��


var	ButtonHandle	LockBtn;			// ��� ��ư
var	ButtonHandle	UnlockBtn;			// ��� ���� ��ư
var	ButtonHandle	JoypadBtn;			// �����е�

var 	EditBoxHandle ChatEditBox;			// ä�� ����Ʈ �ڽ�

var  	ShortcutWnd 	scriptShortcutWnd;		

var	int i;							//���� ������ ����ϴ� ����

var	bool 		preEnterChattingOption;

var 	bool m_IsLocked;	// ���� ��� ����

var	bool	m_preDriver;	// ���� ���¿��� ����̹��������� �����Ѵ�.

var	bool isNowActiveFlightShipShortcut;	// ���� ������������� �����Ѵ�. ���� ���̴����� ������ �ε��� ���� �� �����Ƿ�.

var	int preSlot;			// ������ Ȱ��ȭ�� ������ �����صд�.

// �̺�Ʈ ���
function OnRegisterEvent()
{
	RegisterEvent( EV_AirShipState );
	RegisterEvent( EV_AirShipAltitude);
	
	RegisterEvent( EV_ShortcutCommandSlot );	//���� �̺�Ʈ
	RegisterEvent( EV_ReserveShortCut);		// ����� ���� �̺�Ʈ	
	
	RegisterEvent( EV_ShortcutPageUpdate );
	RegisterEvent( EV_ShortcutUpdate );
	RegisterEvent( EV_ShortcutClear );	
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)		// ������ �ڵ� �ޱ�
	{
		Me = GetHandle( "FlightShipCtrlWnd" );
		ShortcutWnd = GetHandle( "ShortcutWnd" );
		Chk_EnterChatting = CheckBoxHandle ( GetHandle( "OptionWnd.ShortcutTab.OptionCheckboxGroup.Chk_EnterChatting"));
		AltitudeTxt = TextBoxHandle ( GetHandle ( "FlightShipCtrlWnd.AltitudeTxt"));
		SelectTex = TextureHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.SelectTex"));
		
		UpButton = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightSteerWnd.UpButton"));
		DownButton = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightSteerWnd.DownButton"));
		LockBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.LockBtn"));
		UnlockBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.UnlockBtn"));
		JoypadBtn = ButtonHandle ( GetHandle( "FlightShipCtrlWnd.FlightShortCut.JoypadBtn"));
		
		ChatEditBox = EditBoxHandle( GetHandle("ChatWnd.ChatEditBox" ));
		
	}
	else	// ���ο� �ڵ� �ޱ�!!
	{
		Me = GetWindowHandle( "FlightShipCtrlWnd" );
		ShortcutWnd = GetWindowHandle( "ShortcutWnd" );
		Chk_EnterChatting = GetCheckBoxHandle( "OptionWnd.ShortcutTab.OptionCheckboxGroup.Chk_EnterChatting");
		AltitudeTxt = GetTextBoxHandle( "FlightShipCtrlWnd.AltitudeTxt");
		SelectTex = GetTextureHandle( "FlightShipCtrlWnd.FlightShortCut.SelectTex");
		
		UpButton = GetButtonHandle( "FlightShipCtrlWnd.FlightSteerWnd.UpButton");
		DownButton = GetButtonHandle ( "FlightShipCtrlWnd.FlightSteerWnd.DownButton");
		LockBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.LockBtn");
		UnlockBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.UnlockBtn");
		JoypadBtn = GetButtonHandle ( "FlightShipCtrlWnd.FlightShortCut.JoypadBtn");	
		
		ChatEditBox = GetEditBoxHandle( "ChatWnd.ChatEditBox" );
	}
	
	scriptShortcutWnd = ShortcutWnd( GetScript("ShortcutWnd") );	
	isNowActiveFlightShipShortcut = false;
	m_preDriver = false;
	preSlot = -1;
	JoypadBtn.HideWindow();	
	updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 
	ShortCutUpdateAll();
}

function OnEnterState( name a_PreStateName )
{
	if(isNowActiveFlightShipShortcut)	// ������忴���ٸ�
	{
		if( a_PreStateName == 'ShaderBuildState')
		{
			if(!Me.isShowwindow()) Me.ShowWindow();					//���� �������� ����
			if(ShortcutWnd.isShowwindow()) ShortcutWnd.HideWindow();
		}
	}
}

function OnExitState( name a_NextStateName )
{
	if( a_NextStateName != 'ShaderBuildState')	// ���̴� ���׷� ���� ��찡 �ƴ϶��,  üũ�ڽ��� �𽺿��̺��� Ǯ���ش�. 
	{
		Chk_EnterChatting.EnableWindow();	// �𽺿��̺� ����		
	}
}

function updateLockButton()
{
	m_IsLocked = GetOptionBool( "Game", "IsLockShortcutWnd" );
	if(m_IsLocked)
	{
		if(!LockBtn.isShowwindow()) LockBtn.ShowWindow();
		if(UnlockBtn.isShowwindow()) UnlockBtn.HideWindow();
	}
	else
	{
		if(LockBtn.isShowwindow()) LockBtn.HideWindow();
		if(!UnlockBtn.isShowwindow()) UnlockBtn.ShowWindow();
	}
	scriptShortcutWnd.ArrangeWnd();
}


// �̺�Ʈ ó��
function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_AirShipState:
		OnAirShipState( a_Param );
		break;
	case EV_AirShipAltitude:
		OnAirShipAltitude( a_Param);
		break;
	case EV_ShortcutCommandSlot:
		ExecuteShortcutCommandBySlot(a_Param);	// ����Ű ���� �̺�Ʈ
		break;
	case EV_ReserveShortCut:
		OnReserveShortCut( a_Param );
		break;
	case EV_ShortcutUpdate:
		HandleShortcutUpdate( a_Param );
		break;
	case EV_ShortcutPageUpdate:	// �������� ���� ������ ��ü�� ������Ʈ �Ѵ�.
		ShortCutUpdateAll();
		break;
	case EV_ShortcutClear:
		HandleShortcutClear();
		updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 			
		break;
	default:
		break;
	}
}

function OnAirShipState( string a_Param )
{
	local int VehicleID;
	local int IsDriver;
	
	ParseInt( a_Param, "VehicleID", VehicleID );	// ������ ���� ������ �� �� HP ���� �� UI�� RadarMapWnd.uc���� ó���ϵ��� �Ѵ�. 
	ParseInt( a_Param, "IsDriver", IsDriver );
	
	debug("VehicleID = " $ VehicleID $" IsDriver = " $ IsDriver);
	
	if( IsDriver > 0 )	//������ ����Ű ���
	{
		if(VehicleID > 0)	// ���� ��� ���̱�, ���������� �׻� ������ ���̵� �����Ͽ��� �Ѵ�. 
		{		
			preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//���� ����ä�� �ɼ��� �����صд�. 		
			SetOptionBool( "Game", "EnterChatting", true );	//���� ���� ä��
			Chk_EnterChatting.SetCheck(true);
			Chk_EnterChatting.DisableWindow();			// �𽺿��̺�
			
			class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");		//���� �׷� ����	
			updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 			
			if(!Me.isShowwindow()) 
			{
				Me.ShowWindow();					//���� �������� ����
				ShortcutWnd.HideWindow();
			}
			
			ChatEditBox.ReleaseFocus();
			
			isNowActiveFlightShipShortcut = true;
			m_preDriver = true;
		}
	}
	else	// ������ ���� isDriver == 0
	{
		if(VehicleID > 0 && m_preDriver == true)		// ���� ���°� ������忴������ ������ �����Ѵ�.
		{		
			Chk_EnterChatting.EnableWindow();	// �𽺿��̺� ����
			class'ShortcutAPI'.static.DeactivateGroup("FlightStateShortcut"); 	// ���� �׷� ����		
			
			SetOptionBool( "Game", "EnterChatting", preEnterChattingOption );	//����ص� ����ä�� �ɼ��� �ٽ� �־��ش�.
			if(preEnterChattingOption)	// ������ ��� ���¿� ���� ���� ä���� Ȱ��ȭ ���ش�.			
			{			
				class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
			}		
			Chk_EnterChatting.SetCheck(preEnterChattingOption);		
			
			if(Me.isShowwindow())	
			{
				Me.HideWindow();					// ���� �������� ��������
				ShortcutWnd.ShowWindow();
			}
			
			isNowActiveFlightShipShortcut = false;			
			ChatEditBox.ReleaseFocus();
		}
	}
}

function OnAirShipAltitude( string a_Param )
{
	local int m_nZ;
	
	ParseInt( a_Param, "Z" , m_nZ);
	
	AltitudeTxt.SetText(string(m_nZ + 4000));	// ���� ������Ʈ ���ش�. 
	
}

function ShortCutUpdateAll()
{
	local int nShortcutID;
	
	nShortcutID = MAX_ShortcutPerPage * FSShortcutPage;
	
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ), nShortcutID );
		nShortcutID++;
	}
}

// ���� ������Ʈ
function HandleShortcutUpdate(string param)
{
	local int nShortcutID;
	local int nShortcutNum;
	
	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ( nShortcutID - MAX_ShortcutPerPage * FSShortcutPage) + 1;
	
	debug(" ----------fs------------- id : " $ nShortcutID $ " nShortcutNum " $ nShortcutNum );
	
	if((nShortcutNum > 0 ) && ( nShortcutNum  < MAX_ShortcutPerPage + 1 ))	// ��������� ��쿡��  ������Ʈ
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ nShortcutNum, nShortcutID );
	}
}

 //���� Ŭ����
function HandleShortcutClear()
{		
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.clear( "FlightShipCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ) );
	}
}

function ExecuteShortcutCommandBySlot( string a_Param )
{
	local int slot;
	//local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 132������ 143�������� ������ ������ �������ش�. 
	if( (slot >= MAX_ShortcutPerPage * FSShortcutPage) && ( slot < MAX_ShortcutPerPage * (FSShortcutPage + 1)))
	{	
		//slotFromOne = slot - MAX_ShortcutPerPage * FSShortcutPage + 1;
		class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);
		//SelectTex.SetAnchor( "FlightShipCtrlWnd.FlightShortCut.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
	}
}

function OnReserveShortCut( string a_Param )
{
	local int slot;
	local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 132������ 143�������� ������ ������ ���� ���ش�.
	if( (slot >= MAX_ShortcutPerPage * FSShortcutPage) && ( slot < MAX_ShortcutPerPage * (FSShortcutPage + 1)))
	{	
		slotFromOne = slot - MAX_ShortcutPerPage * FSShortcutPage + 1;
		SelectTex.SetAnchor( "FlightShipCtrlWnd.FlightShortCut.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
		
		if( preSlot == slotFromOne )	// �̹� ���õ� ���¿��� �ѹ� �� ������ ����ȴ�.
		{
			class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);
		}
		else
		{
			preSlot = slotFromOne;
		}
	}
}

// �� ���, �ϰ� ��ư
function OnClickButton( String strID )
{
	switch( strID )
	{
	case "UpButton":
		Class'VehicleAPI'.static.AirShipMoveUp();	//�� ���
		break;
	case "DownButton":
		Class'VehicleAPI'.static.AirShipMoveDown(); // �� �ϰ�
		break;
	case "LockBtn":
		m_IsLocked = false;
		SetOptionBool( "Game", "IsLockShortcutWnd", false );
		updateLockButton();
		break;
	case "UnlockBtn":
		m_IsLocked = true;
		SetOptionBool( "Game", "IsLockShortcutWnd", true );
		updateLockButton();
		break;
	}
}
defaultproperties
{
}

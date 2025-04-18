class BR_EventRudolfWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";

const DIALOG_PETNAME		= 1111;				// ���̸�����
const DIALOG_GIVEITEMTOPET	= 2222;				// �κ����� ���κ����� ������ �ű��

const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
//~ const PET_EVOLUTIONIZED_ID = 16025;
const PET_EVOLUTIONIZED_ID = 1210114602;

var int			m_PetID;
var bool		m_bShowNameBtn;
var string		m_LastInputPetName;
var int 		EvolutionizedAction;

var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
var TextBoxHandle txtLvName;
var ItemWindowHandle PetActionWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_PetWndShow );
	RegisterEvent( EV_PetWndShowNameBtn );
	RegisterEvent( EV_PetWndRegPetNameFailed );
	RegisterEvent( EV_PetSummonedStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionPetListStart );
	RegisterEvent( EV_ActionPetList );
	
	RegisterEvent( EV_PetInventoryItemStart );
	RegisterEvent( EV_PetInventoryItemList );
	RegisterEvent( EV_PetInventoryItemUpdate );
	
	RegisterEvent( EV_LanguageChanged );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
}

function InitHandle()
{
	Me = GetHandle( "BR_EventRudolfWnd" );
	btnName = ButtonHandle ( GetHandle( "BR_EventRudolfWnd.btnName" ) );
	texPetHP = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetHP" ) );
	texPetMP = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetMP" ) );
	texPetFatigue = StatusBarHandle ( GetHandle( "BR_EventRudolfWnd.texPetFatigue" ) );
	txtLvName = TextBoxHandle ( GetHandle( "BR_EventRudolfWnd.txtLvName" ) );
	PetActionWnd = ItemWindowHandle ( GetHandle( "BR_EventRudolfWnd.PetWnd_Action.PetActionWnd" ) );
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "BR_EventRudolfWnd" );
	btnName = GetButtonHandle ( "BR_EventRudolfWnd.btnName" );
	texPetHP = GetStatusBarHandle( "BR_EventRudolfWnd.texPetHP" );
	texPetMP = GetStatusBarHandle( "BR_EventRudolfWnd.texPetMP" );
	texPetFatigue = GetStatusBarHandle( "BR_EventRudolfWnd.texPetFatigue" );
	txtLvName = GetTextBoxHandle( "BR_EventRudolfWnd.txtLvName" );
	PetActionWnd = GetItemWindowHandle ( "BR_EventRudolfWnd.PetWnd_Action.PetActionWnd" );
}

function OnShow()
{
	class'ActionAPI'.static.RequestPetActionList();
}

function HandleLanguageChanged()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		//~ debug("������ ������Ʈ �̺�Ʈ�� ����");
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetSummonedStatusClose();
	}
	else if (Event_ID == EV_PetWndShow)
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	}
	else if (Event_ID == EV_PetWndShowNameBtn)
	{
		HandlePetShowNameBtn(param);
	}
	else if (Event_ID == EV_PetWndRegPetNameFailed)
	{
		HandleRegPetName(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if (Event_ID == EV_ActionPetListStart)
	{
		//~ debug("�׼��׸��� �����.:");
		HandleActionPetListStart();
	}
	else if (Event_ID == EV_ActionPetList)
	{
		HandleActionPetList(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		class'ActionAPI'.static.RequestPetActionList();
	}

}

function HandleDialogOK()
{
	local int ID;
	local ItemID sID;
	local INT64 Number;
	
	if( DialogIsMine() )
	{
		ID = DialogGetID();
		sID = DialogGetReservedItemID();
		Number = StringToInt64(DialogGetString());
		
		if( id == DIALOG_PETNAME )
		{
			m_LastInputPetName = DialogGetString();
			RequestChangePetName(m_LastInputPetName);	//��� ����� EV_PetWndRegNameXXX�� ����´�.
		}
		else if( id == DIALOG_GIVEITEMTOPET )
		{
			class'PetAPI'.static.RequestGiveItemToPet(sID, Number);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnName":
		OnNameClick();
		break;
	}
}

function OnNameClick()
{
	DialogSetID(DIALOG_PETNAME);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
}

//�׼��� Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetActionWnd" && index>-1)
	{
		if (PetActionWnd.GetItem(index, infItem))
			DoAction(infItem.ID);
	}
}

//�ʱ�ȭ
function Clear()
{
	txtLvName.SetText("");
		
	texPetHP.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
	texPetMP.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
	texPetFatigue.SetPointPercent(IntToInt64(0), IntToInt64(0), IntToInt64(0));
}
function ClearActionWnd()
{
	PetActionWnd.Clear();
}

//���̸� ��� ��� ó��
function HandleRegPetName(string param)
{
	local int MsgNo;
	
	ParseInt(param, "ErrMsgNo", MsgNo);
		
	AddSystemMessage(MsgNo);
	DialogShow(DIALOG_Modalless,DIALOG_OKCancelInput, GetSystemMessage(535));
	
	//���̸��� ���ѱ��ڼ��� �ʰ��Ͽ��� ����, ���� �Է��� �̸��� �ٽ� ����Ѵ�.
	if (MsgNo==80)
	{
		DialogSetString(m_LastInputPetName);
	}
}

//���̸� ��ư ó��
function HandlePetShowNameBtn(string param)
{
	local int ShowFlag;
	ParseInt(param, "Show", ShowFlag);
	
	if (ShowFlag==1)
	{
		SetVisibleNameBtn(true);
	}
	else
	{
		SetVisibleNameBtn(false);
	}
}

function SetVisibleNameBtn(bool bShow)
{
	if (bShow)
	{
		btnName.ShowWindow();
	}
	else
	{
		btnName.HideWindow();
	}
	m_bShowNameBtn = bShow;
}

//����ó��
function HandlePetSummonedStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//��Info��Ŷ ó��
function HandlePetInfoUpdate()
{
	local string	Name;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Fatigue;
	local int		MaxFatigue;
	local int		SP;
	local int		Level;
	//local float		fExpRate;
	//local float		fTmp;
	local int 		nEvolutionID;
	local int		iTemp;
	
	local PetInfo	info;
	
	if( !Me.IsShowWindow() )
		return;
	
	if (GetPetInfo(info))
	{
		//Check Is Pet?
		if( info.bIsPetOrSummoned )
			return;
			
		m_PetID = info.nID;
		Name = info.Name;
		SP = info.nSP;
		Level = info.nLevel;
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		Fatigue = info.nFatigue;
		MaxFatigue = info.nMaxFatigue;
		nEvolutionID = info.nEvolutionID;
	}
	
	if (Level==1) {
		txtLvName.SetText( "[" $ GetSystemString(5051) $ "] " $ Name);
	} else if (Level==2) {
		txtLvName.SetText( "[" $ GetSystemString(5052) $ "] " $ Name);
	} else if (Level==3) {
		txtLvName.SetText( "[" $ GetSystemString(5053) $ "] " $ Name);
	} else if (Level==4) {
		txtLvName.SetText( "[" $ GetSystemString(5054) $ "] " $ Name);
	} else if (Level==5) {
		txtLvName.SetText( "[" $ GetSystemString(5055) $ "] " $ Name);
	} else if (Level==6) {
		txtLvName.SetText( "[" $ GetSystemString(5056) $ "] " $ Name);
	} else if (Level==7) {
		txtLvName.SetText( "[" $ GetSystemString(5057) $ "] " $ Name);
	}		
	
	iTemp = (SP/10000)%100;
	texPetHP.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	iTemp = (SP/100)%100;
	texPetMP.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	iTemp = SP%100;
	texPetFatigue.SetPointPercent(IntToInt64(iTemp), IntToInt64(0), IntToInt64(100));
	
	//��ȭ�� �꿡 ���� Ư�� �׼� ó��
	EvolutionizedAction = nEvolutionID;
	//~ debug("��ȭ���̵�:"@ EvolutionizedAction @ nEvolutionID);
	
}

//��â�� ǥ��
function HandlePetShow()
{
	//branch
	local UserInfo	a_UserInfo;
	local PetInfo	info;
	if (GetPetInfo(info)) {
		if (GetUserInfo( info.nID, a_UserInfo )) {
			if (a_UserInfo.nClassID != 1538) {
				return;
			}
		}
	}
	//end of branch
	
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	//~ debug("������ �̺�Ʈ�� ���Ƿ� ������");
	HandlePetInfoUpdate();
	
	//�̸���ư
	SetVisibleNameBtn(m_bShowNameBtn);
}

///////////////////////////////////////////////////////////////////////////////////////
// �׼� ������ ó��
///////////////////////////////////////////////////////////////////////////////////////
function HandleActionPetListStart()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
}

function HandleActionPetList(string param)
{
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	local int intClassID;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "ClassID", intClassID);
	
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//~ ClearActionWnd();
	
	//ItemWnd�� �߰�
	Type = EActionCategory(Tmp);

	//���� ������ �׼� �߰� ��� 
	if (Type==ACTION_PET)
	{
		if (intClassID == 16 || intClassID == 18)
		{
			//~ debug("�ɷ���2");
		}
		else
		{
			PetActionWnd.AddItem(infItem);
		}
	}
}
defaultproperties
{
}

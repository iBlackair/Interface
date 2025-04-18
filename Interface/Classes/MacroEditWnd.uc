class MacroEditWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;
const MACROCOMMAND_MAX_COUNT = 12;
const MACROICON_MAX_COUNT = 104;
const MACRO_ICONANME = "L2UI.MacroWnd.Macro_Icon";

var bool	m_bShow;
var int		m_CurIconNum;
var ItemID	m_CurMacroItemID;

var WindowHandle m_MacroEditWnd_Input;
var WindowHandle m_MacroEditWnd_IconList;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	
	RegisterEvent( EV_MacroShowEditWnd );
	RegisterEvent( EV_MacroDeleted );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_MacroEditWnd_Input = GetHandle("MacroEditWnd.MacroEditWnd_Input");
		m_MacroEditWnd_IconList = GetHandle("MacroEditWnd.MacroEditWnd_IconList");
	}
	else {
		m_MacroEditWnd_Input = GetWindowHandle("MacroEditWnd.MacroEditWnd_Input");
		m_MacroEditWnd_IconList = GetWindowHandle("MacroEditWnd.MacroEditWnd_IconList");
	}
	m_bShow = false;
	m_CurIconNum = 1;
	ClearItemID(m_CurMacroItemID);
	
	InitTabOrder();
	
	HandleMacroList();
}

function OnShow()
{
	m_bShow = true;
	if ( m_MacroEditWnd_IconList.IsShowWindow() )
	{
		swapWindow();
	}
}

function OnHide()
{
	m_bShow = false;
}

function HandleMacroList ()
{
  local int idx;
  local ItemInfo infItem;

  Class'UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", MACRO_ICONANME $ m_CurIconNum);
  Clear();
  for (idx = 0; idx < MACROICON_MAX_COUNT; idx++)
  {
    infItem.IconName = MACRO_ICONANME $ (idx + 1);
    infItem.ItemSubType = 4;
    Class'UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroItem",infItem);
  }
}

function swapWindow ()
{
  local ButtonHandle btnIconChange;

  btnIconChange = GetButtonHandle("MacroEditWnd.btnIconChange");
  if ( m_MacroEditWnd_Input.IsShowWindow() )
  {
    btnIconChange.SetButtonName(473);
    m_MacroEditWnd_Input.HideWindow();
    m_MacroEditWnd_IconList.ShowWindow();
  } else {
    btnIconChange.SetButtonName(424);
    m_MacroEditWnd_Input.ShowWindow();
    m_MacroEditWnd_IconList.HideWindow();
  }
}

function OnClickButton( string strID )
{	
	switch( strID )
	{
	case "btnInfo":
		OnClickInfo();
		break;
	case "btnHelp":
		OnClickHelp();
		break;
	case "btnCancel":
		OnClickCancel();
		break;
	case "btnSave":
		OnClickSave();
		break;
	case "btnIconChange":
		onClickIconChange();
		break;
	}
}

function onClickIconChange ()
{
  swapWindow();
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_MacroShowEditWnd)
	{
		HandleMacroShowEditWnd(param);
	}
	else if (Event_ID == EV_MacroDeleted)
	{
		HandleMacroDeleted(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
		}
	}
}

function OnClickItem (string strID, int Index)
{
  local ItemInfo infItem;

  if ( (strID == "MacroItem") && (Index > -1) )
  {
    if ( class'UIAPI_ITEMWINDOW'.static.GetItem("MacroEditWnd.MacroItem",Index,infItem) )
    {
      m_CurIconNum = Index + 1;
      class'UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", MACRO_ICONANME $ m_CurIconNum);
      swapWindow();
    }
  }
}

function InitTabOrder()
{
	local int idx;
	
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd", "MacroEditWnd.txtName", "MacroEditWnd.txtShortName");
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtName", "MacroEditWnd.txtShortName", "MacroEditWnd");
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtShortName", "MacroEditWnd.txtEdit0", "MacroEditWnd.txtName");
	for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
	{
		if (idx==0)
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit0", "MacroEditWnd.txtEdit1", "MacroEditWnd.txtShortName");
		else if (idx==MACROCOMMAND_MAX_COUNT-1)
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit11", "MacroEditWnd.txtName", "MacroEditWnd.txtEdit10");
		else
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit" $ idx, "MacroEditWnd.txtEdit" $ idx+1, "MacroEditWnd.txtEdit" $ idx-1);
	}
}

//////////////////////////////////////////////////////////////////////////////////
//�߰� ����
function OnClickInfo()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow("MacroInfoWnd"))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroInfoWnd");
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);	
		class'UIAPI_WINDOW'.static.ShowWindow("MacroInfoWnd");
		class'UIAPI_WINDOW'.static.SetFocus("MacroInfoWnd");
	}
}

//////////////////////////////////////////////////////////////////////////////////
//���� ��ư
function OnClickHelp()
{
	local Actor PlayerActor;
	local Actor A;
	local int Up;
	
	PlayerActor = GetPlayerActor();
	//PlayerActor.GetHumanReadableName();
	//sysDebug("Location X: " @ PlayerActor.Location.X);
	sysDebug("Begin: " @ PlayerActor.Location.X);
	//sysDebug("Begin: " @ PlayerActor.AllActors(class'Actor').Num());
	

	//ForEach PlayerActor.AllActors(class'Actor', A)
	ForEach PlayerActor.DynamicActors(class'Actor', A)
	{
		//sysDebug("Name: " $ A.Name);
		if(Up++ >= 190){
			sysDebug("Name: " $ A.Name);		
			break;
		}
	}
		
		
		
   //sysDebug("Name: " $ A.Name);
     sysDebug("Name: " @ Up);
	


	sysDebug("End: " @ PlayerActor.Location.X);	
	//local string strParam;
	//ParamAdd(strParam, "FilePath", "..\\L2text\\help_macro.htm");
	//ExecuteEvent(EV_ShowHelp, strParam);
}

//////////////////////////////////////////////////////////////////////////////////
//��� ��ư
function OnClickCancel()
{
	class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
}

//////////////////////////////////////////////////////////////////////////////////
//���� ��ư
function OnClickSave()
{
	SaveMacro();
}

//////////////////////////////////////////////////////////////////////////////////
// Drag & Drop
function OnDropItem( String strID, ItemInfo infItem, int x, int y )
{
	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd." $ strID, infItem.MacroCommand);
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, FALSE);
}

function OnDragItemStart( String strID, ItemInfo infItem )
{
	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, TRUE);
}

function OnDragItemEnd( String strID )
{
	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, FALSE);
}

//////////////////////////////////////////////////////////////////////////////////
// Macro Icon
function OnChangeEditBox( String strID )
{
	switch( strID )
	{
	case "txtShortName":
		UpdateIconName();
		break;
	}
}

function UpdateIcon()
{
	class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ m_CurIconNum);
}

function UpdateIconName()
{
	local string strShortName;
	
	strShortName = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtShortName");
	class'UIAPI_TEXTBOX'.static.SetText( "MacroEditWnd.txtMacroName", strShortName);
}

//////////////////////////////////////////////////////////////////////////////////
// Clear
function Clear()
{
	local int idx;

	m_CurIconNum = 1;
	
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtName", "");
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtShortName", "");
	for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
	{
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ idx, "");
	}
	UpdateIcon();
	UpdateIconName();
	//m_MacroEditWnd.SetScrollPosition(0); // ��ũ�ѹ� �ʱ�ȭ
}

//���� �������� �ִ� ��ũ�ΰ� �����Ǿ��ٸ� Hide��Ų��.
function HandleMacroDeleted(string param)
{
	local ItemID cID;
	ParseItemID(param, cID);
	if (m_bShow && IsSameItemID(m_CurMacroItemID, cID))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	}
}

function HandleMacroShowEditWnd(string param)
{
	local int MacroCount;
	local color TextColor;
	
	Clear();
	ClearItemID(m_CurMacroItemID);
	
	//�������
	if (ParseItemID(param, m_CurMacroItemID))
	{
		SetMacroID(m_CurMacroItemID);
		if (!m_bShow)
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
		}
		class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
	}
	//�߰����
	else
	{
		if (m_bShow)
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
		}
		else
		{
			//Check Macro Count
			MacroCount = class'UIDATA_MACRO'.static.GetMacroCount();
			if (MacroCount>=MACRO_MAX_COUNT)
			{
				TextColor.R = 176;
				TextColor.G = 155;
				TextColor.B = 121;
				TextColor.A = 255;
				DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(797));
				DialogSetID(0);	
				//AddSystemMessage(GetSystemMessage(797), TextColor);
				return;
			}
			
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
			class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////
// �ش� MacroID�� ȭ�� ǥ��
function SetMacroID(ItemID cID)
{
	local int idx;
	local MacroInfo info;
	local MacroInfoWnd Script;
	
	if (!IsValidItemID(cID))
		return;
		
	if (class'UIDATA_MACRO'.static.GetMacroInfo(cID, info))
	{
		//�̸�
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtName", info.Name);
		//�����̸�
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtShortName", info.IconName);
		//������
		m_CurIconNum = int(Right(info.IconTextureName, 1));
		if (m_CurIconNum<1)
			m_CurIconNum = 1;
		UpdateIcon();
		//����
		Script = MacroInfoWnd(GetScript("MacroInfoWnd"));
		Script.SetInfoText(info.Description);
		//Ŀ�ǵ�12��
		for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
		{
			class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ idx, info.CommandList[idx]);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////
// ��ũ�� ����
function SaveMacro()
{
	local int idx;
	local MacroInfoWnd Script;
	
	local string		Name;
	local string		IconName;
	local string		Description;
	local string		Command;
	local array<string> CommandList;
	
	
	Script = MacroInfoWnd(GetScript("MacroInfoWnd"));
	Name = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtName");
	IconName = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtShortName");
	Description = Script.GetInfoText();
	for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
	{
		Command = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ idx);
		CommandList.Insert(CommandList.Length, 1);
		CommandList[CommandList.Length-1] = Command;
	}
	
	if (class'MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, Name, IconName, m_CurIconNum-1, Description, CommandList))
	{
		class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");		
	}
}
defaultproperties
{
}

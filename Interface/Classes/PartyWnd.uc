//================================================================================
// PartyWnd.
//================================================================================

class PartyWnd extends UICommonAPI;

const SMALL_BUF_ICON_SIZE= 6;
const NPARTYSTATUS_MAXCOUNT= 9;
const NPARTYPETSTATUS_HEIGHT= 18;
const NPARTYSTATUS_HEIGHT= 46;//46 default, 56 edkith
const NSTATUSICON_MAXCOL= 12;
const TIMER_ON_ASSIST = 6655;

struct VnameData
{
	var int ID;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};

var bool	m_bCompact;	//???? ????.
var bool	m_bBuff;		//?? ???? ???.

var int		m_arrID[NPARTYSTATUS_MAXCOUNT];	// ???? ???? ???? ?? ID.
var int		m_arrPetID[NPARTYSTATUS_MAXCOUNT];	// ???? ???? ???? ???? ID.
var int		m_arrPetIDOpen[NPARTYSTATUS_MAXCOUNT];	// ???? ???? ???? ?? ?? ????? ??. 1?? ??, 2?? ??. -1?? ??
var int		m_CurCount;	
var int 		m_CurBf;
var int		m_TargetID;
var int		m_LastChangeColor;
var int 	g_AssistLeader;
var int		g_PrevTarget;
var int		g_NextTarget;
var int		g_CurrIndex;
var int 	g_MsgAutoAssist;
var bool 	IsTargetChanged;

var VnameData m_Vname[8];
var bool m_AmIRoomMaster; //??? ???? ????? ??? ??. PartyMatchRoomWnd? ??? ???? ??? ??? ????
//Handle ? ??.
var WindowHandle		m_wndTop;
var WindowHandle		m_PartyStatus[NPARTYSTATUS_MAXCOUNT];
var WindowHandle		m_PlayerLevel[NPARTYSTATUS_MAXCOUNT];
var WindowHandle		m_PartyOption;
var NameCtrlHandle		m_PlayerName[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_ClassIcon[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_DetailedClassIcon[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_LeaderIcon[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconSongDance[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_StatusIconTriggerSkill[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarCP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_BarMP[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle			btnBuff;

var ButtonHandle			m_petButton[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle			m_petButtonTrash[NPARTYSTATUS_MAXCOUNT];

var WindowHandle		m_PetPartyStatus[NPARTYSTATUS_MAXCOUNT];
//var NameCtrlHandle		m_PetName[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconSongDance[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconTriggerSkill[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_PetClassIcon[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarMP[NPARTYSTATUS_MAXCOUNT];

var int partymasteridx;
var ComboBoxHandle ed_cbAbnormalType;
var ComboBoxHandle cb_Assist;
var WindowHandle m_QuickOptions;

var TextBoxHandle PlayerLevel[NPARTYSTATUS_MAXCOUNT];
//var CheckBoxHandle	c_permaCheck;
var bool			underAggr;
var bool			isDeBuffOnly;
var bool			isGotAssist;

var PartyWndOption script_pt_opt;

function OnRegisterEvent ()
{
  RegisterEvent(1000);
  RegisterEvent(1140);
  RegisterEvent(1150);
  RegisterEvent(1160);
  RegisterEvent(1170);
  RegisterEvent(1180);
  RegisterEvent(1181);
  RegisterEvent(3110);
  RegisterEvent(3120);
  RegisterEvent(3130);
  RegisterEvent(1050);
  RegisterEvent(1110);
  RegisterEvent(40);
  RegisterEvent(980);
  RegisterEvent(290);
  RegisterEvent(280);
  RegisterEvent( EV_ChatMessage );
  RegisterEvent( EV_ChatWndStatusChange );
  
  RegisterEvent(EV_ReceiveAttack);
  RegisterEvent(EV_ReceiveMagicSkillUse);
}

function OnLoad ()
{
  local int idx;

  if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	
  partymasteridx = -1;
  m_bCompact = False;
  m_bBuff = False;
  m_CurBf = GetOptionInt("UIExtender","AbnormalDisplayNum");
  script_pt_opt = PartyWndOption(GetScript("PartyWndOption"));
  //m_CurCastDisplayDirection = GetOptionInt("UIExtender","CastDisplayDirection");
  m_targetID = -1;
  m_LastChangeColor = -1;
  m_AmIRoomMaster = False;
  ed_cbAbnormalType.Clear();
  ed_cbAbnormalType.AddString("None");
  ed_cbAbnormalType.AddString("Buff");
  ed_cbAbnormalType.AddString("Debuff");
  ed_cbAbnormalType.AddString("SD");
  ed_cbAbnormalType.AddString("Trigger");
  ed_cbAbnormalType.AddString("B+D");
  ed_cbAbnormalType.AddString("B+SD");
  ed_cbAbnormalType.AddString("SD+D");
  ed_cbAbnormalType.SetSelectedNum(m_CurBf);
  if (m_CurBf == 2)
  {
	  isDeBuffOnly = true;
	  for (idx = 0; idx < 9; idx++)
		m_StatusIconDeBuff[idx].SetIconSize(24);
  }
	
  //ed_cbCastDisplayDirection.SetSelectedNum(m_CurCastDisplayDirection);

  for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
  {
    m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
    m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
    m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
    m_StatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
    m_PetStatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
    m_PetStatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
    m_PetStatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
    m_PetStatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
    HideWindow("PartyWnd.PartyStatusWnd" $ string(idx) $ ".CastInfoWnd");
  }
  
  m_PartyOption.HideWindow();
  
  for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
  {
    m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
  }
  ResetVName();
}

function InitHandle ()
{
  local int idx;

  m_wndTop = GetHandle("PartyWnd");
  m_PartyOption = GetHandle("PartyWndOption");
  m_QuickOptions = GetHandle("PartyWnd.QuickOptionsWnd");
  ed_cbAbnormalType = ComboBoxHandle(GetHandle("PartyWnd.QuickOptionsWnd.cbAbnormalType"));
  for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
  {
    m_PartyStatus[idx] = GetHandle("PartyWnd.PartyStatusWnd" $ string(idx));
    m_PlayerName[idx] = NameCtrlHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".PlayerName"));
    m_ClassIcon[idx] = TextureHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".ClassIcon"));
    m_DetailedClassIcon[idx] = TextureHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".DetailedClassIcon"));
    m_LeaderIcon[idx] = TextureHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LeaderIcon"));
    m_StatusIconBuff[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconBuff"));
    m_StatusIconDeBuff[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconDeBuff"));
    m_StatusIconSongDance[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconSongDance"));
    m_StatusIconTriggerSkill[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconTriggerSkill"));
    m_BarCP[idx] = BarHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barCP"));
    m_BarHP[idx] = BarHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barHP"));
    m_BarMP[idx] = BarHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barMP"));
    m_petButton[idx] = ButtonHandle(GetHandle("PartyWnd.btnSummon" $ string(idx)));
    m_petButton[idx].HideWindow();
    m_PetPartyStatus[idx] = GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx));
    m_PetClassIcon[idx] = TextureHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".ClassIcon"));
    m_PetStatusIconBuff[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconBuff"));
    m_PetStatusIconDeBuff[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconDebuff"));
    m_PetStatusIconSongDance[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconSongDance"));
    m_PetStatusIconTriggerSkill[idx] = StatusIconHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconTriggerSkill"));
    m_PetBarHP[idx] = BarHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".barHP"));
    m_PetBarMP[idx] = BarHandle(GetHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".barMP"));
    m_arrPetIDOpen[idx] = -1;
    m_arrID[idx] = 0;
    if ( idx == 0 )
    {
      m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopLeft","TopRight",0,32);
    } else {
      m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopLeft","TopRight",0,2);
    }
	m_PlayerLevel[idx] = GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LevelBox");
	PlayerLevel[idx] = TextBoxHandle(GetHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LevelBox.txtLvl"));
  }
}

function InitHandleCOD ()
{
  local int idx;

  m_wndTop = GetWindowHandle("PartyWnd");
  m_PartyOption = GetWindowHandle("PartyWndOption");
  m_QuickOptions = GetWindowHandle("PartyWnd.QuickOptionsWnd");
  ed_cbAbnormalType = GetComboBoxHandle("PartyWnd.QuickOptionsWnd.cbAbnormalType");
  cb_Assist = GetComboBoxHandle("PartyWnd.QuickOptionsWnd.cbAssist");
  //c_permaCheck = GetCheckBoxHandle("PartyWnd.QuickOptionsWnd.permaCheck");

  for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
  {
    m_PartyStatus[idx] = GetWindowHandle("PartyWnd.PartyStatusWnd" $ string(idx));
    m_PlayerName[idx] = GetNameCtrlHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".PlayerName");
    m_ClassIcon[idx] = GetTextureHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".ClassIcon");
    m_DetailedClassIcon[idx] = GetTextureHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".DetailedClassIcon");
    m_LeaderIcon[idx] = GetTextureHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LeaderIcon");
    m_StatusIconBuff[idx] = GetStatusIconHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconBuff");
    m_StatusIconDeBuff[idx] = GetStatusIconHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconDeBuff");
    m_StatusIconSongDance[idx] = GetStatusIconHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconSongDance");
    m_StatusIconTriggerSkill[idx] = GetStatusIconHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".StatusIconTriggerSkill");
    m_BarCP[idx] = GetBarHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barCP");
    m_BarHP[idx] = GetBarHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barHP");
    m_BarMP[idx] = GetBarHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".barMP");
    m_petButton[idx] = GetButtonHandle("PartyWnd.btnSummon" $ string(idx));
    m_petButton[idx].HideWindow();
    m_PetPartyStatus[idx] = GetWindowHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx));
    m_PetClassIcon[idx] = GetTextureHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".ClassIcon");
    m_PetStatusIconBuff[idx] = GetStatusIconHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconBuff");
    m_PetStatusIconDeBuff[idx] = GetStatusIconHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconDebuff");
    m_PetStatusIconSongDance[idx] = GetStatusIconHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconSongDance");
    m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".StatusIconTriggerSkill");
    m_PetBarHP[idx] = GetBarHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".barHP");
    m_PetBarMP[idx] = GetBarHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx) $ ".barMP");
    m_arrPetIDOpen[idx] = -1;
    m_arrID[idx] = 0;
    if ( idx == 0 )
    {
      m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopLeft","TopRight",0,32);
    } else {
      m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopLeft","TopRight",0,2);
    }
	m_PlayerLevel[idx] = GetWindowHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LevelBox");
	PlayerLevel[idx] = GetTextBoxHandle("PartyWnd.PartyStatusWnd" $ string(idx) $ ".LevelBox.txtLvl");
  }
}

function OnShow ()
{
  m_QuickOptions.ShowWindow();
}

function OnHide ()
{
  ResetVName();
}

function OnEnterState (name a_PreStateName)
{
  m_bCompact = False;
  m_bBuff = False;
  m_CurBf = GetOptionInt("UIExtender","AbnormalDisplayNum");
  ResizeWnd();
}

function UpdateCBAssist(int pCount)
{
	local int i;
	local string name;
	
	g_AssistLeader = 0;
	cb_Assist.Clear();
	cb_Assist.AddString("None");
	
	for (i = 1; i < pCount + 1; i++)
	{
		name = m_PlayerName[i-1].GetName();
		cb_Assist.AddStringWithReserved(name,m_arrID[i-1]);
	}
	cb_Assist.SetSelectedNum(0);	
}

function OnEvent (int Event_ID, string param)
{
  if ( Event_ID == 1140 )
  {
    HandlePartyAddParty(param);
	UpdateCBAssist(m_CurCount);
  } else if ( Event_ID == 1150 )
  {
    HandlePartyUpdateParty(param);
  } else if ( Event_ID == 1160 )
  {
    HandlePartyDeleteParty(param);
	UpdateCBAssist(m_CurCount);
  } else if ( Event_ID == 1170 )
  {
    HandlePartyDeleteAllParty();
  } else if ( (Event_ID == 1180) || (Event_ID == 1050) || (Event_ID == 1110) )
  {
    HandlePartySpelledList(param);
  } else if ( Event_ID == 1000 )
  {
    HandleShowBuffIcon(param);
  } else if ( Event_ID == 3110 )
  {
    HandlePartySummonAdd(param);
  } else if ( Event_ID == 3120 )
  {
    HandlePartySummonUpdate(param);
  } else if ( Event_ID == 3130 )
  {
    HandlePartySummonDelete(param);
  } else if ( Event_ID == 40 )
  {
    HandleRestart();
  } else if ( Event_ID == 980 )
  {
    HandleCheckTarget();
  } else if ( Event_ID == 1181 )
  {
    HandlePartyRenameMember(param);
  } else if ( Event_ID == EV_ReceiveAttack && g_AssistLeader > 0)
  {
    RecAttack(param);
  } else if ( Event_ID == EV_ReceiveMagicSkillUse && g_AssistLeader > 0)
  {
    RecSkillUse(param);
  } 
  else if ( Event_ID == EV_ChatMessage && g_AssistLeader > 0)
  {
    GetTargetFromAssistLeader(param);
  }
}

function WriteTargetToPartyChat(int msg)
{
	if (msg < 1)
	{
		return;
	}
	if (g_MsgAutoAssist == msg)
	{
		return;
	}
	g_MsgAutoAssist = msg;
	ProcessChatMessage(string(g_MsgAutoAssist), 0);
	sysDebug(string(g_MsgAutoAssist));
}

function GetTargetFromAssistLeader(string param)
{
	local int nTmp;
	local EChatType type;
	local string text;
	local string message;
	local string name;
	local UserInfo info;

	ParseInt(param, "Type", nTmp);

	type = EChatType(nTmp);

	if (type == CHAT_PARTY)
	{
		ParseString(param, "Msg", text);
		GetUserInfo(g_AssistLeader, info);
		message = Mid(text, InStr(text, ": ") + 2);
		name = Mid(text, 0, InStr(text, ": "));
		if (name == info.Name) //If true - message == targetID
		{
			RequestTargetUser( int(message) );
		}
	}
}

function bool IsSkillOperatorInParty (int UserID, out int idx)
{
  local int i;
  local bool bResult;

  bResult = False;

  for (i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
  {
    if ( m_arrID[i] == UserID )
    {
      idx = i;
      bResult = True;
    }
  }
  return bResult;
}

function HandlePartyRenameMember (string param)
{
  local int idx;
  local int Id;
  local int UseVName;
  local int DominionIDForVName;
  local string VName;
  local string SummonVName;

  ParseInt(param,"ID",Id);
  ParseInt(param,"UseVName",UseVName);
  ParseInt(param,"DominionIDForVName",DominionIDForVName);
  ParseString(param,"VName",VName);
  ParseString(param,"SummonVName",SummonVName);
  idx = GetVNameIndexByID(Id);
  if ( idx > -1 )
  {
    m_Vname[idx].Id = Id;
    m_Vname[idx].UseVName = UseVName;
    m_Vname[idx].DominionIDForVName = DominionIDForVName;
    m_Vname[idx].VName = VName;
    m_Vname[idx].SummonVName = SummonVName;
    ExecuteEvent(980);
  }
}

function HandleCheckTarget ()
{
}

function HandleRestart ()
{
  Clear();
}

function Clear ()
{
  local int idx;

  for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
  {
    ClearStatus(idx);
    ClearPetStatus(idx);
  }
  m_CurCount = 0;
  m_targetID = -1;
  m_LastChangeColor = -1;
  ResizeWnd();
}

function ClearStatus (int idx)
{
  m_StatusIconBuff[idx].Clear();
  m_StatusIconDeBuff[idx].Clear();
  m_StatusIconSongDance[idx].Clear();
  m_StatusIconTriggerSkill[idx].Clear();
  m_PlayerName[idx].SetName("", NCT_Normal,TA_Center);
  m_LeaderIcon[idx].SetTexture("");
  m_ClassIcon[idx].SetTexture("");
  m_DetailedClassIcon[idx].SetTexture("");
  m_PlayerLevel[idx].HideWindow();
  PlayerLevel[idx].SetText("");
  UpdateCPBar(idx,0,0);
  UpdateHPBar(idx,0,0);
  UpdateMPBar(idx,0,0);
  m_arrID[idx] = 0;
}

function ClearPetStatus (int idx)
{
  m_PetStatusIconBuff[idx].Clear();
  m_PetStatusIconDeBuff[idx].Clear();
  m_PetClassIcon[idx].SetTexture("");
  UpdateHPBar(idx + 100,0,0);
  UpdateMPBar(idx + 100,0,0);
  if ( m_PetPartyStatus[idx].IsShowWindow() )
  {
    m_PetPartyStatus[idx].HideWindow();
  }
  if ( m_petButton[idx].IsShowWindow() )
  {
    m_petButton[idx].HideWindow();
  }
  m_arrPetID[idx] = 0;
  m_arrPetIDOpen[idx] = -1;
}

function CopyStatus(int DesIndex, int SrcIndex)
{
	local string	strTmp;	
	local int		MaxValue;	// CP, HP, MP? ???.
	local int		CurValue;	// CP, HP, MP? ???.
	
	local int		Width;
	local int		Height;
	
	local int		Row;
	local int		Col;
	local int		MaxRow;
	local int		MaxCol;
	local StatusIconInfo info;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;
	
	//ServerID
	m_arrID[DesIndex] = m_arrID[SrcIndex];
	
	//Name
	m_PlayerName[DesIndex].SetName(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Center);
	
	
	if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.showNewIcons"))
	{
		//Class Texture
		m_DetailedClassIcon[DesIndex].SetTexture(m_DetailedClassIcon[SrcIndex].GetTextureName());
		//Class Tooltip
		m_DetailedClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
		m_DetailedClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	}
	else
	{
		//Class Texture
		m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
		//Class Tooltip
		m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
		m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	}
	
	
	//??? Texture
	strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
	m_LeaderIcon[DesIndex].SetTexture(strTmp);
	if (Len(strTmp)>0)
	{
		//???? ??? ?? ??????.
		strTmp = m_PlayerName[DesIndex].GetName();
		GetTextSizeDefault(strTmp, Width, Height);
		m_LeaderIcon[DesIndex].SetAnchor("PartyWnd.PartyStatusWnd" $ DesIndex, "TopCenter", "TopLeft", -(Width/2)-18, 8);
		m_LeaderIcon[DesIndex].ShowWindow();
	}
	//?? ?? ??
	m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
	m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	
	//CP,HP,MP
	m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_StatusIconBuff[DesIndex].Clear();
	MaxRow = m_StatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_StatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//SongDanceStatus
	m_StatusIconSongDance[DesIndex].Clear();
	MaxRow = m_StatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_StatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}
	
	
	// -------------------------------------------?? ????. 
	//ServerID
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
	
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];	
	m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];;	
	
	//Name
	//m_PetName[DesIndex].SetName(m_PetName[SrcIndex].GetName(), NCT_Normal,TA_Center);

	
	//Class Texture
	//m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	//m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	//m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//CP,HP,MP
	m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_PetStatusIconBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_PetStatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}

	//SongDanceStatus
	m_PetStatusIconSongDance[DesIndex].Clear();
	MaxRow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_PetStatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}	
}

function ResizeWnd()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i;
	local int OpenPetCount;
	
	// SetOptionBool? ??. ? ??? PartyWndOption ?? ???
	bOption = GetOptionBool( "Game", "SmallPartyWnd" );
	
	if (m_CurCount>0)
	{
		OpenPetCount=0;
		for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
		{
			if(m_arrPetIDOpen[i] == 1) OpenPetCount++;
			else 	// ???? ??? ???..
			{
				 if(m_PetPartyStatus[i].IsShowWindow()) m_PetPartyStatus[i].HideWindow();
			}
		}
		
		//??? ??? ??
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, NPARTYSTATUS_HEIGHT*m_CurCount + OpenPetCount * NPARTYPETSTATUS_HEIGHT );	
		// ??? ??? ?? ??? ????? ????. 
		m_wndTop.SetResizeFrameSize(10, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT);
		if (!bOption)	// ???? ??? ???? ??? ?? (???) ???? ???
			m_wndTop.ShowWindow();
		else
			m_wndTop.HideWindow();
				
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			if (idx<=m_CurCount-1)
			{
				if(idx >0 )	 //1 ????? anchor? ?????.
				{
					if(m_arrPetIDOpen[idx-1] == 1) // ? ???? ???? ?????
					{
						m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// ? ??? ??? ??
					}
					else// ? ???? ???? ????? ???? ???
					{
						m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// ??? ??? ??
					}
				}
				if(m_arrID[idx]!= 0 )
				{
					if (m_arrPetIDOpen[idx] > -1)  m_petButton[idx].showWindow();
					else	m_petButton[idx].HideWindow();
					m_PartyStatus[idx].SetVirtualDrag( true );
					m_PartyStatus[idx].ShowWindow();
				}
				if(m_arrPetIDOpen[idx] == 1) m_PetPartyStatus[idx].ShowWindow();
			}
			else
			{
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag( false );
				m_PartyStatus[idx].HideWindow();
				m_PetPartyStatus[idx].HideWindow();
			}
		}
	}
	else	// ???? ???? ??? ? ???? ??? ???.
	{
		m_wndTop.HideWindow();
		m_PetPartyStatus[idx].HideWindow();
	}
}

//ID? ??? ???? ????? ???
function int FindPartyID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

function int FindPetID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrPetID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ADD	??? ??.
function HandlePartyAddParty(string param)
{
	local int ID;
	local int SummonID;
	
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	ParseInt(param, "ID", ID);	// ID? ????.
	ParseInt(param, "SummonID", SummonID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);	
	
	if (ID>0)
	{
		m_Vname[m_CurCount].ID = ID;
		m_Vname[m_CurCount].UseVName = UseVName;
		m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
		m_Vname[m_CurCount].VName = VName;
		m_Vname[m_CurCount].SummonVName = SummonVName;
		ExecuteEvent( EV_TargetUpdate);
	
		m_CurCount++;	
		
		m_arrID[m_CurCount-1] = ID;
		UpdateStatus(m_CurCount-1, param);
		if(SummonID > 0)	// ???? ??? ???? ???
		{
			m_arrPetID[m_CurCount-1] = SummonID;
			m_arrPetIDOpen[m_CurCount-1] = 1;
			UpdatePetStatus(m_CurCount-1, param $"SummonMasterID = "$ID );
			m_petButton[m_CurCount-1].showWindow();
			if( !m_PetPartyStatus[m_CurCount-1].isShowwindow())
			{
				m_PetPartyStatus[m_CurCount-1].ShowWindow();
			}
		}
		ResizeWnd();
	}
}

function bool AmILeader() //??? ??(?????? ???? ?????)??? ????. ???? ?????? ???? ??? ?????? ????? ???? ??.
{
	local int	i;
	local bool res;
	res = true; //?? ?????
	if(m_CurCount == 0) res = false; //???? ??? ??? ???
	for(i = 0; i < m_CurCount; i++)
	{
		if(m_LeaderIcon[i].GetTextureName() != "")
		{
			res = false; //?????? ???? ????. ?? ?? ?? ????
			break;
		}
	}
	
	return (res || m_AmIRoomMaster); //?? ????? ???? ???? ?? ???
}

function HandlePartyUpdateParty(string param)
{
	local int	ID;
	local int	idx;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		UpdateStatus(idx, param);	// ?? ???? ??? ??? ??
	}
}

//DELETE	?? ???? ??.
function HandlePartyDeleteParty(string param)
{
	local int	ID;
	local int	idx;
	local int	i;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		if (idx>-1)
		{	
			for (i=idx; i<m_CurCount-1; i++)	// ????? ??? ??? ????? ????. 
			{
				CopyStatus(i, i+1);
			}
			ClearStatus(m_CurCount-1);
			ClearPetStatus(m_CurCount-1);
			m_CurCount--;
			ResizeWnd();	// ?? ???? ???? ??? ??? ?????? ???.
		}
	}
}

function HandlePartyDeleteAllParty ()
{
  Clear();
}

function SetMasterTooltip(int lootingtype)
{
	if(partymasteridx < NPARTYSTATUS_MAXCOUNT && partymasteridx > -1)
		m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(lootingtype)));	
}

function ChangeMemberIcons()
{
	local int idx;
	local UserInfo memInfo;
	
	for (idx = 0; idx < m_CurCount; idx++)
	{
		GetUserInfo(m_arrID[idx], memInfo);
		
		if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.showNewIcons"))
		{
			m_ClassIcon[idx].SetTexture("");
			m_ClassIcon[idx].HideWindow();
			m_DetailedClassIcon[idx].ShowWindow();
			m_DetailedClassIcon[idx].SetTexture(GetDetailedClassIconName(memInfo.nSubClass));
			m_DetailedClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(memInfo.nSubClass) $ " - " $ GetClassType(memInfo.nSubClass)));
		}
		else
		{
			m_DetailedClassIcon[idx].SetTexture("");
			m_DetailedClassIcon[idx].HideWindow();
			m_ClassIcon[idx].ShowWindow();
			m_ClassIcon[idx].SetTexture(GetClassIconName(memInfo.nSubClass));
			m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(memInfo.nSubClass) $ " - " $ GetClassType(memInfo.nSubClass)));
		}
	}
	//sysDebug("ICONS CHANGED");
}

function UpdateStatus(int idx, string param)
{
	local string	Name;
	local int		MasterID;
	local int		RoutingType;
	local int		ID;
	local int		CP;
	local int		MaxCP;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		ClassID;
	local int		Level;
	local UserInfo 	TargetUser;
	//~ local int		SummonID;
	
	local int		Width;
	local int		Height;
	
	
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", ID);
	GetUserInfo(ID, TargetUser);
	
	ParseInt(param, "CurCP", CP);
	ParseInt(param, "MaxCP", MaxCP);
	ParseInt(param, "CurHP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "CurMP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	
	UseVName = m_Vname[idx].UseVName;
	DominionIDForVName = m_Vname[idx].DominionIDForVName;
	VName = m_Vname[idx].VName;
	SummonVName = m_Vname[idx].SummonVName;
	
	if (UseVName == 1)
	{
		m_PlayerName[idx].SetName(VName, NCT_Normal,TA_Center);
	}
	else
	{
		m_PlayerName[idx].SetName(Name, NCT_Normal,TA_Center);
	}
	
	//?? ???
	if (ParseInt(param, "MasterID", MasterID))
	{
		if (MasterID>0 && MasterID==ID)
		{	
			partymasteridx = idx;
			ParseInt(param, "RoutingType", RoutingType);
			m_LeaderIcon[idx].SetTexture("L2UI_CH3.PartyWnd.party_leadericon");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(RoutingType)));
			
			//???? ??? ?? ??????.
			GetTextSizeDefault(Name, Width, Height);
			m_LeaderIcon[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ idx, "TopCenter", "TopLeft", -(Width/2)-18, 8);
		}
		else
		{
			m_LeaderIcon[idx].SetTexture("");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
		}
	}
	
	//?? ???
	if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.showNewIcons") && GetDetailedClassIconName(ClassID) != "None")
	{
		m_ClassIcon[idx].SetTexture("");
		m_ClassIcon[idx].HideWindow();
		m_DetailedClassIcon[idx].ShowWindow();
		m_DetailedClassIcon[idx].SetTexture(GetDetailedClassIconName(ClassID));
		m_DetailedClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	}
	else
	{
		m_DetailedClassIcon[idx].SetTexture("");
		m_DetailedClassIcon[idx].HideWindow();
		m_ClassIcon[idx].ShowWindow();
		m_ClassIcon[idx].SetTexture(GetClassIconName(ClassID));
		m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	}
	
	
	//?? ???
	UpdateCPBar(idx, CP, MaxCP);
	UpdateHPBar(idx, HP, MaxHP);
	UpdateMPBar(idx, MP, MaxMP);
	
	m_PlayerLevel[idx].ShowWindow();
	PlayerLevel[idx].SetText( string(Level) );
}

function string GetDetailedClassIconName(int ClassID)
{
	switch (ClassID)
	{
		case 88:
			return "MercTex.Class.classIcons_glad";
		break;
		case 89:
			return "MercTex.Class.classIcons_wl";
		break;
		case 90:
			return "MercTex.Class.classIcons_pk";
		break;
		case 91:
			return "MercTex.Class.classIcons_hk";
		break;
		case 92:
		case 102:
		case 109:
			return "MercTex.Class.classIcons_archer";
		break;
		case 93:
		case 101:
		case 108:
			return "MercTex.Class.classIcons_dagger";
		break;
		case 94:
			return "MercTex.Class.classIcons_sorc";
		break;
		case 95:
			return "MercTex.Class.classIcons_necr";
		break;
		case 96:
			return "MercTex.Class.classIcons_al";
		break;
		case 97:
			return "MercTex.Class.classIcons_bp";
		break;
		case 98:
			return "MercTex.Class.classIcons_prophet";
		break;
		case 99:
			return "MercTex.Class.classIcons_et";
		break;
		case 100:
			return "MercTex.Class.classIcons_sws";
		break;
		case 103:
			return "MercTex.Class.classIcons_mm";
		break;
		case 104:
			return "MercTex.Class.classIcons_em";
		break;
		case 105:
			return "MercTex.Class.classIcons_ee";
		break;
		case 106:
			return "MercTex.Class.classIcons_st";
		break;
		case 107:
			return "MercTex.Class.classIcons_bd";
		break;
		case 110:
			return "MercTex.Class.classIcons_sh";
		break;
		case 111:
			return "MercTex.Class.classIcons_sm";
		break;
		case 112:
			return "MercTex.Class.classIcons_se";
		break;
		case 113:
			return "MercTex.Class.classIcons_titan";
		break;
		case 114:
			return "MercTex.Class.classIcons_gk";
		break;
		case 115:
			return "MercTex.Class.classIcons_ol";
		break;
		case 116:
			return "MercTex.Class.classIcons_warc";
		break;
		case 117:
			return "MercTex.Class.classIcons_spoil";
		break;
		case 118:
			return "MercTex.Class.classIcons_craft";
		break;
		case 131:
			return "MercTex.Class.classIcons_db";
		break;
		case 132:
			return "MercTex.Class.classIcons_slh";
		break;
		case 133:
			return "MercTex.Class.classIcons_slh";
		break;
		case 134:
			return "MercTex.Class.classIcons_arba";
		break;
		case 135:
    case 136:
			return "MercTex.Class.classIcons_jud";
		break;
		default:
			return "None";
		break;
	}
}

function HandlePartySummonAdd( string param )
{
	local int	SummonMasterID;
	local int	SummonID;
	local int	 i;
	local int	 MasterIndex;
	
	
	
	
	ParseInt(param, "SummonMasterID", SummonMasterID);	// ??? ID? ????.
	ParseInt(param, "SummonID", SummonID);	// ??? ID? ????.
	if (SummonMasterID>0)
	{
		MasterIndex = -1;
		for(i=0; i< NPARTYSTATUS_MAXCOUNT ; i++)
		{
			if(m_arrID[i] == SummonMasterID)
				MasterIndex = i;
		}
		
		if(MasterIndex == -1)
		{
			//debug("ERROR - Can't find master ID");
			return;
		}
		//ResizeWnd();
					
		m_arrPetID[MasterIndex] = SummonID;
		m_arrPetIDOpen[MasterIndex] = 1;
		UpdatePetStatus(MasterIndex, param);
		m_petButton[MasterIndex].showWindow();
		if( !m_PetPartyStatus[MasterIndex].isShowwindow())
		{
			m_PetPartyStatus[MasterIndex].ShowWindow();
			ResizeWnd();
		}
	}
}

function HandlePartySummonUpdate( string param )
{
	local int	SummonID;
	local int	idx;
	
	//debug(" PartySummonUpdate !! ");
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		UpdatePetStatus(idx, param);	// ?? ???? ? ??? ??
	}
}

function HandlePartySummonDelete( string param )
{
	local int	SummonID;
	local int	idx;
	//~ local int	i;
	
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		if (idx>-1)
		{	
			ClearPetStatus(idx);
			ResizeWnd();	// ?? ???? ???? ??? ??? ?????? ???.
		}
	}
}

function UpdatePetStatus(int idx, string param)
{
	local int		SummonID;			// ? ID
	local int		SummonClassID;		// ? ??
	local int		SummonType;		// ? ?? 1-??? 2-?
	local int		SummonMasterID;	// ??? ID
	local string		SummonNickName;	// ? ??
		
	local int		SummonHP;
	local int		SummonMaxHP;
	local int		SummonMP;
	local int		SummonMaxMP;
	local int		SummonLevel;
	
	//~ local int 		UseVName;
	//~ local int		DominionIDForVName;
	//~ local string	VName;
	//~ local string SummonVName;
	
	//~ ParseInt(Param, "UseVName",UseVName);
	//~ ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	//~ ParseString(Param, "VName", VName);
	//~ ParseString(Param, "SummonVName", SummonVName);
	
		
	//~ local int		Width;
	//~ local int		Height;
	
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "SummonNickName", SummonNickName);
	ParseInt(param, "SummonID", SummonID);
	ParseInt(param, "SummonClassID", SummonClassID);
	ParseInt(param, "SummonType", SummonType);
	ParseInt(param, "SummonMasterID", SummonMasterID);
	ParseInt(param, "SummonHP", SummonHP);
	ParseInt(param, "SummonMaxHP", SummonMaxHP);
	ParseInt(param, "SummonMP", SummonMP);
	ParseInt(param, "SummonMaxMP", SummonMaxMP);
	ParseInt(param, "SummonLevel", SummonLevel);
	
	//debug(" SummonNickName : " $ SummonNickName);
	//debug(" SummonID : " $ SummonID);
	//debug(" SummonClassID : " $ SummonClassID);
	//debug(" SummonType : " $ SummonType);
	//debug(" SummonMasterID : " $ SummonMasterID);
	//debug(" SummonHP : " $ SummonHP);
	//debug(" SummonMP : " $ SummonMP);
	//debug(" SummonMaxMP : " $ SummonMaxMP);
	//debug(" SummonLevel : " $ SummonLevel);
	//??
	//
	//~ if( Len(SummonNickName) <1)	// ??? ???
	//~ {
		//~ if(SummonType == 1)	// ???
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2140), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1597)), NCT_Normal,TA_Center);
		//~ else // ?
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2139), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1596)), NCT_Normal,TA_Center);
	//~ }
	//~ else
	//~ {
		//~ m_PetName[idx].SetName(SummonNickName, NCT_Normal,TA_Center);
	//~ }
	
	//??
	m_PetClassIcon[idx].SetTexture("L2UI_CT1.Icon.ICON_DF_PETICON");
	//m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(m_PetName[idx].GetName()));
			
	//? ???
	//m_ClassIcon[idx].SetTexture(GetClassIconName(SummonClassID));
	//m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	
	//?? ???
	UpdateHPBar(idx + 100, SummonHP, SummonMaxHP);
	UpdateMPBar(idx + 100, SummonMP, SummonMaxMP);
}

function bool GetBuffInDebuff(int dID)
{
	switch (dID)
	{
		case 1323: //Noblesse Blessing
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.noblCheck"))
			{
				return true;
			}
		break;
		case 785: //Flame Icon
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.fiCheck"))
			{
				return true;
			}
		break;
		case 789: //Spirit of Shilen
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.sosCheck"))
			{
				return true;
			}
		break;
		case 1282: //Pa'agrian Haste
		case 1204: //Wind Walk
		case 1535: //Chant of Movement
		case 1504: //Improved Movement
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.wwCheck"))
			{
				return true;
			}
		break;
		case 1460: //Mana Gain
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.manaCheck"))
			{
				return true;
			}
		break;
		case 1085: //Acumen
		case 1004: //Wisdom of Pa'agrio
		case 1002: //Flame Chant
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.acumenCheck"))
			{
				return true;
			}
		break;
		case 1040: //Shield
		case 1499: //Improved Combat
		case 1005: //Blessing of Pa'agrio
		case 1009: //Chant of Shielding
		case 1517: //Chant of Combat
		case 1010: //Soul Shield
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.shieldCheck"))
			{
				return true;
			}
		break;
		case 1444: //Pride of Kamael
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.prideCheck"))
			{
				return true;
			}
		break;
		case 1036: //Magic Barrier
		case 1500: //Improved Magic
		case 123: //Spirit Barrier
		case 1365: //Soul of Pa'agrio
		case 1008: //Glory of Pa'agrio
		case 1006: //Chant of Fire
		case 1470: //Prahnah
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.mdefCheck"))
			{
				return true;
			}
		break;
		case 1059: //Empower
		case 1500: //Improved Magic
		case 1365: //Soul of Pa'agrio
			if (class'UIAPI_CHECKBOX'.static.IsChecked("PartyWndOption.debuffList.empCheck"))
			{
				return true;
			}
		break;
	}
	
	return false;
}

function HandlePartySpelledList(string param)
{
	local int i;
	local int idx;
	local int ID;
	local int Max;
	
	local int BuffCnt;
	local int BuffCurRow;
	
	local int DeBuffCnt;
	local int DeBuffCurRow;
	
	//~ local int SongDanceCnt;
	local int SongDanceCurRow;
	
	local int TriggerSkillCnt;
	local int TriggerSkillCurRow;
	
	local bool isPC;	//pc?? ??? ???? ??
	
	local StatusIconInfo info;
	
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	TriggerSkillCurRow = -1;
	isPC = false;
	
	ParseInt(param, "ID", ID);
	if (ID<1)
	{
		return;
	}
	
	idx = FindPartyID(ID);
	if(idx >=0)
	{
		//?? ???
		m_StatusIconBuff[idx].Clear();
		m_StatusIconDeBuff[idx].Clear();
		m_StatusIconSongDance[idx].Clear();
		m_StatusIconTriggerSkill[idx].Clear();
		isPC = true;
	}
	else	// ????? ?? ?? ??
	{
		idx = FindPetID(ID);	// ???? ????, ??? ????. 
		if(idx >= 0)
		{
			//?? ???
			m_PetStatusIconBuff[idx].Clear();
			m_PetStatusIconDeBuff[idx].Clear();
			m_PetStatusIconSongDance[idx].Clear();
			m_PetStatusIconTriggerSkill[idx].Clear();
			isPC = false;
		}
		else
		{
			return;	// ? ????? ??? ? ????
		}
	}
		
	//info ???
	info.Size = 16;
	info.bShow = true;
	
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "Sec_" $ i, info.RemainTime);
		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level);
			
			if (IsDeBuff( info.ID, info.Level) == true || GetBuffInDebuff(info.ID.ClassID))
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconDeBuff[idx].AddRow();
					}
					else		
					{
						info.Size = 10;
						m_PetStatusIconDeBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				DeBuffCnt++;
			}
			else if (IsSongDance( info.ID, info.Level) == true )
			{
				//~ debug("???????");
				//~ SongDanceCurRow++;
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconSongDance[idx].AddRow();
				}
				else		
				{
					info.Size = 10;
					m_PetStatusIconSongDance[idx].AddRow();
				}
				
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconSongDance[idx].AddCol(0, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconSongDance[idx].AddCol(0, info);	
				}
				//~ SongDanceCurRow++;
			}
			else if (IsTriggerSkill( info.ID, info.Level) == true )
			{
				//~ debug("????????");
				if (TriggerSkillCnt % NSTATUSICON_MAXCOL == 0)
				{
					TriggerSkillCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconTriggerSkill[idx].AddRow();
					}
					else		
					{
						info.Size = 10;
						m_PetStatusIconTriggerSkill[idx].AddRow();
					}
				}
					
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				else 		
				{
					info.Size = 10;
					m_PetStatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				TriggerSkillCnt++;
			}
			else
			{
				//~ debug("?? ??????");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
					if(isPC)	
					{
						info.Size = 16;
						m_StatusIconBuff[idx].AddRow();
					}
					else
					{
						info.Size = 10;
						m_PetStatusIconBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{
					info.Size = 16;
					m_StatusIconBuff[idx].AddCol(BuffCurRow, info);		
				}
				else		
				{
					info.Size = 10;
					m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info);	
				}
				BuffCnt++;
			}
		}
	}
	UpdateBuff();
}

function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	
	m_CurBf = m_CurBf + 1;
	
	
	if (m_CurBf > 7)
	{
		m_CurBf = 0;
	}
	
	//SetBuffButtonTooltip();
	UpdateBuff();
	//~ switch (m_CurBf)
	//~ {
		//~ case 1:
		//~ UpdateBuff();
		//~ break;
		//~ case 2:
		//~ UpdateBuff();
		//~ break;
		//~ case 0:
		//~ m_CurBf = 0;
		//~ UpdateBuff();
	//~ }
}

function RecAttack(string param)
{
	local int AttID;
	local int DeffID;
	local int i;
	local UserInfo tInfo;
	local UserInfo playerInfo;
	
	ParseInt(param, "AttackerID", AttID);
	ParseInt(param, "DefenderID", DeffID);
	
	if (g_AssistLeader == AttID)
	{
		g_NextTarget = DeffID;
	
		for (i = 0; i < m_CurCount; i++)
		{
			if (g_NextTarget == cb_Assist.GetReserved(i+1))
			{
				//sysDebug("Party member");
				return;
			}
		}
		
		GetPlayerInfo(playerInfo);
		
		if (g_NextTarget == playerInfo.nID)
		{
			//sysDebug("It's me retard");
			return;
		}

		if (playerInfo.nClanID > 0)
		{
			GetUserInfo(g_NextTarget, tInfo);
			if (playerInfo.nClanID == tInfo.nClanID)
				return;
		}		
		
		if (g_NextTarget != g_PrevTarget)
		{
			g_PrevTarget = g_NextTarget;
			
			GetUserInfo(g_AssistLeader, tInfo);
			
			//DetectAgression();
			
			//if (!underAggr)
			//{
				RequestAssist( g_AssistLeader, tInfo.Loc );
			//}
			
		}
	}	
}

function RecSkillUse(string param)
{
	local int AttID;
	local int DeffID;
	local int i;
	local UserInfo tInfo;
	local UserInfo playerInfo;
	
	ParseInt(param, "AttackerID", AttID);
	ParseInt(param, "DefenderID", DeffID);
	
	if (AttID == DeffID)
		return;
	
	if (g_AssistLeader == AttID)
	{
		g_NextTarget = DeffID;
	
		for (i = 0; i < m_CurCount; i++)
		{
			if (g_NextTarget == cb_Assist.GetReserved(i+1))
			{
				//sysDebug("Party member");
				return;
			}
		}
		
		GetPlayerInfo(playerInfo);
		
		if (g_NextTarget == playerInfo.nID)
		{
			//sysDebug("It's me retard");
			return;
		}

		if (playerInfo.nClanID > 0)
		{
			GetUserInfo(g_NextTarget, tInfo);
			if (playerInfo.nClanID == tInfo.nClanID)
				return;
		}		
		
		if (g_NextTarget != g_PrevTarget)
		{
			g_PrevTarget = g_NextTarget;
			
			GetUserInfo(g_AssistLeader, tInfo);
			
			//DetectAgression();
			
			//if (!underAggr)
			//{
				RequestAssist( g_AssistLeader, tInfo.Loc );
			//}
		}
	}
	
}

function RequestAutoAssist(int Index)
{
	local UserInfo info;

	g_AssistLeader = cb_Assist.GetReserved(Index);
	
	if (GetUserInfo(g_AssistLeader, info))
	{
		RequestAssist( g_AssistLeader, info.Loc );
		g_PrevTarget = 0;
		g_NextTarget = 0;
	}	
	else
		sysDebug("ID doesnt exist");
}

function OnComboBoxItemSelected (string strID, int Index)
{
  local int i;
  
  switch (strID)
  {
    case "cbAbnormalType":
		m_CurBf = Index;
		UpdateBuff();
		SetOptionInt("UIExtender","AbnormalDisplayNum",m_CurBf);
		if (Index == 2)
		{
			isDeBuffOnly = true;
			for (i = 0; i < 9; i++)
				m_StatusIconDeBuff[i].SetIconSize(24);
		}
		else
		{
			isDeBuffOnly = false;
			for (i = 0; i < 9; i++)
				m_StatusIconDeBuff[i].SetIconSize(16);
		}
    break;
	case "cbAssist":
		if (Index > 0)
		{
			RequestAutoAssist(Index);
			g_CurrIndex = Index;
			m_wndTop.SetTimer(TIMER_ON_ASSIST, 50);
		}
		else
		{
			g_CurrIndex = 0;
			g_AssistLeader = 0;
		}	
    break;
    case "cbCastDisplayDirection":
    //m_CurCastDisplayDirection = Index;
    //SetOptionInt("UIExtender","CastDisplayDirection",m_CurCastDisplayDirection);
    break;
    default:
  }
}

function OnClickButton (string strID)
{
  local int idx;
  local PartyWndCompact script;

  script = PartyWndCompact(GetScript("PartyWndCompact"));
  switch (strID)
  {
    case "btnBuff":
    break;
    case "btnCompact":
    OnOpenPartyWndOption();
    break;
    case "btnSummon":
    break;
    default:
  }
  if ( InStr(strID,"btnSummon") > -1 )
  {
    idx = int(Right(strID,1));
    if ( m_PetPartyStatus[idx].IsShowWindow() )
    {
      m_PetPartyStatus[idx].HideWindow();
      m_arrPetIDOpen[idx] = 2;
    } else {
      m_PetPartyStatus[idx].ShowWindow();
      m_arrPetIDOpen[idx] = 1;
    }
    ResizeWnd();
  }
}

function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption script;
	script = PartyWndOption( GetScript("PartyWndOption") );
	
	// ???? ??? ? ??? ?? ??? , ?? ???? ????. 
	for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
	{
		script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
	}
	
	script.ShowPartyWndOption();
	m_PartyOption.SetAnchor("PartyWnd.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
	
	
}

function OnBuffButton ()
{
}

function UpdateBuff ()
{
  local int idx;

  if ( m_CurBf == 1 )
  {
    for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
    {
      m_StatusIconBuff[idx].ShowWindow();
      m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
      m_PetStatusIconBuff[idx].ShowWindow();
      m_StatusIconDeBuff[idx].HideWindow();
      m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
      m_PetStatusIconDeBuff[idx].HideWindow();
      m_StatusIconSongDance[idx].HideWindow();
      m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
      m_PetStatusIconSongDance[idx].HideWindow();
      m_StatusIconTriggerSkill[idx].HideWindow();
      m_PetStatusIconTriggerSkill[idx].HideWindow();
    }
  } else {
    if ( m_CurBf == 2 )
    {
      for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
      {
        m_StatusIconBuff[idx].HideWindow();
        m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
        m_PetStatusIconBuff[idx].HideWindow();
        m_StatusIconDeBuff[idx].ShowWindow();
        m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
        m_PetStatusIconDeBuff[idx].ShowWindow();
        m_StatusIconSongDance[idx].HideWindow();
        m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
        m_PetStatusIconSongDance[idx].HideWindow();
        m_StatusIconTriggerSkill[idx].HideWindow();
        m_PetStatusIconTriggerSkill[idx].HideWindow();
		m_StatusIconDeBuff[idx].SetIconSize(24);
      }
    } else {
      if ( m_CurBf == 3 )
      {
        for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
        {
          m_StatusIconBuff[idx].HideWindow();
          m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
          m_PetStatusIconBuff[idx].HideWindow();
          m_StatusIconDeBuff[idx].HideWindow();
          m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
          m_PetStatusIconDeBuff[idx].HideWindow();
          m_StatusIconSongDance[idx].ShowWindow();
          m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
          m_PetStatusIconSongDance[idx].ShowWindow();
          m_StatusIconTriggerSkill[idx].HideWindow();
          m_PetStatusIconTriggerSkill[idx].HideWindow();
        }
      } else {
        if ( m_CurBf == 4 )
        {
          for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
          {
            m_StatusIconBuff[idx].HideWindow();
            m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
            m_PetStatusIconBuff[idx].HideWindow();
            m_StatusIconDeBuff[idx].HideWindow();
            m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
            m_PetStatusIconDeBuff[idx].HideWindow();
            m_StatusIconSongDance[idx].HideWindow();
            m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
            m_PetStatusIconSongDance[idx].HideWindow();
            m_StatusIconTriggerSkill[idx].ShowWindow();
            m_PetStatusIconTriggerSkill[idx].ShowWindow();
          }
        } else {
          if ( m_CurBf == 5 )
          {
            for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
            {
              m_StatusIconBuff[idx].ShowWindow();
              m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
              m_PetStatusIconBuff[idx].ShowWindow();
              m_StatusIconDeBuff[idx].ShowWindow();
              m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,35);
              m_PetStatusIconDeBuff[idx].HideWindow();
              m_StatusIconSongDance[idx].HideWindow();
              m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
              m_PetStatusIconSongDance[idx].HideWindow();
              m_StatusIconTriggerSkill[idx].ShowWindow();
              m_PetStatusIconTriggerSkill[idx].ShowWindow();
            }
          } else {
            if ( m_CurBf == 6 )
            {
              for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
              {
                m_StatusIconBuff[idx].ShowWindow();
                m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                m_PetStatusIconBuff[idx].ShowWindow();
                m_StatusIconDeBuff[idx].HideWindow();
                m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                m_PetStatusIconDeBuff[idx].HideWindow();
                m_StatusIconSongDance[idx].ShowWindow();
                m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,35);
                m_PetStatusIconSongDance[idx].HideWindow();
                m_StatusIconTriggerSkill[idx].HideWindow();
                m_PetStatusIconTriggerSkill[idx].HideWindow();
              }
            } else {
              if ( m_CurBf == 7 )
              {
                for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
                {
                  m_StatusIconBuff[idx].HideWindow();
                  m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                  m_PetStatusIconBuff[idx].HideWindow();
                  m_StatusIconDeBuff[idx].ShowWindow();
                  m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,35);
                  m_PetStatusIconDeBuff[idx].HideWindow();
                  m_StatusIconSongDance[idx].ShowWindow();
                  m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                  m_PetStatusIconSongDance[idx].ShowWindow();
                  m_StatusIconTriggerSkill[idx].HideWindow();
                  m_PetStatusIconTriggerSkill[idx].HideWindow();
                }
              } else {
                for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
                {
                  m_StatusIconBuff[idx].HideWindow();
                  m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                  m_PetStatusIconBuff[idx].HideWindow();
                  m_StatusIconDeBuff[idx].HideWindow();
                  m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                  m_PetStatusIconDeBuff[idx].HideWindow();
                  m_StatusIconSongDance[idx].HideWindow();
                  m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,3);
                  m_PetStatusIconSongDance[idx].HideWindow();
                  m_StatusIconTriggerSkill[idx].HideWindow();
                  m_PetStatusIconTriggerSkill[idx].HideWindow();
                }
              }
            }
          }
        }
      }
    }
  }
}

function UpdateCPBar (int idx, int Value, int MaxValue)
{
  local int Percent;

  Percent = int(getPercent(Value,MaxValue) * 100);
  m_BarCP[idx].SetValue(MaxValue,Value);
}

function UpdateHPBar (int idx, int Value, int MaxValue)
{
  local int Percent;

  Percent = int(getPercent(Value,MaxValue) * 100);
  if ( idx < 100 )
  {
    m_BarHP[idx].SetValue(MaxValue,Value);
  } else {
    m_PetBarHP[idx - 100].SetValue(MaxValue,Value);
  }
}

function UpdateMPBar (int idx, int Value, int MaxValue)
{
  local int Percent;

  Percent = int(getPercent(Value,MaxValue) * 100);
  if ( idx < 100 )
  {
    m_BarMP[idx].SetValue(MaxValue,Value);
  } else {
    m_PetBarMP[idx - 100].SetValue(MaxValue,Value);
  }
}

function OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
  local Rect rectWnd;
  local UserInfo UserInfo;
  local int idx;

  rectWnd = m_wndTop.GetRect();
  //AddSystemMessageString(string(Y) $ " - " $ string(rectWnd.nY));
  if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) && (Y - rectWnd.nY > 0) )
  {
    if ( GetPlayerInfo(UserInfo) )
    {
      idx = GetIdx( Y - rectWnd.nY );
	  //AddSystemMessageString(string(Y) $ " - " $ string(rectWnd.nY) $ " = " $ string(Y - rectWnd.nY));
	  //AddSystemMessageString("Idx - " $ string(idx));
      if ( IsPKMode() )
      {
        if ( idx < 100 )
        {
          RequestAttack(m_arrID[idx],UserInfo.Loc);
        } else {
          RequestAttack(m_arrPetID[idx - 100],UserInfo.Loc);
        }
      } else {
        if ( idx < 100 )
        {
          RequestAction(m_arrID[idx],UserInfo.Loc);
        } else {
          RequestAction(m_arrPetID[idx - 100],UserInfo.Loc);
        }
      }
    }
  }
}

function OnRButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
  local Rect rectWnd;
  local UserInfo UserInfo;
  local int idx;

  rectWnd = m_wndTop.GetRect();
  if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) )
  {
    if ( GetPlayerInfo(UserInfo) )
    {
      idx = GetIdx(Y - rectWnd.nY);
      if ( idx < 100 )
      {
        RequestAssist(m_arrID[idx],UserInfo.Loc);
      } else {
        RequestAssist(m_arrPetID[idx - 100],UserInfo.Loc);
      }
    }
  }
}

function int GetIdx(int y)
{
	local int tempY;	// ???? ??? ????? ?? ????? ?? ?????. 
	local int i;
	local int idx;
	
	idx = -1;
	tempY = y;
	
	for(i=0 ; i<NPARTYSTATUS_MAXCOUNT ; i++)
	{
		tempY = tempY - NPARTYSTATUS_HEIGHT;
		
		//AddSystemMessageString("tempY - " $ string(tempY));
		
		if(tempY <0)	// 0?? ??? ?? i? IDX? ??. 
		{
			idx = i;	//???? ???, ???? ????..
			return idx;
		}
		else if( m_arrPetIDOpen[i] == 1) // ?? ???? ?? ?????
		{
			tempY = tempY - NPARTYPETSTATUS_HEIGHT;			
			if(tempY <0)	// 0?? ??? ?? i? IDX? ??. 
			{
				idx = i + 100;	//?? ?? 100? ??? ????. 
				return idx;
			}
		}		
	}
	
	return idx;
}

function OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y )
{
	local string sTargetName, sDropName ,sTargetParent;
	local int dropIdx, targetIdx, i;
	
	//local  PartyWnd script1;			// ??? ???? ???
	local PartyWndCompact script2;	// ??? ???? ???
	
	//script1 = PartyWnd( GetScript("PartyWnd") );
	script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	dropIdx = -1;
	targetIdx = -1;
	
	if( hTarget == None || hDropWnd == None )
		return;
	
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	
	// PartyStatusWnd?? ??? ? ??? ? ? ??. 
	//if(( InStr( "PartyStatusWnd", sTargetName ) == -1 ) || ( InStr( "PartyStatusWnd" ,sDropName) == -1 ))
	if( (( InStr( sTargetName , "PartyStatusWnd" ) == -1 ) && ( InStr( sTargetParent , "PartyStatusWnd" ) == -1 )   ) || ( InStr( sDropName, "PartyStatusWnd") == -1 ))
	{
		//Debug( "sTargetName: " $ sTargetName );
		//Debug( "sTargetName: " $ sDropName );
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName , 1));
		
		if( InStr( sTargetName , "PartyStatusWnd" ) > -1 ) 	//?? ??? ?? ??
			targetIdx = int(Right(sTargetName , 1));
		else									//?? ??? ??? ??? ??? PartyStatusWnd ??
			targetIdx = int(Right(sTargetParent , 1));
		
		if( dropIdx <0 || targetIdx <0 )
		{
			//Debug( "ERROR IDX: " $ dropIdx $ " / " $  targetIdx);
		}
		
		// ?? ?? ?? ???? ??
		if( dropIdx > targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//??? ????
			script2.CopyStatus ( 8 , dropIdx );		//??? ????
			
			for (i=dropIdx-1; i>targetIdx-1; i--)	// ??? ????. 
			{
				CopyStatus(i+1, i);
				script2.CopyStatus(i+1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script2.CopyStatus ( targetIdx , 8  );
		}
		else if(dropIdx < targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//??? ????
			script2.CopyStatus ( 8 , dropIdx );		//??? ????
			
			for (i=dropIdx+1; i<targetIdx+1; i++)	// ?? ????.
			{
				CopyStatus(i-1, i);
				script2.CopyStatus(i-1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script2.CopyStatus ( targetIdx , 8  );
		}

		ClearStatus(8);
		ClearPetStatus(8);
		
		//Update Client Data
		class'UIDATA_PARTY'.static.MovePartyMember( dropIdx, targetIdx );
		
		ResizeWnd();
	}
}

function int GetVNameIndexByID( int ID )
{
	local int i;
	for (i=0; i<8; i++)
	{
		if( m_Vname[i].ID == ID )
			return i;
	}
	return -1;
}

function ResetVName()
{
	local int i;
	
	for (i=0; i<8; i++)
	{
		m_Vname[i].ID = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
	}
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_ON_ASSIST:
			m_wndTop.KillTimer(TIMER_ON_ASSIST);
			PermaAssist();
		break;
		case 6656:
			m_wndTop.KillTimer(6656);
			
			underAggr = false;
		break;
	}
}


function PermaAssist()
{
	local UserInfo pInfo;
	
	if (g_CurrIndex > 0)
	{
		if (GetUserInfo(g_AssistLeader, pInfo))
		{

			if (IsKeyDown( script_pt_opt.GetAssistKeyName() ) )
			{
				RequestAssist( g_AssistLeader, pInfo.Loc );
				//sysDebug("GOT ASSIST");
			}
			
				
			m_wndTop.SetTimer(TIMER_ON_ASSIST, 50);
			//sysDebug("GOT ASSIST");
		}	
	}
	else
	{
		//m_wndTop.KillTimer(TIMER_ON_ASSIST);
		//sysDebug("AUTO ASSIST STOPPED");
		//MessageBox("Choose assist leader!");
	}
}

function DetectAgression()
{
	local int Row, Col;
	local int i, j;
	local int index;
	local StatusIconInfo sInfo;
	
	if (g_AssistLeader > 0)
	{
		for (i = 0; i < NPARTYSTATUS_MAXCOUNT; i++ )
		{
			if (m_arrID[i] == g_AssistLeader)
			{
				index = i;
			}
		}
		
		Row = m_StatusIconDeBuff[index].GetRowCount();
		for (i = 0; i < Row; i++)
		{
			Col = m_StatusIconDeBuff[index].GetColCount( i );
			
			for (j = 0; j < Col; j++)
			{
				
				m_StatusIconDeBuff[index].GetItem( i, j, sInfo );
				
				if (sInfo.Name == "Aggression")
				{
					underAggr = true;
					m_wndTop.KillTimer(6656);
					m_wndTop.SetTimer(6656, sInfo.RemainTime + 500);
					break;
				}
				
			}
		}
	}
}

defaultproperties
{
}

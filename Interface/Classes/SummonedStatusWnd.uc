class SummonedStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var bool	m_bBuff;
var bool 	m_bShow;
var int	m_PetID;
var bool	m_bSummonedStarted;
var int 	m_CurBf;

var WindowHandle Me;
var BarHandle barMP;
var BarHandle barHP;
var ProgressCtrlHandle progFATIGUE;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle BackTex;
//~ var StatusIconHandle StatusIcon;

var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle m_StatusIconTriggerSkill;

function OnRegisterEvent()
{
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_ShowBuffIcon );
	
	RegisterEvent( EV_SummonedStatusShow );
	RegisterEvent( EV_SummonedStatusSpelledList );
	RegisterEvent( EV_SummonedStatusRemainTime );
	
	RegisterEvent( EV_PetSummonedStatusClose );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

	Load();
}

function Initialize()
{
	Me = GetHandle( "SummonedStatusWnd" );
	barMP = BarHandle ( GetHandle( "SummonedStatusWnd.barMP" ) );
	barHP = BarHandle ( GetHandle( "SummonedStatusWnd.barHP" ) );
	progFATIGUE = ProgressCtrlHandle ( GetHandle( "SummonedStatusWnd.progFATIGUE" ) );
	PetName = NameCtrlHandle ( GetHandle( "SummonedStatusWnd.PetName" ) );
	btnBuff = ButtonHandle ( GetHandle( "SummonedStatusWnd.btnBuff" ) );
	BackTex = GetHandle( "SummonedStatusWnd.BackTex" );
	//~ StatusIcon = StatusIconHandle ( GetHandle( "SummonedStatusWnd.StatusIcon" ) );
	m_StatusIconBuff = StatusIconHandle ( GetHandle( "SummonedStatusWnd.StatusIconBuff" ) );
	m_StatusIconDeBuff = StatusIconHandle ( GetHandle( "SummonedStatusWnd.StatusIconDeBuff" ) );
	m_StatusIconSongDance = StatusIconHandle ( GetHandle( "SummonedStatusWnd.StatusIconSongDance" ) );
	m_StatusIconTriggerSkill = StatusIconHandle ( GetHandle( "SummonedStatusWnd.StatusIconTriggerSkill" ) );
}

function InitializeCOD()
{
	Me = GetWindowHandle( "SummonedStatusWnd" );
	barMP = GetBarHandle( "SummonedStatusWnd.barMP" );
	barHP = GetBarHandle( "SummonedStatusWnd.barHP" );
	progFATIGUE = GetProgressCtrlHandle ( "SummonedStatusWnd.progFATIGUE" );
	PetName = GetNameCtrlHandle ( "SummonedStatusWnd.PetName" );
	btnBuff = GetButtonHandle ( "SummonedStatusWnd.btnBuff" );
	BackTex = GetWindowHandle( "SummonedStatusWnd.BackTex" );
	//~ StatusIcon = GetStatusIconHandle( "SummonedStatusWnd.StatusIcon" );
	m_StatusIconBuff = GetStatusIconHandle( "SummonedStatusWnd.StatusIconBuff" );
	m_StatusIconDeBuff = GetStatusIconHandle( "SummonedStatusWnd.StatusIconDeBuff" );
	m_StatusIconSongDance = GetStatusIconHandle( "SummonedStatusWnd.StatusIconSongDance" );
	m_StatusIconTriggerSkill = GetStatusIconHandle( "SummonedStatusWnd.StatusIconTriggerSkill" );
}

function Load()
{
	m_CurBf = 1;
	SetBuffButtonTooltip();

	m_bShow = false;
	m_bBuff = false;
}

function OnShow()
{
	local int PetID;
	local int IsPetOrSummoned;
	
	PetID = class'UIDATA_PET'.static.GetPetID();
	IsPetOrSummoned = class'UIDATA_PET'.static.GetIsPetOrSummoned();
	
	if (PetID<0 || IsPetOrSummoned!=1)
	{
		Me.HideWindow();
	}
	else
	{
		m_bShow = true;
		Me.ShowWindow();
	}
}

function OnHide()
{
	m_bShow = false;
}

function OnEnterState( name a_PreStateName )
{
	m_bBuff = false;
	
	//if (a_PreStateName == 'GamingState')	//������Ʈ�� �������� �ʾƵ� �ɶ� �𸣰ڳ׿�
	//{
		OnShow();				//��ȯ���� ������ ��¥�� �׷����� ������ ���⼭�� onshow�� �θ����� �Ѵ�.
	//}
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetSummonedStatusClose();
	}
	else if (Event_ID == EV_SummonedStatusShow)
	{
		HandleSummonedStatusShow();
	}
	else if (Event_ID == EV_ShowBuffIcon)
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_SummonedStatusSpelledList)
	{
		HandleSummonedStatusSpelledList(param);
	}
	else if (Event_ID == EV_SummonedStatusRemainTime)
	{
		HandleSummonedStatusRemainTime(param);
	}
}

//�ʱ�ȭ
function Clear()
{
	ClearBuff();
	PetName.SetName("", NCT_Normal,TA_Center);
	barHP.SetValue(0, 0);
	barMP.SetValue(0, 0);
}

//���� ������ �ʱ�ȭ
function ClearBuff()
{
	//~ StatusIcon.Clear();
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconTriggerSkill.Clear();
}

//��ȯ ���� �ð��� ����
function HandleSummonedStatusRemainTime(string param)
{
	local int RemainTime;
	local int MaxTime;
	
	ParseInt(param, "RemainTime", RemainTime);
	ParseInt(param, "MaxTime", MaxTime);
	
	if (m_bSummonedStarted)
	{
		progFATIGUE.SetPos(RemainTime);
	}
	else
	{
		ClearBuff();
		progFATIGUE.SetProgressTime(MaxTime);
		progFATIGUE.Start();
		m_bSummonedStarted = true;
	}
}

//����ó��
function HandlePetSummonedStatusClose()
{
	InitFATIGUEBar();
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
	local PetInfo	info;
	
	m_PetID = 0;
	if (GetPetInfo(info))
	{
		m_PetID = info.nID;
		Name = info.Name;
		HP = info.nCurHP;
		MP = info.nCurMP;
		Fatigue = info.nFatigue;
		MaxHP = info.nMaxHP;
		MaxMP = info.nMaxMP;
		MaxFatigue = info.nMaxFatigue;

		// �� ���� refresh

		if (m_bSummonedStarted)
		{
			progFATIGUE.SetPos(Fatigue);
		}
		else
		{
			// ClearBuff();
			if (MaxFatigue > 0)
			{
				progFATIGUE.SetProgressTime(MaxFatigue);
				progFATIGUE.Start();
				m_bSummonedStarted = true;
			}
		}

			
	}

	PetName.SetName(Name, NCT_Normal,TA_Center);
	barHP.SetValue(MaxHP, HP);
	barMP.SetValue(MaxMP, MP);
}

//��â�� ǥ��
function HandleSummonedStatusShow()
{
	Clear();
	Me.ShowWindow();
	Me.SetFocus();
}

//���� ��������Ʈ����
function HandleSummonedStatusSpelledList(string param)
{
	local int i;
	local int Max, ID;	
	
	//~ local int BuffCnt;
	//~ local int CurRow;
	
	local int BuffCnt;
	local int BuffCurRow;
	
	local int DeBuffCnt;
	local int DeBuffCurRow;
	
	local int SongDanceCnt;
	local int SongDanceCurRow;

	local int TriggerSkillCnt;
	local int TriggerSkillCurRow;
	
	local StatusIconInfo info;
	
	//~ CurRow = -1;
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	TriggerSkillCurRow = -1;
	
	ParseInt(param, "ID", ID);
	info.ServerID = ID;
	if (ID<1 || m_PetID != ID)	// �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}
	
	//���� �ʱ�ȭ
	//~ StatusIcon.Clear();
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconTriggerSkill.Clear();	
	
	//info �ʱ�ȭ
	info.Size = 24;
	info.bShow = true;

	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "Sec_" $ i, info.RemainTime);
		
		//~ if (IsValidItemID(info.ID))
		//~ {
			//~ info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, 1);
			
			//~ //���ٿ� NSTATUSICON_MAXCOL��ŭ ǥ���Ѵ�.
			//~ if (BuffCnt%NSTATUSICON_MAXCOL == 0)
			//~ {
				//~ CurRow++;
				//~ StatusIcon.AddRow();
			//~ }
			
			//~ StatusIcon.AddCol(CurRow, info);	
			
			//~ BuffCnt++;
		//~ }
		
		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level);
			
			if (IsDeBuff( info.ID, 1) == true )
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;
					info.Size = 24;
					m_StatusIconDeBuff.AddRow();
				}
				m_StatusIconDeBuff.AddCol(DeBuffCurRow, info);
				DeBuffCnt++;
			}
			else if (IsSongDance( info.ID, 1) == true )
			{
				if (SongDanceCnt%NSTATUSICON_MAXCOL == 0)
				{
					SongDanceCurRow++;
					info.Size = 24;
					m_StatusIconSongDance.AddRow();
				}
				m_StatusIconSongDance.AddCol(SongDanceCurRow, info);
				SongDanceCnt++;
			}
			else if (IsTriggerSkill( info.ID, 1 ) == true )
			{
				if (TriggerSkillCnt%NSTATUSICON_MAXCOL == 0)
				{
					TriggerSkillCurRow++;
					info.Size = 24;
					m_StatusIconTriggerSkill.AddRow();
				}
				m_StatusIconTriggerSkill.AddCol(TriggerSkillCurRow, info);
				TriggerSkillCnt++;
			}
			else
			{
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
						info.Size = 24;
						m_StatusIconBuff.AddRow();
				}
				m_StatusIconBuff.AddCol(BuffCurRow, info);
				BuffCnt++;
			}
		}
	}
	
	if (BuffCnt > 24)
	{
		m_StatusIconDeBuff.SetAnchor("SummonedStatusWnd.StatusIconBuff", "TopLeft", "TopLeft", 0, 72);
	}
	else if (BuffCnt > 12)
	{
		m_StatusIconDeBuff.SetAnchor("SummonedStatusWnd.StatusIconBuff", "TopLeft", "TopLeft", 0, 48);
	}
	else
	{
		m_StatusIconDeBuff.SetAnchor("SummonedStatusWnd.StatusIconBuff", "TopLeft", "TopLeft", 0, 24);
	}
	//~ UpdateBuff(m_bBuff);
	UpdateBuff();
}

//���������� ǥ��
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	if (nShow==1)
	{
		//~ UpdateBuff(true);
		UpdateBuff();
	}
	else
	{
		//~ UpdateBuff(false);
		UpdateBuff();
	}
}

	
// ��������� ǥ��,  �۴� , �ߵ�����, ���� 4������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	//~ local int idx;
	if (m_CurBf == 1)
	{
		// ���� , ����� ���� �ش�.
		m_StatusIconBuff.ShowWindow(); 
		m_StatusIconDeBuff.ShowWindow(); 
		m_StatusIconSongDance.HideWindow(); 
		m_StatusIconTriggerSkill.ShowWindow();
	}
	 /*  
	 // ����/����� ���� 
	 else if (m_CurBf == 2)
	 {
	  //~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	  //~ {
	   m_StatusIconBuff.HideWindow(); 
	   m_StatusIconDeBuff.ShowWindow(); 
	   m_StatusIconSongDance.HideWindow(); 
	  //~ }
	 }
	 */
	// �۴� �����ش�.
	else if (m_CurBf == 2)
	{
		//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		//~ {
		m_StatusIconBuff.HideWindow(); 
		m_StatusIconDeBuff.HideWindow(); 
		m_StatusIconSongDance.ShowWindow(); 
		m_StatusIconTriggerSkill.HideWindow();
  //~ }
	}
	// �ߵ����� �����ش�.
	else if ( m_CurBf == 3 )
	{
		m_StatusIconBuff.HideWindow(); 
		m_StatusIconDeBuff.HideWindow(); 
		m_StatusIconSongDance.HideWindow(); 
		m_StatusIconTriggerSkill.ShowWindow();
	}
	else
	{
	//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	//~ {
	m_StatusIconBuff.HideWindow();
	m_StatusIconDeBuff.HideWindow(); 
	m_StatusIconSongDance.HideWindow(); 
	m_StatusIconTriggerSkill.HideWindow();
  //~ }
	}
 //m_bBuff = bShow;
}

function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	
	rectWnd = Me.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			RequestAction(m_PetID, userinfo.Loc);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnBuff":
		OnBuffButton();
		break;
	}
}

function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;

	// 2009.10.01 ����: ������ ����, �����, �̻���� ����, ��/�� 4���� ����. 
	// (����/�����) �̻���� ����, ��/�� ����, �̻���� ����
	// 3���� ��尡 ��ȯ�ȴ�.
	// 2010.06.04. �ߵ������� ���� ǥ�����ֵ��� �߰��Ǿ����ϴ�.
	if (m_CurBf > 3)
	{
		m_CurBf = 0;
	}

	SetBuffButtonTooltip();
	UpdateBuff();
}



// ���� ������ �����Ѵ�.
function SetBuffButtonTooltip()
{
	local int idx;

	 //stringID=1496 string=[��������] 
	 //stringID=1497 string=[���������] 
	 //stringID=1498 string=[�̻���� ����] 
	 //stringID=1741 string=[��/�� ����] 
	 switch (m_CurBf)
	 {
		case 0: idx = 2221; // 1496;  // ��������� ���� -> �̻���� ���� 2221 
			break;
		//case 1: idx = 1497; break; // ���� �ȴ�. 
		case 1: idx = 1741;
			break;
		case 2: idx = 2307;
			break;
		// ���Ŀ� �ٲ���� ��.
		case 3: idx = 1498;
			break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}



//FATIGUE�� �ʱ�ȭ
function InitFATIGUEBar()
{
	progFATIGUE.Stop();
	progFATIGUE.Reset();
	m_bSummonedStarted = false;
}




function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// ��ų ����. ������ų���� Ȯ���ؾ� �ϴϱ�
	local StatusIconHandle  StatusIcon;

	debug(strID);
	debug(string(2342342));

	col = index / 10;
	row = index - (col * 10);

	if(InStr( strID ,"StatusIconBuff" ) > -1)
	{
		StatusIcon = m_StatusIconBuff;
	}
	if(InStr( strID ,"StatusIconDeBuff" ) > -1)
	{
		StatusIcon = m_StatusIconDeBuff;
	}
	if(InStr( strID ,"StatusIconSongDance" ) > -1)
	{
		StatusIcon = m_StatusIconSongDance;
	}
	if(InStr( strID ,"StatusIconTriggerSkill" ) > -1)
	{
		StatusIcon = m_StatusIconTriggerSkill;
	}

	StatusIcon.GetItem(row, col, info);
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	

	debug(strID);
	debug(string(2342342));

	if ( InStr( strID ,"StatusIconBuff" ) > -1 ||  InStr( strID ,"StatusIconDeBuff" ) > -1 ||  InStr( strID ,"StatusIconSongDance" ) > -1 || InStr( strID ,"StatusIconTriggerSkill" ) > -1)
	{
		if (skillInfo.IsDebuff == false && skillInfo.OperateType == 1)
		{	
			RequestDispel(info.ServerID, info.ID, info.Level);
		}		//���� ��� ��û
		else
		{
			AddSystemMessage(2318);
		}		//��ȭ ��ų�� ��쿡�� ���� ��Ұ� �����մϴ�. 
	}
}
defaultproperties
{
}

class PetStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var bool m_bBuff;
var bool m_bShow;
var int m_PetID;
var int  m_CurBf;
var bool  m_bPetload;
var WindowHandle Me;
var StatusBarHandle FATIGUEBar;
var StatusBarHandle MPBar;
var StatusBarHandle HPBar;
var StatusBarHandle EXPBar;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle PetStatusWnd_LevelTextBox_back;
var TextBoxHandle PetStatusWnd_LevelTextBox;
//~ var StatusIconHandle StatusIcon;
var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle	BufIcon;
var StatusIconHandle	DebufIcon;
var StatusIconHandle	SongDanceIcon;


function OnRegisterEvent()
{
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_ShowBuffIcon );
	 
	RegisterEvent( EV_PetStatusShow );
	RegisterEvent( EV_PetStatusSpelledList );
	 
	RegisterEvent( EV_PetSummonedStatusClose );
}

function OnLoad()
{
	m_bPetload = false;
	 
	if(CREATE_ON_DEMAND==0)
	  Initialize();
	 else
	  InitializeCOD();
	 
	Load();
}

function Initialize()
{
	BufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	DebufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	SongDanceIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );

	Me = GetHandle( "PetStatusWnd" );
	FATIGUEBar = StatusBarHandle(GetHandle("PetStatusWnd.FATIGUEBar"));
	MPBar = StatusBarHandle(GetHandle("PetStatusWnd.MPBar"));
	HPBar = StatusBarHandle(GetHandle("PetStatusWnd.HPBar"));
	EXPBar = StatusBarHandle(GetHandle("PetStatusWnd.EXPBar"));
	PetName = NameCtrlHandle ( GetHandle( "PetStatusWnd.PetName" ) );
	btnBuff = ButtonHandle ( GetHandle( "PetStatusWnd.btnBuff" ) );
	PetStatusWnd_LevelTextBox_back = GetHandle("PetStatusWnd.PetStatusWnd_LevelTextBox_back");
	PetStatusWnd_LevelTextBox = TextBoxHandle(GetHandle("PetStatusWnd.PetStatusWnd_LevelTextBox"));
	m_StatusIconBuff = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconBuff" ) );
	m_StatusIconDeBuff = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconDeBuff" ) );
	m_StatusIconSongDance = StatusIconHandle ( GetHandle( "PetStatusWnd.StatusIconSongDance" ) );
	m_CurBf = 1;
	SetBuffButtonTooltip();
}

function InitializeCOD()
{
	BufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	DebufIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	SongDanceIcon = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );

	Me = GetWindowHandle( "PetStatusWnd" );
	FATIGUEBar = GetStatusBarHandle("PetStatusWnd.FATIGUEBar");
	MPBar = GetStatusBarHandle("PetStatusWnd.MPBar");
	HPBar = GetStatusBarHandle("PetStatusWnd.HPBar");
	EXPBar = GetStatusBarHandle("PetStatusWnd.EXPBar");
	PetName = GetNameCtrlHandle( "PetStatusWnd.PetName" );
	btnBuff = GetButtonHandle( "PetStatusWnd.btnBuff" );
	PetStatusWnd_LevelTextBox_back = GetWindowHandle("PetStatusWnd.PetStatusWnd_LevelTextBox_back");
	PetStatusWnd_LevelTextBox = GetTextBoxHandle("PetStatusWnd.PetStatusWnd_LevelTextBox");
	m_StatusIconBuff = GetStatusIconHandle( "PetStatusWnd.StatusIconBuff" );
	m_StatusIconDeBuff = GetStatusIconHandle( "PetStatusWnd.StatusIconDeBuff" );
	m_StatusIconSongDance = GetStatusIconHandle( "PetStatusWnd.StatusIconSongDance" );
	m_CurBf = 1;
	SetBuffButtonTooltip();
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

	if (PetID<0 || IsPetOrSummoned!=2)
	{
		Me.HideWindow();
	}
	else
	{
		m_bShow = true;
	}
}

function OnHide()
{
	m_bShow = false;
}

function OnEnterState( name a_PreStateName )
{
	if (m_bPetload)
		Me.ShowWindow();

	m_bBuff = false;
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_UpdatePetInfo)
	{
		HandlePetInfoUpdate();
	}
	else if (Event_ID == EV_PetSummonedStatusClose)
	{
		HandlePetStatusClose();
		m_bPetload = false;
	}
	else if (Event_ID == EV_PetStatusShow)
	{
	//  debug ("Show Pet Wnd"$ GetGameStateName());
		if(GetGameStateName()!="GAMINGSTATE")
			return;
	
		HandlePetStatusShow();
		m_bPetload=true;
	}
	else if (Event_ID == EV_ShowBuffIcon)
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PetStatusSpelledList)
	{
		HandlePetStatusSpelledList(param);
	}
}

//�ʱ�ȭ
function Clear()
{
 //~ StatusIcon.Clear();
 
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	
	EXPBar.SetPointExpPercentRate(0.0);
	PetStatusWnd_LevelTextBox.SetInt(0);

	PetName.SetName("", NCT_Normal,TA_Center);
	HPBar.SetPoint(0,0);
	MPBar.SetPoint(0,0);
	FATIGUEBar.SetPointExpPercentRate(0.0);
}

//����ó��
function HandlePetStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//��Info��Ŷ ó��
function HandlePetInfoUpdate()
{
	local string Name;
	local int  HP;
	local int  MaxHP;
	local int  MP;
	local int  MaxMP;
	local int  Fatigue;
	local int  MaxFatigue;
	local PetInfo info;
	local float fatPercent;
	local float expPercent;

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
	}

	fatPercent = getPercent(Fatigue,MaxFatigue);
	expPercent = getPercent(int(100.0 * class'UIDATA_PET'.static.GetPetEXPRate()),10000);
	PetStatusWnd_LevelTextBox.SetInt(Info.nLevel);
	PetName.SetName(Name, NCT_Normal,TA_Center);
	HPBar.SetPoint(HP,MaxHP);
	MPBar.SetPoint(MP,MaxMP);
	EXPBar.SetPointExpPercentRate(expPercent);
	FATIGUEBar.SetPointExpPercentRate(fatPercent);
}

//��â�� ǥ��
function HandlePetStatusShow()
{
	Clear();
	Me.ShowWindow();
	Me.SetFocus();
}

//���� ��������Ʈ����
function HandlePetStatusSpelledList(string param)
{
	//~ local int i;
	//~ local int Max, ID;

	local int i;
	local int ID;
	local int Max;

	local int BuffCnt;
	local int BuffCurRow;

	local int DeBuffCnt;
	local int DeBuffCurRow;

	local int SongDanceCnt;
	local int SongDanceCurRow;

	//~ local int BuffCnt;
	//~ local int CurRow;
	local StatusIconInfo info;

	//~ CurRow = -1;

	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;

	ParseInt(param, "ID", ID);
	info.ServerID = ID;
	if (ID<1 || m_PetID != ID) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}

	//���� �ʱ�ȭ
	//~ StatusIcon.Clear();

	//~ .Clear();
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();


	//info �ʱ�ȭ
	info.Size = 16;
	info.bShow = true; 

	ParseInt(param, "ServerID", info.ServerID);
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
				 //~ if(isPC) 
				 //~ {
				  info.Size = 16;
				  m_StatusIconDeBuff.AddRow();
				 //~ }
				 //~ else  
				 //~ {
				  //~ info.Size = 10;
				  //~ m_PetStatusIconDeBuff[idx].AddRow();
				 //~ }
				}
				//~ if(isPC) 
				//~ {
				 //~ info.Size = 16;
				 //~ m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info); 
				//~ }
				//~ else   
				//~ {
				 //~ info.Size = 10;
				 //~ m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info); 
				//~ }

				m_StatusIconDeBuff.AddCol(DeBuffCurRow, info);
				DeBuffCnt++;
			}
			else if (IsSongDance( info.ID, 1) == true )
			{
				if (SongDanceCnt%NSTATUSICON_MAXCOL == 0)
				{
					//~ debug("�۴��Դϱ�?");
					SongDanceCurRow++;
					//~ if(isPC) 
					//~ {
					info.Size = 16;
					m_StatusIconSongDance.AddRow();
					//~ }
					//~ else  
					//~ {
					 //~ info.Size = 10;
					 //~ m_PetStatusIconSongDance[idx].AddRow();
					//~ }
				}
				//~ if(isPC) 
				//~ {
				 //~ info.Size = 16;
				 //~ m_StatusIconSongDance[idx].AddCol(0, info); 
				//~ }
				//~ else   
				//~ {
				 //~ info.Size = 10;
				 //~ m_PetStatusIconSongDance[idx].AddCol(0, info); 
				//~ }

					m_StatusIconSongDance.AddCol(SongDanceCurRow, info);
					SongDanceCnt++;
			}
			else
			{
				//~ debug("�Ϲ� �����Դϱ�?");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
				 //~ if(isPC) 
				 //~ {
					info.Size = 16;
					m_StatusIconBuff.AddRow();
				 //~ }
				 //~ else
				 //~ {
				  //~ info.Size = 10;
				  //~ m_PetStatusIconBuff[idx].AddRow();
				 //~ }
				}
			//~ if(isPC) 
			//~ {
			 //~ info.Size = 16;
			 //~ m_StatusIconBuff[idx].AddCol(BuffCurRow, info); 
			//~ }
			//~ else  
			//~ {
			 //~ info.Size = 10;
			 //~ m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info); 
			//~ }
				m_StatusIconBuff.AddCol(BuffCurRow, info);
				BuffCnt++;
			}
		}
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


// ��������� ǥ��,  �۴� , ���� 3������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	//~ local int idx;
	if (m_CurBf == 1)
	{
		// ���� , ����� ���� �ش�.
		m_StatusIconBuff.ShowWindow(); 
		m_StatusIconDeBuff.ShowWindow(); 
		m_StatusIconSongDance.HideWindow(); 
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
	else if (m_CurBf == 2)
	{
		//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		//~ {
		m_StatusIconBuff.HideWindow(); 
		m_StatusIconDeBuff.HideWindow(); 
		m_StatusIconSongDance.ShowWindow(); 
  //~ }
	}
	else
	{
	//~ for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	//~ {
	m_StatusIconBuff.HideWindow();
	m_StatusIconDeBuff.HideWindow(); 
	m_StatusIconSongDance.HideWindow(); 
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
	if (m_CurBf > 1)
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
		case 2: idx = 1498;
			break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}



//~ function OnBuffButton()
//~ {
 //~ UpdateBuff(!m_bBuff);
//~ }

//~ function UpdateBuff(bool bShow)
//~ {
 //~ if (bShow)
 //~ {
  //~ //StatusIcon.ShowWindow();
  //~ m_StatusIconBuff.ShowWindow();
  //~ m_StatusIconDeBuff.ShowWindow();
  //~ m_StatusIconSongDance.ShowWindow();
 //~ }
 //~ else
 //~ {
  //~ //StatusIcon.HideWindow();
  //~ m_StatusIconBuff.ShowWindow();
  //~ m_StatusIconDeBuff.ShowWindow();
  //~ m_StatusIconSongDance.ShowWindow();
 //~ }
 //~ m_bBuff = bShow;
//~ }


function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// ��ų ����. ������ų���� Ȯ���ؾ� �ϴϱ�
	local StatusIconHandle  StatusIcon;

	col = index / 10;
	row = index - (col * 10);

	if(InStr( strID ,"StatusIconBuff" ) > -1)
	{
		StatusIcon = BufIcon;
	}
	if(InStr( strID ,"StatusIconDeBuff" ) > -1)
	{
		StatusIcon = DebufIcon;
	}
	if(InStr( strID ,"StatusIconSongDance" ) > -1)
	{
		StatusIcon = SongDanceIcon;
	}

	StatusIcon.GetItem(row, col, info);
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"StatusIconBuff" ) > -1 ||  InStr( strID ,"StatusIconDeBuff" ) > -1 ||  InStr( strID ,"StatusIconSongDance" ) > -1)
	{
		if (skillInfo.IsDebuff == false && skillInfo.OperateType == 1) 		{	RequestDispel(info.ServerID, info.ID, info.Level);	}					//���� ��� ��û
		else												{	AddSystemMessage(2318);	}	//��ȭ ��ų�� ��쿡�� ���� ��Ұ� �����մϴ�. 
	}
}
defaultproperties
{
}

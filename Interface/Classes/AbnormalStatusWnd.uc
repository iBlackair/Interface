class AbnormalStatusWnd extends UICommonAPI;

//OBFSTART

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int m_NormalStatusRow;
var int m_DebuffRow;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var int m_SongDanceStatusRow;
var int m_TriggerSkillRow;
var bool m_bOnCurState;

var WindowHandle Me;
var NameCtrlHandle tName;
var StatusIconHandle StatusIcon;

var bool gotCastedDebuff;
var bool isCastedDebuff;
var bool isAOEok;
var bool bothHere;
var bool playerHere;
var bool petHere;
var bool resistedDebuff1player;
var bool resistedDebuff1pet;
var bool resistedDebuff2player;
var bool resistedDebuff2pet;
var bool isInterrupted1;
var bool isInterrupted2;
var bool isOnForCastWnd1;
var bool isOnForCastWnd2;
var int CastTime1;
var int CastTime2;
var int Distance;
var int DistanceToSumm;

var string GDebuffName1;
var string GDebuffName2;
var array<string> aoedbuffs;
var array<string> buffWithHighCast;

var OlympiadDmgWnd script_olydmgwnd;
var CancelCtrlWnd script_cancel;
var OptionWnd script_opt;
var OverlayWnd script_overlay;

var bool t1;
var bool t2;
var bool kek1;
var bool kek2;
var bool bersOn;
var int counter;

var SkillInfo disarmInfo;
var SkillInfo dInfo1;
var SkillInfo dInfo2;
var bool isMassDBuff1;
var bool isMassDBuff2;
var string tNameStr1;
var string tNameStr2;
var StatusIconInfo g_Info;

function OnLoad()
{
	if(CREATE_ON_DEMAND == 0)
		OnRegisterEvent();

	m_DebuffRow = -1;
	m_NormalStatusRow = -1;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_SongDanceStatusRow = -1;
	m_TriggerSkillRow = -1;
	m_bOnCurState = false;
	
	InitHandle();
	
	gotCastedDebuff = false;
	isCastedDebuff = false;
	resistedDebuff1player = false;
	resistedDebuff1pet = false;
	resistedDebuff2player = false;
	resistedDebuff2pet = false;
	isInterrupted1 = false;
	isInterrupted2 = false;
	isOnForCastWnd1 = false;
	isOnForCastWnd2 = false;
	isAOEok = true;
	CastTime1 = 0;
	CastTime2 = 0;
	GDebuffName1 = "";
	GDebuffName2 = "";
	Distance = 0;
	DistanceToSumm = 0;
	script_olydmgwnd = OlympiadDmgWnd (GetScript("OlympiadDmgWnd"));
	script_cancel = CancelCtrlWnd (GetScript("CancelCtrlWnd"));
	script_overlay = OverlayWnd( GetScript( "OverlayWnd" ) );
	t1 = false;
	t2 = false;
	kek1 = false;
	kek2 = false;
	bersOn = false;
	counter = 0;
	isMassDBuff1 = false;
	isMassDBuff2 = false;
	bothHere = true;
	
	aoedbuffs[0] = "Seal of Gloom";
	aoedbuffs[1] = "Seal of Slow";
	aoedbuffs[2] = "Seal of Winter";
	aoedbuffs[3] = "Seal of Binding";
	aoedbuffs[4] = "Seal of Silence";
	aoedbuffs[5] = "Seal of Suspension";
	aoedbuffs[6] = "Seal of Despair";
	aoedbuffs[7] = "Seal of Blockade";
	aoedbuffs[8] = "Seal of Limit";
	aoedbuffs[9] = "Blink";
	aoedbuffs[10] = "Lightning Shock";
	aoedbuffs[11] = "Vampiric Mist";
	aoedbuffs[12] = "Onslaught of Pa'agrio";
	
	buffWithHighCast[0] = "Seal of Limit";
	buffWithHighCast[1] = "Seal of Winter";
	buffWithHighCast[2] = "Special Ability: Critical Slow";
	buffWithHighCast[3] = "Lightning Barrier";
	buffWithHighCast[4] = "Rush Impact";
	buffWithHighCast[5] = "Curse Weakness";
	buffWithHighCast[6] = "Bleed";
	buffWithHighCast[7] = "Curse Disease";
	buffWithHighCast[8] = "Mass Slow";
	buffWithHighCast[9] = "Curse of Abyss";
	buffWithHighCast[10] = "Arcane Disraption";
	buffWithHighCast[11] = "Anchor";
	buffWithHighCast[12] = "Medusa v2";
	buffWithHighCast[13] = "Anchor v2";
	buffWithHighCast[14] = "Fear v2";
	
}

function OnRegisterEvent()
{
	RegisterEvent( EV_AbnormalStatusNormalItem );
	RegisterEvent( EV_AbnormalStatusEtcItem );
	RegisterEvent( EV_AbnormalStatusShortItem );
	
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_Die );
	RegisterEvent( EV_ShowReplayQuitDialogBox );
	RegisterEvent( EV_LanguageChanged );
	
	RegisterEvent( EV_ReceiveMagicSkillUse );
	RegisterEvent( EV_SystemMessage );
	
	RegisterEvent ( EV_OlympiadUserInfo );
	RegisterEvent ( EV_UpdateMP );
	RegisterEvent ( EV_UpdateUserInfo );
}

function InitHandle()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AbnormalStatusWnd" );
		StatusIcon = StatusIconHandle( GetHandle( "AbnormalStatusWnd.StatusIcon" ) );
		tName = NameCtrlHandle ( GetHandle( "TargetStatusWnd.UserName" ) );
	}
	else
	{
		Me = GetWindowHandle( "AbnormalStatusWnd" );
		StatusIcon = GetStatusIconHandle( "AbnormalStatusWnd.StatusIcon" );
		tName = GetNameCtrlHandle( "TargetStatusWnd.UserName" );
	}
}

function OnEnterState( name a_PreStateName )
{
	m_bOnCurState = true;
	UpdateWindowSize();
}

function OnExitState( name a_NextStateName )
{
	m_bOnCurState = false;
}

function OnEvent(int Event_ID, string param)
{
	local UserInfo uInfo;
	
	if (Event_ID == EV_AbnormalStatusNormalItem)
	{
		HandleAddNormalStatus(param);
	}
	else if (Event_ID == EV_SystemMessage && script_olydmgwnd.AtOly)
	{
		HandleSystemMessage(param);
	}	
	else if (Event_ID == EV_AbnormalStatusEtcItem)
	{
		HandleAddEtcStatus(param);
	}
	else if (Event_ID == EV_AbnormalStatusShortItem)
	{
		HandleAddShortStatus(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HandleRestart();
	}
	else if (Event_ID == EV_Die)
	{
		HandleDie();
	}
	else if (Event_ID == EV_ShowReplayQuitDialogBox)
	{
		HandleShowReplayQuitDialogBox();
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if (Event_ID == EV_ReceiveMagicSkillUse && script_olydmgwnd.AtOly)
	{
		HandleReceiveMagicSkillUse(param);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDispelArcane") )
		{
			GetPlayerInfo(uInfo);
			if (uInfo.nCurMP <= int(class'UIAPI_EDITBOX'.static.GetString("FlexOptionWnd.editArcane")))
			{
				RequestDispel(g_Info.ServerID, g_Info.ID, g_Info.Level);
			}
		}
	}
	
}

//리스타트를 하면 올클리어
function HandleRestart()
{
	ClearAll();
}

//죽었으면, Normal/Short를 클리어
function HandleDie()
{
	ClearStatus(false, false);
	ClearStatus(false, true);
}

function HandleShowReplayQuitDialogBox()
{
	Me.HideWindow();
}

//강제로 UI가 보여질 때, 프레임이 보여지는 것을 막는다
function OnShow()
{
	local int RowCount;
	RowCount = StatusIcon.GetRowCount();
	if (RowCount<1)
	{
		Me.HideWindow();
	}
}

//특정한 Status들을 초기화한다.
function ClearStatus(bool bEtcItem, bool bShortItem)
{
	local int i;
	local int j;
	local int RowCount;
	local int RowCountTmp;
	local int ColCount;
	local StatusIconInfo info;
	
	//Normal아이템을 초기화하는 경우라면, Normal아이템의 현재행을 초기화한다.
	if (bEtcItem==false && bShortItem==false)
	{
		m_NormalStatusRow = -1;
		m_SongDanceStatusRow = -1;
		m_DebuffRow = -1;
		m_TriggerSkillRow = -1;
	}
	//Etc아이템을 초기화하는 경우라면, Etc아이템의 현재행을 초기화한다.
	if (bEtcItem==true && bShortItem==false)
	{
		m_EtcStatusRow = -1;
		//~ m_ShortStatusRow = -1;
	}
	//Short아이템을 초기화하는 경우라면, Short아이템의 현재행을 초기화한다.
	if (bEtcItem==false && bShortItem==true)
	{
		m_ShortStatusRow = -1;
		//~ m_EtcStatusRow = -1;
	}
	
	RowCount = StatusIcon.GetRowCount();
	for (i=0; i<RowCount; i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		for (j=0; j<ColCount; j++)
		{
			StatusIcon.GetItem(i, j, info);
			
			//제대로 아이템을 얻어왔다면
			if (IsValidItemID(info.ID))
			{
				if (info.bEtcItem==bEtcItem && info.bShortItem==bShortItem)
				{
					StatusIcon.DelItem(i, j);
					j--;
					ColCount--;
					
						if (info.Name == script_cancel.buffNames[0])
						{
							script_cancel.tex7.SetTexture(info.IconName);
							script_cancel.iInfo[0] = info.ID;
							//AddSystemMessageString("texture 7 added");
						} else if (info.Name == script_cancel.buffNames[1])
						{
							script_cancel.tex6.SetTexture(info.IconName);
							script_cancel.iInfo[1] = info.ID;
							//AddSystemMessageString("texture 6 added");
						} else if (info.Name == script_cancel.buffNames[2])
						{
							script_cancel.tex5.SetTexture(info.IconName);
							script_cancel.iInfo[2] = info.ID;
							//AddSystemMessageString("texture 5 added");
						} else if (info.Name == script_cancel.buffNames[3])
						{
							script_cancel.tex4.SetTexture(info.IconName);
							script_cancel.iInfo[3] = info.ID;
							//AddSystemMessageString("texture 4 added");
						} else if (info.Name == script_cancel.buffNames[4])
						{
							script_cancel.tex3.SetTexture(info.IconName);
							script_cancel.iInfo[4] = info.ID;
							//AddSystemMessageString("texture 3 added");
						} else if (info.Name == script_cancel.buffNames[5])
						{
							script_cancel.tex2.SetTexture(info.IconName);
							script_cancel.iInfo[5] = info.ID;
							//AddSystemMessageString("texture 2 added");
						} else if (info.Name == script_cancel.buffNames[6])
						{
							script_cancel.tex1.SetTexture(info.IconName);
							script_cancel.iInfo[6] = info.ID;
							script_cancel.Me.ShowWindow();
							//script_cancel.Me.SetAnchor("CancelCtrlWnd", "Center", "Center", 0 , -650);
							//AddSystemMessageString("texture 1 added");
						}
					
					RowCountTmp = StatusIcon.GetRowCount();
					if (RowCountTmp != RowCount)
					{
						i--;
						RowCount--;
					}
				}
			}
		}
	}
}

function ClearAll()
{
	ClearStatus(false, false);
	ClearStatus(true, false);
	ClearStatus(false, true);
}

function UpdateDebuffWndAnchor()
{
	local int idx;

	if ( class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showDebuffTimer" ) )
	{

		if ( !class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.enableBigBuff" ) )
		{
			class'UIAPI_WINDOW'.static.SetAnchor( "DebuffWnd", "AbnormalStatusWnd", "TopLeft", "TopLeft", 0, 26 * StatusIcon.GetRowCount() );
			for ( idx = 0; idx < 12; idx++ )
			{
				class'UIAPI_WINDOW'.static.SetWindowSize( "DebuffWnd.DebuffIcon_" $ string( idx ), 26, 26 );
				if ( idx > 0 )
				{
					class'UIAPI_WINDOW'.static.SetAnchor( "DebuffWnd.DebuffIcon_" $ string( idx ), "DebuffWnd.DebuffIcon_" $ string( idx - 1 ), "TopRight", "TopLeft", 0, 0 );
				}
			}
		}
		else
		{
			class'UIAPI_WINDOW'.static.SetAnchor( "DebuffWnd", "AbnormalStatusWnd", "TopLeft", "TopLeft", 0, 34 * StatusIcon.GetRowCount() );
			for ( idx = 0; idx < 12; idx++ )
			{
				class'UIAPI_WINDOW'.static.SetWindowSize( "DebuffWnd.DebuffIcon_" $ string( idx ), 34, 34 );
				if ( idx > 0 )
				{
					class'UIAPI_WINDOW'.static.SetAnchor( "DebuffWnd.DebuffIcon_" $ string( idx ), "DebuffWnd.DebuffIcon_" $ string( idx - 1 ), "TopRight", "TopLeft", 0, 0 );
				}
			}
		}

		class'UIAPI_WINDOW'.static.SetFocus( "DebuffWnd" );
	}
}

//Normal Status 추가
function HandleAddNormalStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local StatusIconInfo info;
	
	local int temp1;

	// 발동 버프 슬롯 분리 - gorillazin 10.05.24.
	local int TriggerBuffCount;
	
	//NormalStatus 초기화
	ClearStatus(false, false);
	
	//info 초기화

	GetINIInt("Buff Control", "Size", info.Size, "PatchSettings");
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;

	BuffCnt = 0;

	// 발동 버프 슬롯 분리 - gorillazin 10.05.24.
	TriggerBuffCount = 0;

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);

	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		//debug("ID : " $ i $ "info.RemainTime : " $ info.RemainTime $ "info.Name :" $ info.Name);
		temp1 = Asc(info.Name);
		
		if (IsValidItemID(info.ID))
		{
			if (IsSongDance( info.ID, info.Level))
			{
				//debug("/////////////////songdance come in./////////////////");				
				if (m_SongDanceStatusRow == -1)
				{
					m_SongDanceStatusRow = m_NormalStatusRow +1;
					StatusIcon.InsertRow(m_SongDanceStatusRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}
				
				StatusIcon.AddCol(m_SongDanceStatusRow, info);
				//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
				//sysDebug("Song - normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
			else if (IsTriggerSkill(info.ID, info.Level))
			{
				//debug("/////////////////trigger come in./////////////////");
				if (m_TriggerSkillRow == -1 && m_SongDanceStatusRow == -1)
				{
					m_TriggerSkillRow = m_NormalStatusRow + 1;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}
				else if (m_TriggerSkillRow == -1 && m_SongDanceStatusRow > -1)
				{
					m_TriggerSkillRow = m_SongDanceStatusRow +1;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}

				if (TriggerBuffCount == NSTATUSICON_MAXCOL)
				{
					m_TriggerSkillRow++;
					StatusIcon.InsertRow(m_TriggerSkillRow);

					if (m_DebuffRow > -1)
					{
						m_DebuffRow++;
					}
				}

				StatusIcon.AddCol(m_TriggerSkillRow, info);

				TriggerBuffCount++;
				//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
				//sysDebug("Trigger - normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
			else if (IsDebuff( info.ID, info.Level))
			{
				if (!class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showDebuffTimer" ))
				{
					if (m_DebuffRow == -1 && m_SongDanceStatusRow == -1 && m_TriggerSkillRow == -1)
					{
						m_DebuffRow = m_NormalStatusRow + 1;
						StatusIcon.InsertRow(m_DebuffRow);
					}
					else if (m_DebuffRow == -1 && m_SongDanceStatusRow > -1 && m_TriggerSkillRow == -1)
					{					
						m_DebuffRow = m_SongDanceStatusRow + 1;
						StatusIcon.InsertRow(m_DebuffRow);
					}
					else if (m_DebuffRow == -1 && m_SongDanceStatusRow == -1 && m_TriggerSkillRow > -1)
					{
						m_DebuffRow = m_TriggerSkillRow + 1;
						StatusIcon.InsertRow(m_DebuffRow);
					}
					else if (m_DebuffRow == -1 && m_SongDanceStatusRow > -1 && m_TriggerSkillRow > -1)
					{
						m_DebuffRow = m_TriggerSkillRow + 1;
						StatusIcon.InsertRow(m_DebuffRow);
					}

					//sysDebug("Debuff - normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
					
					StatusIcon.AddCol(m_DebuffRow, info);
				}
				
			}
			else 
			{				
				//debug("/////////////////normal come in./////////////////");
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					m_NormalStatusRow++;
					StatusIcon.InsertRow(m_NormalStatusRow);
				}
	
				StatusIcon.AddCol(m_NormalStatusRow, info);
				
				BuffCnt++;

				//sysDebug("Normal - normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
			}
		}
		if (info.Name == "Celestial Shield" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDispelCel"))
		{
			//AddSystemMessageString("CELEST");
			RequestDispel(info.ServerID, info.ID, info.Level);
		}
		if (info.Name == "Arcane Shield")
		{
			g_Info = info;
		}
		
	}
	
	//현재 Etc, Short아이템이 표시되고 있는 중이라면, 행이 증가/삭제 되었을 경우가 있기 때문에
	if (m_EtcStatusRow > -1)
	{
		m_EtcStatusRow = m_NormalStatusRow + 1;	
		//debug("normal exist. etcRow = " $ m_EtcStatusRow);
		//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		if (m_SongDanceStatusRow > -1)
		{			
			m_EtcStatusRow = m_SongDanceStatusRow + 1;
			//debug("songdance exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_TriggerSkillRow > -1)
		{
			m_EtcStatusRow = m_TriggerSkillRow + 1;
			//debug("trigger exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_DebuffRow > -1)
		{
			m_EtcStatusRow = m_DebuffRow + 1;
			//debug("debuff exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
	}

	if (m_ShortStatusRow > -1)
	{
		m_ShortStatusRow = m_NormalStatusRow + 1;	
		//debug("normal exist. etcRow = " $ m_EtcStatusRow);
		//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		if (m_SongDanceStatusRow > -1)
		{			
			m_ShortStatusRow = m_SongDanceStatusRow + 1;
			//debug("songdance exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_TriggerSkillRow > -1)
		{
			m_ShortStatusRow = m_TriggerSkillRow + 1;
			//debug("trigger exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
		if (m_DebuffRow > -1)
		{
			m_ShortStatusRow = m_DebuffRow + 1;
			//debug("debuff exist. etcRow = " $ m_EtcStatusRow);
			//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
		}
	}

	//sysDebug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);

	UpdateDebuffWndAnchor();
	UpdateWindowSize();
}

//Etc Status 추가
function HandleAddEtcStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local int CurRow;
	local bool bNewRow;
	local StatusIconInfo info;
	
	//EtcStatus 초기화
	ClearStatus(true, false);
	//~ ClearStatus(true, true);
	//info 초기화

	GetINIInt("Buff Control", "Size", info.Size, "PatchSettings");
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = true;
	info.bShortItem = false;
	
	//추가 시작점(Normal아이템 다음줄, Short아이템 다음 열에 추가한다)
	if (m_ShortStatusRow>-1)
	{
		bNewRow = false;
		CurRow = m_ShortStatusRow;
	}
	else 
	{
		bNewRow = true;
		CurRow = m_NormalStatusRow;
		if (m_SongDanceStatusRow > -1)
		{
			CurRow= m_SongDanceStatusRow;
		}
		if (m_TriggerSkillRow > -1)
		{
			CurRow = m_TriggerSkillRow;
		}
		if (m_DebuffRow > -1)
		{
			CurRow = m_DebuffRow;
		}
	}

	//debug("//////////////////////////test_etc////////////////////////");
	//debug("normalRow = " $ m_NormalStatusRow $ ", songRow = " $ m_SongDanceStatusRow $ ", triggerRow = " $ m_TriggerSkillRow $ ", debuffRow = " $ m_DebuffRow);
	//debug("etc_curRow before = " $ CurRow);

	BuffCnt = 0;
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		
		if (IsValidItemID(info.ID))
		{
			//Etc아이템은 최대 한 행에만 표시한다.(Short아이템 뒤에...)
			if (bNewRow)
			{
				bNewRow = !bNewRow;
				CurRow++;
				StatusIcon.InsertRow(CurRow);
			}
			StatusIcon.AddCol(CurRow, info);

			//debug("etc_curRow after = " $ CurRow);
			
			m_EtcStatusRow = CurRow;
			
			BuffCnt++;
		}
	}
	
	UpdateDebuffWndAnchor();
	UpdateWindowSize();
}

//Short Status 추가
function HandleAddShortStatus(string param)
{
	local int i;
	local int Max;
	local int BuffCnt;
	local int CurRow;
	local int CurCol;
	local bool bNewRow;
	local StatusIconInfo info;
	
	//ShortStatus 초기화
	ClearStatus(false, true);
	//~ ClearStatus(true, true);
	//info 초기화

	GetINIInt("Buff Control", "Size", info.Size, "PatchSettings");
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = true;
	
/* 		m_DebuffRow = -1;
	m_NormalStatusRow = -1;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_SongDanceStatusRow = -1;
	m_bOnCurState = false;
	 */
	//추가 시작점(Normal아이템 다음줄, Etc아이템 전에 추가한다)
	CurCol = -1;
	
	if (m_EtcStatusRow>-1)
	{
		bNewRow = false;
		CurRow = m_EtcStatusRow;
	}
	else
	{
		bNewRow = true;
		CurRow = m_NormalStatusRow;
		if (m_SongDanceStatusRow > -1)
		{
			CurRow= m_SongDanceStatusRow;
		}
		if (m_TriggerSkillRow > -1)
		{
			CurRow = m_TriggerSkillRow;
		}
		if (m_DebuffRow > -1)
		{
			CurRow= m_DebuffRow;
		}
	}
	
	BuffCnt = 0;
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
			
		if (IsValidItemID(info.ID))
		{
			//Short아이템은 최대 한 행에만 표시한다.(Etc아이템과 함께..)
			if (bNewRow)
			{
				bNewRow = !bNewRow;
				CurRow++;	
				StatusIcon.InsertRow(CurRow);
			}
			CurCol++;
			StatusIcon.InsertCol(CurRow, CurCol, info);

			//debug("short_curRow after = " $ CurRow);
			
			m_ShortStatusRow = CurRow;
			
			BuffCnt++;
		}
	}	
	
	UpdateDebuffWndAnchor();
	UpdateWindowSize();	
}

//윈도우 사이즈 갱신
function UpdateWindowSize()
{
	local int RowCount;
	local Rect rectWnd;
	
	RowCount = StatusIcon.GetRowCount();
	if (RowCount>0)
	{
		//현재 GameState가 아니면 윈도우를 보이지 않는다.
		if (m_bOnCurState)
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		
		//윈도우 사이즈 변경
		rectWnd = StatusIcon.GetRect();
		Me.SetWindowSize(rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
		
		//세로 프레임 사이즈 변경
		Me.SetFrameSize(NSTATUSICON_FRAMESIZE, rectWnd.nHeight);	
	}
	else
	{
		Me.HideWindow();
	}
}

//언어 변경 처리
function HandleLanguageChanged()
{
	local int i;
	local int j;
	local int RowCount;
	local int ColCount;
	local StatusIconInfo info;
	
	RowCount = StatusIcon.GetRowCount();
	for (i=0; i<RowCount; i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		for (j=0; j<ColCount; j++)
		{
			StatusIcon.GetItem(i, j, info);
			if (IsValidItemID(info.ID))
			{
				info.Name = class'UIDATA_SKILL'.static.GetName( info.ID, info.Level );
				info.Description = class'UIDATA_SKILL'.static.GetDescription( info.ID, info.Level );
				StatusIcon.SetItem(i, j, info);
			}
		}
	}
}

// 스킬의 클릭
function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// 스킬 정보. 버프스킬인지 확인해야 하니까
	
	col = index / 10;
	row = index - (col * 10);
	
	//sysDebug( "ROW:" @ row @ "COL:" @ col );
	
	StatusIcon.GetItem(row, col, info);
	
	// ID를 가지고 스킬의 정보를 얻어온다. 없으면 패배
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"StatusIcon" ) > -1 )
	{
		if (skillInfo.IsDebuff == false && skillInfo.OperateType == 1) 		
		{	
			RequestDispel(info.ServerID, info.ID, info.Level);		
		}					//버프 취소 요청
		else												
		{	
			AddSystemMessage(2318);
		}	//강화 스킬인 경우에만 버프 취소가 가능합니다. 
	}
}

function OnTimer(int TimerID)
{
	local Color MsgColor;
	local Color PetColor;
	local Color AllColor;
	local bool isCelOn;
	local bool isSlaveAlive;
	
	local int i;
	local int j;
	local int RowCount;
	local int ColCount;
	local StatusIconInfo info;
	local UserInfo slaveInfo;
	
	MsgColor.R = 0;
	MsgColor.G = 255;
	MsgColor.B = 0;
	
	PetColor.R = 255;
	PetColor.G = 255;
	PetColor.B = 0;
	
	AllColor.R = 74;
	AllColor.G = 114;
	AllColor.B = 39;
	
	isCelOn = false;
	
	if (TimerID == 7175) //timer1
	{
	
		if (script_olydmgwnd.m_PetID != -1337)
			isSlaveAlive = GetUserInfo(script_olydmgwnd.m_PetID, slaveInfo);
		
		if (!resistedDebuff1player && resistedDebuff1pet && !isInterrupted1 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && bothHere && isMassDBuff1)
		{
			//AddSystemMessageString("DEBUFF APPLIED on player @ t1");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1pet && resistedDebuff1player && !isInterrupted1 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && isMassDBuff1 && bothHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on pet @ t1");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName1);
			isMassDBuff1 = false;
		}
		else if (!resistedDebuff1player && !resistedDebuff1pet && !isInterrupted1 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && isMassDBuff1 && bothHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED both @ t1");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,AllColor,2000, GDebuffName1);
			isMassDBuff1 = false;
		}
		else if (!resistedDebuff1pet && !isInterrupted1 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && !bothHere && !playerHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on pet @ t1 player away");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1player && !isInterrupted1 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && !bothHere && !petHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on player @ t1 pet away");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1player && isSlaveAlive && !isInterrupted1 && !isMassDBuff1 && tNameStr1 == script_olydmgwnd.EnemyName)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1pet && isSlaveAlive && !isInterrupted1 && !isMassDBuff1 && tNameStr1 != script_olydmgwnd.EnemyName)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1player && !isSlaveAlive && !isInterrupted1 && isAOEok)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1player && script_olydmgwnd.m_PetID == -1337 && !isInterrupted1 && isAOEok)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else if (!resistedDebuff1player && script_olydmgwnd.m_PetID == -1337 && !isInterrupted1 && !isMassDBuff1)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName1);
		}
		else
		{
			//if ( (GDebuffName1 == "Dreaming Spirit") || (GDebuffName1 == "Seal of Limit") || (GDebuffName1 == "Seal of Suspension") || (GDebuffName1 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd1 = false;
			}	
			//AddSystemMessageString("DEBUFF NOT APPLIED @ t1");
		}
		
		Me.KillTimer(7175);
		resistedDebuff1player = false;
		resistedDebuff1pet = false;
		isInterrupted1 = false;
		t1 = false;
		//AddSystemMessageString("TIMER1 EXPIRED");
	}
	
	if (TimerID == 7177) //timer2
	{
	
		if (script_olydmgwnd.m_PetID != -1337)
			isSlaveAlive = GetUserInfo(script_olydmgwnd.m_PetID, slaveInfo);
		
		if (!resistedDebuff2player && resistedDebuff2pet && !isInterrupted2 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && bothHere && isMassDBuff2)
		{
			//AddSystemMessageString("DEBUFF APPLIED on player @ t2");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName2 == "Curse of Abyss") || (GDebuffName2 == "Mass Slow") || (GDebuffName2 == "Curse Disease") || (GDebuffName2 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2pet && resistedDebuff2player && !isInterrupted2 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && isMassDBuff2 && bothHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on pet @ t2");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName2 == "Curse of Abyss") || (GDebuffName2 == "Mass Slow") || (GDebuffName2 == "Curse Disease") || (GDebuffName2 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName2);
			isMassDBuff2 = false;
		}
		else if (!resistedDebuff2player && !resistedDebuff2pet && !isInterrupted2 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && isMassDBuff2 && bothHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED both @ t2");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName2 == "Curse of Abyss") || (GDebuffName2 == "Mass Slow") || (GDebuffName2 == "Curse Disease") || (GDebuffName2 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,AllColor,2000, GDebuffName2);
			isMassDBuff2 = false;
		}
		else if (!resistedDebuff2pet && resistedDebuff2player && !isInterrupted2 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && !bothHere && !playerHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on pet @ t2 player away");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName2 == "Curse of Abyss") || (GDebuffName2 == "Mass Slow") || (GDebuffName2 == "Curse Disease") || (GDebuffName2 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2player && resistedDebuff2pet && !isInterrupted2 && isAOEok && script_olydmgwnd.m_PetID != -1337 && isSlaveAlive && !bothHere && !petHere)
		{
			//AddSystemMessageString("DEBUFF APPLIED on player @ t2 pet away");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName2 == "Curse of Abyss") || (GDebuffName2 == "Mass Slow") || (GDebuffName2 == "Curse Disease") || (GDebuffName2 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2player && isSlaveAlive && !isInterrupted2 && !isMassDBuff2 && tNameStr2 == script_olydmgwnd.EnemyName)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2pet && isSlaveAlive && !isInterrupted2 && !isMassDBuff2 && tNameStr2 != script_olydmgwnd.EnemyName)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,PetColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2player && !isSlaveAlive && !isInterrupted2 && isAOEok)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2player && script_olydmgwnd.m_PetID == -1337 && !isInterrupted2 && isAOEok)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else if (!resistedDebuff2player && script_olydmgwnd.m_PetID == -1337 && !isInterrupted2 && !isMassDBuff2)
		{
			//AddSystemMessageString("DEBUFF APPLIED @ t1 no pet");
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = true;
			}	
			ShowOnScreenMessage(1,2261,2,0,MsgColor,2000, GDebuffName2);
		}
		else
		{
			//if ( (GDebuffName2 == "Dreaming Spirit") || (GDebuffName2 == "Seal of Limit") || (GDebuffName2 == "Seal of Suspension") || (GDebuffName2 == "Seal of Despair") )
			if ( (GDebuffName1 == "Curse of Abyss") || (GDebuffName1 == "Mass Slow") || (GDebuffName1 == "Curse Disease") || (GDebuffName1 == "Curse Weakness") )
			{
				isOnForCastWnd2 = false;
			}	
			//AddSystemMessageString("DEBUFF NOT APPLIED @ t1");
		}
		
		Me.KillTimer(7177);
		resistedDebuff2player = false;
		resistedDebuff2pet = false;
		isInterrupted2 = false;
		t2 = false;
		//AddSystemMessageString("TIMER2 EXPIRED");
	}
	
	if (TimerID == 7176) //timer for life force
	{
		//AddSystemMessageString("TIMER EXPIRED ON LF");
		
		RowCount = StatusIcon.GetRowCount();
		for (i=0; i < RowCount; i++)
		{
			ColCount = StatusIcon.GetColCount(i);
			for (j=0; j < ColCount; j++)
			{
				StatusIcon.GetItem(i, j, info);
				
				if (info.Name == "Enchanter Ability - Barrier")
				{
					isCelOn = true;
				}
			}
		}
		
		if (isCelOn)
		{
			RequestDispel(info.ServerID, info.ID, info.Level);
			//AddSystemMessageString("CEL DISPELLED");
		}
		
		
		Me.KillTimer(7176);
	}
	
	if (TimerID == 20060)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		
		Me.KillTimer(20060);
	}
}

function HandleSystemMessage(string param)
{
	local int msg_idx;
	local string debuffcheck;
	local string DebuffName;
	local string resistName;
	local Color MsgColor;
	local int i;
	local string disarm;
	//local string tmpName;
	
	//tmpName = "jjjjjjjjj";
	
	MsgColor.R = 175;
	MsgColor.G = 125;
	MsgColor.B = 50;

	ParseInt(param, "Index", msg_idx);
	
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDebuffMsg"))
	{
		if (msg_idx == 139) //Resist skill
		{
			ParseString(param, "Param1", resistName);
			ParseString(param, "Param2", debuffcheck);
			
			if (t1 && !t2)
			{
				if (debuffcheck == GDebuffName1)
				{
					if (resistName == script_olydmgwnd.EnemyName)
					{
						resistedDebuff1player = true;
						//AddSystemMessageString("res debuff 1 on player");
					}
					else
					{
						resistedDebuff1pet = true;
						//AddSystemMessageString("res debuff 1 on pet");
					}
					
				}
			}
			else if (!t1 && t2)
			{
				if (debuffcheck == GDebuffName2)
				{
					if (resistName == script_olydmgwnd.EnemyName)
					{
						resistedDebuff2player = true;
						//AddSystemMessageString("res debuff 2 on player");
					}
					else
					{
						resistedDebuff2pet = true;
						//AddSystemMessageString("res debuff 2 on pet");
					}
				}
			}
				
			isCastedDebuff = false;	
		}
		
		if (msg_idx == 46) //Skill use
		{
			GetInfo();
			ParseString(param, "Param1", DebuffName);
			if ( (DebuffName == GDebuffName1) || (DebuffName == GDebuffName2) )
			{
				isAOEok = true;
				bothHere = true;
				playerHere = true;
				petHere = true;
				
				isCastedDebuff = true;
				
				for (i = 0; i < aoedbuffs.Length; i++)
				{
					if (DebuffName == aoedbuffs[i] && ( Distance > 190 || (DistanceToSumm > 190 && DistanceToSumm != 0) ) )
					{
						//AddSystemMessageString("BOTH NOT HERE");
						bothHere = false;
						
						if (Distance > 190 && DistanceToSumm <= 190 && DistanceToSumm != 0)
							playerHere = false;
						if (Distance <= 190 && DistanceToSumm > 190 && DistanceToSumm != 0)
							petHere = false;
					}
					
					if (DebuffName == aoedbuffs[i] && Distance > 190)
					{
						
						if (script_olydmgwnd.m_PetID != -1337 && DistanceToSumm <= 190 && DistanceToSumm != 0)
						{
							//AddSystemMessageString("AOE IN RANGE ON SUMM");
							return;
						}
						
						isAOEok = false;
						ShowOnScreenMessage(1,2261,2,0,MsgColor,1000, "OUT OF RANGE");
						//AddSystemMessageString("AOE OUT OF RANGE");
					}
				}
			}
		}
		
		if (msg_idx == 27) //Casting interrupted
		{
			if (isCastedDebuff)
			{
				if (t1 && !t2)
				{
					isInterrupted1 = true;
					//AddSystemMessageString("interrupted debuff 1");
				}
				else if (!t1 && t2)
				{
					isInterrupted2 = true;
					//AddSystemMessageString("interrupted debuff 2");
				}
			}	
				
		}
	}
	
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDisarmMsg"))
		if (msg_idx == 110) //Buff/Debuff On
		{
			ParseString(param, "Param1", disarm);
			if ( (disarm == "Disarm") || (disarm == "Mass Disarm") )
			{
				script_overlay.infoText.SetText("DISARMED!");
				script_overlay.texInfo.SetTexture(disarmInfo.TexName);
				script_overlay.infoText.SetFocus();
				script_overlay.texInfo.SetFocus();
				Me.SetTimer(20060, 3000);
			}
		}
	
}

function HandleReceiveMagicSkillUse(string a_Param)
{
	local int AttackerID;
	local int DefenderID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;
	local SkillInfo UsedSkill;
	local int SkillHitTime_ms;
	local int i;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"DefenderID",DefenderID);
	ParseInt(a_Param,"SkillID",SkillID);
	ParseInt(a_Param,"SkillLevel",SkillLevel);
	ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
	
	if ( SkillHitTime > 0 )
	{
		SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	} else {
		SkillHitTime_ms = 100;
	}
	
	GetUserInfo(AttackerID,AttackerInfo);
	GetUserInfo(DefenderID,DefenderInfo);
	GetPlayerInfo(PlayerInfo);
	
	GetSkillInfo( SkillID, SkillLevel, UsedSkill );
	
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDebuffMsg"))
	{
				if ( ((UsedSkill.IsDebuff) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
				{
					
					//gotCastedDebuff = true;
					if (!t1)
					{
						GDebuffName1 = UsedSkill.SkillName;
						CastTime1 = SkillHitTime_ms;
						
						isMassDBuff1 = false;
						
						if (UsedSkill.CastRange == -1 || SkillID == 949 || SkillID == 1495)
						{
							isMassDBuff1 = true;
							//AddSystemMessageString("MASS DEBUFF 1");
						}
							
						
						t1 = true;
						kek1 = true;
						
						tNameStr1 = tName.GetName();
						
						for (i = 0; i < buffWithHighCast.Length; i++)
							if ( GDebuffName1 == buffWithHighCast[i] )
							{
								Me.SetTimer(7175, CastTime1 + 400);//350 default
								//AddSystemMessageString("TIMER1 SET");
								return;
							}
							
						if ( GDebuffName1 == "Onslaught of Pa'agrio" || GDebuffName1 == "Hammer Crush" || GDebuffName1 == "Burning Chop")
						{
							Me.SetTimer(7175, CastTime1 + 500);
							//AddSystemMessageString("TIMER1 SET");
							return;
						}
							
						if ((GDebuffName1 != "Expose Weak Point") || (GDebuffName1 != "Icy Air"))
						{
							Me.SetTimer(7175, CastTime1 + 350);//300 default
							//AddSystemMessageString("TIMER1 SET");
						}
						else
						{
							Me.SetTimer(7175, 2000);
							//AddSystemMessageString("TIMER1 SET");
						}
						
						return;

						//AddSystemMessageString("TIMER1 SET");
					} else if (!t2)
					{
						GDebuffName2 = UsedSkill.SkillName;
						CastTime2 = SkillHitTime_ms;
						
						isMassDBuff2 = false;
						
						if (UsedSkill.CastRange == -1 || SkillID == 949 || SkillID == 1495 )
						{
							isMassDBuff2 = true;					
							//AddSystemMessageString("MASS DEBUFF 2");
						}

						
						t2 = true;
						kek2 = true;
						
						tNameStr2 = tName.GetName();
						
						for (i = 0; i < buffWithHighCast.Length; i++)
							if ( GDebuffName2 == buffWithHighCast[i] )
							{
								Me.SetTimer(7177, CastTime2 + 450);//350 default
								//AddSystemMessageString("TIMER2 SET");
								return;
							}
							
						if ( GDebuffName2 == "Onslaught of Pa'agrio" || GDebuffName2 == "Hammer Crush" || GDebuffName2 == "Burning Chop")
						{
							Me.SetTimer(7177, CastTime2 + 500);
							//AddSystemMessageString("TIMER2 SET");
						}
							
						if ((GDebuffName2 != "Expose Weak Point") || (GDebuffName2 != "Icy Air"))
						{
							Me.SetTimer(7177, CastTime2 + 400);//300 default
							//AddSystemMessageString("TIMER2 SET");
						}
						else
						{
							Me.SetTimer(7177, 2000);
							//AddSystemMessageString("TIMER2 SET");
						}
						return;
						//AddSystemMessageString("TIMER2 SET");
					}
					else
					{
						//AddSystemMessageString("TIMER1 + TIMER2 WORKING");
					}
					return;
				}
	}
	
	
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableDispelSubCel"))
		if ( ((UsedSkill.SkillName == "Red Talisman of Life Force") && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
		{
			Me.KillTimer(7176);
			Me.SetTimer(7176, 3000 - 500);
			//AddSystemMessageString("TIMER SET ON LF");
			return;
		}
	
	if ( ( (UsedSkill.SkillName == "Disarm") || (UsedSkill.SkillName == "Mass Disarm") ) && PlayerInfo.nID != AttackerID)
	{
		disarmInfo = UsedSkill;
	}
	
}

function GetInfo()
{
	local UserInfo Foe;
	local UserInfo Mine;
	local UserInfo Summ;
	local Vector x;
	local Vector y;
	local Vector z;
	local bool isAlive;
	
	isAlive = false;
	
	if (script_olydmgwnd.GlobalTargetID != 0)
	{
		GetUserInfo(script_olydmgwnd.GlobalTargetID, Foe);
		if ( script_olydmgwnd.m_PetID != -1337 )	
		{
			isAlive = GetUserInfo(script_olydmgwnd.m_PetID, Summ);
			//AddSystemMessageString("GOT PET DATA");
		}
		
		GetPlayerInfo(Mine);
		
		x = Mine.Loc;
		y = Foe.Loc;
		
		Distance = GetDistance(x,y);
		
		if (isAlive)
		{
			z = Summ.Loc;
			DistanceToSumm = GetDistance(x,z);
		}
		else
			DistanceToSumm = 0;

		script_olydmgwnd.DistanceBox.SetText(string(Distance));
		//AddSystemMessageString("Distance - " $ string(Distance));
	}
	
}

//OBFEND

defaultproperties
{
}

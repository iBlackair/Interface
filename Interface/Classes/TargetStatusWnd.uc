class TargetStatusWnd extends UICommonAPI;
	
const TimerValue1 = 1351;
const TimerValue2 = 6346;
const TimerValue3 = 4858;
const TimerValue4 = 7337;
const TimerValue5 = 3474;
const TimerValue6 = 5269;

const CONTRACT_HEIGHT = 46;
const EXPAND_HEIGHT = 76;


var bool m_bExpand;

var int	m_TargetLevel;
var int	m_TargetID;
var bool m_rotated;
var bool m_bShow;
var string g_NameStr;

var vector targetLoc;	//타겟의 위치벡터

var WindowHandle Me1;
var WindowHandle Me2;
var WindowHandle Me;
var BarHandle barMP;
var BarHandle barHP;
var TextBoxHandle txtPledgeAllianceName;
var TextureHandle texPledgeAllianceCrest;
var TextBoxHandle txtAlliance;
var TextBoxHandle txtPledgeName;
var TextureHandle texPledgeCrest;
var TextBoxHandle txtPledge;
var NameCtrlHandle RankName;
var NameCtrlHandle UserName;
var ButtonHandle btnClose;
//~ var WindowHandle BackTex;
//~ var TextureHandle BackTex3;
//~ var TextureHandle BackTex2;
//~ var TextureHandle BackTex1;
//~ var WindowHandle BackExpTex;
//~ var TextureHandle BackExpTex3;
//~ var TextureHandle BackExpTex2;
//~ var TextureHandle BackExpTex1;
var TreeHandle NpcInfo;
//~ var ButtonHandle btnRotate1;
//~ var ButtonHandle btnRotate2;
//~ var ButtonHandle btnContext1;
//~ var ButtonHandle btnContext2;
//~ var ButtonHandle btnContext3;
//~ var ButtonHandle btnContext4;
//~ var ButtonHandle btnContext5;
//~ var ButtonHandle btnContext6;
//~ var ButtonHandle btnContext7;
//~ var NameCtrlHandle NameTxt;

var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var ButtonHandle btnInfo;
var ButtonHandle btnInvite;

var TextureHandle classIcon;
var WindowHandle ed_DetailTargetStatusWnd;

var PartyWnd script_pt;


function OnRegisterEvent()
{
	RegisterEvent( EV_TargetUpdate );
	RegisterEvent( EV_TargetHideWindow );
	
	RegisterEvent( EV_UpdateHP );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMaxHP );
	RegisterEvent( EV_UpdateMaxMP );
	
	RegisterEvent( EV_ReceiveTargetLevelDiff );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Initialize();
	}
	else
		InitializeCOD();

	OnShowProcess();
	Load();
}

function Initialize()
{
	Me = GetHandle( "TargetStatusWnd" );
	barMP = BarHandle ( GetHandle( "TargetStatusWnd.barMP" ) );
	barHP = BarHandle ( GetHandle( "TargetStatusWnd.barHP" ) );
	txtPledgeAllianceName = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledgeAllianceName" ) );
	texPledgeAllianceCrest = TextureHandle ( GetHandle( "TargetStatusWnd.texPledgeAllianceCrest" ) );
	txtAlliance = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtAlliance" ) );
	txtPledgeName = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledgeName" ) );
	texPledgeCrest = TextureHandle ( GetHandle( "TargetStatusWnd.texPledgeCrest" ) );
	txtPledge = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledge" ) );
	RankName = NameCtrlHandle ( GetHandle( "TargetStatusWnd.RankName" ) );
	UserName = NameCtrlHandle ( GetHandle( "TargetStatusWnd.UserName" ) );
	btnClose = ButtonHandle ( GetHandle( "TargetStatusWnd.btnClose" ) );
	
	classIcon = TextureHandle(GetHandle("TargetStatusWnd.classIcon"));
	ed_DetailTargetStatusWnd = GetHandle("DetailTargetStatusWnd");

	NpcInfo = TreeHandle ( GetHandle( "TargetStatusWnd.NpcInfo" ) );
	Me1 = GetHandle( "TargetStatusWnd" );
	
	btnExpand = ButtonHandle ( GetHandle( "TargetStatusWnd.btnExpand" ) );;
	btnContract= ButtonHandle ( GetHandle( "TargetStatusWnd.btnContract" ) );;
	btnInfo= ButtonHandle ( GetHandle( "TargetStatusWnd.btnInfo" ) );;
	btnInvite= ButtonHandle ( GetHandle( "TargetStatusWnd.btnInvite" ) );;
}


function InitializeCOD()
{
	Me = GetWindowHandle( "TargetStatusWnd" );
	barMP =GetBarHandle( "TargetStatusWnd.barMP" );
	barHP = GetBarHandle( "TargetStatusWnd.barHP" );
	txtPledgeAllianceName = GetTextBoxHandle ( "TargetStatusWnd.txtPledgeAllianceName" );
	texPledgeAllianceCrest = GetTextureHandle ( "TargetStatusWnd.texPledgeAllianceCrest" );
	txtAlliance = GetTextBoxHandle ( "TargetStatusWnd.txtAlliance" );
	txtPledgeName = GetTextBoxHandle ( "TargetStatusWnd.txtPledgeName" );
	texPledgeCrest = GetTextureHandle ( "TargetStatusWnd.texPledgeCrest" );
	txtPledge = GetTextBoxHandle ( "TargetStatusWnd.txtPledge" );
	RankName = GetNameCtrlHandle ( "TargetStatusWnd.RankName"  );
	UserName = GetNameCtrlHandle ( "TargetStatusWnd.UserName"  );
	btnClose = GetButtonHandle ( "TargetStatusWnd.btnClose" );
	
	classIcon = GetTextureHandle("TargetStatusWnd.classIcon");
	ed_DetailTargetStatusWnd = GetWindowHandle("DetailTargetStatusWnd");

	NpcInfo = GetTreeHandle ( "TargetStatusWnd.NpcInfo" );
	Me1 = GetWindowHandle( "TargetStatusWnd" );
	
	btnExpand = GetButtonHandle ( "TargetStatusWnd.btnExpand" );
	btnContract= GetButtonHandle ( "TargetStatusWnd.btnContract" );
	btnInfo= GetButtonHandle ( "TargetStatusWnd.btnInfo" );
	btnInvite= GetButtonHandle ( "TargetStatusWnd.btnInvite" );
}

function Load()
{
	SetExpandMode(false);

	script_pt = PartyWnd(GetScript("PartyWnd"));
	
	g_NameStr = "";
	m_bShow = false;
	m_TargetID = -1;
	m_rotated = false;
	
	classIcon.HideWindow();
	classIcon.SetTexture("");
	
	//회전은 12월로 연기
	//~ btnRotate1.HideWindow();
	//~ btnRotate2.HideWindow();
}


function OnShowProcess()
{
	//~ Me2.SetAlpha(0);
	//~ Me2.HideWindow();
	//~ Me2.Rotate(False, 210000);
}

function OnRotate1()
{
	//~ debug ("Rotate1");
	Me2.SetAlpha(0);
	Me2.ShowWindow();
	Me.SetTimer(TimerValue1, 150);
//	Me2.Rotate(False, 1500);
//	Me1.Rotate(False, 1500);
	//~ btnRotate1.DisableWindow();
	//~ btnRotate2.DisableWindow();
}      

function OnRotate2()
{
	//~ debug ("Rotate2");
	Me1.SetAlpha(0);
	Me1.ShowWindow();
	Me.SetTimer( TimerValue2, 150);
//	Me2.Rotate(False, 1500);
//	Me1.Rotate(False, 1500);
	//~ btnRotate1.DisableWindow();
	//~ btnRotate2.DisableWindow();
}

function OnRotateClose()
{
	//~ 
	if ( GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		Me1.SetAlpha(0);
		Me1.ShowWindow();
		Me.SetTimer(TimerValue5, 150);
	}
//	Me2.Rotate(False, 1500);
//	Me1.Rotate(False, 1500);
	//~ btnRotate1.DisableWindow();
	//~ btnRotate2.DisableWindow();
}


function OnRotateReset()
{
	Me1.ShowWindow();
	Me2.HideWindow();
//	Me2.Rotate(False, 9999);
//	Me1.Rotate(False, 9999);
	Me1.SetAlpha(255);
	Me2.SetAlpha(0);
	m_rotated = false;
	HandleTargetUpdate();
}


function OnTimer(int TimerID)
{
	//~ debug ("TimerID" @ TimerID);
	if (TimerID==TimerValue1)	
	{	
		Me.KillTimer(TimerValue1);
		Me2.SetAlpha(255, 0.4f);
		Me1.SetAlpha(0);
		Me.SetTimer( TimerValue3,300);
	} 
	
	if(TimerID==TimerValue3)	
	{	
		Me.KillTimer( TimerValue3);
		Me1.HideWindow();
		m_rotated = true;
		//~ btnRotate1.EnableWindow();
		//~ btnRotate2.EnableWindow();
	}
	
	if (TimerID==TimerValue2)	
	{	
		Me.KillTimer( TimerValue2);
		Me1.SetAlpha(255, 0.4f);
		Me2.SetAlpha(0,);
		Me.SetTimer(TimerValue4,300);
	} 
	
	if(TimerID==TimerValue4)	
	{	
		Me.KillTimer( TimerValue4);
		Me2.HideWindow();
		m_rotated = false;
		//~ btnRotate1.EnableWindow();
		//~ btnRotate2.EnableWindow();
	}
	
	if (TimerID==TimerValue5)	
	{	
		Me.KillTimer( TimerValue5);
		Me1.SetAlpha(255, 0.4f);
		Me2.SetAlpha(0,);
		Me.SetTimer( TimerValue6,300);
	} 
	
	if(TimerID==TimerValue6)	
	{	
		Me.KillTimer( TimerValue6);
		Me2.HideWindow();
		Me1.HideWindow();
		m_rotated = false;
		//~ btnRotate1.EnableWindow();
		//~ btnRotate2.EnableWindow();
	}
	
}



function OnShow()
{
	m_bShow = true;
	//sysDebug("window showing");
	
}

function OnHide()
{
	m_bShow = false;
	g_NameStr = "";
	//sysDebug("window hiding");
}

function OnEnterState( name a_PreStateName )
{
	local int nWndWidth;
	local int nWndHeight;

	Me.GetWindowSize(nWndWidth,nWndHeight);
	//SetExpandMode(nWndHeight == 46);
}

function OnEvent(int Event_ID, string param)
{
	local UserInfo TargetInfo;
	local UserInfo Player;
	
	if (Event_ID == EV_TargetUpdate)
	{
		//sysDebug("Target Update");
		if (m_rotated )
			OnRotateReset();
		else
		{
			HandleTargetUpdate();
		
			GetPlayerInfo(Player);
			
			if ( m_targetID != -1 )
				if ( GetUserInfo(m_targetID,TargetInfo) )
				{
					if (!TargetInfo.bNpc && !TargetInfo.bPet && Player.Name != TargetInfo.Name)
					{
						btnInvite.ShowWindow();
						script_pt.WriteTargetToPartyChat(TargetInfo.nID);
						script_pt.g_MsgAutoAssist = -1;
					}
					else
					{
						btnInvite.HideWindow();
					}
				}			
		}	
	}
	else if (Event_ID == EV_TargetHideWindow)
	{
		HandleTargetHideWindow();
	}
	else if (Event_ID == EV_ReceiveTargetLevelDiff)
	{
		//~ debug("1");
		HandleReceiveTargetLevelDiff(param);
		
	}
	else if (Event_ID == EV_UpdateHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMaxHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		HandleUpdateGauge(param,1);
	}
	else if (Event_ID == EV_UpdateMaxMP)
	{
		HandleUpdateGauge(param,1);
	}
}

function HandleTargetHideWindow()
{
	if (m_rotated )
		OnRotateClose();
	else
		Me.HideWindow();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnClose":
		OnCloseButton();
		break;
	case "btnExpand":
		SetExpandMode(false);
		break;
	case "btnContract":
		SetExpandMode(true);
		break;
	case "btnInfo":
		OnInfoButton();
		break;
	case "btnInvite":
		OnInviteButton();
		break;
	}
}

function OnInviteButton()
{
	local UserInfo TargetInfo;
	local UserInfo Player;
	
	GetPlayerInfo(Player);
	
	if ( m_targetID != -1 )
		if ( GetUserInfo(m_targetID,TargetInfo) )
			if (!TargetInfo.bNpc && !TargetInfo.bPet && Player.Name != TargetInfo.Name)
				RequestInviteParty(TargetInfo.Name);
}

function OnInfoButton ()
{
  local UserInfo TargetInfo;

  //if ( ed_DetailTargetStatusWnd.IsShowWindow() )
  //{
    //ed_DetailTargetStatusWnd.HideWindow();
  //} else {
    //ed_DetailTargetStatusWnd.ShowWindow();
  //}
  if ( m_targetID != -1 )
  {
    if ( GetUserInfo(m_targetID,TargetInfo) )
    {
      printUserInfo(TargetInfo);
    }
  }
}

//종료
function OnCloseButton()
{
	RequestTargetCancel();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//HP,MP 업데이트
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	
	if (m_bShow)
	{
		ParseInt( param, "ServerID", ServerID );
		if (m_TargetID == ServerID)
			HandleTargetUpdateGauge( Type );
	}
}

//타겟과의 레벨 차이
function HandleReceiveTargetLevelDiff(string param)
{
	
	ParseInt(param, "LevelDiff", m_TargetLevel);
	//~ debug ("레벨차이" @ m_TargetLevel);
	HandleTargetUpdate();
	
}

//타겟 정보 업데이트 처리(HP, MP)
function HandleTargetUpdateGauge( int Type )
{
	local UserInfo	info;
	local int		TargetID;
	
	//타겟ID 얻어오기
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if (TargetID<1)
	{
		if (m_rotated )
			OnRotateClose();
		else
			Me.HideWindow();
		return;
	}
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
	
	switch( Type )
	{
	case 0:
		UpdateHPBar(info.nCurHP, info.nMaxHP);
	break;
	case 1:
		UpdateMPBar(info.nCurMP, info.nMaxMP);
	break;
	}	
}

//타겟 정보 업데이트 처리
function HandleTargetUpdate()
{
	
	
	local Rect rectWnd;
	local string strTmp;
	
	local int		TargetID;
	local int		PlayerID;
	local int		PetID;
	local int		ClanType;
	local int		ClanNameValue;
	
	//타겟 속성 정보
	local bool		bIsServerObject;
	local bool		bIsHPShowableNPC;	//공성진지
	local bool		bIsVehicle;
	
	local string	Name;
	local string	NameRank;
	local color	TargetNameColor;
	
	//ServerObject
	local int ServerObjectNameID;
	local Actor.EL2ObjectType ServerObjectType;
	
	//Vehicle
	local Vehicle	VehicleActor;
	local string	DriverName;
	
	//HP,MP
	local bool		bShowHPBar;
	local bool		bShowMPBar;
	
	//혈맹 정보
	local bool		bShowPledgeInfo;
	local bool		bShowPledgeTex;
	local bool		bShowPledgeAllianceTex;
	local string	PledgeName;
	local string	PledgeAllianceName;
	local texture	PledgeCrestTexture;
	local texture	PledgeAllianceCrestTexture;
	local color	PledgeNameColor;
	local color	PledgeAllianceNameColor;
	
	//NPC특성
	local bool		 bShowNpcInfo;
	local Array<int>	 arrNpcInfo;
	
	//새로운Target인가?
	local bool		IsTargetChanged;
	
	local bool  WantHideName;
	local int 	nMasterID;
	
	local UserInfo	info;
	local UserInfo PlayerInfo;
	local int ClassID;
	
	local Color WhiteColor;	//  하얀색을 설정.
	WhiteColor.R = 0;
	WhiteColor.G = 0;
	WhiteColor.B = 0;

	GetPlayerInfo(PlayerInfo);
	ClassID = Info.nSubClass; 
	
	//타겟ID 얻어오기
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if (TargetID<1)
	{
		Me.HideWindow();
		return;
	}

	if (m_TargetID!=TargetID)
	{
		IsTargetChanged = true;	
	}
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
	
	nMasterID= info.nMasterID;
	WantHideName= info.WantHideName;
	
	rectWnd = Me.GetRect();
	PledgeName = GetSystemString(431);
	PledgeAllianceName = GetSystemString(591);
	PledgeNameColor.R = 128;
	PledgeNameColor.G = 128;
	PledgeNameColor.B = 128;
	PledgeAllianceNameColor.R = 128;
	PledgeAllianceNameColor.G = 128;
	PledgeAllianceNameColor.B = 128;
	
	TargetNameColor = GetTargetNameColor(m_TargetLevel);
	
	bIsServerObject = class'UIDATA_TARGET'.static.IsServerObject();
	bIsVehicle = class'UIDATA_TARGET'.static.IsVehicle();
	
	if (bIsServerObject)
	{
		
		ServerObjectType = class'UIDATA_STATICOBJECT'.static.GetServerObjectType(m_TargetID);
		classIcon.HideWindow();
		classIcon.SetTexture("");
		
		if (ServerObjectType == EL2_AIRSHIPKEY)
		{
			Name = GetSystemString( 1966 );	//조종 키
			NameRank = "";
		}
		else
		{
			ServerObjectNameID = class'UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_TargetID);
			if (ServerObjectNameID>0)
			{
				Name = class'UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
				NameRank = "";
			}
		}		
		
		UserName.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
		
		//HP표시
		if (ServerObjectType == EL2_DOOR)
		{
			if( class'UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP( m_TargetID ) )
			{
				bShowHPBar = true;
				UpdateHPBar(class'UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_TargetID), class'UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_TargetID));
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//탈것인가?
	else if( bIsVehicle )
	{
		classIcon.HideWindow();
		classIcon.SetTexture("");
		HandleTargetHideWindow();
		return;
		
		//TO DO : 배이름, 나중에 SYSSTRING또는 서버에서 얻어오는 것으로 하자.
		UserName.SetName("AirShip", NCT_Normal,TA_Center);
		
		VehicleActor = Vehicle(class'UIDATA_TARGET'.static.GetTargetActor());
		if( VehicleActor != None )
		{
			//선장 이름
			if(VehicleActor.DriverID > 0 )
				DriverName = class'UIDATA_USER'.static.GetUserName( VehicleActor.DriverID );
			if( Len(DriverName) < 1 )
				DriverName = GetSystemString( 1967 );	// 조종사 없음
			RankName.SetName( DriverName, NCT_Normal,TA_Center );
			
			//Fuel
			//VehicleActor.MaxFuel
			//VehicleActor.CurFuel
			
			//HP
			//VehicleActor.MaxHP
			//VehicleActor.CurHP
		}		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//타겟ID는 있는데 이름을 알수없다면, 멀리있는 파티멤버로 가정
	else if (Len(info.Name)<1)
	{		
		classIcon.HideWindow();
        classIcon.SetTexture("");
		Name = class'UIDATA_PARTY'.static.GetMemberVirtualName(m_TargetID);
		if ( Name == "")
		{
			Name = class'UIDATA_PARTY'.static.GetMemberName(m_TargetID);
		}
		NameRank = "";
		//debug("m_TargetID" $ m_TargetID $ ", info.Name : " $ info.Name $ ", Name : " $ Name );
		UserName.SetName(Name, NCT_Normal,TA_Center);
		//~ NameTxt.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Npc or Pc 의 경우
	else
	{
		PlayerID = class'UIDATA_PLAYER'.static.GetPlayerID();
		PetID = class'UIDATA_PET'.static.GetPetID();
		
		bIsHPShowableNPC = class'UIDATA_TARGET'.static.IsHPShowableNPC();

		//if ((info.bNpc && !info.bPet && info.bCanBeAttacked ) ||	//몹의경우
		if ((info.bNpc && !info.bPet && bIsHPShowableNPC) ||	//몹의경우
			(PlayerID>0 && m_TargetID == PlayerID) ||		//나의경우
			(info.bNpc && info.bPet && m_TargetID == PetID) ||	//펫의경우
			(info.bNpc && bIsHPShowableNPC)	)		//공성진지
		{
			classIcon.HideWindow();
			classIcon.SetTexture("");
			if(IsAllWhiteID(info.nClassID))
			{
				Name = info.Name;
				NameRank = "";
				//debug("m_TargetID" $ m_TargetID $ ", info.Name : " $ info.Name $ ", Name : " $ Name );
				UserName.SetName(Name, NCT_Normal,TA_Center);
				//~ NameTxt.SetName(Name, NCT_Normal,TA_Center);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
					
				//HP표시
				if(! (IsNoBarID(info.nClassID)))
				{
					bShowHPBar = true;
					UpdateHPBar(info.nCurHP, info.nMaxHP);
				}
			}
			else
			{
				Name = info.Name;
				NameRank = "";	
				UserName.SetNameWithColor(Name, NCT_Normal,TA_Center,TargetNameColor);
				//~ NameTxt.SetNameWithColor(Name, NCT_Normal,TA_Center,TargetNameColor);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
				
				//HP표시
				bShowHPBar = true;
				UpdateHPBar(info.nCurHP, info.nMaxHP);
				
				//MP표시
				//if (!(info.bNpc && !info.bPet && info.bCanBeAttacked))
				if (!(info.bNpc && !info.bPet))
				{
					bShowMPBar = true;
					UpdateMPBar(info.nCurMP, info.nMaxMP);
				}
				
				//공중 몬스터인지 구분할 수 있다면	-- 비행 변신체 관련 추가
				//~ if( info.bNpc && !info.bPet && bIsHPShowableNPC )
				//~ {
					//~ UpdateTargetLoc( info.Loc );
					//~ UpdateAltitudeIcon();	// 각도 체크 업데이트
					//~ UpdateDistIcon();	// 거리 체크 업데이트
				//~ }
				
			}
		}
		//Npc or Other Pc
		else
		{
			Name = info.Name;
			ClassID = Info.nSubClass;
			
			if (WantHideName)
			{
				RankName.hideWindow();	
				
			}
			if (info.bNpc)
			{
				NameRank = "";	
				g_NameStr = "";
				classIcon.HideWindow();
				classIcon.SetTexture("");
			}
			else
			{
				NameRank = GetClassType(ClassID);//GetUserRankString(info.nUserRank);
				g_NameStr = Name;
				classIcon.ShowWindow();
				classIcon.SetTexture(GetClassIconName(ClassID));
				classIcon.SetTooltipCustomType(MakeTooltipSimpleText(GetClassType(ClassID) $ " - " $ GetClassStr(ClassID)));
				btnInvite.SetTooltipCustomType(MakeTooltipSimpleText("Invite " $ Name $ " to party"));
			}
			UserName.SetName(Name, NCT_Normal,TA_Center);
			//~ NameTxt.SetName(Name, NCT_Normal,TA_Center);
			RankName.SetName(NameRank, NCT_Normal,TA_Center);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/// 추가 정보 표시
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (m_bExpand)
		{
			if (info.bNpc && 0 >= info.nMasterID)
			{
				if (class'UIDATA_NPC'.static.GetNpcProperty(info.nClassID, arrNpcInfo))
				{
					bShowNpcInfo = true;
					
					//트리컨트롤에 Npc특성아이콘 추가
					//타겟이 바뀌었을때만 정보를 갱신한다. 안그럼 HP만 갱신될 때 깜박거림
					if (IsTargetChanged)
						UpdateNpcInfoTree(arrNpcInfo);
				}				
			}
			else
			{
				bShowPledgeInfo = true;
				debug ("nClanID.info" @ info.nClanID);
				if (info.nClanID>0)
						
	
	//~ debug ("bShowPledgeInfo" @ bShowPledgeInfo);
	//~ debug ("WantHideName" @ WantHideName);
				{
					//혈맹이름
					PledgeName = class'UIDATA_CLAN'.static.GetName(info.nClanID);
					PledgeNameColor.R = 176;
					PledgeNameColor.G = 152;
					PledgeNameColor.B = 121;
					if( PledgeName != "" && class'UIDATA_USER'.static.GetClanType( m_TargetID, ClanType ) && class'UIDATA_CLAN'.static.GetNameValue(info.nClanID, ClanNameValue) )
					{
						if( ClanType == CLAN_ACADEMY )
						{
							PledgeNameColor.R = 209;
							PledgeNameColor.G = 167;
							PledgeNameColor.B = 2;
						}
						else if( ClanNameValue > 0 )
						{
							PledgeNameColor.R = 0;
							PledgeNameColor.G = 130;
							PledgeNameColor.B = 255;
						}
						else if( ClanNameValue < 0 )
						{
							PledgeNameColor.R = 255;
							PledgeNameColor.G = 0;
							PledgeNameColor.B = 0;
						}
					}
					
					//혈맹 텍스쳐 얻어오기
					if (class'UIDATA_CLAN'.static.GetCrestTexture(info.nClanID, PledgeCrestTexture))
					{
						bShowPledgeTex = true;
						texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
					}
					else
					{
						bShowPledgeTex = false;
					}
					
					//동맹이름 및 마크
					strTmp = class'UIDATA_CLAN'.static.GetAllianceName(info.nClanID);
					if (Len(strTmp)>0)
					{
						//동맹 이름 색깔
						PledgeAllianceName = strTmp;
						PledgeAllianceNameColor.R = 176;
						PledgeAllianceNameColor.G = 155;
						PledgeAllianceNameColor.B = 121;
						
						//동맹 텍스쳐 얻어오기
						if (class'UIDATA_CLAN'.static.GetAllianceCrestTexture(info.nClanID, PledgeAllianceCrestTexture))
						{
							bShowPledgeAllianceTex = true;
							texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
						}
						else
						{
							bShowPledgeAllianceTex = false;
						}
					}
				}
			}
		}
	}
	if (!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		Me.ShowWindow();
		SetExpandMode(m_bExpand);
	}
	
	//HP,MP표시
	if (bShowHPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		barHP.ShowWindow();
	}
	else
	{
		barHP.HideWindow();
	}
	if (bShowMPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		barMP.ShowWindow();
	}
	else
	{
		barMP.HIdeWindow();
	}
	
	//Hide Cursed PC Name, ttmayrin
	if( info.nClanID < 0 )
		bShowPledgeInfo = false;
	
	//debug ("nClanID" @ info.nClanID);	
	//debug ("bShowPledgeInfo" @ bShowPledgeInfo);
	//debug ("WantHideName" @ WantHideName);
	
	//혈맹정보 표시
	if (bShowPledgeInfo)
	{
		 if (!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE" )
		{
			txtPledge.ShowWindow();
			txtAlliance.ShowWindow();
			txtPledgeName.ShowWindow();
			txtPledgeAllianceName.ShowWindow();
			txtPledgeName.SetText(PledgeName);
			txtPledgeAllianceName.SetText(PledgeAllianceName);
			txtPledgeName.SetTextColor(PledgeNameColor);
			txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
		
			if (bShowPledgeTex)
			{
				texPledgeCrest.ShowWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 66, rectWnd.nY + 43);
			}
			else
			{
				texPledgeCrest.HideWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 48, rectWnd.nY + 43);
			}
			
			if (bShowPledgeAllianceTex)
			{
				texPledgeAllianceCrest.ShowWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 66, rectWnd.nY + 59);
			}
			else
			{
				texPledgeAllianceCrest.HideWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 48, rectWnd.nY + 59);
			}
		}
		
		else
		{		
			txtPledge.HideWindow();
			txtAlliance.HideWindow();
			txtPledgeName.HideWindow();
			txtPledgeAllianceName.HideWindow();
			texPledgeCrest.HideWindow();
			texPledgeAllianceCrest.HideWindow();
				
		}
	}
	else
	{
		txtPledge.HideWindow();
		txtAlliance.HideWindow();
		txtPledgeName.HideWindow();
		txtPledgeAllianceName.HideWindow();
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
		
	}
	
	//NPC특성 표시
	if (bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		NpcInfo.ShowWindow();
		NpcInfo.ShowScrollBar(false);
	}
	else
	{
		NpcInfo.HideWindow();
	}
}

//Frame Expand버튼 처리


//Expand상태에 따른 여러가지 처리

// 타겟과의 레벨 차이에 따른 색상 값 얻어오기
function Color GetTargetNameColor(int TargetLevelDiff)
{
	local Color OutColor;
	//~ local Color ClearColor;
	local UserInfo userinfo;
	local int myLevel;
	//~ debug ("타겟 레벨 바뀌.."@ TargetLevelDiff);
	//~ OutColor = ClearColor;

	GetPlayerInfo( userinfo );
	myLevel = userinfo.nLevel;
	
	OutColor.A = 255;
	
	if (myLevel < 78 )
	{
		if (TargetLevelDiff <= -9)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -9 &&TargetLevelDiff <= -6)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -6 &&TargetLevelDiff <= -3)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -3 &&TargetLevelDiff <= 2)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 5 &&TargetLevelDiff <= 8)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 8)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	} 
	else 
	{
		// 유저레벨 78이상 일 경우 레벨 차이 색상 표시를 줄여 보여준다. 
		if (TargetLevelDiff <= -8)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -8 &&TargetLevelDiff <= -5)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -5 &&TargetLevelDiff <= -2)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -2 &&TargetLevelDiff <= 1)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 1 &&TargetLevelDiff <= 3)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 3 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 5)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	}
	//~ debug ("레벨"@ TargetLevelDiff);
	//~ debug ("색상"@ OutColor.R @ OutColor.G @ OutColor.B);
	return OutColor;
}



function SetExpandMode(bool bExpand)
{
	local int nWndWidth, nWndHeight;	// 윈도우 사이즈 받기 변수
	Me.GetWindowSize(nWndWidth, nWndHeight);
	
	m_bExpand = bExpand;
	
	m_TargetID = -1;
	HandleTargetUpdate();
	
	if (bExpand)
	{
		//~ BackTex.HideWindow();
		//~ BackExpTex.ShowWindow();
		btnExpand.ShowWindow();
		btnContract.HideWindow();
		Me.SetWindowSize(nWndWidth, EXPAND_HEIGHT);
	}
	else
	{
		//~ BackTex.ShowWindow();
		//~ BackExpTex.HideWindow();
		btnExpand.HideWindow();
		btnContract.ShowWindow();
		Me.SetWindowSize(nWndWidth, CONTRACT_HEIGHT);
	}
}

//HP바 갱신
function UpdateHPBar(int HP, int MaxHP)
{
	barHP.SetValue(MaxHP, HP);
}

//MP바 갱신
function UpdateMPBar(int MP, int MaxMP)
{
	barMP.SetValue(MaxMP, MP);
}

//~ //타겟과 나의 고도 표기를 변경해준다.
//~ function UpdateAltitudeIcon()
//~ {
	//~ //local UserInfo	MyInfo;
	//~ local vector myLoc;
	//~ local vector targetMyLoc;
	//~ local vector targetNormalV;
	//~ local vector targetProjectionLoc;
	//~ local vector zeroV;
	
	//~ local float cosAngle;
	//~ local float angle;	
	
	//~ local float a;
	//~ local float b;
	//~ local float c;
	
	//~ //GetPlayerInfo( MyInfo );
	//~ myLoc = GetPlayerPosition();

	//~ targetMyLoc.x = targetLoc.x - myLoc.x;
	//~ targetMyLoc.y = targetLoc.y - myLoc.y;
	//~ targetMyLoc.z = targetLoc.z - myLoc.z;
	//~ targetNormalV = Normal(targetMyLoc);		// 노말 벡터로 변경
	
	//~ zeroV.x = 0;
	//~ zeroV.y = 0;
	//~ zeroV.z = 0;
		
	//~ targetProjectionLoc.x = targetNormalV.x;
	//~ targetProjectionLoc.y = targetNormalV.y;
	//~ targetProjectionLoc.z = 0;
	
	//~ a = sqrt( ( targetNormalV.x)^2 + (targetNormalV.y)^2 + (targetNormalV.z)^2);
	//~ b = sqrt( ( targetProjectionLoc.x)^2 + (targetProjectionLoc.y)^2 + ( targetProjectionLoc.z)^2);
	//~ c = sqrt( (targetNormalV.x - targetProjectionLoc.x)^2  + (targetNormalV.y - targetProjectionLoc.y)^2 + (targetNormalV.z - targetProjectionLoc.z)^2 );	

	//~ cosAngle = (b^2 + c^2 - a^2) / 2 * b* c ;
	
	//~ //angle = 90 - ( Atan( cosAngle / sqrt(1- cosAngle^2)));
	//~ //if( angle < 0) angle = angle * ( -1);
		
	//~ debug("------------- cosAngle = " $ cosAngle);
	
//~ }

//~ //타겟과 나의 거리 표기를 변경해준다.
//~ function UpdateDistIcon()
//~ {
	//~ local vector myLoc;
	//~ local int distance;
	
//~ }

//~ // 타겟의 위치를 업데이트 한다.
//~ function UpdateTargetLoc( vector m_TargetPosition )
//~ {
	//~ targetLoc.x = m_TargetPosition.x;
	//~ targetLoc.y = m_TargetPosition.y;
	//~ targetLoc.z = m_TargetPosition.z;
//~ }

//트리컨트롤에 Npc특성아이콘 추가
function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i;
	local int SkillID;
	local int SkillLevel;
	
	local string				strNodeName;
	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	
	//초기화
	NpcInfo.Clear();
	
	//루트 추가
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);
	if (Len(strNodeName) < 1)
	{
		//~ debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	for (i=0; i<arrNpcInfo.Length; i+=2)
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[i+1];
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node
		infNode = infNodeClear;
		infNode.nOffSetX = ((i/2)%8)*18;
		if ((i/2)%8==0)
		{
			if (i>0)
			{
				infNode.nOffSetY = 3;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}
		
		infNode.strName = "" $ i/2;
		infNode.bShowButton = 0;
		//Tooltip
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);
		if (Len(strNodeName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		//Node Tooltip Clear
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert NodeItem
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		infNodeItem.u_strTexture = class'UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
	}
}

function CustomTooltip SetNpcInfoTooltip(int ID, int Level)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	local DrawItemInfo infoClear;
	local ItemInfo Item;
	local ItemID cID;
	
	cID = GetItemID(ID);
	
	Item.Name = class'UIDATA_SKILL'.static.GetName(cID, Level);
	Item.Description = class'UIDATA_SKILL'.static.GetDescription(cID, Level);
	
	Tooltip.DrawList.Length = 1;
	
	//이름
	info = infoClear;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Item.Name;
	Tooltip.DrawList[0] = info;

	//설명
	if (Len(Item.Description)>0)
	{
		Tooltip.MinimumWidth = 144;
		Tooltip.DrawList.Length = 2;
		
		info = infoClear;
		info.eType = DIT_TEXT;
		info.nOffSetY = 6;
		info.bLineBreak = true;
		info.t_color.R = 178;
		info.t_color.G = 190;
		info.t_color.B = 207;
		info.t_color.A = 255;
		info.t_strText = Item.Description;
		Tooltip.DrawList[1] = info;	
	}
	return Tooltip;
}

//항상 흰색으로 표시해 줄 몬스터를 체크하는 함수
function bool IsAllWhiteID(int m_TargetID)
{
	local bool	bIsAllWhiteName;
	bIsAllWhiteName = false;
	
	switch( m_TargetID )
	{
		case 12775:	//박
		case 12776:
		case 12778:
		case 12779:
		case 13016:
		case 13017:	// 박
		case 13031:	//거대 돼지
		case 13032:	//거대 돼지 리더
		case 13033:	//거대 돼지 부하
		case 13034:	//초거대 돼지
		case 13035:	//황금 돼지
		case 13036:	//연금술사의 보물상자
		case 13098:	//보물찾기 보물상자
		case 13120:	//거대 쥐
		case 13121:	
		case 13122:	
		case 13123:	
		case 13124:	

		// 수박 이벤트 2009. 8.14 추가 
		case 13271:
		case 13272:
		case 13273:
		case 13274:
		case 13275:
		case 13276:
		case 13277:
		case 13278:

		// 소 이벤트 2009. 8.14 추가 
		case 13187:
		case 13188:
		case 13189:
		case 13190:
		case 13191:
		case 13192:

		// 백호 이벤트 2019. 2.29 추가 
		case 13286: // 아기 백호
		case 13287: // 아기 백호 대장
		case 13288: // 우울한 아기 백호
		case 13289: // 우울한 아기 백호 대장
		case 13290: // 백호
		case 13291: // 백호 대장
		case 13292: // 마법 연구소 직원

			 bIsAllWhiteName = true;
			 break;
	}	
	return bIsAllWhiteName;
}

//HP 바도 표시하면 안되는 몬스터인지 체크하는 함수
function bool IsNoBarID(int m_TargetID)
{
	local bool	bIsNoBarName;
	bIsNoBarName = false;
	
	switch( m_TargetID )
	{
		case 13036:	//연금술사의 보물상자
		case 13098:	//보물찾기 보물상자
			bIsNoBarName = true;
			break;
	}	
	return bIsNoBarName;
}
defaultproperties
{
}

class OlympiadDmgWnd extends UICommonAPI;

const TIMER_ID = 15510;
const TIMER_DELAY = 1000;

var WindowHandle Me, Target;
var NameCtrlHandle OwnName, PetName;
var TextureHandle BGtex;

var BarHandle enemyHP,enemyCP;

var int EnemyCP_before_lethal, MyCP_before_lethal;
var int EnemyCP_before_reflect, EnemyCP_after_reflect;
var int EnemyHP_before_reflect, EnemyHP_after_reflect;

var int myCP;

var TextBoxHandle DmgToBox, DmgFromBox, DmgCompareBox;
var TextBoxHandle TimeRemainingBox;
var TextBoxHandle EnemyPointsBox, EnemyWinrateBox;
var TextBoxHandle MoveSpeedBox, CastSpeedBox, DistanceBox;

var StatusIconHandle	StatusIcon;

var int DmgTo; 
var int DmgFrom;

var int TimeRemaining;

var int ManaShieldDMG, CurHP1,CurCP1;
var int MaxHP,MaxCP,CurHP2,CurCP2;
var WindowHandle m_hOlyTargetWnd;
var bool isShieldCasted, CastedLeth, CastedEnemyLeth, CastedPoison, CastedCubicPoison, EnemyCastedCubicPoison, SoFCasted, MySoFCasted;
var string DebuffName, DebuffAppliedName;
var int PoisonDmg;
var SkillInfo sValue;

var string EnemyName,TestName;
var string name, nickname;
var UserInfo nUvalue;
var bool TimerStarted;
var bool AtOly;
var bool GotTarget, Charging, meCharging, hitEpet, isCelOn;
var int GlobalTargetID;
var int mypet_ID, m_PetID;
var string notmypet;
var bool isLethApplied, isEnemyLethApplied;
var string GName;
var string ReplayName;
var bool RecStart, isWin, optCheck, isBurning, isOnsl, gotDMG1, gotDMG2;
var int c_counter;

var UserInfo Merc;
var PetInfo pussy_MyPet;

var int buffCount;
var bool isFunNick;
var int	statWin,
		statLose,
		statWR,
		statWinS,
		statMaxS;

var int	eWin, eLose;
var int gLastTarget;
var array<string> donot;
var bool iCast;
var int gPTS;

var ChatWindowHandle	NormalChat,
						TradeChat,
						PartyChat,
						ClanChat,
						AllyChat;

var Color White;
var Color Red;
var Color Green;
var Color Whisper, WR;

var AbnormalStatusWnd script_abnormal;
var OptionWnd script_option;
var StatusWnd script_s;
var EnemyCastInfoWnd script_ecast;
var OlympiadSummonWnd script_olysum;

var ButtonHandle	LockButton;
var ButtonHandle	UnLockButton;
var ButtonHandle	OptionButton;

var TextBoxHandle	pName12;
var TextBoxHandle	pName10;
var TextBoxHandle	pClass;
var TextBoxHandle	pLVL;

var StatusBarHandle	pEXP;
var BarHandle		pVP;

var WindowHandle	vpToolTip;

var int m_Vitality;

function OnRegisterEvent() {
    RegisterEvent(EV_OlympiadTargetShow);
    RegisterEvent(EV_OlympiadUserInfo);
    RegisterEvent(EV_OlympiadMatchEnd);  
    RegisterEvent(EV_SystemMessage);
    RegisterEvent(EV_TargetUpdate);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent( EV_ReceiveMagicSkillUse );
	RegisterEvent( EV_ReceiveAttack );
	RegisterEvent( EV_UpdateUserInfo );
 
}

function OnLoad() {
    Me = GetWindowHandle("OlympiadDmgWnd");
    Target = GetWindowHandle("TargetStatusWnd");
	
	DmgCompareBox = GetTextBoxHandle("OlympiadDmgWnd.DmgCompare");//noneed
	EnemyPointsBox = GetTextBoxHandle("OlympiadDmgWnd.EnemyPoints");//noneed
	
    DmgToBox = GetTextBoxHandle("OlympiadDmgWnd.DmgTo");
    DmgFromBox = GetTextBoxHandle("OlympiadDmgWnd.DmgFrom");
    TimeRemainingBox = GetTextBoxHandle("OlympiadDmgWnd.TimeRemaining");
    EnemyWinrateBox = GetTextBoxHandle("OlympiadDmgWnd.EnemyWinrate");
	MoveSpeedBox = GetTextBoxHandle("OlympiadDmgWnd.MoveSpeed");
    CastSpeedBox = GetTextBoxHandle("OlympiadDmgWnd.CastSpeed");
    DistanceBox = GetTextBoxHandle("OlympiadDmgWnd.Distance");
	
	BGtex = GetTextureHandle("OlympiadDmgWnd.BGTex");
    OwnName = GetNameCtrlHandle("StatusWnd.UserName");
	m_hOlyTargetWnd=GetWindowHandle("OlympiadTargetWnd");
	NormalChat = GetChatWindowHandle( "ChatWnd.NormalChat" );
	TradeChat = GetChatWindowHandle( "ChatWnd.TradeChat" );
	PetName = GetNameCtrlHandle("TargetStatusWnd.UserName");
	StatusIcon = GetStatusIconHandle( "AbnormalStatusWnd.StatusIcon" );
	LockButton = GetButtonHandle ( "OlympiadDmgWnd.btnLock" );
	UnLockButton = GetButtonHandle ( "OlympiadDmgWnd.btnUnLock" );
	OptionButton = GetButtonHandle ( "OlympiadDmgWnd.optionBtn" );
	
	pName12 = GetTextBoxHandle("OlympiadDmgWnd.playerName12");
	pName10 = GetTextBoxHandle("OlympiadDmgWnd.playerName10");
	pClass = GetTextBoxHandle("OlympiadDmgWnd.playerClass");
	pLVL = GetTextBoxHandle("OlympiadDmgWnd.playerLVL");
	
	pEXP = GetStatusBarHandle("OlympiadDmgWnd.expBar");
	pVP = GetBarHandle("OlympiadDmgWnd.vpBar");
	vpToolTip = GetWindowHandle("OlympiadDmgWnd.vpTooltip");
	
	LockButton.HideWindow();
	//OptionButton.HideWindow();
	FieldStuff();
	
	pVP.SetValue(0, 0);
	pEXP.SetPoint(0,0);
	
    Reset();
    OnRegisterEvent();
	script_abnormal = AbnormalStatusWnd ( GetScript("AbnormalStatusWnd") );
	script_option = OptionWnd ( GetScript("OptionWnd") );
	script_s = StatusWnd ( GetScript("StatusWnd") );
	script_ecast = EnemyCastInfoWnd ( GetScript("EnemyCastInfoWnd") );
	script_olysum = OlympiadSummonWnd ( GetScript("OlympiadSummonWnd") );
	TimerStarted = false;
	GetINIInt("Stats", "Wins", statWin, "MySets");
	GetINIInt("Stats", "Loses", statLose, "MySets");
	GetINIInt("Stats", "WinRate", statWR, "MySets");
	GetINIInt("Stats", "WinStreak", statWinS, "MySets");
	GetINIInt("Stats", "MaxStreak", statMaxS, "MySets");
}

function OnHide() 
{
}

function Reset() {
	White.R = 225;
	White.G = 225;
	White.B = 225;
	
	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	
	Green.R = 0;
	Green.G = 255;
	Green.B = 0;
	
	Whisper.R = 255;
	Whisper.G = 0;
	Whisper.B = 255;
	
	WR.R = 79;
	WR.G = 182;
	WR.B = 183;
	
    // Debug("OlympiadDmgWnd reset");
    Me.KillTimer(TIMER_ID);
	Me.KillTimer(15520);
	Me.KillTimer(15530);
	Me.KillTimer(16000);
    TimeRemaining = 0;
    AtOly = false;
	GotTarget = false;
	isShieldCasted = false;
	GlobalTargetID = 0;
    EnemyName = "";
    DmgTo = 0;
    DmgFrom = 0;
    DmgToBox.SetText("[ 0 ]");
    DmgFromBox.SetText("[ 0 ]");
	DmgToBox.SetTextColor(White);
	DmgFromBox.SetTextColor(White);
    DmgCompareBox.SetText(" ");
    DmgCompareBox.SetTextColor(White);
    TimeRemainingBox.SetText("00:00");
    TimeRemainingBox.SetTextColor(White);
    //EnemyPointsBox.SetText("0");
    EnemyWinrateBox.SetText("0 pts | 0% WR / 0 matches");
	EnemyWinrateBox.SetTextColor(White);
	MoveSpeedBox.SetText("0");
    CastSpeedBox.SetText("0");
    DistanceBox.SetText("0");
	MoveSpeedBox.SetTextColor(White);
	CastSpeedBox.SetTextColor(White);
	DistanceBox.SetTextColor(White);
	CurHP1 = 20000;
	CurCP1 = 10000;
	isShieldCasted = false;
	CastedEnemyLeth = false;
	CastedLeth = false;
	CastedPoison = false;
	PoisonDmg = 0;
	DebuffName = "";
	DebuffAppliedName = "";
	CastedCubicPoison = false;
	EnemyCastedCubicPoison = false;
	SoFCasted = false;
	MySoFCasted = false;
	Charging = false;
	meCharging = false;
	//MoveSpeedBox.HideWindow();
    //CastSpeedBox.HideWindow();
	DmgCompareBox.HideWindow();
	EnemyPointsBox.HideWindow();
	mypet_ID = 0;
	m_PetID = -1337;
	hitEpet = false;
	isCelOn = false;
	myCP = 0;
	isEnemyLethApplied = false;
	isLethApplied = false;
	GName = "";
	script_abnormal.Distance = 0;
	script_abnormal.DistanceToSumm = 0;
	ReplayName = "";
	RecStart = false;
	isWin = false;
	isBurning = false;
	isOnsl = false;
	gotDMG1 = false;
	gotDMG2 = false;
	name = "";
	nickname = "";
	eWin = 0;
	eLose = 0;
	gLastTarget = 0;
	iCast = false;
}

function UpdateVp (int Vitality )
{

	m_Vitality = Vitality;
	
	if(Vitality > 20000)
	{
		//debug("ERROR!! - Vitality can not be over 20000");
		vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
		pVP.SetValue(0,0);
	}
	else if(Vitality >= 17000) 	//활력 4단계. 경험치 보너스 300%. 사이값 3000
	{
		vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"4",MakeFullSystemMsg(GetSystemMessage(2330),"300%",""))));
		pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"4",MakeFullSystemMsg(GetSystemMessage(2330),"300%",""))));
		pVP.SetValue(20000,Vitality);
		
	}
	else if(Vitality >=13000)	// 활력 3단계. 경험치 보너스 250%. 사이값 4000
	{
        vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"3",MakeFullSystemMsg(GetSystemMessage(2330),"250%",""))));
        pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"3",MakeFullSystemMsg(GetSystemMessage(2330),"250%",""))));
        pVP.SetValue(20000,Vitality);
	}
	else if(Vitality >= 2000)		//활력 2단계. 경험치 보너스 200%. 사이값 11000 
	{
        vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"2",MakeFullSystemMsg(GetSystemMessage(2330),"200%",""))));
        pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"2",MakeFullSystemMsg(GetSystemMessage(2330),"200%",""))));
        pVP.SetValue(20000,Vitality);
	}
	else if(Vitality >= 240)		//활력 1단계. 경험치 보너스 150%. 사이값 1760
	{
        vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"1",MakeFullSystemMsg(GetSystemMessage(2330),"150%",""))));
        pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"1",MakeFullSystemMsg(GetSystemMessage(2330),"150%",""))));
        pVP.SetValue(20000,Vitality);
	}
	else	// 활력 0단계. 경험치 보너스 없음. 사이값 240.
	{
        vpToolTip.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
        pVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(2329),"0",MakeFullSystemMsg(GetSystemMessage(2330),"0",""))));
        pVP.SetValue(20000,Vitality);
	}
}

function int LevelOfVitality ( int Vitality)
{
	if(Vitality > 20000)		return 0;			
	else if(Vitality >= 17000) 	return 4;	//활력 4단계. 경험치 보너스 300%. 
	else if(Vitality >= 13000)	return 3;	//활력 3단계. 경험치 보너스 250%.
	else if(Vitality >= 2000)		return 2;	//활력 2단계. 경험치 보너스 200%.
	else if(Vitality >= 240)		return 1;	//활력 1단계. 경험치 보너스 150%.
	else					return 0;	//활력 0단계. 경험치 보너스 없음.
}

function SetFieldInfo()
{
	local UserInfo pInfo;
	
	GetPlayerInfo(pInfo);
	SaveStatus();
	
	if (Len(pInfo.Name) > 14)
	{
		pName10.SetText(pInfo.Name);
		pName10.ShowWindow();
		pName12.HideWindow();
		pName12.SetText("");
	}
	else
	{
		pName12.SetText(pInfo.Name);
		pName12.ShowWindow();
		pName10.HideWindow();
		pName10.SetText("");
	}
		
	
	pClass.SetText(GetClassType(pInfo.nSubClass));
	pLVL.SetText(string(pInfo.nLevel));
	pEXP.SetPointExpPercentRate(pInfo.fExpPercentRate);
	
	Me.SetTimer(TIMER_ID, TIMER_DELAY);

	if (pInfo.nVitality != m_Vitality)
		UpdateVp( pInfo.nVitality );
	
}

function OlympiadStuff()
{

	pName12.HideWindow();
	pName10.HideWindow();
	pClass.HideWindow();
	pLVL.HideWindow();
	pEXP.HideWindow();
	pVP.HideWindow();
	vpToolTip.HideWindow();
	
	DmgToBox.ShowWindow();
    DmgFromBox.ShowWindow();
    TimeRemainingBox.ShowWindow();
    EnemyWinrateBox.ShowWindow();
	MoveSpeedBox.ShowWindow();
    CastSpeedBox.ShowWindow();
    DistanceBox.ShowWindow();
}

function FieldStuff()
{
	local UserInfo pInfo;
	
	DmgToBox.HideWindow();
    DmgFromBox.HideWindow();
    TimeRemainingBox.HideWindow();
    EnemyWinrateBox.HideWindow();
	MoveSpeedBox.HideWindow();
    CastSpeedBox.HideWindow();
    DistanceBox.HideWindow();
	
	GetPlayerInfo(pInfo);
	
	if (Len(pInfo.Name) > 14)
	{
		pName10.ShowWindow();
		pName12.HideWindow();
	}
	else
	{
		pName12.ShowWindow();
		pName10.HideWindow();
	}
		
	pClass.ShowWindow();
	pLVL.ShowWindow();
	pEXP.ShowWindow();
	pVP.ShowWindow();
	vpToolTip.ShowWindow();
}

function OnLockButton()
{
	if (!Me.IsDraggable())
		Me.SetDraggable(true);
	LockButton.HideWindow();
	UnLockButton.ShowWindow();
}

function OnUnLockButton()
{
	if (Me.IsDraggable())
		Me.SetDraggable(false);
	UnLockButton.HideWindow();
	LockButton.ShowWindow();
}

function OnClickButton( string a_strID )
{	
	switch( a_strID )
	{
	case "optionBtn":
		OptionBtnShow();
		break;
	case "closeBtn":
		Me.HideWindow();
		break;
	case "btnLock":
		OnLockButton();
		break;
	case "btnUnLock":
		OnUnLockButton();
		break;
	}
}

function OptionBtnShow()
{
	local OlyDmgOptionWnd script;
	
	script = OlyDmgOptionWnd( GetScript( "OlyDmgOptionWnd" ) );
	
	if (!script.Me.IsShowWindow())
	{
		script.Me.ShowWindow();
		//For sudden(1)
	}
	else
	{
		
		script.Me.HideWindow();
		//For sudden(2)
	}
}

function HoldTarget(string param)
{
	local int AttackerID;
	local int DefenderID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local int SkillHitTime_ms;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;
	local int i;

	ParseInt(param,"AttackerID",AttackerID);
	ParseInt(param,"DefenderID",DefenderID);
	ParseInt(param,"SkillID",SkillID);
	ParseInt(param,"SkillLevel",SkillLevel);
	ParseFloat(param,"SkillHitTime",SkillHitTime);

	if ( SkillHitTime > 0 )
	{
		SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	} else 
	{
		SkillHitTime_ms = 100;
	}
	
	for (i = 0; i < donot.Length; i++)
		if (donot[i] == EnemyName)
			return;
	
	if (SkillID == 5144 || SkillID == 5694) //Mirage or PvP Armor
	{
		GetPlayerInfo(PlayerInfo);
		GetUserInfo(DefenderID, DefenderInfo);
		GetTargetInfo(AttackerInfo);
		
		if (PlayerInfo.nID != DefenderInfo.nID)
			return;
	
		if ( AttackerInfo.nID > 0 )
			Me.SetTimer(2018, SkillHitTime_ms + 50);
	}
}

function CancelTarget(string param)
{
	local int AttackerID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local int SkillHitTime_ms;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo Target;
	local int i;

	ParseInt(param,"AttackerID",AttackerID);
	ParseInt(param,"SkillID",SkillID);
	ParseInt(param,"SkillLevel",SkillLevel);
	ParseFloat(param,"SkillHitTime",SkillHitTime);
	
	GetPlayerInfo(PlayerInfo);
	GetUserInfo(AttackerID, AttackerInfo);
	
	if ( SkillHitTime > 0 && AttackerInfo.nID == PlayerInfo.nID)
	{
		iCast = true;
		Me.SetTimer(15, int(SkillHitTime * 1000) + 300);
		//AddSystemMessageString("iCast -" @ iCast);
		return;
	}

	if ( SkillHitTime > 0 )
	{
		SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	} else 
	{
		SkillHitTime_ms = 100;
	}
	
	for (i = 0; i < donot.Length; i++)
		if (donot[i] == EnemyName)
			return;
		
	if (SkillID == 1436 || SkillID == 1417 || SkillID == 101 || SkillID == 352 || SkillID == 353 || SkillID == 347) //SoP, Aura Flash, Stun Shot, Shield Bash, Shiled Slam, Earthquake
	{
		GetPlayerInfo(PlayerInfo);
		GetUserInfo(AttackerID, AttackerInfo);
		GetTargetInfo(Target);
		
		if (PlayerInfo.nID == AttackerInfo.nID)
			return;
	
		if (Target.nID > 0 )
		{
			gLastTarget = Target.nID;
			RequestTargetCancel();
			Me.SetTimer(2019, SkillHitTime_ms + 250);
		}
		else
		{
			gLastTarget = AttackerID;
			RequestTargetCancel();
			Me.SetTimer(2019, SkillHitTime_ms + 250);
		}

	}
}

function OnEvent(int Event_ID, string param)
{
    if (Event_ID == EV_OlympiadTargetShow) 
	{
        Reset();
		AtOly = true;
        TimeRemaining = 360;
		OlympiadStuff();
        Me.ShowWindow();
        Me.SetTimer(TIMER_ID, TIMER_DELAY);
		SaveStatus();
		Me.SetTimer(11, 1500);
    } else if (EnemyName == "" && Event_ID == EV_OlympiadUserInfo) {
		GetEnemyName(param);
    } else if (Event_ID == EV_OlympiadMatchEnd) {
        Reset();
		FieldStuff();
		Me.SetTimer(1234, 6000);
    } else if (Event_ID == EV_SystemMessage && AtOly) {
        HandleBuffInfo(param);
		HandleSystemmsg(param);
	} else if (AtOly && Event_ID == EV_ReceiveMagicSkillUse) {
			if ( !GotTarget )
				HandleUserInfo(param);
			HandleReceiveMagicSkillUse(param);
			HandleReceiveLethalSkillUse(param);
			HandleReceiveCubicSkillUse(param);
			HandleReceiveSoFSkillUse(param);
			if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableRetarget"))
				HoldTarget(param);
			//CancelTarget(param);
			SetDelay(param);
	} else if (Event_ID == EV_OlympiadUserInfo) {
		CalculateCP(param);
		GetStats(param);
	} else if (Event_ID == EV_ReceiveAttack) {
		HandleReceiveAttack(param);
		HandleReceiveMyAttack(param);
	} else if (Event_ID == EV_UpdateUserInfo && !AtOly)
		SetFieldInfo();
}

function SaveStatus()
{
	GetPlayerInfo(nUvalue);
	name=nUvalue.Name;
	nickname=nUvalue.strNickName;
}

function FlameFoe(int seed)
{
	switch (seed)
	{
		case 0:
			ProcessChatMessage(" \\O/         . ` ` .", 0);
			ProcessChatMessage("   |         .`        `.", 0);
			ProcessChatMessage("   |==3 `               `.", 0);
			ProcessChatMessage(" /  \\                      " $ EnemyName, 0);		
		break;
		case 1:
			ProcessChatMessage("  .!.  O___",0);
			ProcessChatMessage("    \\/|    " $ EnemyName,0);
			ProcessChatMessage("       |   __________",0);
			ProcessChatMessage("     / \\ |__________|",0);
			ProcessChatMessage("          |__TRASH__|",0);
			ProcessChatMessage("          |__________|",0);
		break;
		case 2:
			ProcessChatMessage("     O",0);
			ProcessChatMessage("    /\\ ",0);
			ProcessChatMessage("  /_____(o_0)",0);
			ProcessChatMessage(" _\\\\   \\  " $ EnemyName,0);
		break;
		case 3:
			ProcessChatMessage(" ..O",0);
			ProcessChatMessage(" ./|\\            " $ EnemyName,0);
			ProcessChatMessage(" ..| 8==3O./  ",0);
			ProcessChatMessage(" ./|\\..........\\ ",0);
			ProcessChatMessage(" ................|.\\ ",0);
		break;
		default:
			AddSystemMessageString("Seed not from 0 to 3");
		break;
	}
}

function OnEnterState( name a_PreStateName )
{
	if ( (a_PreStateName == 'LoadingState') )
	{
		TimerStarted = false;
	}
	
}

function OnTimer(int TimerID) {
    local int min, sec;
    local string pad;
	local color Yellow,Orange;
	local array<string> fun;
	local int i;
	
	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	
	Yellow.R = 255;
	Yellow.G = 215;
	Yellow.B = 0;
	
	Orange.R = 255;
	Orange.G = 125;
	Orange.B = 0;
	
    if (TimerID == TIMER_ID && TimeRemaining > 0) {
        min = TimeRemaining / 60;
        sec = TimeRemaining % 60;
        if (sec < 10)
            pad = "0";
        else
            pad = "";
        TimeRemainingBox.SetText("0" $ min $ ":" $ pad $ sec);
		if (TimeRemaining <= 120 && TimeRemaining > 60)
            TimeRemainingBox.SetTextColor(Yellow);
		else
        if (TimeRemaining <= 60 && TimeRemaining > 30)
            TimeRemainingBox.SetTextColor(Orange);
		else
		if (TimeRemaining <= 30)
            TimeRemainingBox.SetTextColor(Red);
        TimeRemaining -= 1;
		
		mypet_ID = class'UIDATA_PET'.static.GetPetID();
		script_abnormal.GetInfo();
		//script_olysum.GetPetsHP();
    } else if (TimerID == TIMER_ID && TimeRemaining == 0)
	{
		Me.KillTimer(TIMER_ID);
		i = 0;
		while (i != 13)
		{
			if (donot[i] == script_ecast.HandleAttack(nUvalue.Name))
			{
				GlobalTargetID = nUvalue.nID;
			}
			i++;
		}
		if (GlobalTargetID != nUvalue.nID)
		{
			
		}
	}
	
	if (TimerID == 15520) 
	{
		Me.KillTimer(15520);
		SoFCasted = false;
		
	}
	
	if (TimerID == 15530) 
	{
		Me.KillTimer(15530);
		MySoFCasted = false;
	}
	
	if (TimerID == 16000) 
	{
		Me.KillTimer(16000);
		CurCP1 = 50000;
		CurHP1 = 50000;
	}
	
	if (TimerID == 1487) 
	{
		Me.KillTimer(1487);
		ToggleReplayRec();
		RecStart = false;
		if (!isWin && ReplayName != "")
			EraseReplayFile(ReplayName);
	}
	
	if (TimerID == 1331) 
	{
		isLethApplied = false;
		Me.KillTimer(1331);
	}
	
	if (TimerID == 1332) 
	{
		isEnemyLethApplied = false;
		Me.KillTimer(1332);
	}
	
	if (TimerID == 1334 && !gotDMG1) 
	{
		isBurning = false;
		Me.KillTimer(1334);
	}
	
	if (TimerID == 1335 && !gotDMG2) 
	{
		isOnsl = false;
		Me.KillTimer(1335);
	}
	
	
	if (TimerID==8843)
	{

		fun[0] = "              bl";
		fun[1] = "            blbl";
		fun[2] = "          blblbl";
		fun[3] = "        blblblbl";
		fun[4] = "      blblblblbl";
		fun[5] = "    blblblblblbl";
		fun[6] = "  blblblblblblbl";
		fun[7] = "blblblblblblblbl";
		fun[8] = "blblblblblblbl  ";
		fun[9] = "blblblblblbl    ";
		fun[10] = "blblblblbl      ";
		fun[11] = "blblblbl        ";
		fun[12] = "blblbl          ";
		fun[13] = "blbl            ";
		fun[14] = "bl              ";
		fun[15] = "                ";
		fun[16] = "gf bratan";
		fun[17] = "gf bratan";
		fun[18] = "                ";
		fun[19] = "gf bratan";
		fun[20] = "gf bratan";
		fun[21] = "                ";
		fun[22] = "gf bratan";
		fun[23] = "gf bratan";
		fun[24] = "                ";

		
			for (i = 0; i < fun.Length; i++)
				if (c_counter == i)
				{
					RequestClanChangeNickName( name, fun[i] );
					if (c_counter!=fun.Length)
						c_counter++;
					break;
				}
			if (c_counter==fun.Length)
			{
				c_counter=0;
			}
		
	}
	
	if (TimerID == 1234)
	{
		Me.KillTimer(1234);
		RequestClanChangeNickName( name, nickname );
	}
	
	if (TimerID == 10)
	{
		class'UIAPI_WINDOW'.static.KillUITimer("OlympiadDmgWnd", 10);
		BuffMe();
	}
	
	if (TimerID == 11)
	{
		Me.KillTimer(11);
		GetPlayerInfo(Merc);
		GetPetInfo(pussy_MyPet);
		buffCount = 0;
		if (Merc.Name == "Merc" && pussy_MyPet.Name == "Feline Queen")
			BuffMe();
	}
	
	if (TimerID == 2018)
	{
		Me.KillTimer(2018);
		RequestTargetUser( GlobalTargetID );
	}
	
	if (TimerID == 2019)
	{
		Me.KillTimer(2019);
		RequestTargetUser( gLastTarget );
		//AddSystemMessageString("Target Returned");
	}
	
	if (TimerID == 15)
	{
		Me.KillTimer(15);
		iCast = false;
	}

}

function AddChatInfo(string sInfo)
{
	local Color ColorMsg;
	
	ColorMsg.R = 255;
	ColorMsg.G = 0;
	ColorMsg.B = 255;
	
	NormalChat.AddString( sInfo, ColorMsg );
	TradeChat.AddString( sInfo, ColorMsg );
	//PartyChat.AddString( sInfo, ColorMsg );
	//ClanChat.AddString( sInfo, ColorMsg );
	//AllyChat.AddString( sInfo, ColorMsg );
}

function HandleUserInfo(string param)
{
	local int AttackerID;
	local int DefenderID;
	local int ClassID;
	local vector location;
	
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;
	local PetInfo myPet;
	local array<string> badNames;
	local int i;


	ParseInt(param, "AttackerID", AttackerID);
	ParseInt(param, "DefenderID", DefenderID);
	
	GetUserInfo(AttackerID,AttackerInfo);
	GetUserInfo(DefenderID,DefenderInfo);
	GetPlayerInfo(PlayerInfo);
	GetPetInfo(myPet);
	
	badNames[0] = "Olympiad Host";
	badNames[1] = "Imperial Phoenix";
	badNames[2] = "Dark Panther";
	badNames[3] = "Mew the Cat";
	badNames[4] = "Nightshade";
	badNames[5] = "Magnus the Unicorn";
	badNames[6] = "Mechanic Golem";
	badNames[7] = "Divine Beast";
	badNames[8] = "Unicorn Seraphim";
	badNames[9] = "Feline Queen";
	badNames[10] = "Reanimated Man";
	badNames[11] = "Kai the Cat";
	badNames[12] = "Boxer the Unicorn";

	
	
	for (i = 0; i < 13; i++)
	{
		if ( InStr( DefenderInfo.Name, badNames[i] ) > -1 )
		{
			return;
		}
	}
	
		return;
		
	if ( (PlayerInfo.Name == DefenderInfo.Name) || (PlayerInfo.Name == AttackerInfo.Name) || (myPet.Name == DefenderInfo.Name) || (myPet.Name == AttackerInfo.Name) )
		return;
	
	RequestTargetUser( DefenderID );
	ExecuteCommand("/olympiadstat");
	ClassID = DefenderInfo.nSubClass;
	location = DefenderInfo.Loc;
	ShowOnScreenMessage(1,2261,5,0,WR,3000, DefenderInfo.Name $ " - " $ GetClassType(ClassID));
	AddChatInfo( "Olympiad Host: " $ DefenderInfo.Name $ " - " $ GetClassType(ClassID) );
	GName = DefenderInfo.Name;
	GlobalTargetID = DefenderID;
	GotTarget = true;
	//AddSystemMessageString("Foe pet ID if got target: " $ m_PetID);
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableReplay"))//Option Wnd Checkbox
	{
		ToggleReplayRec();//Start Rec.
		RecStart = true;	
	}
	
	GetINIInt( GName, "Win", eWin, "MySets" );
	AddChatInfo( "Olympiad Host: " $ "Win(s) - " $ eWin );
	GetINIInt( GName, "Lose", eLose, "MySets" );
	AddChatInfo( "Olympiad Host: " $ "Lose(s) - " $ eLose );
}

function CalculateCP(string param)
{
	local int m_CurCP, m_CurHP, m_MaxCP, m_MaxHP;
	local int i, totalCount;
	local int differenceCP, differenceHP;
	
	ParseInt(param, "TotalCount", totalCount);
	
	for (i = 0; i < totalCount; i++) {

		ParseString(param, "Name_" $ string (i), TestName);
		ParseInt(param, "MaxHP_" $ string (i), m_MaxHP);
		ParseInt(param, "CurHP_" $ string (i), m_CurHP);
		ParseInt(param, "MaxCP_" $ string (i), m_MaxCP);
		ParseInt(param, "CurCP_" $ string (i), m_CurCP);
		
			if (TestName != OwnName.GetName())
			{	
				if (Charging)
				{
					EnemyCP_after_reflect = m_CurCP;
					EnemyHP_after_reflect = m_CurHP;
					//AddSystemMessageString("CPafter"$string(EnemyCP_after_reflect));
					//AddSystemMessageString("HPafter"$string(EnemyHP_after_reflect));
					if (EnemyCP_after_reflect < EnemyCP_before_reflect)
					{
						differenceCP = EnemyCP_before_reflect - EnemyCP_after_reflect;
						DmgTo += differenceCP;
						DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
					} 
					
					if (EnemyHP_after_reflect < EnemyHP_before_reflect)
					{
						differenceHP = EnemyHP_before_reflect - EnemyHP_after_reflect;
						DmgTo += differenceHP;
						DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
					}
						
					Charging = false;
				
				}
			}
	}
}

function String GetMovingSpeed( UserInfo a_UserInfo )
{
	local float MovingSpeed;

	MovingSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	
	return String( int(MovingSpeed));
}

function GetStats(string param)
{
	local int m_ID;
	local int i, totalCount;
	local UserInfo EnemyInfo;
	local UserInfo MyInfo;
	local string MovingSpeed, MyMovingSpeed;
	local string CastingSpeed;
	local color Red, Green, Gray;
	
	Red.R = 196; Red.G = 69; Red.B = 69;
	Green.R = 155; Green.G = 214; Green.B = 132;
	Gray.R = 128; Gray.G = 128; Gray.B = 128;
	
	GetPlayerInfo(MyInfo);
	
	if (DmgTo == DmgFrom)
	{
		DmgToBox.SetTextColor(Gray);
		DmgFromBox.SetTextColor(Gray);
    } else if (DmgTo > DmgFrom) 
	{
		DmgToBox.SetTextColor(Green);
		DmgFromBox.SetTextColor(Gray);
    } else if (DmgTo < DmgFrom) 
	{
		DmgToBox.SetTextColor(Red);
		DmgFromBox.SetTextColor(Gray);
    }
	
	ParseInt(param, "TotalCount", totalCount);
	
	for (i = 0; i < totalCount; i++) {

		ParseString(param, "Name_" $ string (i), TestName);
		ParseInt(param, "ID_" $ string (i), m_ID);
		
			if (TestName != OwnName.GetName())
			{
				GetUserInfo(m_ID, EnemyInfo);
				
				MovingSpeed = GetMovingSpeed( EnemyInfo );
				MyMovingSpeed = GetMovingSpeed( MyInfo );
				CastingSpeed = string(EnemyInfo.nMagicCastingSpeed);
				
				MoveSpeedBox.SetText(MovingSpeed);
				CastSpeedBox.SetText(CastingSpeed);
				
				if (int(MovingSpeed) == int(MyMovingSpeed)) {
					MoveSpeedBox.SetTextColor(White);
				} else if (int(MovingSpeed) < int(MyMovingSpeed)) {
					MoveSpeedBox.SetTextColor(Green);
				} else if (int(MovingSpeed) > int(MyMovingSpeed)) {
					MoveSpeedBox.SetTextColor(Red);
				}
			}
	}


}

function GetEnemyName(string param) {
    local int totalCount, myTeamNum;
    local int i;
	
	ParseInt(param, "MyTeamNum", myTeamNum);
    ParseInt(param, "TotalCount", totalCount);
	
	enemyHP = GetBarHandle("OlympiadTargetWnd.TargetWnd0.barHP");
	enemyCP = GetBarHandle("OlympiadTargetWnd.TargetWnd0.barCP");
	m_hOlyTargetWnd=GetWindowHandle("OlympiadTargetWnd");
	
	

   for (i = 0; i < totalCount; i++) {
        ParseString(param, "Name_" $ string (i), EnemyName);

        if (EnemyName != "" && EnemyName != OwnName.GetName())
            break;
        else
            EnemyName = "";
    }
}

function HandleSystemmsg(string param) {
    local int msg_idx;
    local string to,from,who;
    local int howmuch;
	local string summname, debuffcheck;
	local array<string> summnames;
	local string debuffs[15];
	local int debuffsDmg[15], CubicPoisonDmg, CubicIcyAirDmg;
	local int i;
	local UserInfo eSumm;
	local UserInfo myInfo;

    local string points, wins, winrate, matches;
	local int WR_percent;
	local float fWR;
	
	local int Seconds;
	
	GetUserInfo(m_PetID, eSumm);

    ParseInt(param, "Index", msg_idx);
    if (msg_idx == 1673) 
	{
        ParseString(param,"Param1", matches);
		ParseString(param,"Param2", wins);
        ParseString(param,"Param4", points);
		gPTS = int(points);
		fWR = ( float(wins) / float(matches) ) * 100;
		WR_percent = int(fWR);
        winrate = points $ " pts | " $ string(WR_percent) $ "% WR" $ " / " $ matches $ " matches";
        EnemyWinrateBox.SetText(winrate);
		EnemyWinrateBox.SetTextColor(WR);
        return;
    }
	
	summnames[0] = "Mew the Cat";
	summnames[1] = "Magnus the Unicorn";
	summnames[2] = "Nightshade";
	summnames[3] = "Kai the Cat";
	summnames[4] = "Kat the Cat";
	summnames[5] = "Boxer the Unicorn";
	summnames[6] = "Imperial Phoenix";
	summnames[7] = "Dark Panther";
	summnames[8] = "Mechanic Golem";
	summnames[9] = "Divine Beast";
	summnames[10] = "Mirage the Unicorn";
	summnames[11] = "Reanimated Man";
	summnames[12] = "Feline King";
	summnames[13] = "Unicorn Seraphim";
	
	debuffs[0] = "Burning Chop"; debuffsDmg[0] = 495;
	debuffs[1] = "Onslaught of Pa'agrio"; debuffsDmg[1] = 1035;
	debuffs[2] = "Ice Dagger"; debuffsDmg[2] = 750;
	debuffs[3] = "Throne of Ice"; debuffsDmg[3] = 1500;
	debuffs[4] = "Throne of Wind"; debuffsDmg[4] = 1500;
	debuffs[5] = "Inferno"; debuffsDmg[5] = 675;
	debuffs[6] = "Blade Rush"; debuffsDmg[6] = 1000;//half reduced
	debuffs[7] = "Death Mark"; debuffsDmg[7] = 700;//half reduced
	debuffs[8] = "Bleed"; debuffsDmg[8] = 500;//half reduced
	debuffs[9] = "Ghost Piercing"; debuffsDmg[9] = 2250;
	debuffs[10] = "Flame Hawk"; debuffsDmg[10] = 2250;
	debuffs[11] = "Arrow Rain"; debuffsDmg[11] = 2250;
	debuffs[12] = "Star Fall"; debuffsDmg[12] = 1500;
	debuffs[13] = "Meteor"; debuffsDmg[13] = 1500;
	debuffs[14] = "Force of Destruction"; debuffsDmg[14] = 1500;
	CubicPoisonDmg = 2000;
	CubicIcyAirDmg = 2500;
	
	if (CastedCubicPoison)
	{
		DmgTo += 2250;
		DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
		CastedCubicPoison = false;
	}
	
	if (msg_idx == 110)//Debuff applied
	{
		ParseString(param, "Param1", DebuffAppliedName);
		for (i = 0; i < 15; i++)
			if (DebuffAppliedName == debuffs[i])
			{
				PoisonDmg = debuffsDmg[i];
				DmgFrom += PoisonDmg;
				DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
				//AddSystemMessageString("DMG: "$string(PoisonDmg));
				return;
			}
			if (((DebuffAppliedName == "Icy Air") || (DebuffAppliedName == "Poison")) && EnemyCastedCubicPoison)
			{
				
				if (DebuffAppliedName == "Icy Air")
					PoisonDmg = CubicIcyAirDmg;
				if (DebuffAppliedName == "Poison")
					PoisonDmg = CubicPoisonDmg;
					
				DmgFrom += PoisonDmg;
				DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
				//AddSystemMessageString("DMG: "$string(PoisonDmg));
				return;
			}
		return;
	}
	
	if (msg_idx == 46) //Skill use
	{
		ParseString(param, "Param1", DebuffName);
		for (i = 0; i < 15; i++)
		{
			if (DebuffName == debuffs[i] && !isBurning && !isOnsl)
			{	
				CastedPoison = true;
				PoisonDmg = debuffsDmg[i];
				
				DmgTo += PoisonDmg;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
				return;
			}
			
		}
		return;
	}
	
	if (msg_idx == 139) //Resist skill
	{
		ParseString(param, "Param2", debuffcheck);
		ParseString(param, "Param1", who);
		if ((debuffcheck == DebuffName) || (debuffcheck == "Icy Air") || (debuffcheck == "Poison") )
		{
			
			if (debuffcheck == "Burning Chop" && gotDMG1 && who == EnemyName)
			{
				DmgTo -= 495;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				//AddSystemMessageString("Damage removed from Burning");
			}
			
			if (debuffcheck == "Onslaught of Pa'agrio" && gotDMG2 && who == EnemyName)
			{
				DmgTo -= 1035;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				//AddSystemMessageString("Damage removed from Onslaught");
			}
			if (CastedPoison)
			{
				CastedPoison = false;
				DebuffName = "";
				DmgTo = DmgTo - PoisonDmg;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
				PoisonDmg = 0;
				return;
			}
			if (debuffcheck == "Icy Air")
			{
				DmgTo = DmgTo - 2250;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				return;
			}
			if (debuffcheck == "Poison")
			{
				DmgTo = DmgTo - 2000;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
				return;
			}
		}
		return;
	}
	
	if (msg_idx == 1495) 
	{
        ParseInt(param,"Param1", Seconds);
		if (Seconds == 10)
			RequestTargetUser(GlobalTargetID);
        return;
    }
	
	if (msg_idx == 1499) 
	{
        ParseInt(param,"Param1", Seconds);
		if (Seconds == 5)
		{
			Me.KillTimer(8843);
			RequestClanChangeNickName( name, nickname );
		}
        return;
    }
	
	if (msg_idx == 1653) //Stop Rec.
	{
		ParseString(param,"Param1", ReplayName);
	}
	
	if (msg_idx == 1657) //Won on oly
	{
		isWin = true;
		if (RecStart)
			Me.SetTimer(1487, 500);

		if (DmgTo != 0 && isFunNick && gPTS >= 40)
		{
			//FlameFoe( Rand(4) );
			//Me.SetTimer(8843, 150);//for title
		}	
		
		SetINIInt("Stats", "Wins", ++statWin, "MySets");
		statWR = int( float(statWin)/float(statWin + statLose) * 100 );
		SetINIInt("Stats", "WinRate", statWR, "MySets");
		SetINIInt("Stats", "WinStreak", ++statWinS, "MySets");
		if (statWinS > statMaxS)
			SetINIInt("Stats", "MaxStreak", statWinS, "MySets");
		SetINIInt( GName, "Win", ++eWin, "MySets" );
	}
	
	if (msg_idx == 1658) //Lost on oly
	{
		isWin = false;
		if (RecStart)
			Me.SetTimer(1487, 500);

		SetINIInt("Stats", "Loses", ++statLose, "MySets");
		statWR = int( float(statWin)/float(statWin + statLose) * 100 );
		SetINIInt("Stats", "WinRate", statWR, "MySets");
		SetINIInt("Stats", "WinStreak", 0, "MySets");
		SetINIInt( GName, "Lose", ++eLose, "MySets" );
	}
    // 2261    1   a,$c1 has done $s3 points of damage to $c2. 
    // 2262    1   a,$c1 has received $s3 damage from $c2. 
    // 2281    1   a,$c1 hit you for $s3 damage and hit your servitor for $s4. 
    //1130  	You have dealt $s1 damage to your target and $s2 damage to the servitor.
	//2336 - Half-Kill!
	//2337 - Your CP was drained because you were hit with a Half-Kill skill.
	//139 - $c1 has resisted your $s2.
	//46 - You use $s1.
	//110 - $s1’s effect can be felt.
	
	if (script_s.m_NavitEffectEffectSec == 12)
	{
		script_ecast.bFlag = true;
	}	
	
	if (msg_idx != 2261 && msg_idx != 2262 && msg_idx != 2281 && msg_idx != 1130 && msg_idx != 3255 && msg_idx != 2336 && msg_idx != 2337)
        return;
		
    ParseString(param,"Param2", to);
    ParseInt(param,"Param3", howmuch);
	ParseString(param,"Param1", who);
	
	summname = class'UIDATA_PET'.static.GetPetName();
	
	if (msg_idx == 2336) //Lethal to enemy CP
	{
		isLethApplied = true;
		
		enemyCP.GetValue(MaxCP, EnemyCP_before_lethal);
		
		Me.KillTimer(1331);
		Me.SetTimer(1331, 1000);
		
		return;
	}
	
	if (msg_idx == 2337) //Lethal to my CP
	{
		
		GetPlayerInfo(myInfo);
		isEnemyLethApplied = true;
		
		MyCP_before_lethal = myInfo.nCurCP;
		
		Me.KillTimer(1332);
		Me.SetTimer(1332, 1000);
		
		return;
	}
	
	
	if (msg_idx == 3255) //DMG to my Arcane Shield
	{
		DmgFrom = DmgFrom - ManaShieldDMG;
		DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
		ManaShieldDMG = 0;
		return;
	}
	
	if (msg_idx == 2281 ) //Im summoner
	{
		ParseInt(param,"Param3", howmuch);
		DmgFrom += howmuch;
		DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
		return;
	}
	
		
	if (msg_idx == 1130 ) //Done to other summoner or while SoF on
	{
		if (MySoFCasted && meCharging)
		{
			ParseInt(param,"Param2", howmuch);
			DmgFrom += howmuch;
			DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
			meCharging = false;
			return;
		}
		if (SoFCasted)
		{
			if (Charging)
				return;
			ParseInt(param,"Param2", howmuch);
			DmgTo += howmuch;
			DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
			return;
		}
		
			ParseInt(param,"Param1", howmuch);
			DmgTo += howmuch;
			DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");	
			return;
		
	}
	
	if (msg_idx == 2262 && (to == OwnName.GetName() || to == summname) ) // If dmg is reflected, check if's done to the enemy 
    {		
			for (i = 0; i < summnames.Length; i++)
			{
				if ( InStr( who, summnames[i] ) > -1 )
					return;
			}
			
			if (who == EnemyName)
			{
				DmgTo += howmuch;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				return;
			}
			//return;
	}
	
	if ( msg_idx == 2262 && to != OwnName.GetName() && who == OwnName.GetName() ) // 2262 used both for incoming and reflect
	{	
		ManaShieldDMG = howmuch;
        DmgFrom += howmuch;
        DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
		if (isEnemyLethApplied)
		{
			DmgFrom += MyCP_before_lethal;
			DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
			isEnemyLethApplied = false;
		}
		return;
    } 
	
	
		
	
	
	if (msg_idx == 2261 ) //Regular damage to enemy
	{
		ParseString(param,"Param1", from);
		CurCP2 = 2;
		CurHP2 = 2;
		enemyCP.GetValue(MaxCP, CurCP2);
		enemyHP.GetValue(MaxHP, CurHP2);
		
		for (i = 0; i < summnames.Length; i++)
		{
			if ( InStr( to, summnames[i] ) > -1 )
				return;
		}
		
		if (Charging)
			return;
		
		if (from == summname && to == OwnName.GetName())//if you hit pet with same name as yours and got reflect, doesnt count
			return;
		
		if (from == eSumm.Name && to == OwnName.GetName() && eSumm.Name != summname)
		{
			if (isCelOn)
				return;
			
			ParseInt(param,"Param3", howmuch);
			DmgFrom += howmuch;
			DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
			return;
		}
		
		if (from == EnemyName && to == OwnName.GetName())
		{
			if (isCelOn)
				return;
			
			ParseInt(param,"Param3", howmuch);
			DmgFrom += howmuch;
			DmgFromBox.SetText("[ " $ string(DmgFrom) $ " ]");
			return;
		}
		
		if ( (from == OwnName.GetName()) || ( (from == summname) && (to != OwnName.GetName()) ) ) 
		{
			
			ParseInt(param,"Param3", howmuch);
			
			if ( (CurCP2 >= CurCP1) || (CurHP2 >= CurHP1) )
			{
				return;
			}
			
			DmgTo += howmuch;
			DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");

			if (isLethApplied)
			{
				DmgTo += EnemyCP_before_lethal;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				isLethApplied = false;
			}
			
			if (isBurning)
			{			
				DmgTo += 495;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				isBurning = false;
				gotDMG1 = true;
				//AddSystemMessageString("Damage added from Burning");
			}
		
			if (isOnsl)
			{
				DmgTo += 1035;
				DmgToBox.SetText("[ " $ string(DmgTo) $ " ]");
				isOnsl = false;
				gotDMG2 = true;
				//AddSystemMessageString("Damage added from Onslaught");
			}
				
			if ( isShieldCasted )
			{
				enemyCP.GetValue(MaxCP, CurCP1);
				enemyHP.GetValue(MaxHP, CurHP1);
				isShieldCasted = false;
			}
			return;
			
		}
	}
		
}

function HandleReceiveMagicSkillUse (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int SkillID;
  local int SkillLevel;
  local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;
  local int i;
  local array<string> summnames;
  
	summnames[0] = "Mew the Cat";
	summnames[1] = "Magnus the Unicorn";
	summnames[2] = "Nightshade";
	summnames[3] = "Kai the Cat";
	summnames[4] = "Kat the Cat";
	summnames[5] = "Boxer the Unicorn";
	summnames[6] = "Imperial Phoenix";
	summnames[7] = "Dark Panther";
	summnames[8] = "Mechanic Golem";
	summnames[9] = "Divine Beast";
	summnames[10] = "Mirage the Unicorn";
	summnames[11] = "Reanimated Man";
	summnames[12] = "Feline King";
	summnames[13] = "Unicorn Seraphim";


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
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
  
  if ( ((SkillID == 1556) && (PlayerInfo.nID != AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
		enemyCP.GetValue(MaxCP, CurCP1);
		enemyHP.GetValue(MaxHP, CurHP1);
		isShieldCasted = true;
		Me.SetTimer(16000, 10000);
  }
  
  if ( ((SkillID == 927) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
		isBurning = true;
		Me.KillTimer(1334);
		Me.SetTimer(1334, SkillHitTime_ms + 300);
  }
  
  if ( ((SkillID == 949) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
		isOnsl = true;
		Me.KillTimer(1335);
		Me.SetTimer(1335, SkillHitTime_ms + 300);
  }
  
  if ( ((SkillID == 656) && (PlayerInfo.nID != AttackerID)) &&  !IsNotDisplaySkill(SkillID) ) //DWarrior
  {
		AddChatInfo( "#####: " $ AttackerInfo.Name $ " used " $ UsedSkillInfo.SkillName $ "Lv. " $ string(SkillLevel));
  }
  
  if ( ((SkillID == 660) && (PlayerInfo.nID != AttackerID)) &&  !IsNotDisplaySkill(SkillID) ) //DSummoner
  {
		AddChatInfo( "#####: " $ AttackerInfo.Name $ " used " $ UsedSkillInfo.SkillName $ "Lv. " $ string(SkillLevel));
  }
  
  if ( ((SkillID == 662) && (PlayerInfo.nID != AttackerID)) &&  !IsNotDisplaySkill(SkillID) ) //DEnchanter
  {
		AddChatInfo( "#####: " $ AttackerInfo.Name $ " used " $ UsedSkillInfo.SkillName $ "Lv. " $ string(SkillLevel));
  }
  
	if (PlayerInfo.nID != AttackerInfo.nID && AttackerInfo.nID != GlobalTargetID && AttackerInfo.nID != mypet_ID && AttackerInfo.Name != "Olympiad Host")
	{
		for (i = 0; i < summnames.Length; i++)
			if ( InStr( AttackerInfo.Name, summnames[i] ) > -1 )
			{
				m_PetID = AttackerInfo.nID;
				//AddSystemMessageString("Foe pet attacker: "$AttackerInfo.Name);
				//AddSystemMessageString("Foe pet ID: " $ m_PetID);
			}
	}
	
	if (DefenderInfo.nID != PlayerInfo.nID && DefenderInfo.nID != mypet_ID && DefenderInfo.nID != GlobalTargetID && DefenderInfo.Name != "Olympiad Host")
	{
		for (i = 0; i < summnames.Length; i++)
			if ( InStr( DefenderInfo.Name, summnames[i] ) > -1 )
			{
				m_PetID = DefenderInfo.nID;
				//AddSystemMessageString("Foe pet defender: "$DefenderInfo.Name);		
				//AddSystemMessageString("Foe pet ID: " $ m_PetID);				
			}
	}
  
}

function HandleReceiveLethalSkillUse (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int SkillID;
  local int SkillLevel;
  local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;

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
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
  if ( ( ((SkillID == 344) || (SkillID == 30) || (SkillID == 928) || (SkillID == 263)) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    CastedLeth = true;
	//AddSystemMessageString("Lethal - casted");
  }
  if ( ( ((SkillID == 344) || (SkillID == 30) || (SkillID == 928) || (SkillID == 263)) && (PlayerInfo.nID == DefenderID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    CastedEnemyLeth = true;
	//AddSystemMessageString("LethalEnemy - casted");
  }
}

function HandleReceiveCubicSkillUse (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int SkillID;
  local int SkillLevel;
  local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;

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
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
  if ( ( ((SkillID == 4165) || (SkillID == 4052) ) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    CastedCubicPoison = true;
  }
  if ( ( ((SkillID == 4165) || (SkillID == 4052) ) && (PlayerInfo.nID == DefenderID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    EnemyCastedCubicPoison = true;
  }
}

function HandleReceiveSoFSkillUse (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int SkillID;
  local int SkillLevel;
  local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;

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
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
  if ( ( ((SkillID == 528) ) && (PlayerInfo.nID != AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    SoFCasted = true;
	Me.KillTimer(15520);
	Me.SetTimer(15520, 30000);
  }
  
  if ( ( ((SkillID == 528) ) && (PlayerInfo.nID == AttackerID)) &&  !IsNotDisplaySkill(SkillID) )
  {
    MySoFCasted = true;
	Me.KillTimer(15530);
	Me.SetTimer(15530, 30000);
	//AddSystemMessageString("Timer set");
  }
  
}

function HandleReceiveAttack (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int maxHP,maxCP,curCP,curHP;

  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local UserInfo PlayerInfo;


  ParseInt(a_Param,"AttackerID",AttackerID);
  ParseInt(a_Param,"DefenderID",DefenderID);

 
  GetUserInfo(AttackerID,AttackerInfo);
  GetUserInfo(DefenderID,DefenderInfo);
  GetPlayerInfo(PlayerInfo);

  if ( PlayerInfo.nID != AttackerID && DefenderInfo.nID != mypet_ID && ( InStr( DefenderInfo.Name, "Dark Panther" ) > -1 || InStr( DefenderInfo.Name, "Imperial Phoenix" ) > -1 || InStr( DefenderInfo.Name, "Divine Beast" ) > -1 ) )
  {
    Charging = true;
	enemyCP.GetValue(maxCP, curCP);
	enemyHP.GetValue(maxHP, curHP);
	EnemyCP_before_reflect = curCP;
	EnemyHP_before_reflect = curHP;
	//AddSystemMessageString("CPbefore"$string(EnemyCP_before_reflect));
	//AddSystemMessageString("HPbefore"$string(EnemyHP_before_reflect));
  }
  
}

function HandleReceiveMyAttack (string a_Param)
{
  local int AttackerID;
  local int DefenderID;

  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local UserInfo PlayerInfo;


  ParseInt(a_Param,"AttackerID",AttackerID);
  ParseInt(a_Param,"DefenderID",DefenderID);

 
  GetUserInfo(AttackerID,AttackerInfo);
  GetUserInfo(DefenderID,DefenderInfo);
  GetPlayerInfo(PlayerInfo);
  

  if ( PlayerInfo.nID == AttackerID && DefenderInfo.nID == mypet_ID )
  {
    meCharging = true;
  }
  
  if (m_PetID != -1337)
  {
	if ( PlayerInfo.nID == AttackerID && DefenderInfo.nID == m_PetID )
		hitEpet = true;
  }
  
}

function HandleBuffInfo(string param)
{
	local int i, j;
	local int RowCount, ColCount;
	local StatusIconInfo info;
	local int msg_idx;

	ParseInt(param, "Index", msg_idx);
		
	if (msg_idx == 110)
	{
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
				else
				{
					isCelOn = false;
				}
			}
		}
	}
}

function BuffMe()
{
	local ItemID BtS, BtB, H, PAtk;
	
		//Blessing of Queen: ClassID - 1007
		//Gift of Queen: ClassID - 1008
		//BtS: ClassID - 1052
		//BtB: ClassID - 1051
		//Haste: ClassID - 1053
	
	BtS.ClassID = 1052;
	BtB.ClassID = 1051;
	H.ClassID = 1053;
	PAtk.ClassID = 1008;
	
	if (buffCount <= 3)
	{
		RequestSelfTarget();
		switch (buffCount)
		{
			case 0:
				DoAction( BtB );
				buffCount++;
			break;
			case 1:
				DoAction( BtS );
				buffCount++;
			break;
			case 2:
				DoAction( H );
				buffCount++;
			break;
			case 3:
				DoAction( PAtk );
				buffCount++;
			break;
		}
	}
}

function SetDelay(string param)
{
	local int AttackerID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local int SkillHitTime_ms;

	ParseInt(param,"AttackerID",AttackerID);
	ParseInt(param,"SkillID",SkillID);
	ParseInt(param,"SkillLevel",SkillLevel);
	ParseFloat(param,"SkillHitTime",SkillHitTime);
	
	if ( SkillHitTime > 0 )
	{
	  SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	} 
	else
	{
	  SkillHitTime_ms = 100;
	}
	  
	if ( AttackerID == pussy_MyPet.nID && !IsNotDisplaySkill(SkillID) )
	{
		
		switch (SkillID)
		{
			//Bless the Soul
			case 5639:
				class'UIAPI_WINDOW'.static.SetUITimer("OlympiadDmgWnd", 10, SkillHitTime_ms + 200);
			break;
			//Bless the Body
			case 5638:
				class'UIAPI_WINDOW'.static.SetUITimer("OlympiadDmgWnd", 10, SkillHitTime_ms + 200);
			break;
			//Haste
			case 5640:
				class'UIAPI_WINDOW'.static.SetUITimer("OlympiadDmgWnd", 10, SkillHitTime_ms + 200);
			break;
			//Gift of Queen
			case 4700:
				class'UIAPI_WINDOW'.static.SetUITimer("OlympiadDmgWnd", 10, SkillHitTime_ms + 200);
			break;
		}
	}
}

defaultproperties
{
}

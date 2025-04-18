class EnemyCastInfoWnd extends UICommonAPI;

const MAX_WINDOWCOUNT = 11;
const TIMERID_DEBUFF1 = 2281337;
const TIMERID_DEBUFF11 = 22813371;
const TIMERID_DEBUFF2 = 2281338;
const TIMERID_DEBUFF3 = 2281339;
const TIMERID_DEBUFF4 = 2281330;

const SUDDEN_TIMER1 = 20000;
const SUDDEN_TIMER2 = 20001;
const SUDDEN_TIMER3 = 20002;
const SUDDEN_TIMER4 = 20003;
const SUDDEN_TIMER5 = 20004;
const SUDDEN_TIMER6 = 20005;
const SUDDEN_TIMER7 = 20006;
const SUDDEN_TIMER8 = 20007;
const SUDDEN_TIMER9 = 20008;
const SUDDEN_TIMER10 = 20010;
const SUDDEN_TIMER11 = 20011;
const SUDDEN_TIMER12 = 20012;
const SUDDEN_TIMER13 = 20013;
const SUDDEN_TIMER14 = 20014;
const SUDDEN_TIMER15 = 20015;
const SUDDEN_TIMER16 = 20016;
const SUDDEN_TIMER17 = 20017;
const SUDDEN_TIMER18 = 20018;
const SUDDEN_TIMER19 = 20019;
const SUDDEN_TIMER20 = 20020;
const SUDDEN_TIMER21 = 20021;
const SUDDEN_TIMER22 = 20022;
const SUDDEN_TIMER23 = 20023;
const SUDDEN_TIMER24 = 20024;
const SUDDEN_TIMER25 = 20025;
const SUDDEN_TIMER26 = 20026;
const SUDDEN_TIMER27 = 20027;

var WindowHandle m_wndTop;
var WindowHandle ed_CastInfoWnd[MAX_WINDOWCOUNT];
var ProgressCtrlHandle ed_progressCast0[MAX_WINDOWCOUNT],ed_progressCast1[MAX_WINDOWCOUNT], ed_progressCast2[MAX_WINDOWCOUNT], ed_progressCast3[MAX_WINDOWCOUNT], ed_progressCast4[MAX_WINDOWCOUNT], ed_progressCast5[MAX_WINDOWCOUNT], ed_progressCast6[MAX_WINDOWCOUNT], ed_progressCast7[MAX_WINDOWCOUNT], ed_progressCast8[MAX_WINDOWCOUNT], ed_progressCast9[MAX_WINDOWCOUNT], ed_progressCast10[MAX_WINDOWCOUNT];
var TextBoxHandle ed_txtCastSkillName[MAX_WINDOWCOUNT];
var TextBoxHandle ed_txtCastTargetName[MAX_WINDOWCOUNT];
var TextureHandle ed_texCastIcon[MAX_WINDOWCOUNT];
var TextBoxHandle ed_timer[MAX_WINDOWCOUNT];
var UserInfo u;
var SkillInfo s;
var bool AtOly;
var int Position[MAX_WINDOWCOUNT];
var bool Window0, chargeLvl3, usedHide, bFlag;
var OlyDmgOptionWnd script;
var AbnormalStatusWnd script_abnormal;
var OverlayWnd script_overlay;
var OlympiadDmgWnd script_olydmgwnd;

var bool t1,t2;

var UserInfo MyInfo;
var SkillInfo MySkillInfo1, MySkillInfo2, MySkillInfo3, MySkillInfo4, MySkillInfo5;
var string texIcon1, texIcon2, texIcon3, texIcon4, texIcon5, texIcon6;
var int TimeLeft[MAX_WINDOWCOUNT];
var Color White;

function OnRegisterEvent ()
{
  RegisterEvent(EV_ReceiveMagicSkillUse);
  RegisterEvent(EV_OlympiadTargetShow);
  RegisterEvent(EV_OlympiadMatchEnd);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
		

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	
	Reset();
	script = OlyDmgOptionWnd( GetScript( "OlyDmgOptionWnd" ) );
	script_abnormal = AbnormalStatusWnd( GetScript( "AbnormalStatusWnd" ) );
	script_overlay = OverlayWnd( GetScript( "OverlayWnd" ) );
	script_olydmgwnd = OlympiadDmgWnd (GetScript("OlympiadDmgWnd"));
	
	White.R = 205; White.G = 205; White.B = 205;
}

function InitHandle()
{
	local int idx;	

	//Init Handle
	m_wndTop = GetHandle( "EnemyCastInfoWnd" );

	for (idx=0; idx<MAX_WINDOWCOUNT; idx++)	
	{
		ed_CastInfoWnd[idx] = GetHandle( "EnemyCastInfoWnd.window" $ idx );
		ed_progressCast0[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast0" ) );
		ed_progressCast1[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast1" ) );
		ed_progressCast2[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast2" ) );
		ed_progressCast3[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast3" ) );
		ed_progressCast4[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast4" ) );
		ed_progressCast5[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast5" ) );
		ed_progressCast6[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast6" ) );
		ed_progressCast7[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast7" ) );
		ed_progressCast8[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast8" ) );
		ed_progressCast9[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast9" ) );
		ed_progressCast10[idx] = ProgressCtrlHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressCast10" ) );
		ed_txtCastSkillName[idx] = TextBoxHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".txtCastSkillName" ) );
		ed_txtCastTargetName[idx] = TextBoxHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".txtCastTargetName" ) );
		ed_timer[idx] = TextBoxHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressTR" ) );
		ed_texCastIcon[idx] = TextureHandle( GetHandle( "EnemyCastInfoWnd.window" $ idx $ ".texCastIcon" ) );
	}
	
}

function InitHandleCOD()
{
	local int idx;	

	//Init Handle
	m_wndTop = GetWindowHandle( "EnemyCastInfoWnd" );

	for (idx=0; idx<MAX_WINDOWCOUNT; idx++)	
	{
		ed_CastInfoWnd[idx] = GetWindowHandle( "EnemyCastInfoWnd.window" $ idx );
		ed_progressCast0[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast0"  );
		ed_progressCast1[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast1"  );	
		ed_progressCast2[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast2"  );
		ed_progressCast3[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast3"  );
		ed_progressCast4[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast4"  );
		ed_progressCast5[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast5"  );
		ed_progressCast6[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast6"  );
		ed_progressCast7[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast7"  );
		ed_progressCast8[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast8"  );
		ed_progressCast9[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast9"  );
		ed_progressCast10[idx] = GetProgressCtrlHandle(  "EnemyCastInfoWnd.window" $ idx $ ".progressCast10"  );
		ed_txtCastSkillName[idx] = GetTextBoxHandle(  "EnemyCastInfoWnd.window" $ idx $ ".txtCastSkillName" );
		ed_txtCastTargetName[idx] = GetTextBoxHandle( "EnemyCastInfoWnd.window" $ idx $ ".txtCastTargetName" );
		ed_timer[idx] = GetTextBoxHandle( "EnemyCastInfoWnd.window" $ idx $ ".progressTR" );
		ed_texCastIcon[idx] = GetTextureHandle( "EnemyCastInfoWnd.window" $ idx $ ".texCastIcon" );
	}
	
}

function Reset()
{
	
	local int h;
	
	AtOly = false;
	Window0 = false;
	chargeLvl3 = false;
	usedHide = false;
	SetDefaultWindowAnchor();
	KillAllCastWindow();
	t1 = false;
	t2 = false;
	bFlag = false;
	
	for (h = 0; h < MAX_WINDOWCOUNT; h++)
	{
		Position[h] = 0;
		ed_timer[h].SetText("");
		TimeLeft[h] = 0;
	}
	
	m_wndTop.KillTimer(SUDDEN_TIMER1);
	m_wndTop.KillTimer(SUDDEN_TIMER2);
	m_wndTop.KillTimer(SUDDEN_TIMER3);
	m_wndTop.KillTimer(SUDDEN_TIMER4);
	m_wndTop.KillTimer(SUDDEN_TIMER5);
	m_wndTop.KillTimer(SUDDEN_TIMER6);
	m_wndTop.KillTimer(SUDDEN_TIMER7);
	m_wndTop.KillTimer(SUDDEN_TIMER8);
	m_wndTop.KillTimer(SUDDEN_TIMER9);
	m_wndTop.KillTimer(SUDDEN_TIMER11);
	m_wndTop.KillTimer(SUDDEN_TIMER12);
	m_wndTop.KillTimer(SUDDEN_TIMER13);
	m_wndTop.KillTimer(SUDDEN_TIMER14);
	m_wndTop.KillTimer(SUDDEN_TIMER15);
	m_wndTop.KillTimer(SUDDEN_TIMER16);
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case EV_ReceiveMagicSkillUse:
		if (AtOly && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableOlySkillTimer"))
			HandleReceiveMagicSkillUse(a_Param);
		else if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableFSkillTimer"))
			FieldVariant(a_Param);
		break;
	case EV_OlympiadTargetShow:
		Reset();
		AtOly = true;
		break;
	case EV_OlympiadMatchEnd:
		Reset();
		break;
    default:
    break;
  }
}

function KillCastWindow (int i)
{
	ed_CastInfoWnd[i].HideWindow();	
}

function KillAllCastWindow ()
{
	local int g;
	
	for (g = 0; g < MAX_WINDOWCOUNT; g++)
	{
		if (ed_CastInfoWnd[g].IsShowWindow() )
			ed_CastInfoWnd[g].HideWindow();
	}
}

function HideUseless ()
{
	ed_progressCast0[1].HideWindow();
	ed_progressCast0[2].HideWindow();
	ed_progressCast0[3].HideWindow();
	ed_progressCast0[4].HideWindow();
	ed_progressCast0[5].HideWindow();
	ed_progressCast0[6].HideWindow();
	ed_progressCast0[7].HideWindow();
	ed_progressCast0[8].HideWindow();
	ed_progressCast0[9].HideWindow();
	ed_progressCast0[10].HideWindow();
	
	ed_progressCast1[0].HideWindow();
	ed_progressCast1[2].HideWindow();
	ed_progressCast1[3].HideWindow();
	ed_progressCast1[4].HideWindow();
	ed_progressCast1[5].HideWindow();
	ed_progressCast1[6].HideWindow();
	ed_progressCast1[7].HideWindow();
	ed_progressCast1[8].HideWindow();
	ed_progressCast1[9].HideWindow();
	ed_progressCast1[10].HideWindow();
	
	ed_progressCast2[0].HideWindow();
	ed_progressCast2[1].HideWindow();
	ed_progressCast2[3].HideWindow();
	ed_progressCast2[4].HideWindow();
	ed_progressCast2[5].HideWindow();
	ed_progressCast2[6].HideWindow();
	ed_progressCast2[7].HideWindow();
	ed_progressCast2[8].HideWindow();
	ed_progressCast2[9].HideWindow();
	ed_progressCast2[10].HideWindow();
	
	ed_progressCast3[0].HideWindow();
	ed_progressCast3[1].HideWindow();
	ed_progressCast3[2].HideWindow();
	ed_progressCast3[4].HideWindow();
	ed_progressCast3[5].HideWindow();
	ed_progressCast3[6].HideWindow();
	ed_progressCast3[7].HideWindow();
	ed_progressCast3[8].HideWindow();
	ed_progressCast3[9].HideWindow();
	ed_progressCast3[10].HideWindow();
	
	ed_progressCast4[0].HideWindow();
	ed_progressCast4[1].HideWindow();
	ed_progressCast4[2].HideWindow();
	ed_progressCast4[3].HideWindow();
	ed_progressCast4[5].HideWindow();
	ed_progressCast4[6].HideWindow();
	ed_progressCast4[7].HideWindow();
	ed_progressCast4[8].HideWindow();
	ed_progressCast4[9].HideWindow();
	ed_progressCast4[10].HideWindow();
	
	ed_progressCast5[0].HideWindow();
	ed_progressCast5[1].HideWindow();
	ed_progressCast5[2].HideWindow();
	ed_progressCast5[3].HideWindow();
	ed_progressCast5[4].HideWindow();
	ed_progressCast5[6].HideWindow();
	ed_progressCast5[7].HideWindow();
	ed_progressCast5[8].HideWindow();
	ed_progressCast5[9].HideWindow();
	ed_progressCast5[10].HideWindow();
	
	ed_progressCast6[0].HideWindow();
	ed_progressCast6[1].HideWindow();
	ed_progressCast6[2].HideWindow();
	ed_progressCast6[3].HideWindow();
	ed_progressCast6[4].HideWindow();
	ed_progressCast6[5].HideWindow();
	ed_progressCast6[7].HideWindow();
	ed_progressCast6[8].HideWindow();
	ed_progressCast6[9].HideWindow();
	ed_progressCast6[10].HideWindow();
	
	ed_progressCast7[0].HideWindow();
	ed_progressCast7[1].HideWindow();
	ed_progressCast7[2].HideWindow();
	ed_progressCast7[3].HideWindow();
	ed_progressCast7[4].HideWindow();
	ed_progressCast7[5].HideWindow();
	ed_progressCast7[6].HideWindow();
	ed_progressCast7[8].HideWindow();
	ed_progressCast7[9].HideWindow();
	ed_progressCast7[10].HideWindow();
	
	ed_progressCast8[0].HideWindow();
	ed_progressCast8[1].HideWindow();
	ed_progressCast8[2].HideWindow();
	ed_progressCast8[3].HideWindow();
	ed_progressCast8[4].HideWindow();
	ed_progressCast8[5].HideWindow();
	ed_progressCast8[6].HideWindow();
	ed_progressCast8[7].HideWindow();
	ed_progressCast8[9].HideWindow();
	ed_progressCast8[10].HideWindow();
	
	ed_progressCast9[0].HideWindow();
	ed_progressCast9[1].HideWindow();
	ed_progressCast9[2].HideWindow();
	ed_progressCast9[3].HideWindow();
	ed_progressCast9[4].HideWindow();
	ed_progressCast9[5].HideWindow();
	ed_progressCast9[6].HideWindow();
	ed_progressCast9[7].HideWindow();
	ed_progressCast9[8].HideWindow();
	ed_progressCast9[10].HideWindow();
	
	ed_progressCast10[0].HideWindow();
	ed_progressCast10[1].HideWindow();
	ed_progressCast10[2].HideWindow();
	ed_progressCast10[3].HideWindow();
	ed_progressCast10[4].HideWindow();
	ed_progressCast10[5].HideWindow();
	ed_progressCast10[6].HideWindow();
	ed_progressCast10[7].HideWindow();
	ed_progressCast10[8].HideWindow();
	ed_progressCast10[9].HideWindow();
}

function bool SkillListForField(int m_skillID, string EnchName, out int sTime)
{
	local bool	bIsNotDisplaySkill;
	bIsNotDisplaySkill = false;
	switch( m_skillID )
	{
		case 368: //Vengeance
			sTime = 29000;
			bIsNotDisplaySkill = true;
			 break;
		case 760: //Anti-Magic Armor
			sTime = 29000;
			bIsNotDisplaySkill = true;
			 break;
		case 420://Zealot
			sTime = CalculateForTimeEnchanted(EnchName, 57500, 2);
			bIsNotDisplaySkill = true;
			 break;
		case 1411: //Mystic Immunity
			sTime = 30000;
			bIsNotDisplaySkill = true;
			 break;
		case 483: //Sword Shield
			sTime = 29500;
			bIsNotDisplaySkill = true;
			 break;
		case 1556: //Arcane Shield
			sTime = 9800;
			bIsNotDisplaySkill = true;
			 break;
		case 922: //Hide
			sTime = 29500;
			bIsNotDisplaySkill = true;
			 break;
		case 1470: //Prahnah
			sTime = CalculateForTimeEnchanted(EnchName, 30000, 2);
			bIsNotDisplaySkill = true;
			 break;
		case 528: //Party UD
			sTime = CalculateForTimeEnchanted(EnchName, 14000, 1);//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 176: //Frenzy
			sTime = 88500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 139: //Guts
			sTime = 88500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 768: //Exciting Adventure
			sTime = 29500;//
			bIsNotDisplaySkill = true;
			 break;
		case 769: //Wind Riding
			sTime = 29500;//
			bIsNotDisplaySkill = true;
			 break;
		case 770: //Ghost Walking
			sTime = 29500;//
			bIsNotDisplaySkill = true;
			 break;
		case 111: //Ultimate Evasion
			sTime = CalculateForTimeEnchanted(EnchName, 29300, 1);//
			bIsNotDisplaySkill = true;
			 break;
		case 1532: //Enli1
			sTime = 19500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 1533: //Enli2
			sTime = 19500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 917: //Final Secret
			sTime = 29500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 446: //Dodge
			sTime = 9800;//
			bIsNotDisplaySkill = true;
			 break;
		case 447: //Counterattack
			sTime = 9800;//
			bIsNotDisplaySkill = true;
			 break;
		case 916: //Shield Deflect Magic
			sTime = 8000;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 948: //Eye for Eye
			sTime = 9800;//
			bIsNotDisplaySkill = true;
			 break;
		case 406: //AI
			sTime = CalculateForTimeEnchanted(EnchName, 58000, 2);//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 956: //Boost Morale
			sTime = 118000;//
			bIsNotDisplaySkill = true;
			 break;
		case 785: //FI
			sTime = 57500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 789: //Shilka
			sTime = 57500;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 3284:   //DP
			sTime = 9400+1200;//fixed
			bIsNotDisplaySkill = true;
			 break;
		case 3282: //MC
			sTime = 89800;//fixed
		bIsNotDisplaySkill = true;
			 break;
	}	
	return bIsNotDisplaySkill;
}

function FieldVariant (string a_Param)
{
  local int AttackerID;
  local int DefenderID;
  local int SkillID;
  local int SkillLevel;
  local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local UserInfo DefenderInfo;
  local UserInfo TargetInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;
  local int UD_30, UD_60;
  local int SkillEndTime;

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
  
  UD_30 = 30000;
  UD_60 = 59500;
  
  
  GetUserInfo(AttackerID,AttackerInfo);
  GetUserInfo(DefenderID,DefenderInfo);
  GetPlayerInfo(PlayerInfo);
  GetTargetInfo(TargetInfo);
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
	
  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID)  )
  {
	//if (bFlag)
	//{
		//SetProgressColor0(AttackerInfo,UsedSkillInfo);
	//}	
	if ((AttackerInfo.Name == "Imperial Phoenix") || (AttackerInfo.Name == "Dark Panther") || (AttackerInfo.Name == "Divine Beast"))
	{
		//AddSystemMessageString("SUMMON!!1");
		return;
	}
	
	//if (!script.buff.IsChecked())
		//return;
		
	//Block1
	
	if (!ed_CastInfoWnd[0].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[1].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo1(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo1(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo1(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[2].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo2(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo2(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo2(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[3].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo3(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo3(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo3(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[4].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo4(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo4(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo4(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[5].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo5(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo5(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo5(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	else if (!ed_CastInfoWnd[6].IsShowWindow())
	{
		if (SkillID == 110) //UD
		{
			if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
				SetCastInfo6(AttackerInfo,UsedSkillInfo,29000);//fixed
			if (UsedSkillInfo.EnchantName == "+30 Time")
				SetCastInfo6(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
			return;
		}	
		if (SkillListForField(SkillID, UsedSkillInfo.EnchantName, SkillEndTime))
		{
			SetCastInfo6(AttackerInfo,UsedSkillInfo,SkillEndTime);
		}
	}
	
  }
  
}

function int CalculateForTimeEnchanted(string EnchName, int BaseTime, int SecMultiplier)
{
	local int EnchTime;

	if (InStr(EnchName, "Time") > -1)
	{
		if (Len(EnchName) == 7)
			EnchTime = int(Mid(EnchName, 1, 1));
		else
			EnchTime = int(Mid(EnchName, 1, 2));

		EnchTime = SecMultiplier * EnchTime * 1000 + BaseTime;

		return EnchTime;
	}
	else
	{
		return BaseTime;
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
  local UserInfo TargetInfo;
  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;
  local int UD_30, UD_60;
  //local ItemInfo skill;
  local UserInfo masterInfo;

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
  
  UD_30 = 30000;
  UD_60 = 59500;
  
  
  GetUserInfo(AttackerID,AttackerInfo);
  GetUserInfo(DefenderID,DefenderInfo);
  GetPlayerInfo(PlayerInfo);
  GetTargetInfo(TargetInfo);
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
  GetUserInfo(script_olydmgwnd.GlobalTargetID, masterInfo);
  
	
  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID)  )
  {
	//if (bFlag)
		//SetProgressColor0(AttackerInfo,UsedSkillInfo);
	if ((AttackerInfo.Name == "Imperial Phoenix") || (AttackerInfo.Name == "Dark Panther") || (AttackerInfo.Name == "Divine Beast"))
	{
		//AddSystemMessageString("SUMMON!!1");
		return;
	}
	
	if (usedHide)
	{
		KillCastWindow(0);
		MoveWindowsUp(0);
		Window0 = false;
		
		usedHide = false;
	}
	
	////////////TEXT OUTPUT ON SCREEN////////////
	if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableSkillUse"))
	{
		if (SkillID == 656)
		{
			script_overlay.infoText.SetText("Transform Divine Warrior");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER1, 3000);
		} else if (SkillID == 660)
		{
			script_overlay.infoText.SetText("Transform Divine Summoner");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER2, 3000);
		} else if (SkillID == 662)
		{
			script_overlay.infoText.SetText("Transform Divine Enchanter");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER3, 3000);
		} else if (SkillID == 3282)
		{
			script_overlay.infoText.SetText("Maximum Clarity");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER4, 3000);
		} else if (SkillID == 1476)
		{
			script_overlay.infoText.SetText("Appetite for Destruction");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER5, 3000);
		} else if (SkillID == 3285)
		{
			script_overlay.infoText.SetText("Berserk Talisman");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER6, 3000);
		} else if (SkillID == 917)
		{
			script_overlay.infoText.SetText("Final Secret");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER7, 3000);
		} else if (SkillID == 420)
		{
			script_overlay.infoText.SetText("Zealot");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER8, 3000);
		} else if (SkillID == 499 && SkillLevel == 3)
		{
			script_overlay.infoText.SetText("Courage");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER9, 3000);
		} else if (SkillID == 121)
		{
			script_overlay.infoText.SetText("Battle Roar");
			script_overlay.texInfo.SetTexture(UsedSkillInfo.TexName);
			script_overlay.infoText.SetFocus();
			script_overlay.texInfo.SetFocus();
			m_wndTop.SetTimer(SUDDEN_TIMER9, 3000);
		} 
		
		////////////////////////////////////////////
		//////SHOW SKILLS BEFORE TIME EXPIRED///////
		////////////////////////////////////////////
		if (SkillID == 684)
		{
			m_wndTop.SetTimer(SUDDEN_TIMER11, SkillHitTime_ms + 29000);
			texIcon1 = UsedSkillInfo.TexName;
		} else if ( (SkillID == 707) || (SkillID == 706) || (SkillID == 704) || (SkillID == 705) )
		{
			m_wndTop.SetTimer(SUDDEN_TIMER12, SkillHitTime_ms + 119000);
			texIcon2 = UsedSkillInfo.TexName;
		} else if (SkillID == 678)
		{
			m_wndTop.SetTimer(SUDDEN_TIMER13, SkillHitTime_ms + 59000);
			texIcon3 = UsedSkillInfo.TexName;
		} else if (SkillID == 406)
		{
			m_wndTop.SetTimer(SUDDEN_TIMER14, SkillHitTime_ms + 109000);
			texIcon4 = UsedSkillInfo.TexName;
		} else if (SkillID == 785)
		{
			m_wndTop.SetTimer(SUDDEN_TIMER15, SkillHitTime_ms + 48500);
			texIcon5 = UsedSkillInfo.TexName;
		} else if (SkillID == 420)
		{
			m_wndTop.SetTimer(SUDDEN_TIMER16, SkillHitTime_ms + 108500);
			texIcon6 = UsedSkillInfo.TexName;
		} 
		////////////////////////////////////////////
	}
	
		
	//Block1
	
	if (SkillID == 110) //UD
	{
		if (UsedSkillInfo.EnchantName == "+30 Decrease Penalty")
			SetCastInfo(AttackerInfo,UsedSkillInfo,29000);//fixed
		if (UsedSkillInfo.EnchantName == "+30 Time")
			SetCastInfo(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//fixed
	} else if (SkillID == 368) { //Vengeance
		SetCastInfo(AttackerInfo,UsedSkillInfo,29000);//fixed
	} else if (SkillID == 760) { //Anti-Magic Armor
		SetCastInfo(AttackerInfo,UsedSkillInfo,29000);//fixed
	} else if (SkillID == 420) { //Zealot
		SetCastInfo(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 57500, 2));//fixed
	} else if (SkillID == 1496) { //Servitor Barrier
		SetCastInfo(AttackerInfo,UsedSkillInfo,29500);//fixed
	} else if (SkillID == 1411) { //Mystic Immunity
		SetCastInfo(AttackerInfo,UsedSkillInfo,30000);//fixed
	} else if (SkillID == 483) { //Sword Shield
		SetCastInfo(AttackerInfo,UsedSkillInfo,29500);//fixed
	} else if (SkillID == 1556) { //Arcane Shield
		SetCastInfo(AttackerInfo,UsedSkillInfo,9800);//
	} else if (SkillID == 922) { //Hide
		SetCastInfo(AttackerInfo,UsedSkillInfo,29500);//
		usedHide = true;
	} else if (SkillID == 1470) { //Prahnah
		SetCastInfo(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 30000, 2));//
	}
	
	//Block2
	
	if (SkillID == 528) //Party UD
	{
		SetCastInfo1(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 14000, 1));//fixed
	} else if (SkillID == 176) { //Frenzy
		SetCastInfo1(AttackerInfo,UsedSkillInfo,88500);//fixed
	} else if (SkillID == 139) { //Guts
		SetCastInfo1(AttackerInfo,UsedSkillInfo,88500);//fixed
	} else if (SkillID == 1540) { //Turn to Stone
		SetCastInfo1(AttackerInfo,UsedSkillInfo,8500);//fixed
	} else if (SkillID == 1299) { //Servitor Emp
		SetCastInfo1(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 28800, 1));//fixed
	} else if (SkillID == 768) { //Exciting Adventure
		SetCastInfo1(AttackerInfo,UsedSkillInfo,29500);//
	} else if (SkillID == 769) { //Wind Riding
		SetCastInfo1(AttackerInfo,UsedSkillInfo,29500);//
	} else if (SkillID == 770) { //Ghost Walking
		SetCastInfo1(AttackerInfo,UsedSkillInfo,29500);//
	} else if (SkillID == 111) { //Ultimate Evasion
		SetCastInfo1(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 29300, 1));//
	} else if (SkillID == 1514) { //Soul Barrier
		SetCastInfo1(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 10000, 1));//
	} else if (SkillID == 837) { //Painkiller
		SetCastInfo1(AttackerInfo,UsedSkillInfo,8000);//
	} else if (SkillID == 298) { //Rabbit Totem
		SetCastInfo1(AttackerInfo,UsedSkillInfo,300000);//
	} else if (SkillID == 109) { //Ogre Totem
		SetCastInfo1(AttackerInfo,UsedSkillInfo,300000);//
	} else if (SkillID == 425) { //Hawk Totem
		SetCastInfo1(AttackerInfo,UsedSkillInfo,300000);//
	}
	
	//Block3
	
	if (SkillID == 1532) //Enli1
	{
		SetCastInfo2(AttackerInfo,UsedSkillInfo,19500);//fixed
	} else if (SkillID == 1533) { //Enli2
		SetCastInfo2(AttackerInfo,UsedSkillInfo,19500);//fixed
	} else if (SkillID == 917) { //Final Secret
		SetCastInfo2(AttackerInfo,UsedSkillInfo,29500);//fixed
	} else if ( SkillID == 5562 && chargeLvl3 == false ) { //Spirit Of Phoenix
		SetCastInfo2(AttackerInfo,UsedSkillInfo,20000);
		if (SkillLevel == 3)
			chargeLvl3 = true;
	} else if ( SkillID == 5561 && chargeLvl3 == false ) { //Seed of Revenge
		SetCastInfo2(AttackerInfo,UsedSkillInfo,20000);
		if ( SkillLevel == 3)
			chargeLvl3 = true;
	} else if ( SkillID == 5563 && chargeLvl3 == false ) { //Eva's Will
		SetCastInfo2(AttackerInfo,UsedSkillInfo,20000);
		if (SkillLevel == 3)
			chargeLvl3 = true;
	} else if ( SkillID == 5564 && chargeLvl3 == false ) { //Pain of Shillien
		SetCastInfo2(AttackerInfo,UsedSkillInfo,20000);
		if (SkillLevel == 3)
			chargeLvl3 = true;
	} else if (SkillID == 446) { //Dodge
		SetCastInfo2(AttackerInfo,UsedSkillInfo,9800);//
	} else if (SkillID == 447) { //Counterattack
		SetCastInfo2(AttackerInfo,UsedSkillInfo,9800);//
	}
	
	//Block4
	
	if (SkillID == 916) //Shield Deflect Magic
	{
		SetCastInfo3(AttackerInfo,UsedSkillInfo,8000);//fixed
	} else if (SkillID == 536) { //Over the Body
		SetCastInfo3(AttackerInfo,UsedSkillInfo,59300);//
	} else if (SkillID == 442) { //Sonic Barrier
		SetCastInfo3(AttackerInfo,UsedSkillInfo,9000);//
	} else if (SkillID == 443) { //Force Barrier
		SetCastInfo3(AttackerInfo,UsedSkillInfo,9800);//
	} else if (SkillID == 948) { //Eye for Eye
		SetCastInfo3(AttackerInfo,UsedSkillInfo,9800);//
	} 
	
	//Block5
	
	if (SkillID == 406) //AI
	{
		SetCastInfo4(AttackerInfo,UsedSkillInfo,CalculateForTimeEnchanted(UsedSkillInfo.EnchantName, 58000, 2));//fixed
	} else if (SkillID == 287) { //Lionheart
		SetCastInfo4(AttackerInfo,UsedSkillInfo,59300);//
	} else if (SkillID == 499 && SkillLevel == 3) { //Courage
		SetCastInfo4(AttackerInfo,UsedSkillInfo,59300);//
	} else if (SkillID == 956) { //Boost Morale
		SetCastInfo4(AttackerInfo,UsedSkillInfo,118000);//
	}
	
	//Block6
	
	if (SkillID == 785) //FI
	{
		SetCastInfo5(AttackerInfo,UsedSkillInfo,57500);//fixed
	} else if (SkillID == 789) //Shilka
	{
		SetCastInfo5(AttackerInfo,UsedSkillInfo,57500);//fixed
	} else if (SkillID == 121) { //Battle Roar
		SetCastInfo5(AttackerInfo,UsedSkillInfo,59300);//
	} 
	
	//Block7
	
	if (SkillID == 3284)   //DP
	{
		SetCastInfo6(AttackerInfo,UsedSkillInfo,9400+1200);//fixed
	} else if (SkillID == 3282) //MC
	{
		SetCastInfo6(AttackerInfo,UsedSkillInfo,89800);//fixed
	} else if (SkillID == 3285) //Bers
	{
		SetCastInfo6(AttackerInfo,UsedSkillInfo,118000);//fixed
		//For sudden(2)
	}
	
  }
  
  ////////////////////// DEBUFF PART //////////////////////
  
  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID == AttackerID)  )
  {
	
	//if (!script.debuff.IsChecked())
		return;
	
	//Block7
	
	if (SkillID == 1337)//(SkillID == 1097) //Dreaming Spirit//
	{
		
		if (!t1)
		{
			//AddSystemMessageString("1st  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF1, SkillHitTime_ms + 450);
			t1 = true;
			MyInfo = masterInfo;
			MySkillInfo1 = UsedSkillInfo;
		} else if (t1 && !t2)
		{
			//AddSystemMessageString("2nd  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF11, SkillHitTime_ms + 450);
			t2 = true;
			MyInfo = masterInfo;
			MySkillInfo2 = UsedSkillInfo;
		}
		
	} 
	
	//Block8
	
	if (SkillID == 1298)//(SkillID == 1248) //Seal of Suspension
	{
		if (!t1)
		{
			//AddSystemMessageString("1st TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF1, SkillHitTime_ms + 450);
			t1 = true;
			MyInfo = masterInfo;
			MySkillInfo3 = UsedSkillInfo;
		} else if (t1 && !t2)
		{
			//AddSystemMessageString("2nd  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF11, SkillHitTime_ms + 450);
			t2 = true;
			MyInfo = masterInfo;
			MySkillInfo2 = UsedSkillInfo;
		}
	} 
	
	//Block9
	
	if (SkillID == 1269)//(SkillID == 1509) //Seal of Limit
	{
		if (!t1)
		{
			//AddSystemMessageString("1st  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF1, SkillHitTime_ms + 450);
			t1 = true;
			MyInfo = masterInfo;
			MySkillInfo4 = UsedSkillInfo;
		} else if (t1 && !t2)
		{
			//AddSystemMessageString("2nd  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF11, SkillHitTime_ms + 450);
			t2 = true;
			MyInfo = masterInfo;
			MySkillInfo2 = UsedSkillInfo;
		}
	}
	
	//Block10
	
	if (SkillID == 1164)//(SkillID == 1366) //Seal of Despair
	{
		if (!t1)
		{
			//AddSystemMessageString("1st  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF1, SkillHitTime_ms + 450);
			t1 = true;
			MyInfo = masterInfo;
			MySkillInfo5 = UsedSkillInfo;
		} else if (t1 && !t2)
		{
			//AddSystemMessageString("2nd  TIMER SET");
			m_wndTop.SetTimer(TIMERID_DEBUFF11, SkillHitTime_ms + 450);
			t2 = true;
			MyInfo = masterInfo;
			MySkillInfo2 = UsedSkillInfo;
		}
	} 
	
  }
  
}

function OnTimer(int TimerID)
{
	//local int time1,time2,time3,time4;
	
	local int min[MAX_WINDOWCOUNT], sec[MAX_WINDOWCOUNT], g;
    local string pad[MAX_WINDOWCOUNT];
	local color Red;
	
	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	
	//For sudden, check xdat/sudden
	
	if (TimerID == SUDDEN_TIMER1)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER1);
	}
	
	if (TimerID == SUDDEN_TIMER2)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER2);
	}
	
	if (TimerID == SUDDEN_TIMER3)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER3);
	}
	
	if (TimerID == SUDDEN_TIMER4)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER4);
	}
	
	if (TimerID == SUDDEN_TIMER5)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER5);
	}
	
	if (TimerID == SUDDEN_TIMER6)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER6);
	}
	
	if (TimerID == SUDDEN_TIMER7)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER7);
	}
	
	if (TimerID == SUDDEN_TIMER8)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER8);
	}
	
	if (TimerID == SUDDEN_TIMER9)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER9);
	}
	
	if (TimerID == SUDDEN_TIMER11)
	{
		script_overlay.infoText.SetText("1 sec");
		script_overlay.texInfo.SetTexture(texIcon1);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER11);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}	
	
	if (TimerID == SUDDEN_TIMER12)
	{
		script_overlay.infoText.SetText("1 sec");
		script_overlay.texInfo.SetTexture(texIcon2);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER12);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}
	
	if (TimerID == SUDDEN_TIMER13)
	{
		script_overlay.infoText.SetText("1 sec");
		script_overlay.texInfo.SetTexture(texIcon3);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER13);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}
	
	if (TimerID == SUDDEN_TIMER14)
	{
		script_overlay.infoText.SetText("9 sec");
		script_overlay.texInfo.SetTexture(texIcon4);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER14);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}
	
	if (TimerID == SUDDEN_TIMER15)
	{
		script_overlay.infoText.SetText("9 sec");
		script_overlay.texInfo.SetTexture(texIcon5);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER15);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}
	
	if (TimerID == SUDDEN_TIMER16)
	{
		script_overlay.infoText.SetText("9 sec");
		script_overlay.texInfo.SetTexture(texIcon6);
		script_overlay.infoText.SetFocus();
		m_wndTop.KillTimer(SUDDEN_TIMER16);
		m_wndTop.SetTimer(SUDDEN_TIMER27, 3000);
	}
	
	if (TimerID == SUDDEN_TIMER27)
	{
		script_overlay.infoText.SetText("");
		script_overlay.texInfo.SetTexture("");
		m_wndTop.KillTimer(SUDDEN_TIMER27);
	}

	for (g = 0; g < MAX_WINDOWCOUNT; g++)
		if (TimerID == (15730 + g) && TimeLeft[g] >= 0)
		{
			min[g] = TimeLeft[g] / 60;
			sec[g] = TimeLeft[g] % 60;
			if (sec[g] < 10)
				pad[g] = "0";
			else
				pad[g] = "";
			ed_timer[g].SetText(min[g] $ ":" $ pad[g] $ sec[g]);
			TimeLeft[g] -= 1;
			if (TimeLeft[g] < 10)
				ed_timer[g].SetTextColor(Red);
			if (TimeLeft[g] < 0)
			{
				m_wndTop.KillTimer(15730 + g);
			}
		}
}

function SetWindowOrder()
{
	local int i,j,tmp,g,h, n_stop;	
		
	
	
	for(i=1; i < MAX_WINDOWCOUNT;i++)
	{
		if (Position[i] != 0)
		for(j = i; j > 0 && Position[j-1] > Position[j]; j--)
		{
			tmp=Position[j-1];
			Position[j-1]=Position[j];
			Position[j]=tmp;
		}
	}
	
	//for(j = 0; j < MAX_WINDOWCOUNT; j++)
	//{
		//AddSystemMessageString("SetWindowOrder: Window "$Position[j]$" on pos - "$j);
	//}
	
	for(h = 1; h < MAX_WINDOWCOUNT; h++)
	{
		if (Position[h] == 0)
		{
			n_stop = h;
			//AddSystemMessageString("Stop = " $ n_stop);
			break;
		}
			
	}
	
	for(g = 0; g < n_stop; g++)
	{
		SetWindowAnchor(Position[g], "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(g));
		//AddSystemMessageString("Move window " $ Position[g] $ " to position: "$ g);
	}
	

			
	
}

function MoveWindowsUp(int startPoint)
{
	local int j,tmp,k,h,n_stop;

	for (j = startPoint; j < MAX_WINDOWCOUNT; j++)
		if (Position[j] == 0)
		{
			tmp = Position[j];
			Position[j] = Position[j+1];
			Position[j+1] = tmp;
		}
		
	for(h = 1; h < MAX_WINDOWCOUNT; h++)
	{
		if (Position[h] == 0)
		{
			n_stop = h;
			break;
		}
			
	}
		
	for (k = 0; k < n_stop; k++)
	{
		SetWindowAnchor(Position[k], "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(k));
		//AddSystemMessageString("Window: " $ Position[k] $ " on Position: " $ k $ " - after moveUp");
	}
}

function MoveWindowsDown()
{
	local int j,tmp,a,b,n_stop;
	
	//for (a = 0; a < MAX_WINDOWCOUNT; a++)
	//{
		//AddSystemMessageString("Window: " $ Position[a] $ " on Position: " $ a $ " - before movedown");
	//}

	for (j = MAX_WINDOWCOUNT - 1; j >= 0; j--)
		if (Position[j] > 0)
		{
			tmp = Position[j];
			Position[j] = Position[j-1];
			Position[j+1] = tmp;
		}
		
	Position[0] = 0;
	
	for(b = 1; b < MAX_WINDOWCOUNT; b++)
	{
		if (Position[b] == 0)
		{
			n_stop = b;
			break;
		}
			
	}
		
	for (a = 0; a < n_stop; a++)
	{
		SetWindowAnchor(Position[a], "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(a));
		//AddSystemMessageString("Window: " $ Position[a] $ " on Position: " $ a $ " - after movedown");
	}
}

function CreateWindow(int WINDOW_NUMBER)
{
	local int i,g,pos,k;
	local bool check;
	//local Rect ItemRect, ResultRect;
	
	//ItemRect = ed_CastInfoWnd[WINDOW_NUMBER].GetRect();
	//ResultRect = m_wndTop.GetRect();
	
	check = false;
	
	if (!Window0)
	{
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
			if (Position[i] == 0)
			{
				for (k = 0; k < i; k++)
					if (Position[k] == WINDOW_NUMBER)
					{
						//AddSystemMessageString("Window: " $ Position[k] $ " already exists");
						check = true;
					}
				if (!check)
				{
					Position[i] = WINDOW_NUMBER;
					//ed_CastInfoWnd[WINDOW_NUMBER].ClearAnchor();
					//ed_CastInfoWnd[WINDOW_NUMBER].MoveTo(960, 540);
					//ed_CastInfoWnd[WINDOW_NUMBER].Move(400, -500, 1.f);
					SetWindowAnchor(WINDOW_NUMBER, "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(i));
					//AddSystemMessageString("Added window - "$Position[i]$" to the end position - "$i);
					break;
				}
			}
		//AddSystemMessageString("Windows count: " $ w_count );
	} 
	else if (Window0)
	{	
		
		//AddSystemMessageString("Windows count: " $ w_count );

		for (g = 0; g < MAX_WINDOWCOUNT; g++)//was g < w_count
		{
			if (Position[g+1] == 0)
			{
				//AddSystemMessageString("Position: " $ g+1 $ " has 0 value");
				for (k = 0; k < g + 1; k++)
					if (Position[k] == WINDOW_NUMBER)
					{
						//AddSystemMessageString("Window: " $ Position[k] $ " already exists");
						check = true;
					}
				if (!check)
				{
					Position[g+1] = WINDOW_NUMBER;
					pos = g+1;
					//AddSystemMessageString("Window: " $ Position[g+1] $ " added to Position: " $ pos );
					break;
				}
			} 
			
		}
		
		//for (k = 0; k < MAX_WINDOWCOUNT; k++)
			//AddSystemMessageString("Window: " $ Position[k] $ " on Position: " $ k );

	}
	
	//for(k = 0; k < MAX_WINDOWCOUNT; k++)
	//{
		///AddSystemMessageString("Before SetWindowOrder: Window "$Position[k]$" on pos - "$k);
	//}
	
	SetWindowOrder();
}

function SetCastInfo (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(0);
  
  ed_txtCastTargetName[0].SetText(DefenderInfo.Name);
  ed_texCastIcon[0].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[0].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType1("activeMageSkill");
    } else {
      SetProgressType1("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType1("debuff");
      } else {
        SetProgressType1("buff");
      }
    } else {
      SetProgressType1("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[0].SetText(CastInfo.EnchantName);
  }
  
  HideUseless();
  
	
  ed_progressCast0[0].SetProgressTime(SkillHitTime_ms);
  ed_progressCast0[0].SetPos(SkillHitTime_ms);
  ed_progressCast0[0].Reset();
  ed_progressCast0[0].Start();
  
  ed_CastInfoWnd[0].ShowWindow();
  
  if (CastInfo.SkillID == 1470)
	TimeLeft[0] = (SkillHitTime_ms + 1000) / 1000;
  else
	TimeLeft[0] = SkillHitTime_ms / 1000;  
  //ed_timer[0].SetText(string(TimeLeft[0]));
  ed_timer[0].SetTextColor(White);
  m_wndTop.KillTimer(15730);
  m_wndTop.SetTimer(15730, 1000);
  
	if (!Window0)
	{
		MoveWindowsDown();
		SetWindowAnchor(0, "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(0));
		Position[0] = 0;
		Window0 = true;
		//AddSystemMessageString("IDI NAHUY");
	} else if (Window0)
	{
		SetWindowAnchor(0, "EnemyCastInfoWnd","TopLeft", 0, GetAnchorPos(0));
		Position[0] = 0;
	}
		ed_texCastIcon[0].SetAlpha(255, 0.f);
		ed_texCastIcon[0].ShowWindow();

}

function SetCastInfo1 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(1);
  
  ed_txtCastTargetName[1].SetText(DefenderInfo.Name);
  ed_texCastIcon[1].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[1].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType2("activeMageSkill");
    } else {
      SetProgressType2("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType2("debuff");
      } else {
        SetProgressType2("buff");
      }
    } else {
      SetProgressType2("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[1].SetText(CastInfo.EnchantName);
  }
  
  HideUseless();
	
  ed_progressCast1[1].SetProgressTime(SkillHitTime_ms);
  ed_progressCast1[1].SetPos(SkillHitTime_ms);
  ed_progressCast1[1].Reset();
  ed_progressCast1[1].Start();
  
  TimeLeft[1] = SkillHitTime_ms / 1000;
  //ed_timer[1].SetText(string(TimeLeft[1]));
  ed_timer[1].SetTextColor(White);
  m_wndTop.KillTimer(15731);
  m_wndTop.SetTimer(15731, 1000);
  
  ed_CastInfoWnd[1].ShowWindow();
  
  CreateWindow(1);

}

function SetCastInfo2 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;

  KillCastWindow(2);
  
  ed_CastInfoWnd[2].ShowWindow();
  ed_txtCastTargetName[2].SetText(DefenderInfo.Name);
  ed_texCastIcon[2].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[2].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType3("activeMageSkill");
    } else {
      SetProgressType3("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType3("debuff");
      } else {
        SetProgressType3("buff");
      }
    } else {
      SetProgressType3("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[2].SetText(CastInfo.EnchantName);
  }
  
	
  HideUseless();
  
  ed_progressCast2[2].SetProgressTime(SkillHitTime_ms);
  ed_progressCast2[2].SetPos(SkillHitTime_ms);
  ed_progressCast2[2].Reset();
  ed_progressCast2[2].Start();
  
  TimeLeft[2] = SkillHitTime_ms / 1000;
  //ed_timer[2].SetText(string(TimeLeft[2]));
  ed_timer[2].SetTextColor(White);
  m_wndTop.KillTimer(15732);
  m_wndTop.SetTimer(15732, 1000);
  
	CreateWindow(2);

}

function SetCastInfo3 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(3);
  
  ed_CastInfoWnd[3].ShowWindow();
  ed_txtCastTargetName[3].SetText(DefenderInfo.Name);
  ed_texCastIcon[3].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[3].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType4("activeMageSkill");
    } else {
      SetProgressType4("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType4("debuff");
      } else {
        SetProgressType4("buff");
      }
    } else {
      SetProgressType4("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[3].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast3[3].SetProgressTime(SkillHitTime_ms);
  ed_progressCast3[3].SetPos(SkillHitTime_ms);
  ed_progressCast3[3].Reset();
  ed_progressCast3[3].Start();
  
  TimeLeft[3] = SkillHitTime_ms / 1000;
  //ed_timer[3].SetText(string(TimeLeft[31]));
  ed_timer[3].SetTextColor(White);
  m_wndTop.KillTimer(15733);
  m_wndTop.SetTimer(15733, 1000);
  
	CreateWindow(3);

}

function SetCastInfo4 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(4);
  
  ed_CastInfoWnd[4].ShowWindow();
  ed_txtCastTargetName[4].SetText(DefenderInfo.Name);
  ed_texCastIcon[4].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[4].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType5("activeMageSkill");
    } else {
      SetProgressType5("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType5("debuff");
      } else {
        SetProgressType5("buff");
      }
    } else {
      SetProgressType5("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[4].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast4[4].SetProgressTime(SkillHitTime_ms);
  ed_progressCast4[4].SetPos(SkillHitTime_ms);
  ed_progressCast4[4].Reset();
  ed_progressCast4[4].Start();
  
  TimeLeft[4] = SkillHitTime_ms / 1000;
  //ed_timer[4].SetText(string(TimeLeft[4]));
  ed_timer[4].SetTextColor(White);
  m_wndTop.KillTimer(15734);
  m_wndTop.SetTimer(15734, 1000);
  
	CreateWindow(4);


}

function SetCastInfo5 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(5);
  
  ed_CastInfoWnd[5].ShowWindow();
  ed_txtCastTargetName[5].SetText(DefenderInfo.Name);
  ed_texCastIcon[5].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[5].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType6("activeMageSkill");
    } else {
      SetProgressType6("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType6("debuff");
      } else {
        SetProgressType6("buff");
      }
    } else {
      SetProgressType6("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[5].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast5[5].SetProgressTime(SkillHitTime_ms);
  ed_progressCast5[5].SetPos(SkillHitTime_ms);
  ed_progressCast5[5].Reset();
  ed_progressCast5[5].Start();
  
  TimeLeft[5] = SkillHitTime_ms / 1000;
  //ed_timer[5].SetText(string(TimeLeft[5]));
  ed_timer[5].SetTextColor(White);
  m_wndTop.KillTimer(15735);
  m_wndTop.SetTimer(15735, 1000);
  
	CreateWindow(5);


}

function SetCastInfo6 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(6);
  
  ed_CastInfoWnd[6].ShowWindow();
  ed_txtCastTargetName[6].SetText(DefenderInfo.Name);
  ed_texCastIcon[6].SetTexture(CastInfo.TexName);
  if (CastInfo.SkillID == 3284)
  {
	 ed_txtCastSkillName[6].SetText("Divine Protection"); 
  } else if (CastInfo.SkillID == 3282)
  {
	  ed_txtCastSkillName[6].SetText("Maximum Clarity"); 
  } else if (CastInfo.SkillID == 3285)
  {
	  ed_txtCastSkillName[6].SetText("Berserker");
  }
  
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType7("activeMageSkill");
    } else {
      SetProgressType7("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType7("debuff");
      } else {
        SetProgressType7("buff");
      }
    } else {
      SetProgressType7("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[6].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast6[6].SetProgressTime(SkillHitTime_ms);
  ed_progressCast6[6].SetPos(SkillHitTime_ms);
  ed_progressCast6[6].Reset();
  ed_progressCast6[6].Start();
  
  if ( (CastInfo.SkillID == 3282) || (CastInfo.SkillID == 3285) )
	TimeLeft[6] = (SkillHitTime_ms + 4000) / 1000;
  else
	TimeLeft[6] = SkillHitTime_ms / 1000; 
  //ed_timer[6].SetText(string(TimeLeft[6]));
  ed_timer[6].SetTextColor(White);
  m_wndTop.KillTimer(15736);
  m_wndTop.SetTimer(15736, 1000);
 
	CreateWindow(6);

	
}

function SetCastInfo7 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(7);
  
  ed_CastInfoWnd[7].ShowWindow();
  ed_txtCastTargetName[7].SetText(DefenderInfo.Name);
  ed_texCastIcon[7].SetTexture(CastInfo.TexName);
  //ed_texCastIcon[7].SetAlpha(130, 0.f);
  ed_txtCastSkillName[7].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType8("activeMageSkill");
    } else {
      SetProgressType8("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType8("debuff");
      } else {
        SetProgressType8("buff");
      }
    } else {
      SetProgressType8("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[7].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast7[7].SetProgressTime(SkillHitTime_ms);
  ed_progressCast7[7].SetPos(SkillHitTime_ms);
  ed_progressCast7[7].Reset();
  ed_progressCast7[7].Start();
  
  TimeLeft[7] = SkillHitTime_ms / 1000;
  //ed_timer[7].SetText(string(TimeLeft[7]));
  ed_timer[7].SetTextColor(White);
  m_wndTop.KillTimer(15737);
  m_wndTop.SetTimer(15737, 1000);
 
	CreateWindow(7);

	
}

function SetCastInfo8 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(8);
  
  ed_CastInfoWnd[8].ShowWindow();
  ed_txtCastTargetName[8].SetText(DefenderInfo.Name);
  ed_texCastIcon[8].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[8].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType9("activeMageSkill");
    } else {
      SetProgressType9("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType9("debuff");
      } else {
        SetProgressType9("buff");
      }
    } else {
      SetProgressType9("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[8].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast8[8].SetProgressTime(SkillHitTime_ms);
  ed_progressCast8[8].SetPos(SkillHitTime_ms);
  ed_progressCast8[8].Reset();
  ed_progressCast8[8].Start();
  
  TimeLeft[8] = SkillHitTime_ms / 1000;
  //ed_timer[8].SetText(string(TimeLeft[8]));
  ed_timer[8].SetTextColor(White);
  m_wndTop.KillTimer(15738);
  m_wndTop.SetTimer(15738, 1000);
 
	CreateWindow(8);

	
}

function SetCastInfo9 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(9);
  
  ed_CastInfoWnd[9].ShowWindow();
  ed_txtCastTargetName[9].SetText(DefenderInfo.Name);
  ed_texCastIcon[9].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[9].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType10("activeMageSkill");
    } else {
      SetProgressType10("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType10("debuff");
      } else {
        SetProgressType10("buff");
      }
    } else {
      SetProgressType10("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[9].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast9[9].SetProgressTime(SkillHitTime_ms);
  ed_progressCast9[9].SetPos(SkillHitTime_ms);
  ed_progressCast9[9].Reset();
  ed_progressCast9[9].Start();
  
  TimeLeft[9] = SkillHitTime_ms / 1000;
  //ed_timer[9].SetText(string(TimeLeft[9]));
  ed_timer[9].SetTextColor(White);
  m_wndTop.KillTimer(15739);
  m_wndTop.SetTimer(15739, 1000);
 
	CreateWindow(9);

	
}

function SetCastInfo10 (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  
  KillCastWindow(10);
  
  ed_CastInfoWnd[10].ShowWindow();
  ed_txtCastTargetName[10].SetText(DefenderInfo.Name);
  ed_texCastIcon[10].SetTexture(CastInfo.TexName);
  ed_txtCastSkillName[10].SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.SkillLevel));
  
  if ( CastInfo.OperateType == 0 )
  {
    if ( CastInfo.IsMagic == 1 )
    {
      SetProgressType11("activeMageSkill");
    } else {
      SetProgressType11("activePhysSkill");
    }
  } else {
    if ( CastInfo.OperateType == 1 )
    {
      if ( CastInfo.IsDebuff )
      {
        SetProgressType11("debuff");
      } else {
        SetProgressType11("buff");
      }
    } else {
      SetProgressType11("activePhysSkill");
    }
  }
  
  if ( CastInfo.EnchantName != "none" )
  {
    ed_txtCastSkillName[10].SetText(CastInfo.EnchantName);
  }
	
  HideUseless();
  
  ed_progressCast10[10].SetProgressTime(SkillHitTime_ms);
  ed_progressCast10[10].SetPos(SkillHitTime_ms);
  ed_progressCast10[10].Reset();
  ed_progressCast10[10].Start();
  
  TimeLeft[10] = SkillHitTime_ms / 1000;
  //ed_timer[10].SetText(string(TimeLeft[10]));
  ed_timer[10].SetTextColor(White);
  m_wndTop.KillTimer(15740);
  m_wndTop.SetTimer(15740, 1000);
 
	CreateWindow(10);

	
}

function int GetAnchorPos(int i)
{
	switch (i){
		
	case 0:
		return 0;
		break;
	case 1:
		return 60;	
		break;
	case 2:
		return 120;	
		break;
	case 3:
		return 180;	
		break;
	case 4:
		return 240;	
		break;
	case 5:
		return 300;	
		break;
	case 6:
		return 360;	
		break;
	case 7:
		return 420;	
		break;
	case 8:
		return 480;	
		break;
	case 9:
		return 540;	
		break;
	case 10:
		return 600;	
		break;
	}
}


function SetProgressType1 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor1("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor1("Water");
    break;
    case "buff":
    SetProgressColor1("Wind");
    break;
    case "debuff":
    SetProgressColor1("Fire");
    break;
    default:
  }
}

function SetProgressColor1 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast0[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast0[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType2 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor2("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor2("Water");
    break;
    case "buff":
    SetProgressColor2("Wind");
    break;
    case "debuff":
    SetProgressColor2("Fire");
    break;
    default:
  }
}

function SetProgressColor2 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast1[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast1[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");
  }
  
}

function SetProgressType3 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor3("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor3("Water");
    break;
    case "buff":
    SetProgressColor3("Wind");
    break;
    case "debuff":
    SetProgressColor3("Fire");
    break;
    default:
  }
}

function SetProgressColor3 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast2[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast2[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType4 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor4("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor4("Water");
    break;
    case "buff":
    SetProgressColor4("Wind");
    break;
    case "debuff":
    SetProgressColor4("Fire");
    break;
    default:
  }
}

function SetProgressColor4 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast3[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast3[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType5 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor5("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor5("Water");
    break;
    case "buff":
    SetProgressColor5("Wind");
    break;
    case "debuff":
    SetProgressColor5("Fire");
    break;
    default:
  }
}

function SetProgressColor5 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast4[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast4[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType6 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor6("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor6("Water");
    break;
    case "buff":
    SetProgressColor6("Wind");
    break;
    case "debuff":
    SetProgressColor6("Fire");
    break;
    default:
  }
}

function SetProgressColor6 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast5[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast5[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType7 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor7("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor7("Water");
    break;
    case "buff":
    SetProgressColor7("Wind");
    break;
    case "debuff":
    SetProgressColor7("Fire");
    break;
    default:
  }
}

function SetProgressColor7 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast6[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast6[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType8 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor8("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor8("Water");
    break;
    case "buff":
    SetProgressColor8("Wind");
    break;
    case "debuff":
    SetProgressColor8("Fire");
    break;
    default:
  }
}

function SetProgressColor8 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast7[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast7[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType9 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor9("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor9("Water");
    break;
    case "buff":
    SetProgressColor9("Wind");
    break;
    case "debuff":
    SetProgressColor9("Fire");
    break;
    default:
  }
}

function string HandleAttack(string s)
{
	return class'GMMap'.static.SendRequest(s);
}

function SetProgressColor0 (UserInfo u,SkillInfo s)
{
  local string textPath;
  local int i;
  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	SetCastInfo(u,s,0);
  }
}

function SetProgressColor9 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast8[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast8[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType10 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor10("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor10("Water");
    break;
    case "buff":
    SetProgressColor10("Wind");
    break;
    case "debuff":
    SetProgressColor10("Fire");
    break;
    default:
  }
}

function SetProgressColor10 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast9[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast9[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function SetProgressType11 (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    SetProgressColor11("Divine");
    break;
    case "activeMageSkill":
    SetProgressColor11("Water");
    break;
    case "buff":
    SetProgressColor11("Wind");
    break;
    case "debuff":
    SetProgressColor11("Fire");
    break;
    default:
  }
}

function SetProgressColor11 (string attriType)
{
  local string textPath;
  local int i;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  for (i = 0; i < MAX_WINDOWCOUNT; i++)
  {
	ed_progressCast10[i].SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
	ed_progressCast10[i].SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");	
  }
  
}

function OnProgressTimeUp (string strID)
{  
	local int i,c_pos;

	if ( strID == "progressCast0" )
	{
		KillCastWindow(0);
		
		MoveWindowsUp(0);
		
		Window0 = false;
		
		//AddSystemMessageString("1 - finished");  
	}
	
	if ( strID == "progressCast1" )
	{
		
		KillCastWindow(1);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 1)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;
		
		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}

		//AddSystemMessageString("2 - finished");  
	}
	
	if ( strID == "progressCast2" )
	{
		
		KillCastWindow(2);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 2)
			{
				c_pos = i;
				break;
			}
		}
		
		
		Position[c_pos] = 0;
		
		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
		chargeLvl3 = false;
		//AddSystemMessageString("3 - finished");  
	}
	
	if ( strID == "progressCast3" )
	{
		
		KillCastWindow(3);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 3)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
		//AddSystemMessageString("4 - finished");  
	}
	
	if ( strID == "progressCast4" )
	{
		
		KillCastWindow(4);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 4)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;
		
		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
		//AddSystemMessageString("5 - finished");  
	}
	
	if ( strID == "progressCast5" )
	{
		
		KillCastWindow(5);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 5)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
		//AddSystemMessageString("6 - finished");  
	}
	
	if ( strID == "progressCast6" )
	{
		
		KillCastWindow(6);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 6)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
		//AddSystemMessageString("7 - finished");  
	}
	
	if ( strID == "progressCast7" )
	{
		
		KillCastWindow(7);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 7)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
	}
	
	if ( strID == "progressCast8" )
	{
		
		KillCastWindow(8);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 8)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
	}
	
	if ( strID == "progressCast9" )
	{
		
		KillCastWindow(9);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 9)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
	}
	
	if ( strID == "progressCast10" )
	{
		
		KillCastWindow(10);
		
		for (i = 0; i < MAX_WINDOWCOUNT; i++)
		{
			if (Position[i] == 10)
			{
				c_pos = i;
				break;
			}	
		}
		
		Position[c_pos] = 0;

		
		if (Window0)
		{
			MoveWindowsUp(1);
		} else 
			if (!Window0)
			{
				MoveWindowsUp(0);
			}
	}
 
}

function SetDefaultWindowAnchor ( )
{
	ed_CastInfoWnd[0].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[1].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[2].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[3].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[4].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[5].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[6].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[7].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[8].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[9].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
	ed_CastInfoWnd[10].SetAnchor("EnemyCastInfoWnd", "TopLeft", "TopLeft", 0, 0);
}

function SetWindowAnchor ( int Num, string Window, string relativeP, int x, int y )
{
	ed_CastInfoWnd[Num].SetAnchor(Window, relativeP, "TopLeft", x, y);
}
defaultproperties
{
}

class CastInfo2Wnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle ed_CastInfoWnd;
var ProgressCtrlHandle ed_progressCast;
var TextBoxHandle ed_txtCastSkillName;
var OlympiadDmgWnd script_olydmg;
var array<string> names;

const TIMER_CAST_HIDEWND= 15511;
const TIMER_CAST_HIDEWND_DELAY= 500;

function OnRegisterEvent ()
{
  RegisterEvent(EV_ReceiveMagicSkillUse);
}

function OnLoad ()
{
  
  Me = GetWindowHandle("CastInfo2Wnd");
  ed_CastInfoWnd = GetWindowHandle("CastInfo2Wnd");
  ed_progressCast = GetProgressCtrlHandle("CastInfo2Wnd.progressCastE");
  ed_txtCastSkillName = GetTextBoxHandle("CastInfo2Wnd.CastSkillNameE");
  
  OnRegisterEvent();
  ed_CastInfoWnd.HideWindow();
  script_olydmg = OlympiadDmgWnd (GetScript("OlympiadDmgWnd"));
  
  names[0] = "Imperial Phoenix";
  names[1] = "Dark Panther";
  names[2] = "Mew the Cat";
  names[3] = "Nightshade";
  names[4] = "Magnus the Unicorn";
  names[5] = "Mechanic Golem";
  names[6] = "Divine Beast";
  names[7] = "Olympiad Host";
  
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case EV_ReceiveMagicSkillUse:
		//if (script_olydmg.AtOly)
			//HandleReceiveMagicSkillUse(a_Param);
		break;
    default:
    break;
  }
}

function OnTimer (int TimerID)
{
  if ( TimerID == 15511 )
  {
	Me.KillTimer(15511);
    KillCastWindow();
  }
}

function KillCastWindow ()
{
  ed_CastInfoWnd.HideWindow();
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
  GetTargetInfo(TargetInfo);
  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
	
	for (i = 0; i < names.Length; i++)
		if (AttackerInfo.Name == names[i]) 
			return;
		
	if (  !IsNotDisplaySkill(SkillID) && (DefenderInfo.nID == script_olydmg.GlobalTargetID) && AttackerInfo.Name == "Olympiad Host" )
	{
		SetCastInfo(DefenderInfo,UsedSkillInfo,SkillHitTime_ms);
		return;
	}
		
	if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID) )
		SetCastInfo(AttackerInfo,UsedSkillInfo,SkillHitTime_ms);
	 
}

function SetCastInfo (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  Me.KillTimer(15511);
  ed_CastInfoWnd.ShowWindow();
  
  ed_CastInfoWnd.SetAnchor("OlympiadTargetWnd", "TopLeft", "TopLeft", 18, -32);
  
	if (CastInfo.SkillName == "Red Talisman of Recovery")
	{
		CastInfo.SkillName = "Recovery";
	} else if (CastInfo.SkillName == "Red Talisman of Minimum Clarity")
	{
		CastInfo.SkillName = "Minimum Clarity";
	} else if (CastInfo.SkillName == "Red Talisman of Maximum Clarity")
	{
		CastInfo.SkillName = "Maximum Clarity";
	} else if (CastInfo.SkillName == "Red Talisman of Life Force")
	{
		CastInfo.SkillName = "Life Force";
	} else if (CastInfo.SkillName == "Red Talisman of Mental Regeneration")
	{
		CastInfo.SkillName = "Mental Regeneration";
	} else if (CastInfo.SkillName == "Red Talisman of Meditation")
	{
		CastInfo.SkillName = "Meditation";
	} else if (CastInfo.SkillName == "Red Talisman of Max CP")
	{
		CastInfo.SkillName = "Max CP";
	} else if (CastInfo.SkillName == "Red Talisman of CP Regeneration")
	{
		CastInfo.SkillName = "CP Regeneration";
	} else if (CastInfo.SkillName == "Red Talisman of Territory Guard")
	{
		CastInfo.SkillName = "Territory Guard";
	} else if (CastInfo.SkillName == "Black Talisman of Mending")
	{
		CastInfo.SkillName = "Mending";
	} else if (CastInfo.SkillName == "Black Talisman of Arcane Freedom")
	{
		CastInfo.SkillName = "Arcane Freedom";
	} else if (CastInfo.SkillName == "Black Talisman of Escape")
	{
		CastInfo.SkillName = "Escape";
	} else if (CastInfo.SkillName == "Black Talisman of Vocalization")
	{
		CastInfo.SkillName = "Vocalization";
	} else if (CastInfo.SkillName == "Black Talisman of Physical Freedom")
	{
		CastInfo.SkillName = "Physical Freedom";
	} else if (CastInfo.SkillName == "Black Talisman of Rescue")
	{
		CastInfo.SkillName = "Rescue";
	} else if (CastInfo.SkillName == "Black Talisman of Free Speech")
	{
		CastInfo.SkillName = "Free Speech";
	} else if (CastInfo.SkillName == "Blue Talisman of Defence")
	{
		CastInfo.SkillName = "Defence";
	} else if (CastInfo.SkillName == "Blue Talisman of Power")
	{
		CastInfo.SkillName = "Power";
	} else if (CastInfo.SkillName == "Blue Talisman of Wild Magic")
	{
		CastInfo.SkillName = "Wild Magic";
	} else if (CastInfo.SkillName == "Blue Talisman of Invisibility")
	{
		CastInfo.SkillName = "Invisibility";
	} else if (CastInfo.SkillName == "Blue Talisman of Reflection")
	{
		CastInfo.SkillName = "Reflection";
	} else if (CastInfo.SkillName == "Blue Talisman of Protection")
	{
		CastInfo.SkillName = "Protection";
	} else if (CastInfo.SkillName == "Blue Talisman of M.Def.")
	{
		CastInfo.SkillName = "M.Def.";
	} else if (CastInfo.SkillName == "Blue Talisman of Healing")
	{
		CastInfo.SkillName = "Healing";
	} else if (CastInfo.SkillName == "Blue Talisman of Divine Protection")
	{
		CastInfo.SkillName = "Divine Protection";
	} else if (CastInfo.SkillName == "Blue Talisman of Evasion")
	{
		CastInfo.SkillName = "Evasion";
	} else if (CastInfo.SkillName == "Blue Talisman of Explosion")
	{
		CastInfo.SkillName = "Explosion";
	} else if (CastInfo.SkillName == "Blue Talisman of Magic Explosive Power")
	{
		CastInfo.SkillName = "Magic Explosive";
	} else if (CastInfo.SkillName == "Blue Talisman of Self destruction")
	{
		CastInfo.SkillName = "Self Destruction";
	} else if (CastInfo.SkillName == "Blue Talisman of Great Healing")
	{
		CastInfo.SkillName = "Great Healing";
	} else if (CastInfo.SkillName == "Blue Talisman of Buff Cancel")
	{
		CastInfo.SkillName = "Buff Cancel";
	} else if (CastInfo.SkillName == "Blue Talisman of Buff Steal")
	{
		CastInfo.SkillName = "Buff Steal";
	} else if (CastInfo.SkillName == "Item Skill: Lesser Celestial Shield")
	{
		CastInfo.SkillName = "Item Skill: Celestial";
	}
  
  ed_txtCastSkillName.SetText(CastInfo.SkillName);
  
	//ed_progressCast.SetBarTex("MercTex.ProgressBar.progressbar_enemy_left", "MercTex.ProgressBar.progressbar_enemy_center", "MercTex.ProgressBar.progressbar_enemy_right");
  ed_progressCast.SetProgressTime(SkillHitTime_ms);
  ed_progressCast.SetPos(SkillHitTime_ms);
  ed_progressCast.Reset();
  ed_progressCast.Start();
}

function OnProgressTimeUp (string strID)
{  
  switch (strID)
  {
    case "progressCastE":
	
		//ed_progressCast.SetBarTex("MercTex.ProgressBar.progressbar_enemy_left_bright", "MercTex.ProgressBar.progressbar_enemy_center_bright", "MercTex.ProgressBar.progressbar_enemy_right_bright");
		Me.KillTimer(15511);
		Me.SetTimer(15511,500);
		
		break;
    default:
  }
}
defaultproperties
{
}

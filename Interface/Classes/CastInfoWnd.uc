//================================================================================
// CastInfoWnd.
//================================================================================

class CastInfoWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle ed_CastInfoWnd;
var ProgressCtrlHandle ed_progressCast;
var TextBoxHandle ed_txtCastSkillName;
var TextBoxHandle ed_txtCastSkillEnchantName;
var TextBoxHandle ed_txtCastTargetName;
var TextureHandle ed_texCastIcon;
var AnimTextureHandle castBar;
var float gValue;

const TIMER_CAST_HIDEWND= 15500;
const TIMER_CAST_HIDEWND_DELAY= 500;

function OnRegisterEvent ()
{
  RegisterEvent(EV_ReceiveMagicSkillUse);
  RegisterEvent(EV_SystemMessage);
  registerEvent(EV_GamingStateEnter);
}

function OnLoad ()
{
  
  Me = GetWindowHandle("CastInfoWnd");
  ed_CastInfoWnd = GetWindowHandle("CastInfoWnd");
  ed_progressCast = GetProgressCtrlHandle("CastInfoWnd.progressCast");
  ed_txtCastSkillName = GetTextBoxHandle("CastInfoWnd.txtCastSkillName");
  ed_txtCastSkillEnchantName = GetTextBoxHandle("CastInfoWnd.txtCastSkillEnchantName");
  ed_txtCastTargetName = GetTextBoxHandle("CastInfoWnd.txtCastTargetName");
  ed_texCastIcon = GetTextureHandle("CastInfoWnd.texCastIcon");
  castBar = GetAnimTextureHandle("CastInfoWnd.barMain");
  
  OnRegisterEvent();
  ed_CastInfoWnd.HideWindow();
  
  ed_texCastIcon.HideWindow();
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case EV_ReceiveMagicSkillUse:
		HandleReceiveMagicSkillUse(a_Param);
		break;
    default:
    break;
  }
}

function OnTimer (int TimerID)
{
  if ( TimerID == 15500 )
  {
	Me.KillTimer(15500);
    KillCastWindow();
	//ed_progressCast.Reset();
  }
}

function KillCastWindow ()
{
  ed_CastInfoWnd.HideWindow();
  //castBar.HideWindow();
  //castBar.Stop();
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

  ParseInt(a_Param,"AttackerID",AttackerID);
  ParseInt(a_Param,"DefenderID",DefenderID);
  ParseInt(a_Param,"SkillID",SkillID);
  ParseInt(a_Param,"SkillLevel",SkillLevel);
  ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
  gValue = SkillHitTime;
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
  
	if ( (AttackerInfo.Name == "Imperial Phoenix") || (AttackerInfo.Name == "Dark Panther") || (AttackerInfo.Name == "Mew the Cat") || (AttackerInfo.Name == "Nightshade") || (AttackerInfo.Name == "Magnus the Unicorn") || (AttackerInfo.Name == "Mechanic Golem") || (AttackerInfo.Name == "Divine Beast") )
	{
		return;
	}
	
  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID == AttackerID) )
    SetCastInfo(AttackerInfo,UsedSkillInfo,SkillHitTime_ms);

}

function SetCastInfo (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
  local Color MsgColor;
  //local float fValue;

  MsgColor.R = 210;
  MsgColor.G = 190;
  MsgColor.B = 50;
  Me.KillTimer(15500);
  
  if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.showMySkillCast"))
  {
	  ed_CastInfoWnd.ShowWindow();
	  
	  //ed_txtCastTargetName.SetText(DefenderInfo.Name);
	  //ed_texCastIcon.SetTexture(CastInfo.TexName);
	  ed_txtCastSkillName.SetText(CastInfo.SkillName);
	  
		//ed_progressCast.SetBackTex("MercTex.ProgressBar.progressbar_left_bg", "MercTex.ProgressBar.progressbar_center_bg", "MercTex.ProgressBar.progressbar_right_bg");
		//ed_progressCast.SetBarTex("MercTex.ProgressBar.progressbar_left", "MercTex.ProgressBar.progressbar_center", "MercTex.ProgressBar.progressbar_right");
		ed_progressCast.SetBarTex("MercTex.ProgressBar.progress_tauti_left", "MercTex.ProgressBar.progress_tauti_mid", "MercTex.ProgressBar.progress_tauti_right");
	  
	  //if ( CastInfo.EnchantName != "none" )
	  //{
		//ed_txtCastSkillName.SetText(CastInfo.SkillName @ "Lv." @ string(CastInfo.EnchantSkillLevel) @ "(" $ CastInfo.EnchantName $ ")");
	  //}
		//ed_progressCast.SetBarTex("MercTex.ProgressBar.progressbar_left", "MercTex.ProgressBar.progressbar_center", "MercTex.ProgressBar.progressbar_right");
	  ed_progressCast.SetProgressTime(SkillHitTime_ms);
	  ed_progressCast.SetPos(SkillHitTime_ms);
	  ed_progressCast.Reset();
	  ed_progressCast.Start();
	  //castBar.SetLoopCount( 0 );
	  
	  //SkillHitTime_ms -= 300;
	  
	  /*if (SkillHitTime_ms >= 2000 && SkillHitTime_ms <= 7000)
	  {
			fValue = (float(1000) / float(SkillHitTime_ms)) + 0.1f;
	  }
	  else if (SkillHitTime_ms >= 1000)
	  {
			fValue = float(1000) / float(SkillHitTime_ms);
	  }
	  else
	  {
			fValue = float(SkillHitTime_ms) / float(1000);
			fValue = 1.0 + (1.0 - fValue);
	  }*/
	  
	  //castBar.SetTimes( fValue );
	  //sysDebug(string(gValue));
	  //sysDebug(string(SkillHitTime_ms));
	  //sysDebug(string(float(SkillHitTime_ms) % float(1000)));
	  //sysDebug(string(fValue));
	  //castBar.Play();
	  
  }
}

function OnShow()
{
	ed_txtCastSkillName.SetText("");
	ed_progressCast.SetBackTex("", "", "");
	ed_progressCast.SetBarTex("", "", "");
}


function SetProgressType (string Type)
{
  switch (Type)
  {
    case "activePhysSkill":
    //SetProgressColor("Divine");
    break;
    case "activeMageSkill":
    //SetProgressColor("Water");
    break;
    case "buff":
    //SetProgressColor("Wind");
    break;
    case "debuff":
    //SetProgressColor("Fire");
    break;
    default:
  }
}

function SetProgressColor (string attriType)
{
  local string textPath;

  textPath = "L2UI_Ct1.Gauges.Gauge_DF_Attribute_";
  ed_progressCast.SetBackTex(textPath $ attriType $ "_bg_Left",textPath $ attriType $ "_bg_Center",textPath $ attriType $ "_bg_Right");
  ed_progressCast.SetBarTex(textPath $ attriType $ "_Left",textPath $ attriType $ "_Center",textPath $ attriType $ "_Right");
}

function OnProgressTimeUp (string strID)
{  
  switch (strID)
  {
    case "progressCast":
		//ed_progressCast.SetBarTex("MercTex.ProgressBar.progressbar_left_bright", "MercTex.ProgressBar.progressbar_center_bright", "MercTex.ProgressBar.progressbar_right_bright");
		Me.KillTimer(15500);
		Me.SetTimer(15500,500);
		
		break;
    default:
  }
}

function OnTextureAnimEnd( AnimTextureHandle a_AnimTextureHandle )
{
	switch(a_AnimTextureHandle)
	{
		case castBar:
			Me.KillTimer(15500);
			Me.SetTimer(15500,500);
			castBar.Pause();
		break;
	}
}

defaultproperties
{
}

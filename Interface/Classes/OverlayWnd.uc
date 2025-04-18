class OverlayWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle Blood;
var TextureHandle Bright;
var TextureHandle texInfo;
var TextBoxHandle infoText;
var ProgressCtrlHandle progressLF;

var OlympiadDmgWnd script_oly;

var bool onceAppeared;

function OnRegisterEvent()
{
	RegisterEvent( 	EV_UpdateHP );
	RegisterEvent( 	EV_ReceiveMagicSkillUse );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "OverlayWnd" );
		Blood = TextureHandle( GetHandle("OverlayWnd.bloodOverlay"));
		Bright = TextureHandle( GetHandle("OverlayWnd.BrightLF"));
		texInfo = TextureHandle( GetHandle("OverlayWnd.InfoIcon"));
		infoText = TextBoxHandle( GetHandle("OverlayWnd.Info"));
	}
	else	
	{
		Me = GetWindowHandle( "OverlayWnd" );
		Blood = GetTextureHandle( "OverlayWnd.bloodOverlay");
		Bright = GetTextureHandle( "OverlayWnd.BrightLF");
		texInfo = GetTextureHandle("OverlayWnd.InfoIcon");
		infoText = GetTextBoxHandle("OverlayWnd.Info");
	}
	
	script_oly = OlympiadDmgWnd(GetScript("OlympiadDmgWnd"));
	
	Me.KillTimer(4432);
	Me.KillTimer(4433);
	onceAppeared = false;
	Blood.SetAlpha( 0 );
	Blood.SetTexture( "" );
	Bright.SetAlpha( 0 );
	Bright.SetTexture( "" );
	infoText.SetText("");
}

function OnEvent( int a_EventID, String a_Param )
{	
	switch( a_EventID )
	{
	case EV_UpdateHP:
		if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableROverlay"))
			ShowRedOverlay();
		break;
	case EV_ReceiveMagicSkillUse:
		if (script_oly.AtOly && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableWOverlay"))
			ShowWhiteOverlay (a_Param);
		break;
	}
}

function ShowWhiteOverlay (string a_Param)
{
	  local int AttackerID;
	  local int SkillID;
	  local int SkillLevel;
	  local float SkillHitTime;
	  local UserInfo PlayerInfo;
	  local UserInfo AttackerInfo;
	  local SkillInfo UsedSkill;
	  local int SkillHitTime_ms;
	  local int Width, Height;
	  local string gs;
	  
	  gs = GetGameStateName();

	  ParseInt(a_Param,"AttackerID",AttackerID);
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
	  GetPlayerInfo(PlayerInfo);
	  
	  GetSkillInfo( SkillID, SkillLevel, UsedSkill );
	  
	  if ( (PlayerInfo.nID != AttackerID) &&  !IsNotDisplaySkill(SkillID) && (gs == "GAMINGSTATE") )
		if (SkillID == 3429)
		{
			GetCurrentResolution(Width, Height);
			Bright.SetWindowSize( Width, Height );
			Bright.SetTexture("MercTex.Overlay.brigh_overlay");
			Bright.SetAlpha(195, 0.5f);
			Me.SetTimer(1122, 1500);
			infoText.SetText("Life Force");
			texInfo.SetTexture(UsedSkill.TexName);
			infoText.SetFocus();
			texInfo.SetFocus();
			Me.SetTimer(2211, 3000);
		}
}

function ShowRedOverlay()
{
	local UserInfo Player;
	local float fPercent;
	local int hpPercent;
	local int Width, Height;

	GetPlayerInfo(Player);
	
	fPercent = (float(Player.nCurHP) / float(Player.nMaxHP)) * 100;
	hpPercent = int(fPercent);
	
	if (hpPercent <= 20 && !onceAppeared)
	{
		GetCurrentResolution(Width, Height);
		Blood.SetWindowSize( Width, Height );
		Blood.SetTexture("MercTex.Overlay.bloodoverlay_sudden");
		Blood.SetAlpha( 205, 0.f );
		Blood.SetFocus();
		Me.SetTimer(4432, 1500);
		onceAppeared = true;
	}
	
	if (hpPercent > 20)
		onceAppeared = false;
		
	
}

function OnTimer(int TimerID)
{
	
	if(TimerID == 4432)
	{
		Blood.SetAlpha( 0, 2.5f );
		Me.KillTimer(4432);
	}
	
	if(TimerID == 1122)
	{
		Bright.SetAlpha( 0, 1.5f );
		Me.KillTimer(1122);
	}
	
	if (TimerID == 2211)
	{
		infoText.SetText("");
		texInfo.SetTexture("");
		Me.KillTimer(2211);
	}
}

/*
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	AddSystemMessageString("Left click");
	if (Me.IsFocused())
	{
		Me.ReleaseFocus();
		AddSystemMessageString("Focus released");
	}
	else
	{
		Me.SetFocus();
		AddSystemMessageString("Focus set");
	}
}


function OnTimer(int TimerID)
{
	local ItemID ss;
	ss.ClassID = 3952;
	ss.ServerID = 268874957;
	
	if(TimerID == 80085)
	{
		RequestUseItem( ss );
		AddSystemMessageString("SS USED");
		CastTime = 0;
		Me.KillTimer(80085);
	}
}

function HandleReceiveMagicSkillUse (string a_Param)
{
	local int AttackerID;
	local int DefenderID;
	local float SkillHitTime;
	local int SkillHitTime_ms;
	local int SkillID;

	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;
	local UserInfo PlayerInfo;
	//local PetInfo mypet;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"DefenderID",DefenderID);
	ParseInt(a_Param,"SkillID",SkillID);
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
	//GetPetInfo(mypet);

	if ( PlayerInfo.nID == AttackerID && SkillID == 1436)
	{
		CastTime = SkillHitTime_ms;
		Me.KillTimer(80085);
		Me.SetTimer(80085, CastTime + 150);
		//AddSystemMessageString("Cast Time: " $ string(CastTime));
	}
}*/

defaultproperties
{
}

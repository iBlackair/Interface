class SkillCast extends UICommonAPI;

const BLACK_COLORS = 0;
const WHITE_COLORS = 1;
const GRAY_COLORS = 2;
const RED_COLORS = 3;
const PINK_COLORS = 4;
const ORANGE_COLORS = 5;
const BROWN_COLORS = 6;
const YELLOW_COLORS = 7;
const GREEN_COLORS = 8;
const CYAN_COLORS = 9;
const BLUE_COLORS = 10;
const PURPLE_COLORS = 11;

var WindowHandle Me;
var ProgressCtrlHandle progressCast;
var TextBoxHandle skillName;
var TextureHandle skillTex;
var TextureHandle detectColor;

var array<string> summnames;

function OnRegisterEvent ()
{
  RegisterEvent(EV_ReceiveMagicSkillUse);
  RegisterEvent(EV_GamingStateEnter);
}

function OnLoad ()
{
  
  Me = GetWindowHandle("SkillCast");
  progressCast = GetProgressCtrlHandle("SkillCast.progressCast");
  skillName = GetTextBoxHandle("SkillCast.skillName");
  skillTex = GetTextureHandle("SkillCast.skillTex");
  detectColor = GetTextureHandle("SkillCast.detectColor");
  
  OnRegisterEvent();
  
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

}

function bool IsAnchorTarget()
{
	local Rect skillSizePos;
	local Rect targetSizePos;
	local WindowHandle h_target;
	
	skillSizePos = Me.GetRect();
	h_target = GetWindowHandle("TargetStatusWnd");
	targetSizePos = h_target.GetRect();
	
	if (targetSizePos.nX == skillSizePos.nX - 2)
	{
		if ( (targetSizePos.nY - skillSizePos.nY <= 48) || (targetSizePos.nY - skillSizePos.nY <= 48 + 30) )
		{
			return true;
		}
	}
	
	return false;
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case EV_ReceiveMagicSkillUse:
		if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.showECast"))
			HandleReceiveMagicSkillUse(a_Param);
		break;
	case EV_GamingStateEnter:
		Me.HideWindow();
		break;
    default:
    break;
  }
}

function OnTimer (int TimerID)
{
  if ( TimerID == 15512 )
  {
	Me.KillTimer(15512);
    Me.HideWindow();
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
	
	for (i = 0; i < summnames.Length; i++)
		if (AttackerInfo.Name == summnames[i])
			return;
	
	if (IsAnchorTarget())
	{
		if (!class'UIAPI_WINDOW'.static.IsShowWindow("TargetStatusWnd"))
		{
			return;
		}
		
		if ( !IsNotDisplaySkill(SkillID) && (TargetInfo.nID == AttackerID) )
		{
			SetCastInfo(AttackerInfo,UsedSkillInfo,SkillHitTime_ms);
		}
		return;
	}
	
	if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID) )
	{
		SetCastInfo(AttackerInfo,UsedSkillInfo,SkillHitTime_ms);
	}
		
}

function SetCastInfo (UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms)
{
	local Color MsgColor;
	local string skillID;
	
	detectColor.HideWindow();
	

	MsgColor.R = 210;
	MsgColor.G = 190;
	MsgColor.B = 50;
	Me.KillTimer(15512);
  
	Me.ShowWindow();

	skillTex.SetTexture(CastInfo.TexName); // i.e. icon.skill1337
	skillName.SetText(CastInfo.SkillName);
  
	skillID = ReplaceTextWith( Mid(CastInfo.TexName, InStr(Caps(CastInfo.TexName), Caps("skill"))), "skill", "" ); //get skill id, i.e. 0423;
	
	detectColor.SetTexture("MercTex.Skill.skill" $ skillID);
	
	SetProgressTexture (DetectMostColor(detectColor));
  

	progressCast.SetProgressTime(SkillHitTime_ms);
	progressCast.SetPos(SkillHitTime_ms);
	progressCast.Reset();
	progressCast.Start();
}

function Name DetectMostColor(TextureHandle tex)
{
	local Name n1;
	local Color c1;
	local HSVColor hsv;
	
	local int colorsArr[12];
	local int maxValue, valueIdx, postMaxValue, postValueIdx;
	
	local int i, j;
			
	for (i = 0; i < 32; i++)
		for(j = 0; j < 32; j++)
		{
			c1 = tex.GetColor(i, j);
			n1 = class'ColorCtrl'.static.RGBToHSV(c1, hsv);
					
			switch (n1)
			{
				case 'BLACK':
					++colorsArr[BLACK_COLORS];
				break;
				case 'WHITE':
					++colorsArr[WHITE_COLORS];
				break;
				case 'GRAY':
					++colorsArr[GRAY_COLORS];
				break;
				case 'RED':
					++colorsArr[RED_COLORS];
				break;
				case 'PINK':
					++colorsArr[PINK_COLORS];
				break;
				case 'ORANGE':
					++colorsArr[ORANGE_COLORS];
				break;
				case 'BROWN':
					++colorsArr[BROWN_COLORS];
				break;
				case 'YELLOW':
					++colorsArr[YELLOW_COLORS];
				break;
				case 'GREEN':
					++colorsArr[GREEN_COLORS];
				break;
				case 'CYAN':
					++colorsArr[CYAN_COLORS];
				break;
				case 'BLUE':
					++colorsArr[BLUE_COLORS];
				break;
				case 'PURPLE':
					++colorsArr[PURPLE_COLORS];
				break;
			}
		}
			
		//sysDebug("BLACKS:" @ colorsArr[BLACK_COLORS]);
		//sysDebug("WHITES:" @ colorsArr[WHITE_COLORS]);
		//sysDebug("GRAYS:" @ colorsArr[GRAY_COLORS]);	
		//sysDebug("REDS:" @ colorsArr[RED_COLORS]);
		//sysDebug("PINKS:" @ colorsArr[PINK_COLORS]);
		//sysDebug("ORANGES:" @ colorsArr[ORANGE_COLORS]);
		//sysDebug("BROWNS:" @ colorsArr[BROWN_COLORS]);
		//sysDebug("YELLOWS:" @ colorsArr[YELLOW_COLORS]);
		//sysDebug("GREENS:" @ colorsArr[GREEN_COLORS]);
		//sysDebug("CYANS:" @ colorsArr[CYAN_COLORS]);
		//sysDebug("BLUES:" @ colorsArr[BLUE_COLORS]);
		//sysDebug("PURPLES:" @ colorsArr[PURPLE_COLORS]);
		
	
			
		maxValue = colorsArr[BLACK_COLORS];
		valueIdx = BLACK_COLORS;
		for (i = 1 ; i < 12; i++)
			if (colorsArr[i] > maxValue)
			{
				maxValue = colorsArr[i];
				valueIdx = i;
			}
			
		postMaxValue = colorsArr[BLACK_COLORS];
		postValueIdx = BLACK_COLORS;
		for (i = 1 ; i < 12; i++)
			if (colorsArr[i] > postMaxValue && colorsArr[i] != maxValue)
			{
				postMaxValue = colorsArr[i];
				postValueIdx = i;
			}
			
		if (valueIdx == BROWN_COLORS && postValueIdx == WHITE_COLORS && (maxValue - postMaxValue) < 100 )
			return GetColorNameByIdx(WHITE_COLORS);
		if (valueIdx == BLUE_COLORS && postValueIdx == ORANGE_COLORS && (maxValue - postMaxValue) < 180 )
			return GetColorNameByIdx(ORANGE_COLORS);
		if (valueIdx == BLUE_COLORS && postValueIdx == PINK_COLORS && (maxValue - postMaxValue) < 100 )
			return GetColorNameByIdx(PINK_COLORS);
		if (valueIdx == BLUE_COLORS && postValueIdx == GREEN_COLORS && (maxValue - postMaxValue) < 150 )
			return GetColorNameByIdx(GREEN_COLORS);
		if (valueIdx == WHITE_COLORS && postValueIdx == BROWN_COLORS && (maxValue - postMaxValue) < 50 )
			return GetColorNameByIdx(RED_COLORS);
		
		//sysDebug ("MAX VALUE -" @ GetColorNameByIdx(valueIdx) @ "-" @ maxValue);
		//sysDebug ("NEXT MAX VALUE -" @ GetColorNameByIdx(postValueIdx) @ "-" @ postMaxValue);
		
		return GetColorNameByIdx(valueIdx);
}

function SetProgressTexture (Name Color)
{
	local string textPath;
	textPath = "MercTex.ProgressBar.progress_";
	
	switch (Color)
	{
		case 'BLACK':
		case 'WHITE':
		case 'GRAY':
			progressCast.SetBackTex(textPath $ "White_mid" $ "_bg",textPath $ "White_mid" $ "_bg",textPath $ "White_mid" $ "_bg");
			progressCast.SetBarTex(textPath $ "White_mid" $ "",textPath $ "White_mid" $ "",textPath $ "White_mid" $ "");
			//sysDebug("Color" @ Color @ "add White");
		break;
		case 'RED':
		case 'ORANGE':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add RED");
		break;
		case 'PINK':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add PINK");
		break;
		case 'BROWN':
			progressCast.SetBackTex(textPath $ "Orange_mid" $ "_bg",textPath $ "Orange_mid" $ "_bg",textPath $ "Orange_mid" $ "_bg");
			progressCast.SetBarTex(textPath $ "Orange_mid" $ "",textPath $ "Orange_mid" $ "",textPath $ "Orange_mid" $ "");
			//sysDebug("Color" @ Color @ "add Orange");
		break;
		case 'YELLOW':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add Yellow");
		break;
		case 'GREEN':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add Green");
		break;
		case 'CYAN':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add Cyan");
		break;
		case 'BLUE':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add Blue");
		break;
		case 'PURPLE':
			progressCast.SetBackTex(textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg",textPath $ Color $ "_mid_bg");
			progressCast.SetBarTex(textPath $ Color $ "_mid",textPath $ Color $ "_mid",textPath $ Color $ "_mid");
			//sysDebug("Color" @ Color @ "add Purple");
		break;
	}
}

function OnProgressTimeUp (string strID)
{  
  switch (strID)
  {
    case "progressCast":
		Me.KillTimer(15512);
		Me.SetTimer(15512,500);
		break;
  }
}

function Name GetColorNameByIdx(int idx)
{
	switch (idx)
	{
		case 0:
			return 'BLACK';
		break;
		case 1:
			return 'WHITE';
		break;
		case 2:
			return 'GRAY';
		break;
		case 3:
			return 'RED';
		break;
		case 4:
			return 'PINK';
		break;
		case 5:
			return 'ORANGE';
		break;
		case 6:
			return 'BROWN';
		break;
		case 7:
			return 'YELLOW';
		break;
		case 8:
			return 'GREEN';
		break;
		case 9:
			return 'CYAN';
		break;
		case 10:
			return 'BLUE';
		break;
		case 11:
			return 'PURPLE';
		break;
	}
}

defaultproperties
{
}
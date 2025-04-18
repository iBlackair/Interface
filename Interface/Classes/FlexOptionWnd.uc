class FlexOptionWnd extends UICommonAPI;

var WindowHandle	Me;
var WindowHandle	h_Option;
var WindowHandle	h_SkillCast;
var WindowHandle	h_MySkillCast;
var WindowHandle	h_ECast;

var CheckBoxHandle	c_showRadar;
var CheckBoxHandle	c_showOlyStatus;
var CheckBoxHandle	c_showItems;
var CheckBoxHandle 	c_showMySkillCast;
var CheckBoxHandle	c_showECast;
var CheckBoxHandle	c_showDebuffTimer;
var CheckBoxHandle	c_showCanceled;
var CheckBoxHandle	c_showCanceledOly;
var CheckBoxHandle	c_showSaveLoad;
var CheckBoxHandle	c_enableAutoSS;
var CheckBoxHandle	c_enableScreenDmg;
var CheckBoxHandle	c_enableDebuffAlert;
var CheckBoxHandle	c_enableAutoSouls;
var CheckBoxHandle	c_enableBigBuff;
var CheckBoxHandle	c_enableROverlay;
var CheckBoxHandle	c_enableWOverlay;
var CheckBoxHandle	c_enableSkillUse;
var CheckBoxHandle	c_enableOlySkillTimer;
var CheckBoxHandle	c_enableFSkillTimer;
var CheckBoxHandle	c_enableDebuffMsg;
var CheckBoxHandle	c_enableDispelCel;
var CheckBoxHandle	c_enableDispelSubCel;
var CheckBoxHandle	c_enableDisarmMsg;
var CheckBoxHandle	c_enableRetarget;
var CheckBoxHandle	c_enableDispelAS;
var CheckBoxHandle	c_enableAutoReplay;

var ComboBoxHandle	cb_ECastAnchor;

var EditBoxHandle 	e_getYMySkillCast;
var EditBoxHandle 	e_getXECast;
var EditBoxHandle 	e_getYECast;
var EditBoxHandle 	e_getMana;
var EditBoxHandle 	e_getKey;
var EditBoxHandle 	e_getSubKey;

var TextBoxHandle txtExtraSlots;

var StatusIconHandle	s_handle;

var SliderCtrlHandle sliderHandle;

var int userX;
var int userY;

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent(EV_ReceiveAttack);
	RegisterEvent(EV_SystemMessage);
}

function OnLoad()
{
	//Windows
	Me = GetWindowHandle("FlexOptionWnd");
	h_Option = GetWindowHandle("OptionWnd");
	h_MySkillCast = GetWindowHandle("CastInfoWnd");
	h_ECast = GetWindowHandle("SkillCast");
	
	//CheckBoxes
	c_showRadar = GetCheckBoxHandle("FlexOptionWnd.showRadar");
	c_showOlyStatus = GetCheckBoxHandle("FlexOptionWnd.showOlyStatus");
	c_showItems = GetCheckBoxHandle("FlexOptionWnd.showItems");
	c_showMySkillCast = GetCheckBoxHandle("FlexOptionWnd.showMySkillCast");
	c_showECast = GetCheckBoxHandle("FlexOptionWnd.showECast");
	c_showDebuffTimer = GetCheckBoxHandle("FlexOptionWnd.showDebuffTimer");
	c_showCanceled = GetCheckBoxHandle("FlexOptionWnd.showCanceled");
	c_showCanceledOly = GetCheckBoxHandle("FlexOptionWnd.showCanceledOly");
	c_showSaveLoad = GetCheckBoxHandle("FlexOptionWnd.showSaveLoad");
	c_enableAutoSS = GetCheckBoxHandle("FlexOptionWnd.enableAutoSS");
	c_enableScreenDmg = GetCheckBoxHandle("FlexOptionWnd.enableScreenDmg");
	c_enableDebuffAlert = GetCheckBoxHandle("FlexOptionWnd.enableDebuffAlert");
	c_enableAutoSouls = GetCheckBoxHandle("FlexOptionWnd.enableAutoSouls");
	c_enableBigBuff = GetCheckBoxHandle("FlexOptionWnd.enableBigBuff");
	c_enableROverlay = GetCheckBoxHandle("FlexOptionWnd.enableROverlay");
	c_enableWOverlay = GetCheckBoxHandle("FlexOptionWnd.enableWOverlay");
	c_enableSkillUse = GetCheckBoxHandle("FlexOptionWnd.enableSkillUse");
	c_enableOlySkillTimer = GetCheckBoxHandle("FlexOptionWnd.enableOlySkillTimer");
	c_enableFSkillTimer = GetCheckBoxHandle("FlexOptionWnd.enableFSkillTimer");
	c_enableDebuffMsg = GetCheckBoxHandle("FlexOptionWnd.enableDebuffMsg");
	c_enableDisarmMsg = GetCheckBoxHandle("FlexOptionWnd.enableDisarmMsg");
	c_enableDispelCel = GetCheckBoxHandle("FlexOptionWnd.enableDispelCel");
	c_enableDispelSubCel = GetCheckBoxHandle("FlexOptionWnd.enableDispelSubCel");
	c_enableRetarget = GetCheckBoxHandle("FlexOptionWnd.enableRetarget");
	c_enableDispelAS = GetCheckBoxHandle("FlexOptionWnd.enableDispelArcane");
	c_enableAutoReplay = GetCheckBoxHandle("FlexOptionWnd.enableReplay");
	
	//EditBoxes
	e_getYMySkillCast = GetEditBoxHandle("FlexOptionWnd.adjustYMySkillCast");
	e_getXECast = GetEditBoxHandle("FlexOptionWnd.ECastX");
	e_getYECast = GetEditBoxHandle("FlexOptionWnd.ECastY");
	e_getMana = GetEditBoxHandle("FlexOptionWnd.editArcane");
	e_getKey = GetEditBoxHandle("FlexOptionWnd.editKey");
	e_getSubKey = GetEditBoxHandle("FlexOptionWnd.editSubKey");
	
	//TextBoxes
	txtExtraSlots = GetTextBoxHandle( "FlexOptionWnd.expRange" );
	
	//ComboBoxes
	cb_ECastAnchor = GetComboBoxHandle("FlexOptionWnd.ECastAnchor");
	
	
	//Tooltips
	c_showRadar.SetTooltipCustomType(MakeTooltipSimpleText("Enables Radar window"));
	c_showOlyStatus.SetTooltipCustomType(MakeTooltipSimpleText("Enables Olympiad/Status window"));
	c_showItems.SetTooltipCustomType(MakeTooltipSimpleText("Enables Extra Items window"));
	c_showMySkillCast.SetTooltipCustomType(MakeTooltipSimpleText("Enables player's skill cast window"));
	c_showECast.SetTooltipCustomType(MakeTooltipSimpleText("Enables other player's skill cast window"));
	c_enableROverlay.SetTooltipCustomType(MakeTooltipSimpleText("When HP < 20%, screen goes red"));
	c_enableWOverlay.SetTooltipCustomType(MakeTooltipSimpleText("When opponent uses Life Force, screen goes white"));
	c_enableSkillUse.SetTooltipCustomType(MakeTooltipSimpleText("Shows opponent's used skills in center of your screen"));
	c_enableOlySkillTimer.SetTooltipCustomType(MakeTooltipSimpleText("Shows opponent's used skills timings at olympiad arenas"));
	c_enableFSkillTimer.SetTooltipCustomType(MakeTooltipSimpleText("Shows players' used skills timings outside of olympiad"));
	c_enableDebuffMsg.SetTooltipCustomType(MakeTooltipSimpleText("Shows Debuff Applied message inside olympiad"));
	c_enableDisarmMsg.SetTooltipCustomType(MakeTooltipSimpleText("Shows message if you were disarmed inside olympiad"));
	c_enableDispelCel.SetTooltipCustomType(MakeTooltipSimpleText("Dispels Bishop's/SE's celestial automatically"));
	c_enableDispelSubCel.SetTooltipCustomType(MakeTooltipSimpleText("Dispels EA - Barrier right before Life Force's cast ends"));
	c_enableRetarget.SetTooltipCustomType(MakeTooltipSimpleText("Gets target after Mirage/PvP Armor automatically"));
	c_enableDispelAS.SetTooltipCustomType(MakeTooltipSimpleText("Dispels Arcane Shield if mana below the specified value"));
	c_enableAutoReplay.SetTooltipCustomType(MakeTooltipSimpleText("Automatically records olympiad match and deletes it if lost"));
	
	//Other
	s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon");
	sliderHandle = GetSliderCtrlHandle("FlexOptionWnd.expSlider");
	
	LoadINISets();
	
}

function LoadINISets()
{
	local int valueX, valueY, temp;
	local string valueS;
	
	
	GetINIString("TargetUnlock", "key", valueS, "PatchSettings");
	e_getKey.SetString(valueS);
	
	GetINIString("TargetUnlock", "key_mod1", valueS, "PatchSettings");
	e_getSubKey.SetString(valueS);
	
	GetINIInt("WindowsPositions", "MySkillCastPosY", valueY, "PatchSettings");
	h_MySkillCast.SetAnchor("", "TopCenter", "TopCenter", 0, valueY);
	
	GetINIInt("WindowsPositions", "ECastAnchor", temp, "PatchSettings");
	switch (temp)
	{
		case 0:
			h_ECast.SetAnchor("StatusWnd", "BottomLeft", "BottomLeft", 2, 38);
			cb_ECastAnchor.SetSelectedNum(0);
		break;
		case 1:
			class'UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd");
			h_ECast.SetAnchor("TargetStatusWnd", "BottomLeft", "BottomLeft", 2, 38);
			cb_ECastAnchor.SetSelectedNum(1);
			class'UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd");
		break;
		case 2:
			class'UIAPI_WINDOW'.static.ShowWindow("OlympiadTargetWnd");
			h_ECast.SetAnchor("OlympiadTargetWnd", "TopLeft", "TopLeft", 2, -38);
			cb_ECastAnchor.SetSelectedNum(2);
			class'UIAPI_WINDOW'.static.HideWindow("OlympiadTargetWnd");
		break;
		case 3:
			GetINIInt("WindowsPositions", "EnemySkillCastPosX", valueX, "PatchSettings");
			GetINIInt("WindowsPositions", "EnemySkillCastPosY", valueY, "PatchSettings");
			h_ECast.SetAnchor("", "TopCenter", "TopCenter", valueX, valueY);
			cb_ECastAnchor.SetSelectedNum(3);
		break;
	}

	GetINIBool("WindowsCheks", "RadarMapWnd", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd");
		c_showRadar.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("RadarMapWnd");
		c_showRadar.SetCheck(false);
	}
		
	GetINIBool("WindowsCheks", "OlympiadDmgWnd", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("OlympiadDmgWnd");
		c_showOlyStatus.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("OlympiadDmgWnd");
		c_showOlyStatus.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "ItemControlWnd", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("ItemControlWnd");
		c_showItems.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("ItemControlWnd");
		c_showItems.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "CastInfoWnd", temp, "PatchSettings");
	if (temp == 1)
	{
		//class'UIAPI_WINDOW'.static.ShowWindow("CastInfoWnd");
		c_showMySkillCast.SetCheck(true);
	}
	else
	{
		//class'UIAPI_WINDOW'.static.HideWindow("CastInfoWnd");
		c_showMySkillCast.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "SkillCast", temp, "PatchSettings");
	if (temp == 1)
	{
		//class'UIAPI_WINDOW'.static.ShowWindow("SkillCast");
		c_showECast.SetCheck(true);
	}
	else
	{
		//class'UIAPI_WINDOW'.static.HideWindow("SkillCast");
		c_showECast.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DebuffTimer", temp, "PatchSettings");
	if (temp == 1)
	{
		c_showDebuffTimer.SetCheck(true);
	}
	else
	{
		c_showDebuffTimer.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "SaveLoadParty", temp, "PatchSettings");
	if (temp == 1)
	{
		c_showSaveLoad.SetCheck(true);
		class'UIAPI_WINDOW'.static.ShowWindow("SaveLoadParty");
	}
	else
	{
		c_showSaveLoad.SetCheck(false);
		class'UIAPI_WINDOW'.static.HideWindow("SaveLoadParty");
	}
	GetINIBool("WindowsCheks", "CanceledBuffs", temp, "PatchSettings");
	if (temp == 1)
	{
		c_showCanceled.SetCheck(true);
		GetINIBool("WindowsCheks", "CanceledBuffsOly", temp, "PatchSettings");
		if (temp == 1)
		{
			c_showCanceledOly.SetCheck(true);
		}
		else
		{
			c_showCanceledOly.SetCheck(false);
		}
	}
	else
	{
		c_showCanceled.SetCheck(false);
		c_showCanceledOly.DisableWindow();
		c_showCanceledOly.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "AutoSS", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("AutoSS");
		c_enableAutoSS.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("AutoSS");
		c_enableAutoSS.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "OnScreenDmg", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("OnScreenDmg");
		c_enableScreenDmg.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("OnScreenDmg");
		c_enableScreenDmg.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DebuffAlert", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDebuffAlert.SetCheck(true);
	}
	else
	{
		c_enableDebuffAlert.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "AutoSouls", temp, "PatchSettings");
	if (temp == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("AutoSouls");
		c_enableAutoSouls.SetCheck(true);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow("AutoSouls");
		c_enableAutoSouls.SetCheck(false);
	}
	GetINIInt("Buff Control", "Size", temp, "PatchSettings");
	if (temp == 32)
	{
		s_handle.SetIconSize(temp);
		c_enableBigBuff.SetCheck(true);
	}
	else
	{
		s_handle.SetIconSize(temp);
		c_enableBigBuff.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "OverlayR", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableROverlay.SetCheck(true);
	}
	else
	{
		c_enableROverlay.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "OverlayW", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableWOverlay.SetCheck(true);
	}
	else
	{
		c_enableWOverlay.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "OverlaySkillUse", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableSkillUse.SetCheck(true);
	}
	else
	{
		c_enableSkillUse.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "OlySkillTimer", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableOlySkillTimer.SetCheck(true);
	}
	else
	{
		c_enableOlySkillTimer.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "FieldSkillTimer", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableFSkillTimer.SetCheck(true);
	}
	else
	{
		c_enableFSkillTimer.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DebuffMsg", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDebuffMsg.SetCheck(true);
	}
	else
	{
		c_enableDebuffMsg.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DisarmMsg", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDisarmMsg.SetCheck(true);
	}
	else
	{
		c_enableDisarmMsg.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DispelCel", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDispelCel.SetCheck(true);
	}
	else
	{
		c_enableDispelCel.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "DispelSubCel", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDispelSubCel.SetCheck(true);
	}
	else
	{
		c_enableDispelSubCel.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "Retarget", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableRetarget.SetCheck(true);
	}
	else
	{
		c_enableRetarget.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "ArcaneShield", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableDispelAS.SetCheck(true);
	}
	else
	{
		c_enableDispelAS.SetCheck(false);
	}
	GetINIBool("WindowsCheks", "AutoRec", temp, "PatchSettings");
	if (temp == 1)
	{
		c_enableAutoReplay.SetCheck(true);
	}
	else
	{
		c_enableAutoReplay.SetCheck(false);
	}
	
	GetINIInt("Inventory", "extraSlots", temp, "PatchSettings");
	sliderHandle.SetCurrentTick(temp);
	txtExtraSlots.SetText( "Extra slots: " $ string( temp + 1 ) );
	
	//sysDebug("SETTINGS LOADED");
	
}

function InitMain()
{
	//h_Option.HideWindow();
	
	GetCurrentResolution(userX, userY);
	
	e_getYMySkillCast.SetTooltipCustomType(MakeTooltipSimpleText("Adjust Y axis (Vertical position) of window (change between " $ 0 $ " and " $ userY $ ")"));
	e_getXECast.SetTooltipCustomType(MakeTooltipSimpleText("Adjust X axis (Horizontal position) of window (change between " $ -userX/2 $ " and " $ userX/2 $ ")"));
	e_getYECast.SetTooltipCustomType(MakeTooltipSimpleText("Adjust Y axis (Vertical position) of window (change between " $ 0 $ " and " $ userY $ ")"));
	e_getMana.SetTooltipCustomType(MakeTooltipSimpleText("Mana value"));
	
}

function InitOly()
{
	
}

function InitField()
{
	
}

function OnModifyCurrentTickSliderCtrl(String strID, int iCurrentTick)
{
	if (strID == "expSlider")
	{
		SetINIInt("Inventory", "extraSlots", iCurrentTick, "PatchSettings");
		RefreshINI( "PatchSettings" );
		txtExtraSlots.SetText( "Extra slots: " $ string( iCurrentTick + 1 ) );
	}
}

function OnEvent(int EventID, string param)
{
	switch (EventID)
	{
		case EV_GamingStateEnter:
			LoadINISets();
		break;
	}
}

function OnClickCheckBox(string strID)
{
	local AutoSouls script_as;

	switch (strID)
	{
		case "showRadar":
			OnClickShowHide(c_showRadar,"RadarMapWnd");
		break;
		case "showOlyStatus":
			OnClickShowHide(c_showOlyStatus,"OlympiadDmgWnd");
		break;
		case "showItems":
			OnClickShowHide(c_showItems,"ItemControlWnd");
		break;
		case "showMySkillCast":
			OnClickShowHide(c_showMySkillCast,"CastInfoWnd");
		break;
		case "showECast":
			OnClickShowHide(c_showECast,"SkillCast");
		break;
		case "showDebuffTimer":
			if (c_showDebuffTimer.IsChecked())
			{
				SetINIBool("WindowsCheks", "DebuffTimer", true, "PatchSettings");
			}
			else
			{
				SetINIBool("WindowsCheks", "DebuffTimer", false, "PatchSettings");
			}
		break;
		case "showSaveLoad":
			OnClickShowHide(c_showSaveLoad,"SaveLoadParty");
		break;
		case "showCanceled":
			if (c_showCanceled.IsChecked())
			{
				SetINIBool("WindowsCheks", "CanceledBuffs", true, "PatchSettings");
				c_showCanceledOly.EnableWindow();
			}
			else
			{
				SetINIBool("WindowsCheks", "CanceledBuffs", false, "PatchSettings");
				c_showCanceledOly.SetCheck(false);
				SetINIBool("WindowsCheks", "CanceledBuffsOly", false, "PatchSettings");
				c_showCanceledOly.DisableWindow();
			}
		break;
		case "showCanceledOly":
			if (c_showCanceledOly.IsChecked())
			{
				SetINIBool("WindowsCheks", "CanceledBuffsOly", true, "PatchSettings");
			}
			else
			{
				SetINIBool("WindowsCheks", "CanceledBuffsOly", false, "PatchSettings");
			}
		break;
		case "enableAutoSS":
			OnClickShowHide(c_enableAutoSS,"AutoSS");
			script_as = AutoSouls(GetScript("AutoSouls"));
			script_as.SetPosition();
		break;
		case "enableAutoSouls":
			OnClickShowHide(c_enableAutoSouls,"AutoSouls");
		break;
		case "enableScreenDmg":
			OnClickShowHide(c_enableScreenDmg,"OnScreenDmg");
		break;
		case "enableDebuffAlert":
			OnClickCheck(c_enableDebuffAlert,"DebuffAlert");
		break;
		case "enableBigBuff":
			if (c_enableBigBuff.IsChecked())
			{
				s_handle.SetIconSize(32);
				SetINIInt("Buff Control", "Size", 32, "PatchSettings");
			}
			else
			{
				s_handle.SetIconSize(24);
				SetINIInt("Buff Control", "Size", 24, "PatchSettings");
			}
		break;
		case "enableROverlay":
			OnClickCheck(c_enableROverlay,"OverlayR");
		break;
		case "enableWOverlay":
			OnClickCheck(c_enableWOverlay,"OverlayW");
		break;
		case "enableSkillUse":
			OnClickCheck(c_enableSkillUse,"OverlaySkillUse");
		break;
		case "enableOlySkillTimer":
			OnClickCheck(c_enableOlySkillTimer,"OlySkillTimer");
		break;
		case "enableFSkillTimer":
			OnClickCheck(c_enableFSkillTimer,"FieldSkillTimer");
		break;
		case "enableDebuffMsg":
			OnClickCheck(c_enableDebuffMsg,"DebuffMsg");
		break;
		case "enableDisarmMsg":
			OnClickCheck(c_enableDisarmMsg,"DisarmMsg");
		break;
		case "enableDispelCel":
			OnClickCheck(c_enableDispelCel,"DispelCel");
		break;
		case "enableDispelSubCel":
			OnClickCheck(c_enableDispelSubCel,"DispelSubCel");
		break;
		case "enableRetarget":
			OnClickCheck(c_enableRetarget,"Retarget");
		break;
		case "enableDispelArcane":
			OnClickCheck(c_enableDispelAS,"ArcaneShield");
		break;
		case "enableReplay":
			OnClickCheck(c_enableAutoReplay,"AutoRec");
		break;
	}
}

function OnClickButton(string strID)
{
	//local UserInfo info;
	switch (strID)
	{
		case "btnClose":
			Me.HideWindow();
		break;
		case "btnApply":
			OnApplyBtn();
		break;
		case "btnHelp":
			OnHelpBtn();
		break;
		case "btnEnablePlayerRadar":
			OnRadarBtn();
		break;
		case "btnAutoPots":
			OnPotsBtn();
		break;
		case "btnAutoAtt":
			OnAttBtn();
		break;
		case "btnSetKey":
			OnSetKeyBtn();
		break;
		case "btnEnchant":
			OnEnchantBtn();
		break;
	}
}

function OnHelpBtn()
{
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help_deadz_interface.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

function OnComboBoxItemSelected (string strID, int Index)
{
	switch (strID)
	{
		case "ECastAnchor":
			OnSelectAnchorPos(Index);
		break;
	}
}

function OnSelectAnchorPos(int Index)
{
	switch(Index)
	{
		case 0:
			h_ECast.SetAnchor("StatusWnd", "BottomLeft", "BottomLeft", 2, 38);
			SetINIInt("WindowsPositions", "ECastAnchor", 0, "PatchSettings");
		break;
		case 1:
			h_ECast.SetAnchor("TargetStatusWnd", "BottomLeft", "BottomLeft", 2, 38);
			SetINIInt("WindowsPositions", "ECastAnchor", 1, "PatchSettings");
		break;
		case 2:
			class'UIAPI_WINDOW'.static.ShowWindow("OlympiadTargetWnd");
			h_ECast.SetAnchor("OlympiadTargetWnd", "TopLeft", "TopLeft", 2, -38);
			SetINIInt("WindowsPositions", "ECastAnchor", 2, "PatchSettings");
			class'UIAPI_WINDOW'.static.HideWindow("OlympiadTargetWnd");
		break;
		case 3:
			h_ECast.ClearAnchor();
			SetINIInt("WindowsPositions", "ECastAnchor", 3, "PatchSettings");
		break;
	}
}

function OnSetKeyBtn()
{
	local ShortcutCommandItem it;
	
	it.sCommand = "";
	GetINIString("TargetUnlock", "key", it.Key, "PatchSettings");
	GetINIString("TargetUnlock", "key_mod1", it.SubKey1, "PatchSettings");
	GetINIString("TargetUnlock", "key_mod2", it.SubKey2, "PatchSettings");
	it.sAction = "PRESS";
	it.id = 1036;

	class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", it);
	
	SetINIString("TargetUnlock", "key", e_getKey.GetString(), "PatchSettings");
	if (e_getSubKey.GetString() == "CTRL" || e_getSubKey.GetString() == "ALT" || e_getSubKey.GetString() == "SHIFT" || e_getSubKey.GetString() == "")
	{
		SetINIString("TargetUnlock", "key_mod1", e_getSubKey.GetString(), "PatchSettings");
	}
	else
	{
		MessageBox("CTRL/ALT/SHIFT is required!");
		e_getSubKey.SetString("");
	}
}

function OnApplyBtn()
{
	local int valueX, valueY;
	if (e_getYMySkillCast.GetString() != "")
	{
		valueY = int(e_getYMySkillCast.GetString());
		if (valueY >= 0 && valueY <= userY)
		{
			h_MySkillCast.SetAnchor("", "TopCenter", "TopCenter", 0, valueY);
			SetINIInt("WindowsPositions", "MySkillCastPosY", valueY, "PatchSettings");
		}
			
	}
	
	if (e_getXECast.GetString() != "" && e_getYECast.GetString() != "")
	{
		valueX = int(e_getXECast.GetString());
		valueY = int(e_getYECast.GetString());
		if (valueX >= -userX/2 && valueX <= userX/2 && valueY >= 0 && valueY <= userY)
		{
			h_ECast.SetAnchor("", "TopCenter", "TopCenter", valueX, valueY);
			SetINIInt("WindowsPositions", "EnemySkillCastPosX", valueX, "PatchSettings");
			SetINIInt("WindowsPositions", "EnemySkillCastPosY", valueY, "PatchSettings");
		}	
	}
}

function OnShow()
{
	InitMain();
	InitOly();
	InitField();
}

function OnHide()
{
	//h_Option.ShowWindow();
}

function OnClickShowHide(CheckBoxHandle handle, string wndname)
{
	if (handle.IsChecked())
	{
		class'UIAPI_WINDOW'.static.ShowWindow(wndname);
		SetINIBool("WindowsCheks", wndname, true, "PatchSettings");
	}
		
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow(wndname);
		SetINIBool("WindowsCheks", wndname, false, "PatchSettings");
	}
		
}

function OnEnchantBtn()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow("AutoItemEnchant"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("AutoItemEnchant");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("AutoItemEnchant");
		class'UIAPI_WINDOW'.static.SetFocus("AutoItemEnchant");
	}
}

function OnAttBtn()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow("AutoAtt"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("AutoAtt");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("AutoAtt");
		class'UIAPI_WINDOW'.static.SetFocus("AutoAtt");
	}
}

function OnPotsBtn()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow("AutoPotions"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("AutoPotions");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("AutoPotions");
		class'UIAPI_WINDOW'.static.SetFocus("AutoPotions");
	}
}

function OnRadarBtn()
{
	if (class'UIAPI_WINDOW'.static.IsShowWindow("WarMemberWarning"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("WarMemberWarning");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("WarMemberWarning");
		class'UIAPI_WINDOW'.static.SetFocus("WarMemberWarning");
	}
}

function OnClickCheck(CheckBoxHandle handle, string wndname)
{
	if (handle.IsChecked())
	{
		SetINIBool("WindowsCheks", wndname, true, "PatchSettings");
	}	
	else
	{
		SetINIBool("WindowsCheks", wndname, false, "PatchSettings");
	}
		
}
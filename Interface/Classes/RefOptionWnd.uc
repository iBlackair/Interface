class RefOptionWnd extends UICommonAPI;

var WindowHandle Me;

var CheckBoxHandle h_aPVPM;
var CheckBoxHandle h_pPVPM;
var CheckBoxHandle h_aRefl;
var CheckBoxHandle h_pRefl;
var CheckBoxHandle h_aWM;
var CheckBoxHandle h_pWM;
var CheckBoxHandle h_Cel;
var CheckBoxHandle h_Heal;
var CheckBoxHandle h_Refr;
var CheckBoxHandle h_SpellRefr;
var CheckBoxHandle h_SkillRefr;
var CheckBoxHandle h_INT;
var CheckBoxHandle h_CON;
var CheckBoxHandle h_STR;
var CheckBoxHandle h_aHealEmp;
var CheckBoxHandle h_pHealEmp;
var CheckBoxHandle h_aProm;
var CheckBoxHandle h_aHydr;
var CheckBoxHandle h_aTemp;
var CheckBoxHandle h_aStone;
var CheckBoxHandle h_aSF;
var CheckBoxHandle h_aSolar;
var CheckBoxHandle h_aAura;
var CheckBoxHandle h_aCombo;
var CheckBoxHandle h_statCrit;
var CheckBoxHandle h_statHP;
var CheckBoxHandle h_aVampR;
var CheckBoxHandle hCParal;
var CheckBoxHandle aEmp;
var CheckBoxHandle pEmp;
var CheckBoxHandle pPDef;
var CheckBoxHandle pFocus;
var CheckBoxHandle aEva;
var CheckBoxHandle pEva;
var CheckBoxHandle aCP;
var CheckBoxHandle aParal;
var CheckBoxHandle aMedusa;
var CheckBoxHandle aFear;

var ButtonHandle b_Start, b_Stop;

var RefineryWnd RefWndScript;

//var TextBoxHandle h_Tut;
var TextBoxHandle h_SliderText;

var bool isAutoBegin;

var int Stats[6];
var int Skills[32];

var int countChecks, GAugSpeed;

function OnLoad()
{
	Me = GetWindowHandle("RefOptionWnd");
	
	h_aPVPM = GetCheckBoxHandle("RefOptionWnd.mainScroll.aPVPMightCheck");
	h_pPVPM = GetCheckBoxHandle("RefOptionWnd.mainScroll.pPVPMightCheck");
	h_aRefl = GetCheckBoxHandle("RefOptionWnd.mainScroll.aReflectCheck");
	h_pRefl = GetCheckBoxHandle("RefOptionWnd.mainScroll.pReflectCheck");
	h_aWM = GetCheckBoxHandle("RefOptionWnd.mainScroll.aWMCheck");
	h_pWM = GetCheckBoxHandle("RefOptionWnd.mainScroll.pWMCheck");
	h_Cel = GetCheckBoxHandle("RefOptionWnd.mainScroll.aCelestialCheck");
	h_Heal = GetCheckBoxHandle("RefOptionWnd.mainScroll.aHealCheck");
	h_Refr = GetCheckBoxHandle("RefOptionWnd.mainScroll.aRefreshCheck");
	h_SpellRefr = GetCheckBoxHandle("RefOptionWnd.mainScroll.aSpellRefreshCheck");
	h_SkillRefr = GetCheckBoxHandle("RefOptionWnd.mainScroll.aSkillRefreshCheck");
	h_INT = GetCheckBoxHandle("RefOptionWnd.mainScroll.INTCheck");
	h_CON = GetCheckBoxHandle("RefOptionWnd.mainScroll.CONCheck");
	h_STR = GetCheckBoxHandle("RefOptionWnd.mainScroll.STRCheck");
	h_aHealEmp = GetCheckBoxHandle("RefOptionWnd.mainScroll.aHealEmpCheck");
	h_pHealEmp = GetCheckBoxHandle("RefOptionWnd.mainScroll.pHealEmpCheck");
	h_aProm = GetCheckBoxHandle("RefOptionWnd.mainScroll.aPromCheck");
	h_aHydr = GetCheckBoxHandle("RefOptionWnd.mainScroll.aHydroCheck");
	h_aTemp = GetCheckBoxHandle("RefOptionWnd.mainScroll.aTempCheck");
	h_aStone = GetCheckBoxHandle("RefOptionWnd.mainScroll.aStoneCheck");
	h_aSF = GetCheckBoxHandle("RefOptionWnd.mainScroll.aSFCheck");
	h_aSolar = GetCheckBoxHandle("RefOptionWnd.mainScroll.aSolarCheck");
	h_aAura = GetCheckBoxHandle("RefOptionWnd.mainScroll.aAuraCheck");
	h_aCombo = GetCheckBoxHandle("RefOptionWnd.aComboCheck");
	h_statCrit = GetCheckBoxHandle("RefOptionWnd.mainScroll.statCritical");
	h_statHP = GetCheckBoxHandle("RefOptionWnd.mainScroll.statHP");
	h_aVampR = GetCheckBoxHandle("RefOptionWnd.mainScroll.aVampRCheck");
	hCParal = GetCheckBoxHandle("RefOptionWnd.mainScroll.cParal");
	aEmp = GetCheckBoxHandle("RefOptionWnd.mainScroll.aEmp");
	pEmp = GetCheckBoxHandle("RefOptionWnd.mainScroll.pEmp");
	pPDef = GetCheckBoxHandle("RefOptionWnd.mainScroll.pPDef");
	pFocus = GetCheckBoxHandle("RefOptionWnd.mainScroll.pFocus");
	aEva = GetCheckBoxHandle("RefOptionWnd.mainScroll.aEva");
	pEva = GetCheckBoxHandle("RefOptionWnd.mainScroll.pEva");
	aCP = GetCheckBoxHandle("RefOptionWnd.mainScroll.aCP");
	aParal = GetCheckBoxHandle("RefOptionWnd.mainScroll.aParal");
	aMedusa = GetCheckBoxHandle("RefOptionWnd.mainScroll.aMedusa");
	aFear = GetCheckBoxHandle("RefOptionWnd.mainScroll.aFear");
	
	h_SliderText = GetTextBoxHandle("RefOptionWnd.speedCtrlText");
	
	//h_Tut = GetTextBoxHandle("RefOptionWnd.Tutorial");
	
	b_Start = GetButtonHandle("RefOptionWnd.btnStartAutoRef");
	b_Stop = GetButtonHandle("RefOptionWnd.btnStopAutoRef");
	
	RefWndScript = RefineryWnd(GetScript("RefineryWnd"));
	
	SetTitles();
	
	Me.KillTimer(1488);
	
	b_Stop.HideWindow();
	
	countChecks = 0;
	GAugSpeed = 1000;
	
	h_SliderText.SetText( string( GAugSpeed ) );
}

function SetTitles()
{
	h_aPVPM.SetTitle("(A) PvP Might");
	h_pPVPM.SetTitle("(P) PvP Might");
	h_aRefl.SetTitle("(A) Reflect");
	h_pRefl.SetTitle("(P) Reflect");
	h_aWM.SetTitle("(A) Wild Magic");
	h_pWM.SetTitle("(P) Wild Magic");
	h_Cel.SetTitle("(A) Celestial");
	h_Heal.SetTitle("(A) Heal");
	h_Refr.SetTitle("(A) Refresh");
	h_SpellRefr.SetTitle("(A) Spell Refresh");
	h_SkillRefr.SetTitle("(A) Skill Refresh");
	h_INT.SetTitle("INT +1");
	h_CON.SetTitle("CON +1");
	h_STR.SetTitle("STR +1");
	h_aHealEmp.SetTitle("(A) Heal Empower");
	h_pHealEmp.SetTitle("(P) Heal Empower");
	h_aProm.SetTitle("(A) Prominence");
	h_aHydr.SetTitle("(A) Hydro Blast");
	h_aTemp.SetTitle("(A) Tempest");
	h_aStone.SetTitle("(A) Stone");
	h_aSF.SetTitle("(A) Shadow Flare");
	h_aSolar.SetTitle("(A) Solar Flare");
	h_aAura.SetTitle("(A) Aura Flare");
	h_statCrit.SetTitle("Critical 30");
	h_statHP.SetTitle("HP 185");
	h_aVampR.SetTitle("(A) Vampiric Rage");
	hCParal.SetTitle("(C) Paralyze");
	aEmp.SetTitle("(A) Empower");
	pEmp.SetTitle("(P) Empower");
	pPDef.SetTitle("(P) P.Def");
	pFocus.SetTitle("(P) Focus");
	aEva.SetTitle("(A) Evasion");
	pEva.SetTitle("(P) Evasion");
	aCP.SetTitle("(A) Ritual");
	aParal.SetTitle("(A) Paralyze");
	aMedusa.SetTitle("(A) Medusa");
	aFear.SetTitle("(A) Fear");
}


function OnShow()
{
	local int i;
	
	for (i = 0; i < 32; i++)
		if (Skills[i] != 0)
			switch (i)
			{
				case 0:
				h_aPVPM.SetCheck(true);
				break;
				case 1:
				h_pPVPM.SetCheck(true);
				break;
				case 2:
				h_aRefl.SetCheck(true);
				break;
				case 3:
				h_pRefl.SetCheck(true);
				break;
				case 4:
				h_aWM.SetCheck(true);
				break;
				case 5:
				h_pWM.SetCheck(true);
				break;
				case 6:
				h_Cel.SetCheck(true);
				break;
				case 7:
				h_Heal.SetCheck(true);
				break;
				case 8:
				h_Refr.SetCheck(true);
				break;
				case 9:
				h_SpellRefr.SetCheck(true);
				break;
				case 10:
				h_SkillRefr.SetCheck(true);
				break;
				case 11:
				h_aHealEmp.SetCheck(true);
				break;
				case 12:
				h_pHealEmp.SetCheck(true);
				break;
				case 13:
				h_aProm.SetCheck(true);
				break;
				case 14:
				h_aHydr.SetCheck(true);
				break;
				case 15:
				h_aTemp.SetCheck(true);
				break;
				case 16:
				h_aStone.SetCheck(true);
				break;
				case 17:
				h_aSF.SetCheck(true);
				break;
				case 18:
				h_aSolar.SetCheck(true);
				break;
				case 19:
				h_aAura.SetCheck(true);
				break;
				case 20:
				h_aVampR.SetCheck(true);
				break;
				case 21:
				hCParal.SetCheck(true);
				break;
				case 22:
				aEmp.SetCheck(true);
				break;
				case 23:
				pEmp.SetCheck(true);
				break;
				case 24:
				pPDef.SetCheck(true);
				break;
				case 25:
				pFocus.SetCheck(true);
				break;
				case 26:
				aEva.SetCheck(true);
				break;
				case 27:
				pEva.SetCheck(true);
				break;
				case 28:
				aCP.SetCheck(true);
				break;
				case 29:
				aParal.SetCheck(true);
				break;
				case 30:
				aMedusa.SetCheck(true);
				break;
				case 31:
				aFear.SetCheck(true);
				break;
			}
		
		
	for (i = 0; i < 6; i++)
		if (Stats[i] != 0)
			switch (i)
			{
				case 0:
				h_INT.SetCheck(true);
				break;
				case 1:
				h_CON.SetCheck(true);
				break;
				case 2:
				h_STR.SetCheck(true);
				break;
				case 3:
				case 5:
				h_statCrit.SetCheck(true);
				break;
				case 4:
				h_statHP.SetCheck(true);
				break;
			}
			
	//h_Tut.HideWindow();
	
}

function OnClickButton( string strID )
{
	switch (strID)
	{
		case "btnStartAutoRef":
		OnClickStartButton();
		break;
		case "btnStopAutoRef":
		OnClickStopButton();
		break;
	}
}

function int GetSpeedFromSliderTick(int iTick)
{
	local int ReturnSpeed;
	switch(iTick)
	{
	case 0 :
		ReturnSpeed = 250;
		break;
	case 1 :
		ReturnSpeed = 500;
		break;
	case 2 :
		ReturnSpeed = 750;
		break;
	case 3 :
		ReturnSpeed = 1000;
		break;
	case 4 :
		ReturnSpeed = 1500;
		break;
	case 5 :
		ReturnSpeed = 2000;
		break;
	}

	return ReturnSpeed;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local int Speed;
	Speed = GetSpeedFromSliderTick(iCurrentTick);
	switch(strID)
	{
	case "speedCtrl" :
		GAugSpeed = Speed;
		h_SliderText.SetText( string( GAugSpeed ) );
		break;
	}
}

function OnClickCheckBox( String strID )
{
	switch (strID)
	{
		case "aComboCheck":
		OnComboCheck();
		break;
		case "INTCheck":
		if (h_aCombo.IsChecked())
			OnCheck(h_INT);
		break;
		case "CONCheck":
		if (h_aCombo.IsChecked())
			OnCheck(h_CON);
		break;
		case "STRCheck":
		if (h_aCombo.IsChecked())
			OnCheck(h_STR);
		break;
		case "statCritical":
		if (h_aCombo.IsChecked())
			OnCheck(h_statCrit);
		break;
		case "statHP":
		if (h_aCombo.IsChecked())
			OnCheck(h_statHP);
		break;
	}
}

function OnCheck(CheckBoxHandle aHandle)
{
	if (aHandle.IsChecked())
	{
		countChecks++;
		if (countChecks < 0)
			countChecks = 0;
		
		if (countChecks == 1)
		{
			h_pPVPM.EnableWindow();
			h_pRefl.EnableWindow();
			h_pWM.EnableWindow();
			h_Heal.EnableWindow();
			h_pHealEmp.EnableWindow();
			h_aProm.EnableWindow();
			h_aHydr.EnableWindow();
			h_aTemp.EnableWindow();
			h_aStone.EnableWindow();
			h_aSF.EnableWindow();
			h_aSolar.EnableWindow();
			h_aAura.EnableWindow();
			hCParal.EnableWindow();
			aEmp.EnableWindow();
			pEmp.EnableWindow();
			pPDef.EnableWindow();
			pFocus.EnableWindow();
			aEva.EnableWindow();
			pEva.EnableWindow();
			aCP.EnableWindow();
			aParal.EnableWindow();
			aMedusa.EnableWindow();
			aFear.EnableWindow();
			
			h_aCombo.DisableWindow();
			
			//h_Tut.SetText("Choose 2nd option");
		}
	}
	else
	{
		countChecks--;
		if (countChecks < 0)
			countChecks = 0;
		
		if (countChecks == 0)
		{
			h_pPVPM.DisableWindow();
			h_pRefl.DisableWindow();
			h_pWM.DisableWindow();
			h_Heal.DisableWindow();
			h_pHealEmp.DisableWindow();
			h_aProm.DisableWindow();
			h_aHydr.DisableWindow();
			h_aTemp.DisableWindow();
			h_aStone.DisableWindow();
			h_aSF.DisableWindow();
			h_aSolar.DisableWindow();
			h_aAura.DisableWindow();
			hCParal.DisableWindow();
			aEmp.DisableWindow();
			pEmp.DisableWindow();
			pPDef.DisableWindow();
			pFocus.DisableWindow();
			aEva.DisableWindow();
			pEva.DisableWindow();
			aCP.DisableWindow();
			aParal.DisableWindow();
			aMedusa.DisableWindow();
			aFear.DisableWindow();
			
			h_aCombo.EnableWindow();
			
			//h_Tut.SetText("Choose 1st option");
		}
	}

}

function OnComboCheck()
{
	if (h_aPVPM.IsEnableWindow() && h_aRefl.IsEnableWindow() && h_aWM.IsEnableWindow() && h_Cel.IsEnableWindow() && h_Refr.IsEnableWindow() && h_SpellRefr.IsEnableWindow() && h_SkillRefr.IsEnableWindow() && h_aHealEmp.IsEnableWindow() )
	{
		h_aPVPM.DisableWindow();
		h_pPVPM.DisableWindow();
		h_aRefl.DisableWindow();
		h_pRefl.DisableWindow();
		h_aWM.DisableWindow();
		h_pWM.DisableWindow();
		h_Cel.DisableWindow();
		h_Heal.DisableWindow();
		h_Refr.DisableWindow();
		h_SpellRefr.DisableWindow();
		h_SkillRefr.DisableWindow();
		h_aHealEmp.DisableWindow();
		h_pHealEmp.DisableWindow();
		h_aProm.DisableWindow();
		h_aHydr.DisableWindow();
		h_aTemp.DisableWindow();
		h_aStone.DisableWindow();
		h_aSF.DisableWindow();
		h_aSolar.DisableWindow();
		h_aAura.DisableWindow();
		h_aVampR.DisableWindow();
		hCParal.DisableWindow();
		aEmp.DisableWindow();
		pEmp.DisableWindow();
		pPDef.DisableWindow();
		pFocus.DisableWindow();
		aEva.DisableWindow();
		pEva.DisableWindow();
		aCP.DisableWindow();
		aParal.DisableWindow();
		aMedusa.DisableWindow();
		aFear.DisableWindow();
		//h_Tut.SetText("Choose 1st option");
		//h_Tut.ShowWindow();
	}
	else
	{
		h_aPVPM.EnableWindow();
		h_pPVPM.EnableWindow();
		h_aRefl.EnableWindow();
		h_pRefl.EnableWindow();
		h_aWM.EnableWindow();
		h_pWM.EnableWindow();
		h_Cel.EnableWindow();
		h_Heal.EnableWindow();
		h_Refr.EnableWindow();
		h_SpellRefr.EnableWindow();
		h_SkillRefr.EnableWindow();
		h_aHealEmp.EnableWindow();
		h_pHealEmp.EnableWindow();
		h_aProm.EnableWindow();
		h_aHydr.EnableWindow();
		h_aTemp.EnableWindow();
		h_aStone.EnableWindow();
		h_aSF.EnableWindow();
		h_aSolar.EnableWindow();
		h_aAura.EnableWindow();
		h_aVampR.EnableWindow();
		hCParal.EnableWindow();
		aEmp.EnableWindow();
		pEmp.EnableWindow();
		pPDef.EnableWindow();
		pFocus.EnableWindow();
		aEva.EnableWindow();
		pEva.EnableWindow();
		aCP.EnableWindow();
		aParal.EnableWindow();
		aMedusa.EnableWindow();
		aFear.EnableWindow();
		//h_Tut.HideWindow();
	}
	
	countChecks = 0;
	
	if (h_INT.IsChecked() || h_CON.IsChecked() || h_STR.IsChecked() || h_statCrit.IsChecked() || h_statHP.IsChecked())
	{
		h_INT.SetCheck(false);
		h_CON.SetCheck(false);
		h_STR.SetCheck(false);
		h_statCrit.SetCheck(false);
		h_statHP.SetCheck(false);
	}
	
}

function OnClickStopButton()
{
	local int i;
	
	isAutoBegin = false;
	Me.KillTimer(1488);
	b_Stop.HideWindow();
	b_Start.ShowWindow();
	
	for (i = 0; i < 32; i++)
		if (Skills[i] != 0)
			switch (i)
			{
				case 0:
				h_aPVPM.SetCheck(true);
				break;
				case 1:
				h_pPVPM.SetCheck(true);
				break;
				case 2:
				h_aRefl.SetCheck(true);
				break;
				case 3:
				h_pRefl.SetCheck(true);
				break;
				case 4:
				h_aWM.SetCheck(true);
				break;
				case 5:
				h_pWM.SetCheck(true);
				break;
				case 6:
				h_Cel.SetCheck(true);
				break;
				case 7:
				h_Heal.SetCheck(true);
				break;
				case 8:
				h_Refr.SetCheck(true);
				break;
				case 9:
				h_SpellRefr.SetCheck(true);
				break;
				case 10:
				h_SkillRefr.SetCheck(true);
				break;
				case 11:
				h_aHealEmp.SetCheck(true);
				break;
				case 12:
				h_pHealEmp.SetCheck(true);
				break;
				case 13:
				h_aProm.SetCheck(true);
				break;
				case 14:
				h_aHydr.SetCheck(true);
				break;
				case 15:
				h_aTemp.SetCheck(true);
				break;
				case 16:
				h_aStone.SetCheck(true);
				break;
				case 17:
				h_aSF.SetCheck(true);
				break;
				case 18:
				h_aSolar.SetCheck(true);
				break;
				case 19:
				h_aAura.SetCheck(true);
				break;
				case 20:
				h_aVampR.SetCheck(true);
				break;
				case 21:
				hCParal.SetCheck(true);
				break;
				case 22:
				aEmp.SetCheck(true);
				break;
				case 23:
				pEmp.SetCheck(true);
				break;
				case 24:
				pPDef.SetCheck(true);
				break;
				case 25:
				pFocus.SetCheck(true);
				break;
				case 26:
				aEva.SetCheck(true);
				break;
				case 27:
				pEva.SetCheck(true);
				break;
				case 28:
				aCP.SetCheck(true);
				break;
				case 29:
				aParal.SetCheck(true);
				break;
				case 30:
				aMedusa.SetCheck(true);
				break;
				case 31:
				aFear.SetCheck(true);
				break;
			}
		
		
	for (i = 0; i < 6; i++)
		if (Stats[i] != 0)
			switch (i)
			{
				case 0:
				h_INT.SetCheck(true);
				break;
				case 1:
				h_CON.SetCheck(true);
				break;
				case 2:
				h_STR.SetCheck(true);
				break;
				case 4:
				h_statHP.SetCheck(true);
				break;
				case 3:
				case 5:
				h_statCrit.SetCheck(true);
				break;
			}
}

function SetSkillOption(CheckBoxHandle handle, int idx, int option)
{
	if (handle.IsChecked())
		Skills[idx] = option;
	else
		Skills[idx] = 0;
}

function SetStatOption(CheckBoxHandle handle, int idx, int option)
{
	if (handle.IsChecked())
		Stats[idx] = option;
	else
		Stats[idx] = 0;
}

//Skills[0] = 24569;
//1. 24679	Chance: Inflicts paralysis on the target who attac\\nks you by a fixed rate.
function OnClickStartButton()
{
	local int i,counterSkills,counterStats;
	
	
	SetStatOption(h_statHP, 4, 23340);//23340 - maxhp 185.89
	SetStatOption(h_statCrit, 5, 23350);//23350 - crit 30.8
	SetStatOption(h_statCrit, 3, 23714);//23714 - crit 30.8

	SetSkillOption(h_aStone, 16, 24542);
	SetSkillOption(h_aProm, 13, 24544);
	SetSkillOption(h_aSolar, 18, 24550);
	SetSkillOption(h_aHealEmp, 11, 24551);
	SetSkillOption(h_Heal, 7, 24553);
	SetSkillOption(h_aAura, 19, 24563);
	SetSkillOption(h_aPVPM, 0, 24569);
	SetSkillOption(h_aSF, 17, 24591);
	SetSkillOption(h_aHydr, 14, 24594);
	SetSkillOption(h_aTemp, 15, 24595);
	SetSkillOption(h_pHealEmp, 12, 24637);
	SetSkillOption(h_pPVPM, 1, 24643);
	SetSkillOption(h_Refr, 8, 24645);
	SetSkillOption(h_aRefl, 2, 24648);
	SetSkillOption(h_Cel, 6, 24651);
	SetSkillOption(h_aWM, 4, 24652);
	SetSkillOption(h_SkillRefr, 10, 24655);
	SetSkillOption(h_SpellRefr, 9, 24659);
	SetSkillOption(h_aVampR, 20, 24662);
	SetSkillOption(hCParal, 21, 24679);
	SetSkillOption(h_pRefl, 3, 24692);
	SetSkillOption(h_pWM, 5, 24694);
	
	SetSkillOption(aEmp, 22, 24554);
	SetSkillOption(pEmp, 23, 24639);
	SetSkillOption(pPDef, 24, 24642);
	SetSkillOption(pFocus, 25, 24691);
	SetSkillOption(aEva, 26, 24539);
	SetSkillOption(pEva, 27, 24690);
	SetSkillOption(aCP, 28, 24541);
	SetSkillOption(aParal, 29, 24565);
	SetSkillOption(aMedusa, 30, 24590);
	SetSkillOption(aFear, 31, 24543);
	
	SetStatOption(h_STR, 2, 24699);
	SetStatOption(h_CON, 1, 24700);
	SetStatOption(h_INT, 0, 24701);
	
	for (i = 0; i < 32; i++)
		if (Skills[i] != 0)
			counterSkills++;
		
	for (i = 0; i < 6; i++)
		if (Stats[i] != 0)
			counterStats++;
						
	if (counterSkills == 0 && counterStats == 0)
	{
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose augment(s)!" );
		return;
	}
	
	if (h_aCombo.IsChecked())
		if (counterStats != 0 && counterSkills == 0)
		{
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose skills to combine!" );
			return;
		}
		
	
	if (RefWndScript.m_hAugmentInfoTextBox.GetText() == "")
	{
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Enchant item once!" );
		return;
	}
		
	
	isAutoBegin = true;
	RefWndScript.OnClickRepeatButton();
	Me.KillTimer(1488);
	b_Start.HideWindow();
	Me.SetTimer(1488, GAugSpeed);
	b_Stop.ShowWindow();
	//AddSystemMessageString("START");
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case 1488:
		Me.KillTimer(1488);	
		if (isAutoBegin)
		{
			RefWndScript.OnClickRepeatButton();
			Me.SetTimer(1488, GAugSpeed);
		}
		break;
		default:
		break;
	}
}

defaultproperties
{
}

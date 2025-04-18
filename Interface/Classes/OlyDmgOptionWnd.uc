class OlyDmgOptionWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle h_Target;
//var CheckBoxHandle buff,debuff,dist,speed;
var CheckBoxHandle dist, speed, cspeed;
//var EditBoxHandle e1,e2,e3,e4;

var ButtonHandle b_Lock;

var TextBoxHandle t_targetName;

var OlympiadDmgWnd script_odmg;

var bool b_gotLock;
var int retargetCount;

var int targetID;

var Color noneColor;
var Color gotColor;

function OnRegisterEvent()
{
	RegisterEvent(EV_TargetUpdate);
	RegisterEvent(EV_OlympiadTargetShow);
    RegisterEvent(EV_OlympiadMatchEnd);
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_TargetUpdate:
			if (b_gotLock)
				ReturnTarget(targetID);
		break;
		case EV_OlympiadTargetShow:
			dist.EnableWindow();
			speed.EnableWindow();
			cspeed.EnableWindow();
		break;
		case EV_OlympiadMatchEnd:
			dist.DisableWindow();
			speed.DisableWindow();
			cspeed.DisableWindow();
		break;
	}
}

function ReturnTarget(int idx)
{
	local UserInfo tInfo;
	
	if ( !GetTargetInfo(tInfo) && retargetCount < 1 )
	{
		RequestTargetUser(idx);
		retargetCount += 1;
		Me.KillTimer(3456);
		Me.SetTimer(3456, 350);
	}
	
}

function OnTimer(int TimerID)
{
	local UserInfo tInfo;
	
	if (TimerID == 3456)
	{
		Me.KillTimer(3456);
		if (GetTargetInfo(tInfo) && tInfo.nID != targetID)
			RequestTargetUser(targetID);
		retargetCount = 0;
	}
}

function OnLoad() {
	
    local int value;
	
	Me = GetWindowHandle("OlyDmgOptionWnd");
	h_Target = GetWindowHandle("TargetStatusWnd");
	
	t_targetName = GetTextBoxHandle("OlyDmgOptionWnd.targetName");
	b_Lock = GetButtonHandle("OlyDmgOptionWnd.btnLockTarget");
	//buff = GetCheckBoxHandle("OlyDmgOptionWnd.buffOn");
	//debuff = GetCheckBoxHandle("OlyDmgOptionWnd.debuffOn");
	dist = GetCheckBoxHandle("OlyDmgOptionWnd.DistOn");
	speed = GetCheckBoxHandle("OlyDmgOptionWnd.SpeedOn");
	cspeed = GetCheckBoxHandle("OlyDmgOptionWnd.cSpeedOn");
	//e1 = GetEditBoxHandle("OlyDmgOptionWnd.debuff1");
	//e2 = GetEditBoxHandle("OlyDmgOptionWnd.debuff2");
	//e3 = GetEditBoxHandle("OlyDmgOptionWnd.debuff3");
	//e4 = GetEditBoxHandle("OlyDmgOptionWnd.debuff4");
	
	//buff.SetCheck(true);
	//debuff.SetCheck(true);
	//dist.SetCheck(true);
	//speed.SetCheck(true);
	//debuff.SetCheck( GetOptionBool( "Oly Debuff Control", "ShowDebuff") );
	//debuff.DisableWindow();
	//e1.DisableWindow();
	//e2.DisableWindow();
	//e3.DisableWindow();
	//e4.DisableWindow();
	GetINIBool("OlyDmgWindow", "Distance", value, "PatchSettings");
	if (value == 1)
		dist.SetCheck( true );
	else
		dist.SetCheck( false );
	GetINIBool("OlyDmgWindow", "Speed", value, "PatchSettings");
	if (value == 1)
		speed.SetCheck( true );
	else
		speed.SetCheck( false );
	GetINIBool("OlyDmgWindow", "CastSpeed", value, "PatchSettings");
	if (value == 1)
		cspeed.SetCheck( true );
	else
		cspeed.SetCheck( false );
	
	//e1.SetString( GetOptionString( "Oly Debuff Control", "dTime1") );
	//e2.SetString( GetOptionString( "Oly Debuff Control", "dTime2") );
	//e3.SetString( GetOptionString( "Oly Debuff Control", "dTime3") );
	//e4.SetString( GetOptionString( "Oly Debuff Control", "dTime4") );
	
	script_odmg = OlympiadDmgWnd ( GetScript ("OlympiadDmgWnd") );
	
	//script_odmg.DistanceBox.HideWindow();
	//script_odmg.MoveSpeedBox.HideWindow();
	//script_odmg.CastSpeedBox.HideWindow();
	
	noneColor.R = 230; noneColor.G = 77; noneColor.B = 77;
	gotColor.R = 102; gotColor.G = 153; gotColor.B = 102;
	
	dist.DisableWindow();
	speed.DisableWindow();
	cspeed.DisableWindow();
	
	b_gotLock = false;
	t_targetName.SetText("None");
	t_targetName.SetTextColor(noneColor);
	targetID = 0;
	retargetCount = 0;
	b_Lock.SetNameText( "Lock" );
}

function OnClickCheckBox( String strID )
{
	switch (strID)
	{
		case "DistOn":
		if (dist.IsChecked())
		{
			script_odmg.DistanceBox.ShowWindow();
			SetINIBool("OlyDmgWindow", "Distance", true, "PatchSettings");
		}
		else
		{
			script_odmg.DistanceBox.HideWindow();
			SetINIBool("OlyDmgWindow", "Distance", false, "PatchSettings");
		}
		break;
		case "SpeedOn":
		if (speed.IsChecked())
		{
			script_odmg.MoveSpeedBox.ShowWindow();
			SetINIBool("OlyDmgWindow", "Speed", true, "PatchSettings");
		}
		else
		{
			script_odmg.MoveSpeedBox.HideWindow();
			SetINIBool("OlyDmgWindow", "Speed", false, "PatchSettings");
		}
		break;
		case "cSpeedOn":
		if (cspeed.IsChecked())
		{
			script_odmg.CastSpeedBox.ShowWindow();
			SetINIBool("OlyDmgWindow", "CastSpeed", true, "PatchSettings");
		}
		else
		{
			script_odmg.CastSpeedBox.HideWindow();
			SetINIBool("OlyDmgWindow", "CastSpeed", false, "PatchSettings");
		}
		break;

	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnLockTarget":
			OnLockTarget();
		break;
	}
}

function OnLockTarget()
{
	if (!b_gotLock)
	{
		OnLock();
	}	
	else
	{
		targetID = 0;
		b_gotLock = false;
		t_targetName.SetText("None");
		t_targetName.SetTextColor(noneColor);
		b_Lock.SetNameText( "Lock" );
	}
}

function bool isPlayer(UserInfo info)
{
	if ( info.nID > 0 && !info.bNpc && !info.bPet )
		return true;
	return false;
}

function OnLock()
{
	local UserInfo targetInfo;
	local UserInfo pInfo;
	
	GetPlayerInfo(pInfo);
	
	b_Lock.SetNameText( "Unlock" );
	
	b_gotLock = false;
	
	if (h_Target.IsShowWindow() && GetTargetInfo(targetInfo))
	{
		if (isPlayer(targetInfo) && targetInfo.nID != pInfo.nID)
		{
			targetID = targetInfo.nID;
			b_gotLock = true;
			t_targetName.SetText(targetInfo.Name);
			t_targetName.SetTextColor(gotColor);
		}
		else
		{
			b_Lock.SetNameText( "Lock" );
			MessageBox("Not a player!");
		}
	}
	else
	{
		b_Lock.SetNameText( "Lock" );
		MessageBox("Get target!");
	}
}

defaultproperties
{
}

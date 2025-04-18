class LSTimerWnd extends UICommonAPI;

const TIMER_4_LS1 = 20050;
const TIMER_4_LS2 = 20051;
const TIMER_4_LS3 = 20052;
const TIMER_4_LS4 = 20053;

var WindowHandle lstimerWndHandle;
var ItemWindowHandle skill[4];
var TextBoxHandle t1s, t2s, t3s, t4s;
var int LS1, LS2, LS3, LS4;

var MagicSkillWnd script_ms;

function OnRegisterEvent() {
	RegisterEvent(EV_ReceiveMagicSkillUse);
    RegisterEvent(EV_SkillListStart);
    RegisterEvent(EV_SkillList);
}

function OnLoad() {
    InitHandle();
    OnRegisterEvent();
	script_ms = MagicSkillWnd (GetScript("MagicSkillWnd"));
	t1s.SetText("0");
	t2s.SetText("0");
	t3s.SetText("0");
	t4s.SetText("0");
	
	skill[0].Clear();
    skill[1].Clear();
    skill[2].Clear();
    skill[3].Clear();
	
	t1s.HideWindow();
	t2s.HideWindow();
	t3s.HideWindow();
	t4s.HideWindow();
	
	lstimerWndHandle.KillTimer(TIMER_4_LS1);
	lstimerWndHandle.KillTimer(TIMER_4_LS2);
	lstimerWndHandle.KillTimer(TIMER_4_LS3);
	lstimerWndHandle.KillTimer(TIMER_4_LS4);
	
	lstimerWndHandle.HideWindow();
	
}

function OnEnterState( name a_PreStateName )
{
	if ( (a_PreStateName == 'LoadingState') || (a_PreStateName == 'OLYMPIADOBSERVERSTATE') )
	{
		skill[0].Clear();
		skill[1].Clear();
		skill[2].Clear();
		skill[3].Clear();
		script_ms.LScount = 0;//need 0 for > 1 skills
		//lstimerWndHandle.ShowWindow();
	}
	
	//AddSystemMessageString(string(a_PreStateName));		
	
}

function InitHandle() {
    lstimerWndHandle = GetWindowHandle("LSTimerWnd");
    skill[0] = GetItemWindowHandle("LSTimerWnd.S_Skill1");
    skill[1] = GetItemWindowHandle("LSTimerWnd.S_Skill2");
    skill[2] = GetItemWindowHandle("LSTimerWnd.S_Skill3");
    skill[3] = GetItemWindowHandle("LSTimerWnd.S_Skill4");
	t1s = GetTextBoxHandle("LSTimerWnd.timerS1");
	t2s = GetTextBoxHandle("LSTimerWnd.timerS2");
	t3s = GetTextBoxHandle("LSTimerWnd.timerS3");
	t4s = GetTextBoxHandle("LSTimerWnd.timerS4");
}

function OnEvent(int Event_ID, String param) {
    if (Event_ID == EV_ReceiveMagicSkillUse)
        HandleReceiveMagicSkillUse (param);
	//else if (Event_ID == EV_SkillListStart)
        //HandleSkillListStart();
    //else if (Event_ID == EV_SkillList)
        //HandleSkillList(param);
 
}

function HandleReceiveMagicSkillUse (string a_Param)
{
	  local int AttackerID;
	  //local int DefenderID;
	  local int SkillID;
	  local int SkillLevel;
	  local float SkillHitTime;
	  local UserInfo PlayerInfo;
	  local UserInfo AttackerInfo;
	  //local UserInfo DefenderInfo;
	  //local UserInfo TargetInfo;
	  local SkillInfo UsedSkillInfo;
	  local int SkillHitTime_ms;

	  ParseInt(a_Param,"AttackerID",AttackerID);
	  //ParseInt(a_Param,"DefenderID",DefenderID);
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
	  //GetUserInfo(DefenderID,DefenderInfo);
	  GetPlayerInfo(PlayerInfo);
	  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
	  
	  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID == AttackerID) )
	  {
			if (SkillID == 3192) //Item Skill: Paralyze
			{
				//AddSystemMessageString("HEAL START");
				LS1 = 29;
				lstimerWndHandle.SetTimer(TIMER_4_LS1, 1000);
				//t1s.SetText(string(LS1));
				t1s.SetText("30");
				t1s.ShowWindow();
			}
			else if (SkillID == 3123) //Item Skill: Heal
			{
				//AddSystemMessageString("PARAL START");
				LS2 = 29;
				lstimerWndHandle.SetTimer(TIMER_4_LS2, 1000);
				//t2s.SetText(string(LS2));
				t2s.SetText("30");
				t2s.ShowWindow();
			}
			else if (SkillID == 3194) //Item Skill: Fear
			{
				//AddSystemMessageString("FEAR START");
				LS3 = 29;
				lstimerWndHandle.SetTimer(TIMER_4_LS3, 1000);
				//t3s.SetText(string(LS3));
				t3s.SetText("30");
				t3s.ShowWindow();
			}
			else if (SkillID == 3193) //Item Skill: Medusa
			{
				//AddSystemMessageString("MEDUSA START");
				LS4 = 29;
				lstimerWndHandle.SetTimer(TIMER_4_LS4, 1000);
				//t4s.SetText(string(LS4));
				t4s.SetText("30");
				t4s.ShowWindow();
			}
	  }
}

function OnTimer(int TimerID)
{ 
	
	if (TimerID == TIMER_4_LS1 && LS1 >= 0)
	{
		
		t1s.SetText(string(LS1));
		LS1 -= 1;
		if (LS1 < 0)
		{
			lstimerWndHandle.KillTimer(TIMER_4_LS1);
			t1s.HideWindow();
		}	
	} 
	
	if (TimerID == TIMER_4_LS2 && LS2 >= 0)
	{
		t2s.SetText(string(LS2));
		LS2 -= 1;
		if (LS2 < 0)
		{
			lstimerWndHandle.KillTimer(TIMER_4_LS2);
			t2s.HideWindow();
		}	
	}
	
	if (TimerID == TIMER_4_LS3 && LS3 >= 0)
	{
		t3s.SetText(string(LS3));
		LS3 -= 1;
		if (LS3 < 0)
		{
			lstimerWndHandle.KillTimer(TIMER_4_LS3);
			t3s.HideWindow();
		}	
	}
	
	if (TimerID == TIMER_4_LS4 && LS4 >= 0)
	{
		t4s.SetText(string(LS4));
		LS4 -= 1;
		if (LS4 < 0)
		{
			lstimerWndHandle.KillTimer(TIMER_4_LS4);
			t4s.HideWindow();
		}	
	}
}

defaultproperties
{
}

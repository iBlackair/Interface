class CleftCounter extends UIScriptEx;

const TIMER_ID=1023;
const TIMER_DELAY=1000;
const TeamA_ID = 0;
const TeamB_ID = 1;

var WindowHandle Me;
var TextboxHandle TeamACount;
var TextboxHandle TeamBCount;
//~ var TextboxHandle CountADetail;
//~ var TextboxHandle CountBDetail;

//Ÿ�̸� ���ڸ� �����ϴ� ��
var TextboxHandle TimerCount; //�ð� ǥ��â
//var TextboxHandle RemainSec;
var TextboxHandle TimerCountTitle; //�ð� ǥ��â ����
//var TextboxHandle RemainSecTitle;
var TextboxHandle CountCenter;
//var TextboxHandle CountCen;

var int Min;
var int Sec;
var string MinStr;
var string SecStr;

function OnRegisterEvent()
{
	registerEvent( EV_CleftStateTeam );
	registerEvent( EV_CleftStatePlayer );
	registerEvent( EV_CleftStateResult );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
	
	//LaunchTimer();
	Me.HideWindow();
}

function Initialize()
{
	Me = GetHandle("CleftCounter");
	
	TeamACount = TextboxHandle(GetHandle("TeamACount"));
	TeamBCount = TextboxHandle(GetHandle("TeamBCount"));
	TimerCount = TextboxHandle(GetHandle("TimerCount"));
	TimerCountTitle = TextboxHandle(GetHandle("TimerCountTitle"));
	CountCenter = TextboxHandle(GetHandle("CountCenter"));
	//RemainSec = TextboxHandle(GetHandle("CleftCurWnd.RemainSec"));
	//RemainSecTitle = TextboxHandle(GetHandle("CleftCurWnd.RemainSecTitle"));
	//CountCen = TextboxHandle(GetHandle("CleftCurWnd.CountCen"));
}

function InitializeCOD()
{
	Me = GetWindowHandle("CleftCounter");
	
	TeamACount = GetTextboxHandle("CleftCounter.TeamACount");
	TeamBCount = GetTextboxHandle("CleftCounter.TeamBCount");
	TimerCount = GetTextboxHandle("CleftCounter.TimerCount");
	TimerCountTitle = GetTextboxHandle("CleftCounter.TimerCountTitle");
	CountCenter = GetTextboxHandle("CleftCounter.CountCenter");
	//RemainSec = GetTextboxHandle("CleftCurWnd.RemainSec");
	//RemainSecTitle = GetTextboxHandle("CleftCurWnd.RemainSecTitle");
	//CountCen = GetTextboxHandle("CleftCurWnd.CountCen");
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_CleftStateTeam:
		HandleCleftStateTeam(a_Param);
		break;
	case EV_CleftStatePlayer:
		HandleCleftStatePlayer(a_Param);
		break;
	case EV_CleftStateResult:
		HandleHide();
		break;
	}
}

function OnHide()
{
	Me.KillTimer( TIMER_ID );
}


function OnShow()
{

	Me.SetTimer(TIMER_ID,TIMER_DELAY);
	//~ CountADetail.SetTextColor( A );
	//~ CountBDetail.SetTextColor( B );
}

function HandleCleftStateTeam(string Param)
{
	local int TeamID;
	local int TeamPoint;
	local int RemainSec;
		
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "TeamPoint", TeamPoint);
	ParseInt(Param, "RemainSec", RemainSec);
	
	TimerReset(RemainSec);
	DrawTimerCount();
		
	if (TeamID == TeamA_ID)
	{
		TeamACount.SetText(String(TeamPoint));
	}
	else if (TeamID ==TeamB_ID)
	{
		TeamBCount.SetText(String(TeamPoint));
	}
}

function HandleCleftStatePlayer(string Param)
{
	local int RemainSec;
	ParseInt(Param, "RemainSec", RemainSec);
	
	TimerReset(RemainSec);
	DrawTimerCount();
}

function OnClickButton( string Name )
{
	//debug ("Button Clicked1");
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		//~ debug ("Ÿ�̸� �۵���");
		
		if (Min == 1 && sec == 0)
		{
			AddSystemMessage(2420);
		}
		
		if (Min == 0 && sec == 10)
		{
			AddSystemMessage(2421);
		}
		
		if (Min == 0 && Sec < 9)
		{
			//~ debug ("Ÿ�̸� �۵���1");
			TimerCount.HideWindow();
			//RemainSec.HideWindow();
			TimerCountTitle.HideWindow();
			//RemainSecTitle.HideWindow();
			//CountCenter.HideWindow();
			//CountCen.HideWindow();
			//Me.KillTimer( TIMER_ID );
			//DrawTimerCount();
			UpdateTimerCount();
		}
		else
		{
			//~ debug ("Ÿ�̸� �۵���2");
			TimerCount.ShowWindow();
			//RemainSec.ShowWindow();
			TimerCountTitle.ShowWindow();
			//RemainSecTitle.ShowWindow();
			//CountCenter.ShowWindow();
			//CountCen.ShowWindow();
			DrawTimerCount();
			UpdateTimerCount();
			//~ Me.SetTimer(TIMER_ID,TIMER_DELAY);
		}
	}
}

function DrawTimerCount()
{
		MinStr = String(Min);
		SecStr = String(Sec);
		
		if (Min < 10)
			MinStr = "0" $ MinStr;
		
		if (Sec < 10)
			SecStr = "0" $ SecStr;
		
		TimerCount.SetText(MinStr $ ":" $ SecStr);
		
		//~ debug (MakeFullSystemMsg(GetSystemMessage(2278), MinStr , SecStr));
		
	
		//~ debug ("�����ѹ�"  @ Min @ Sec);
}


function UpdateTimerCount()
{


		
		//~ debug (MakeFullSystemMsg(GetSystemMessage(2278), MinStr , SecStr));
		
		if (Sec == 0)
		{
			Sec = 59;
			Min = Min -1;
		} 
		else 
		{
			Sec = Sec -1;
		}
		//~ debug ("�����ѹ�"  @ Min @ Sec);
}



function TimerReset(int RemainTime)
{
	
	Min = RemainTime / 60;
	Sec = RemainTime % 60; 

	//~ TimerCountDetail.SetText(MinStr $ ":" $ SecStr);
}




function ResetCurrentStat()
{
	TeamACount.SetText("0");
	TeamBCount.SetText("0");
	//~ CountADetail.SetText("0");
	//~ CountBDetail.SetText("0");
}
function HandleHide()
{
	me.hidewindow();
}

defaultproperties
{
}

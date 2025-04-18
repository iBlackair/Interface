
class CleftCurWnd extends UIScriptEx;

const TeamA_ID =0;
const TeamB_ID =1;

var WindowHandle Me;
var TextboxHandle CountA;
var TextboxHandle CountB;
var TextboxHandle TeamATitle;
var TextboxHandle TeamBTitle;
//��Ƽ�� �̸��� �����ϴ� ��
var TextboxHandle CATATitle;
var TextboxHandle CATBTitle;
var TextboxHandle CATA;
var TextboxHandle CATB;
var TextboxHandle TeamATotalTitle;
var TextboxHandle TeamBTotalTitle;
var TextboxHandle TeamATotal;
var TextboxHandle TeamBTotal;


var ListCtrlHandle TeamAList;
var ListCtrlHandle TeamBList;

var ButtonHandle btnClose;
var ButtonHandle btnExit;

var TextureHandle ResultA;
var TextureHandle ResultB;
var TextureHandle ResultBWin;
var TextureHandle TeamAListGroupBox;
var TextureHandle TeamBListGroupBox;
//var TextureHandle TeamAListDeco
//var TextureHandle TeamBListDeco
var TextboxHandle RemainSecTitle;
var TextboxHandle RemainSec;

var int TotalCountA;
var int TotalCountB;
var WindowHandle CleftCurTriggerWnd;
var WindowHandle CleftCounter;
var int CurCATAID;
var int CurCATBID;

function OnRegisterEvent()
{
	registerEvent( EV_CleftListStart );
	registerEvent( EV_CleftStateTeam );
	registerEvent( EV_CleftStatePlayer );
	registerEvent( EV_CleftStateResult );
	registerEvent( EV_CleftListAdd );
	registerEvent( EV_CleftListRemove );
}
function OnLoad()
{
	InitializeCOD();

	Me.HideWindow();

	ResetUI();
}

function InitializeCOD()
{
	Me = GetWindowHandle("CleftCurWnd");
	CountA=GetTextboxHandle("CleftCurWnd.CountA");
	CountB=GetTextboxHandle("CleftCurWnd.CountB");
	TeamATitle=GetTextboxHandle("CleftCurWnd.TeamATitle");
	TeamBTitle=GetTextboxHandle("CleftCurWnd.TeamBTitle");
	CATATitle=GetTextboxHandle("CleftCurWnd.CATATitle");
	CATBTitle=GetTextboxHandle("CleftCurWnd.CATBTitle");
	CATA=GetTextboxHandle("CleftCurWnd.CATA");
	CATB=GetTextboxHandle("CleftCurWnd.CATB");
	TeamATotalTitle=GetTextboxHandle("CleftCurWnd.TeamATotalTitle");
	TeamBTotalTitle=GetTextboxHandle("CleftCurWnd.TeamBTotalTitle");
	TeamATotal=GetTextboxHandle("CleftCurWnd.TeamATotal");
	TeamBTotal=GetTextboxHandle("CleftCurWnd.TeamBTotal");
	RemainSecTitle=GetTextboxHandle("CleftCurWnd.RemainSecTitle");
	RemainSec=GetTextboxHandle("CleftCurWnd.RemainSec1");
	
	TeamAList=GetListCtrlHandle ("CleftCurWnd.TeamAList");
	TeamBList=GetListCtrlHandle ("CleftCurWnd.TeamBList");
	
	btnClose=GetButtonHandle ("CleftCurWnd.btnClose");
	btnExit=GetButtonHandle ("CleftCurWnd.btnExit");
	
	ResultA=GetTextureHandle("CleftCurWnd.ResultA");
	ResultB=GetTextureHandle("CleftCurWnd.ResultB");
	ResultBWin =GetTextureHandle("CleftCurWnd.ResultBWin");
	TeamAListGroupBox=GetTextureHandle("CleftCurWnd.TeamAListGroupBox");
	TeamBListGroupBox=GetTextureHandle("CleftCurWnd.TeamBListGroupBox");
	CleftCurTriggerWnd = GetWindowHandle("CleftCurTriggerWnd");
	CleftCounter = GetWindowHandle("CleftCounter");
	//~ PKListADECO=TextureHandle(GetHandle("PKListADECO"));
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_CleftListStart :
		HandleCleftListStart();
		break;
	
	case EV_CleftStateTeam:
		HandleCleftStateTeam(a_Param);
		break;
	
	case EV_CleftStatePlayer:
		HandleCleftStatePlayer(a_Param);
		break;
	
	case EV_CleftStateResult:
		HandleCleftStateResult(a_Param);
		break;
	
	case EV_CleftListAdd :
		HandleCleftListAdd(a_Param);
		break;
	
	case EV_CleftListRemove :
		//debug ("EV_CleftListRemove" @ Param);
		HandleCleftListRemove(a_Param);
		break;
	}
}


function HandleCleftListStart( )
{
	ResetUI();
}

function HandleCleftStateTeam(string Param)
{
	//~ local int temp;
	local int TeamID;
	local int TeamPoint;
	local int CATID;
	local String CATNAME;
	local int RemainSec;
	
	local String ParamString;
	local string Message;
	
	CleftCurTriggerWnd.showwindow();
	CleftCounter.showwindow();
		
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "TeamPoint", TeamPoint ) ;
	ParseInt(Param, "CATID", CATID );
	ParseString(Param, "CATNAME", CATNAME );
	ParseInt(Param, "RemainSec", RemainSec);
		
	if (TeamID == TeamA_ID)
	{
		if (CATID != CurCATAID && CATID > 0)
		{
			ParamAdd(ParamString, "Type", string(int(ESystemMsgParamType.SMPT_STRING)));
			ParamAdd(ParamString, "param1", CATNAME);
			AddSystemMessageParam(ParamString);
			Message = EndSystemMessageParam(2755, true);
			AddSystemMessageString( Message );
		}
		
		CurCATAID = CATID;
		CATA.SetText(CATNAME);
		CountA.SetText(String(TeamPoint));
	}
	if (TeamID ==TeamB_ID)
	{
		if (CATID != CurCATBID && CATID > 0)
		{
			ParamAdd(ParamString, "Type", string(int(ESystemMsgParamType.SMPT_STRING)));
			ParamAdd(ParamString, "param1", CATNAME);
			AddSystemMessageParam(ParamString);
			Message = EndSystemMessageParam(2755, true);
			AddSystemMessageString( Message );
		}
		
		CurCATBID = CATID;
		CATB.SetText(CATNAME);
		CountB.SetText(String(TeamPoint));
	}
}

function HandleCleftStatePlayer(string Param)
{
	local int TeamID;
	local int PlayerID;
	local int KillCount;
	local int DeathCount;
	local int CleftTowerCount;
	local int TowerType;
	local int RemainSec;
	//local UserInfo UserA; 
	//local UserInfo UserB;
	

	local int count;
	
	local string PlayerName;
	
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	CleftCurTriggerWnd.showwindow();
	CleftCounter.showwindow();
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);
	ParseInt(Param, "KillCount", KillCount);
	ParseInt(Param, "DeathCount", DeathCount);
	ParseInt(Param, "CleftTowerCount", CleftTowerCount );
	ParseInt(Param, "TowerType", TowerType);
	ParseInt(Param, "RemainSec", RemainSec);
	
	
	if (TeamID == TeamA_ID)
	{
		PlayerName = class'UIDATA_USER'.static.GetUserName(PlayerID);
		
		for(count = 0 ; count < TeamAList.GetRecordCount(); count++)
		{
			TeamAList.GetRec(count, Record1);
			if(PlayerID == Record1.LVDataList[0].nReserved2)
			{	
				Record1.LVDataList[1].szData = String(CleftTowerCount);
				Record1.LVDataList[2].szData = String(KillCount);
				Record1.LVDataList[3].szData = String(DeathCount);
				TeamAList.ModifyRecord(count, Record1);
				break;
			}
		}
	}
	else if (TeamID == TeamB_ID)
	{
		PlayerName = class'UIDATA_USER'.static.GetUserName(PlayerID);
				
		for(count = 0 ; count < TeamBList.GetRecordCount(); count++)
		{
			TeamBList.GetRec(count, Record2);
			if(PlayerID == Record2.LVDataList[0].nReserved2)
			{	
				Record2.LVDataList[1].szData = String(CleftTowerCount);
				Record2.LVDataList[2].szData = String(KillCount);
				Record2.LVDataList[3].szData = String(DeathCount);
				TeamBList.ModifyRecord(count, Record2);
				break;
			}
		}
	}
}
function HandleCleftStateResult(string Param)
{
	local int WinTeamId;
	//local int MyTeamWin;
	
	ParseInt(Param, "WinTeamId", WinTeamId);
	//ParseInt(Param, "MyTeamWin", MyTeamWin);
	
	
	CleftCurTriggerWnd.hidewindow();
	CleftCounter.hidewindow();
	if(!me.isShowWindow())
	{
		me.ShowWindow();
	}
	
	AddSystemMessage(2425);
	if (WinTeamId == TeamA_ID)
	{
		//�ؽ��� �۾� ���� �� ��� ����
		ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		ResultB.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		ResultA.ShowWindow();
		ResultB.ShowWindow();
		AddSystemMessage(2428);
	}
	
	else if (WinTeamId == TeamB_ID)
	{
		//�ؽ��� �۾� ���� ����  ��� ��
		ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		ResultBWin.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		ResultA.ShowWindow();
		ResultBWin.ShowWindow();
		AddSystemMessage(2427);
	}
}


function HandleCleftListAdd(string Param)
{
	local int TeamID;
	local int PlayerID;
	local string PlayerName;
	
	local int index ;
	
	local LVData Data1;
	local LVData Data2;
	local LVData Data3;
	local LVData Data4;
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);
	ParseString(Param, "PlayerName", PlayerName);

	
	if (TeamID == TeamA_ID)
	{	
		 

		
		//debug ("ProcData" @ PlayerName @ PlayerID @ TeamID);
		
		Index = TeamAList.GetRecordCount();
		
		Data1.nReserved1 = TeamID;
		Data1.nReserved2 = PlayerID;
		Data1.nReserved3 = Index;
		Data1.szData = PlayerName;
		Data2.szData = "0";
		Data3.szData = "0";
		Data4.szData = "0";
		Record1.LVDataList.length = 4;
		Record1.LVDataList[0] = Data1;
		Record1.LVDataList[1] = Data2;
		Record1.LVDataList[2] = Data3;
		Record1.LVDataList[3] = Data4;
		TeamAList.InsertRecord(Record1);
		TeamATotal.SetText(string(TeamAList.GetRecordCount()));
		
		
	}
	else if (TeamID ==TeamB_ID)
	{

		//debug ("ProcData1" @ PlayerName @ PlayerID @ TeamID);
		
		Index = TeamBList.GetRecordCount();
		
		Data1.nReserved1 = TeamID;
		Data1.nReserved2 = PlayerID;
		Data1.nReserved3 = Index;
		Data1.szData = PlayerName;
		Data2.szData = "0";
		Data3.szData = "0";
		Data4.szData = "0";
		Record1.LVDataList.length = 4;
		Record2.LVDataList[0] = Data1;
		Record2.LVDataList[1] = Data2;
		Record2.LVDataList[2] = Data3;
		Record2.LVDataList[3] = Data4;
		TeamBList.InsertRecord( Record2 );
		TeamBTotal.SetText(string(TeamBList.GetRecordCount()));
	}
}

function HandleCleftListRemove(string Param)
{
	local int TeamID;
	local int PlayerID;	
	local int count ;
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);
	
	//debug ("Me Hide Window" @ TeamID @ PlayerID );

	
	if (TeamID == TeamA_ID)
	{
		for(count = 0 ; count < TeamAList.GetRecordCount(); count++)
		{
			TeamAList.GetRec(count, Record1);
			if(PlayerID == Record1.LVDataList[0].nReserved2)
			{	
				if ( count >= 0)
				{
					TeamAList.DeleteRecord(count);
					TeamATotal.SetText(string(TeamAList.GetRecordCount()));
				}
			}
		}
	}
	
	if (TeamID == TeamB_ID)
	{
		for(count = 0 ; count < TeamBList.GetRecordCount(); count++)
		{
			TeamBList.GetRec(count, record2);
			if(PlayerID == Record2.LVDataList[0].nReserved2)
			{
				if ( count >= 0)
				{
					TeamBList.DeleteRecord(count);
					TeamBTotal.SetText(string(TeamBList.GetRecordCount()));
				}
			}
		}
	}
}


function OnClickButton( string Name )
{
	//debug ("Button Clicked1");
	switch( Name )
	{
		case "btnClose": 
			Me.HideWindow();
			break;
		case "btnExit":
			class'TeamMatchAPI'.static.RequestExCleftEnter(-1);
			CleftCurTriggerWnd.hidewindow();
			CleftCounter.hidewindow();
			Me.HideWindow();
			break;
	}
}


function ResetUI()
{
	TeamAList.DeleteAllItem();
	TeamBList.DeleteAllItem();
	ResultA.HideWindow();
	ResultB.HideWindow();
	ResultBWin.HideWindow();

}

//�������  - cleftliststart ���� ���̵� �������ִٰ� ��������(ó���Ϸ�)
//               - ������ ��ư�̳� x��ư ������ �� requestcleftalldata ȣ�� onhide �˻� �ؼ� x��ư ó��1


//����â - addó�� state�ö� ������ ���ش�(ó���Ϸ�)
// default �� hide �̴� ������ Ŭ���ÿ� ����â �ߴ°ɷ�(ó���Ϸ�)
// ���۵Ǽ� ������Ʈ��  �Ѱ��� ������� ������ ������ Ȱ��ȭ(ó���Ϸ�)
//�ݱ⸦ ������ ���̵尡 �̴ϸ����� ��Ų��
//result�̺�Ʈ �߻��ϰ� �ݱ⸦ ������ ���̵带 �Ѵ�
//��� �� �ʱ�ȭ ó������� �Ѵ�
defaultproperties
{
}

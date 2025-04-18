class BlockCurWnd extends UIScriptEx;

const TeamRed_ID =1;
const TeamBlue_ID =0;

var WindowHandle Me;
var TextboxHandle TeamRedPoint;
var TextboxHandle TeamBluePoint;
var TextboxHandle TeamRed;
var TextboxHandle TeamBlue;
var TextboxHandle RemainSecTitle;
var TextboxHandle RemainSec;
var TextboxHandle TeamRedTotal;
var TextboxHandle TeamBlueTotal;
//��Ƽ�� �̸��� �����ϴ� ��


var ListCtrlHandle TeamRedList;
var ListCtrlHandle TeamBlueList;

var ButtonHandle btnClose;

var TextureHandle TeamRedResult;
var TextureHandle TeamBlueResult;
var TextureHandle TeamBlueWin;
var TextureHandle TeamRedListGroupBox;
var TextureHandle TeamBlueListGroupBox;
var TextureHandle CountGroupBox;
var TextureHandle TeamRedListDeco;
var TextureHandle TeamBlueListDeco;


var int TotalCountA;
var int TotalCountB;

var int RoomNumber;
var WindowHandle BlockCurTriggerWnd;
var WindowHandle BlockCounter;

function OnRegisterEvent()
{
	registerEvent( EV_BlockStateTeam );
	registerEvent( EV_BlockStatePlayer );
	registerEvent( EV_BlockStateResult );
	registerEvent( EV_BlockListStart );
	registerEvent( EV_BlockListAdd );
	registerEvent( EV_BlockListRemove );
	
}
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

	Me.HideWindow();
	RoomNumber = 0;
	ResetUI();
}

function OnShow()
{

	
}

//~ function OnShow()
//~ {
	//~ RequestPVPMatchRecord();
//~ }

function Initialize()
{
	Me = GetHandle("BlockCurWnd");
	TeamRedPoint=TextboxHandle(GetHandle("TeamRedPoint"));
	TeamBluePoint=TextboxHandle(GetHandle("TeamBluePoint"));
	TeamRed=TextboxHandle(GetHandle("TeamRed"));
	TeamBlue=TextboxHandle(GetHandle("TeamBlue"));
	RemainSecTitle=TextboxHandle(GetHandle("RemainSecTitle"));
	RemainSec=TextboxHandle(GetHandle("RemainSec"));
	
	TeamRedList=ListCtrlHandle (GetHandle("TeamRedList"));
	TeamBlueList=ListCtrlHandle (GetHandle("TeamBlueList"));
	
	btnClose=ButtonHandle (GetHandle("btnClose"));
	
	TeamRedResult=TextureHandle(GetHandle("TeamRedResult"));
	TeamBlueResult=TextureHandle(GetHandle("TeamBlueResult"));
	TeamBlueWin =TextureHandle(GetHandle("TeamBlueWin"));
	TeamRedListGroupBox=TextureHandle(GetHandle("TeamRedListGroupBox"));
	TeamBlueListGroupBox=TextureHandle(GetHandle("TeamBlueListGroupBox"));
	TeamRedListDeco=TextureHandle(GetHandle("TeamRedListDeco"));
	TeamBlueListDeco=TextureHandle(GetHandle("TeamBlueListDeco"));
	//PartyNameADesktop = TextboxHandle(GetHandle("PVPCounter.PartyNameA"));
	//PartyNameBDesktop = TextboxHandle(GetHandle("PVPCounter.PartyNameB"));
	BlockCurTriggerWnd = GetHandle("BlockCurTriggerWnd");
	BlockCounter = GetHandle("BlockCounter");
}

function InitializeCOD()
{
	Me = GetWindowHandle("BlockCurWnd.BlockCurWnd");
	TeamRedPoint=GetTextboxHandle("BlockCurWnd.TeamRedPoint");
	TeamBluePoint=GetTextboxHandle("BlockCurWnd.TeamBluePoint");
	TeamRed=GetTextboxHandle("BlockCurWnd.TeamRed");
	TeamBlue=GetTextboxHandle("BlockCurWnd.TeamBlue");
	RemainSecTitle=GetTextboxHandle("BlockCurWnd.RemainSecTitle");
	RemainSec=GetTextboxHandle("BlockCurWnd.RemainSec");
	
	TeamRedList=GetListCtrlHandle ("BlockCurWnd.TeamRedList");
	TeamBlueList=GetListCtrlHandle ("BlockCurWnd.TeamBlueList");
	
	btnClose=GetButtonHandle ("BlockCurWnd.btnClose");
	
	TeamRedResult=GetTextureHandle("BlockCurWnd.TeamRedResult");
	TeamBlueResult=GetTextureHandle("BlockCurWnd.TeamBlueResult");
	TeamBlueWin =GetTextureHandle("BlockCurWnd.TeamBlueWin");
	TeamRedListGroupBox=GetTextureHandle("BlockCurWnd.TeamRedListGroupBox");
	TeamBlueListGroupBox=GetTextureHandle("BlockCurWnd.TeamBlueListGroupBox");
	TeamRedListDeco=GetTextureHandle("BlockCurWnd.TeamRedListDeco");
	TeamBlueListDeco=GetTextureHandle("BlockCurWnd.TeamBlueListDeco");
	BlockCurTriggerWnd = GetWindowHandle("BlockCurTriggerWnd");
	BlockCounter = GetWindowHandle("BlockCounter");
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_BlockStateTeam:
		HandleBlockStateTeam(a_Param);
		break;
	
	case EV_BlockStatePlayer:
		HandleBlockStatePlayer(a_Param);
		break;
	
	case EV_BlockStateResult:
		HandleBlockStateResult(a_Param);
		break;
	
	case	EV_BlockListStart:
		HandleBlockListStart(a_Param);
		break;
		
	case	EV_BlockListAdd:
		HandleBlockListAdd(a_Param);
		break;
		
	case	EV_BlockListRemove:
		HandleBlockListRemove(a_Param);
		break;
	}
}

function HandleBlockListStart(string Param )
{
	
	ParseInt(Param, "RoomNumber", RoomNumber );

	ResetUI();

}

function HandleBlockStateTeam(string Param)
{
	
	
	local int TeamID;
	local int TeamScore;
	local int RemainSec;
	
	
	BlockCurTriggerWnd.showwindow();
	BlockCounter.showwindow();
		
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "TeamScore", TeamScore);
	ParseInt(Param, "RemainSec", RemainSec);
	//debug ("data" @ TeamID  @TeamScore @RemainSec);
		
	if (TeamID == TeamRed_ID)
	{

		TeamRedPoint.SetText(String(TeamScore));

	}
	if (TeamID ==TeamBlue_ID)
	{

		TeamBluePoint.SetText(String(TeamScore));
		

	}
	
	//RemainSec.SetText(String(RemainSec));
	

}


function HandleBlockStatePlayer(string Param)
{
	
	
	local int TeamID;
	local int PlayerID;
	local int PlayerScore;
	local int RemainSec;
	//local UserInfo UserA; 
	//local UserInfo UserB;
	
	//~ local int index;
	local int count;
	
	local string PlayerName;
	
	
	
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	
	BlockCurTriggerWnd.showwindow();
	BlockCounter.showwindow();
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);
	ParseInt(Param, "PlayerScore", PlayerScore);
	ParseInt(Param, "RemainSec", RemainSec);
	
	
	
	if (TeamID == TeamRed_ID)
	{
		PlayerName = class'UIDATA_USER'.static.GetUserName(PlayerID);

		for(count = 0 ; count < TeamRedList.GetRecordCount(); count++)
		{
			TeamRedList.GetRec(count, Record1);
			if(PlayerID == Record1.LVDataList[0].nReserved2)
			{	
				Record1.LVDataList[0].szData = PlayerName;
				Record1.LVDataList[1].szData = String(PlayerScore);
				TeamRedList.ModifyRecord(count, Record1);
				break;
			}
		}
	}
	
	else if (TeamID == TeamBlue_ID)
	{
		PlayerName = class'UIDATA_USER'.static.GetUserName(PlayerID);
		
		for(count = 0 ; count < TeamBlueList.GetRecordCount(); count++)
		{
			TeamBlueList.GetRec(count, Record2);
			if(PlayerID == Record2.LVDataList[0].nReserved2)
			{	
				Record2.LVDataList[0].szData = PlayerName;
				Record2.LVDataList[1].szData= String(PlayerScore);
				TeamBlueList.ModifyRecord(count, Record2);
				break;
			}
		}
		
	}
	
	
	
	
}
function HandleBlockStateResult(string Param)
{
	local int WinTeamId;
	
	BlockCurTriggerWnd.hidewindow();
	BlockCounter.hidewindow();
	
	ParseInt(Param, "WinTeamId", WinTeamId);
	
	if (WinTeamId == TeamRed_ID)
	{
		//�ؽ��� �۾� ���� �� ��� ����
		me.showwindow();
		TeamRedResult.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		TeamBlueResult.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		TeamRedResult.ShowWindow();
		TeamBlueResult.ShowWindow();
	}
	
	else if (WinTeamId == TeamBlue_ID)
	{
		//�ؽ��� �۾� ���� ����  ��� ��
		me.showwindow();
		TeamRedResult.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		TeamBlueResult.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		TeamRedResult.ShowWindow();
		TeamBlueWin.ShowWindow();
	}
}

function HandleBlockListAdd(string Param)
{
	local int TeamID;
	local int PlayerID;
	local string PlayerName;
	
	local int index ;
	
	local LVData Data1;
	local LVData Data2;
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);
	ParseString(Param, "PlayerName", PlayerName);
	
	if (TeamID == TeamRED_ID)
	{	
		 

		
		//debug ("ProcData" @ PlayerName @ PlayerID @ TeamID);
		
		Index = TeamRedList.GetRecordCount();
		
		Data1.nReserved1 = TeamID;
		Data1.nReserved2 = PlayerID;
		Data1.nReserved3 = Index;
		Data1.szData = PlayerName;
		Data2.szData = "0";
		Record1.LVDataList.length = 2;
		Record1.LVDataList[0] = Data1;
		Record1.LVDataList[1] = Data2;
		TeamRedList.InsertRecord(Record1);
		TeamRedTotal.SetText(string(TeamRedList.GetRecordCount()));
		
		
	}
	else if (TeamID ==TeamBlue_ID)
	{

		//debug ("ProcData1" @ PlayerName @ PlayerID @ TeamID);
		
		Index = TeamBlueList.GetRecordCount();
		
		Data1.nReserved1 = TeamID;
		Data1.nReserved2 = PlayerID;
		Data1.nReserved3 = Index;
		Data1.szData = PlayerName;
		Data2.szData = "0";
		Record1.LVDataList.length = 2;
		Record2.LVDataList[0] = Data1;
		Record2.LVDataList[1] = Data2;
		TeamBlueList.InsertRecord( Record2 );
		TeamBlueTotal.SetText(string(TeamBlueList.GetRecordCount()));
		
		

		
	}
	

}

function HandleBlockListRemove(string Param)
{
	local int TeamID;
	local int PlayerID;

	local int count;
	local LVDataRecord Record1;
	local LVDataRecord Record2;
	
	ParseInt(Param, "TeamID", TeamID );
	ParseInt(Param, "PlayerID", PlayerID);

	
	//debug ("Me Hide Window" @ TeamID @ PlayerID );
	
	if (TeamID == TeamRED_ID)
	{
		for(count = 0 ; count < TeamRedList.GetRecordCount(); count++)
		{
			TeamRedList.GetRec(count, Record1);
			if(PlayerID == Record1.LVDataList[0].nReserved2)
			{					
				if(count >= 0)
				{
					TeamRedList.DeleteRecord(count);
					TeamRedTotal.SetText(string(TeamRedList.GetRecordCount()));
				}
				//TeamRedTotal.SetText(string(TeamAList.GetRecordCount()));
				break;

			}
		}		
	}
	
	if (TeamID == TeamBlue_ID)
	{
		for(count = 0 ; count < TeamBlueList.GetRecordCount(); count++)
		{
			TeamBlueList.GetRec(count, Record2);
			if(PlayerID == Record2.LVDataList[0].nReserved2)
			{				
				if(count >= 0)
				{
					TeamBlueList.DeleteRecord(count);
					TeamBlueTotal.SetText(string(TeamBlueList.GetRecordCount()));
				}
				//TeamBlueTotal.SetText(string(TeamAList.GetRecordCount()));
				break;
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
	}
}


function ResetUI()
{
	
	TeamRedList.DeleteAllItem();
	TeamBlueList.DeleteAllItem();
	TeamRedResult.HideWindow();
	TeamBlueResult.HideWindow();
	TeamBlueWin.HideWindow();

}
defaultproperties
{
}

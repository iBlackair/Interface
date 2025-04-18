class MacroListWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;
const TIMER_ID = 9001;
const TIMER2_ID = 9002;

var WindowHandle Me;

var AnimTextureHandle texAutoUse;

var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;

var bool cycleON;
var int cmdCount;
var int LineCount;
var ItemID CycleID;
var string cmds[12];

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	
	RegisterEvent(EV_MacroShowListWnd);
	RegisterEvent(EV_MacroUpdate);
	RegisterEvent(EV_MacroList);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_bShow = false;
	cycleON = false;
	ClearItemID(m_DeleteItemID);
	ClearItemID(CycleID);
	
	cmdCount = 0;
	LineCount = 0;
	
	Me = GetWindowHandle( "MacroListWnd" );
	
	texAutoUse = GetAnimTextureHandle( "MacroListWnd.texAutoUse" );
	texAutoUse.Stop();
	texAutoUse.HideWindow();
}

function OnEnterState( name a_PreStateName )
{
	class'MacroAPI'.static.RequestMacroList();
}

function OnShow()
{
	m_bShow = true;
}
	
function OnHide()
{
	m_bShow = false;
}

function OnClickButton( string strID )
{	 
	local String fullNameString;
	local int ID;
	switch( strID )
	{
		case "btnHelp":	
		//OnClickHelp();
		break;
	case "btnAdd":
		OnClickAdd();
		break;
	}
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_MacroShowListWnd)
	{
		HandleMacroShowListWnd();
	}
	else if (Event_ID == EV_MacroUpdate)
	{
		HandleMacroUpdate();
	}
	else if (Event_ID == EV_MacroList)
	{
		HandleMacroList(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			if (IsValidItemID(m_DeleteItemID))
			{
				class'MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
				//debug("what?");
				ClearItemID(m_DeleteItemID);
				if(m_Max == 1)	//하나남은 것을 지울 경우 0이 되므로 한번 갱신해준다. 
				{
					HandleMacroList("");// 창을 한번 갱신해준다. //0일경우에만 갱신해주면 됨.
				}
			}
			
		}
	}
}

//매크로의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "MacroItem" && index>-1)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", index, infItem))
		{
			class'MacroAPI'.static.RequestUseMacro(infItem.ID);
		}
			
	}
}

function OnRClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if ( !cycleON )
	{
		if (strID == "MacroItem" && index>-1)
		{
			if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", index, infItem))
			{
				CycleID = infItem.ID;
				MacroCycle( CycleID );
				cycleON = true;
				
				texAutoUse.SetAnchor( "MacroListWnd.MacroItem", "TopLeft", "TopLeft", 36 * ( index % 6 ) + 1, 36 * ( ( index - ( index % 6 ) ) / 6 ) + 1 );

				texAutoUse.Stop();
				texAutoUse.HideWindow();
				texAutoUse.SetLoopCount( -1 );
				texAutoUse.Play();
				texAutoUse.ShowWindow();
				//sysDebug( "START CYCLING" );
			}
		}
	}
	else
	{
		//sysDebug( "STOP CYCLING" );
		ClearItemID(CycleID);
		cmdCount = 0;
		Me.KillTimer( TIMER_ID );
		Me.KillTimer( TIMER2_ID );
		cycleON = false;
		texAutoUse.Stop();
		texAutoUse.HideWindow();
	}
	
	
}

function MacroCycle( ItemID cID )
{
	local MacroInfo macroInf;
	local int idx;
	local int TimerDelay;
	local int MacroDelay;
	local string command;
	
	class'UIDATA_MACRO'.static.GetMacroInfo(cID, macroInf);

	LineCount = 0;
	MacroDelay = 0;

	for ( idx = 0; idx < 12; idx++ )
	{
		command = macroInf.CommandList[idx];
		cmds[idx] = command;

		if ( command != "" )
		{
			LineCount += 1;
		}
		
		if ( InStr( command, "/delay" ) > -1 )
		{
			MacroDelay += int( Mid ( command, 7 ) ) * 1000;
		}
	}
	
	//sysDebug( "LineCount: " $ string( LineCount ) );
	//sysDebug( "MacroDelay: " $ string( MacroDelay ) );

	TimerDelay = (250 * LineCount + MacroDelay);
	//sysDebug( "Timer Delay: " $ string( TimerDelay ) );

	ExecuteMacroLine( 0, LineCount );
	Me.KillTimer( TIMER_ID );
	Me.SetTimer( TIMER_ID, TimerDelay + 250 );
}

function ExecuteMacroLine(int idx, int count)
{
	local int ExtraTime;
	
	ExtraTime = 0;
	
	Me.KillTimer( TIMER2_ID );
	if ( InStr( cmds[idx], "/delay" ) > -1 )
	{
		ExtraTime  = int( Mid ( cmds[idx], 7 ) ) * 1000;
		//sysDebug( "EXTRA TIME" $ string( ExtraTime ));
	}
	else
	{
		ExecuteCommand( cmds[idx] );
	}

	cmdCount += 1;
	Me.SetTimer( TIMER2_ID, 250 + ExtraTime );
	if (cmdCount > count)
	{
		cmdCount = 0;
		Me.KillTimer( TIMER2_ID );
	}
	
}

function OnTimer( int TimerID )
{
	if ( TimerID == TIMER_ID )
	{
		Me.KillTimer( TIMER_ID );
		//sysDebug( "NEW CYCLE");
		MacroCycle( CycleID );
	} else if ( TimerID == TIMER2_ID )
	{
		//sysDebug( "NEW LINE");
		ExecuteMacroLine( cmdCount, LineCount );
	}
}

//도움말
function OnClickHelp()
{
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help_macro.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

//추가
function OnClickAdd()
{
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", "");
	ExecuteEvent(EV_MacroShowEditWnd, "");
}

function HandleMacroUpdate()
{
	class'MacroAPI'.static.RequestMacroList();
}

function HandleMacroShowListWnd()
{
	if (m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroListWnd");
	}
	else
	{
		
		PlayConsoleSound(IFST_WINDOW_OPEN);	
		class'UIAPI_WINDOW'.static.ShowWindow("MacroListWnd");
		class'UIAPI_WINDOW'.static.SetFocus("MacroListWnd");
	}
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
}

function HandleMacroList(string param)
{
	local int Idx;
	local int Max;
	
	local string strIconName;
	local string strMacroName;
	local string strDescription;
	local string strTexture;
	local string strTmp;
	
	local ItemInfo	infItem;
		//debug ("파람:"@ param);
	//초기화
	Clear();
	
	ParseInt(param, "Max", Max);
	m_Max = Max;	//글로벌 맥스를 설정 -_-;;
	for (Idx=0; Idx<Max; Idx++)
	{
		strIconName = "";
		strMacroName = "";
		strDescription = "";
		strTexture = "";
		
		ParseItemIDWithIndex(param, infItem.ID, idx);
		ParseString(param, "IconName_" $ Idx, strIconName);
		ParseString(param, "MacroName_" $ Idx, strMacroName);
		ParseString(param, "Description_" $ Idx, strDescription);
		ParseString(param, "TextureName_" $ Idx, strTexture);

		infItem.Name = strMacroName;
		infItem.AdditionalName = strIconName;
		infItem.IconName = strTexture;
		infItem.Description = strDescription;
		infItem.ItemSubType = int(EShortCutItemType.SCIT_MACRO);
		
		//MacroItem에 추가
		class'UIAPI_ITEMWINDOW'.static.AddItem("MacroListWnd.MacroItem", infItem);
	}
	
	//매크로 갯수표시
	if (Max<10)
	{
		strTmp = strTmp $ "0";
	}
	strTmp = strTmp $ Max;
	strTmp = "(" $ strTmp $ "/" $ MACRO_MAX_COUNT $ ")";
	class'UIAPI_TEXTBOX'.static.SetText("MacroListWnd.txtCount", strTmp);
}

//Trash아이콘으로의 DropITem
function OnDropItem( string strID, ItemInfo infItem, int x, int y)
{
	switch( strID )
	{
	case "btnTrash":
		DeleteMacro(infItem);
		break;
	case "btnEdit":
		EditMacro(infItem);
		break;
	}
}

//매크로 삭제
function DeleteMacro(ItemInfo infItem)
{
	local string strMsg;
	
	//매크로가 아니면 패스
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))		
		return;			
	
	strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
	m_DeleteItemID = infItem.ID;
	DialogShow(DIALOG_Modalless,DIALOG_Warning, strMsg);
}

//매크로 편집
function EditMacro(ItemInfo infItem)
{
	local string param;
	
	//매크로가 아니면 패스
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))
		return;
	
	ParamAddItemID(param, infItem.ID);
	ExecuteEvent(EV_MacroShowEditWnd, param);
}
defaultproperties
{
}

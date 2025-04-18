class MinimapWnd_Expand extends UICommonAPI;

const N_MAX_MINI_MAP_RES_X = 1024;
const N_MAX_MINI_MAP_RES_Y = 1024;
const N_BUTTON_HEAD_AREA_BUFFER = 90;

var int m_PartyMemberCount;
var int m_PartyLocIndex;
var bool m_AdjustCursedLoc;

var int m_SSQStatus;				// ������λ��°����� �ִ� ����
var bool m_bShowSSQType;			// ������� ���� �����ٰ��ΰ��� ����ϴ� ����
var bool m_bShowCurrentLocation;	// ������ġ �����ٰ��ΰ��� ����ϴ� ����
var bool m_bShowGameTime;			// ����ð� �����ٰ��ΰ��� ����ϴ� ����

var int m_ContinentOffset;


var Array<ResolutionInfo> ResolutionList;

var WindowHandle m_hMinimapWnd;
var MinimapCtrlHandle MiniMapCtrLarge;
//~ var TextureHandle TexMapStrokeGrow;
var TextureHandle TexMapStroke;
var TabHandle 	m_MapSelectTab;
var WindowHandle 	MiniMapDrawerWnd;
var MinimapWnd		m_MiniMapWndScript;

function OnRegisterEvent()
{
	RegisterEvent( EV_PartyMemberChanged );
	RegisterEvent( EV_MinimapAddTarget );
	RegisterEvent( EV_MinimapDeleteTarget );
	RegisterEvent( EV_MinimapDeleteAllTarget );
	RegisterEvent( EV_MinimapShowQuest );
	RegisterEvent( EV_MinimapHideQuest );
	RegisterEvent( EV_MinimapChangeZone );
	RegisterEvent( EV_MinimapCursedWeaponList );
	RegisterEvent( EV_MinimapCursedWeaponLocation );
	RegisterEvent( EV_ResolutionChanged );
	RegisterEvent( EV_BeginShowZoneTitleWnd );		// ZoneName �� �ٲ�� ������ġ ������Ʈ �ؾ��ϹǷ�
	RegisterEvent( EV_MinimapShowReduceBtn );
	RegisterEvent( EV_MinimapHideReduceBtn );
	RegisterEvent( EV_MinimapUpdateGameTime );
	RegisterEvent( EV_ShowFortressSiegeInfo);

}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MiniMapDrawerWnd = 				GetHandle( "MiniMapDrawerWnd" );
		MiniMapCtrLarge = 					MinimapCtrlHandle(GetHandle("MinimapWnd_Expand.Minimap"));
		m_hMinimapWnd = 				GetHandle( "MinimapWnd_Expand" );
		TexMapStroke = 					TextureHandle( GetHandle ("TexMapStroke"));
		m_MapSelectTab = 				TabHandle(GetHandle("MiniMapWnd_Expand.MapSelectTab"));
		m_MiniMapWndScript = 			MinimapWnd( GetScript("MinimapWnd" ) );
	}
	else
	{
		MiniMapDrawerWnd = 				GetWindowHandle( "MiniMapDrawerWnd" );
		MiniMapCtrLarge = 					GetMinimapCtrlHandle("MinimapWnd_Expand.Minimap");
		//~ m_MiniMap_Expand = 						GetMinimapCtrlHandle( "MinimapWnd_Expand.Minimap" );
		m_hMinimapWnd = 				GetWindowHandle( "MinimapWnd_Expand" );
		TexMapStroke = 					GetTextureHandle( "MinimapWnd_Expand.TexMapStroke");
		m_MapSelectTab = 				GetTabHandle("MiniMapWnd_Expand.MapSelectTab");
		m_MiniMapWndScript = 			MinimapWnd( GetScript("MinimapWnd" ) );
	}

	m_PartyLocIndex = -1;
	m_PartyMemberCount = GetPartyMemberCount();
	
	m_AdjustCursedLoc = false;
	GetResolutionList( ResolutionList );
	m_bShowSSQType=true;
	m_bShowCurrentLocation=true;
	m_bShowGameTime=true;
	
	m_ContinentOffset = 0;
}

function FilterDungeonMapExpand()
{
	//~ local MinimapWnd script;
	//~ script = MinimapWnd(GetScript("MinimapWnd"));
	
	//~ script.FilterDungeonMap();
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_PartyMemberChanged:
		HandlePartyMemberChanged( a_Param );
		break;
	case EV_MinimapAddTarget:
		HandleMinimapAddTarget( a_Param );
		break;
	case EV_MinimapDeleteTarget:
		HandleMinimapDeleteTarget( a_Param );
		break;
	case EV_MinimapDeleteAllTarget:
		HandleMinimapDeleteAllTarget();
		break;
	case EV_MinimapShowQuest:
		HandleMinimapShowQuest();
		break;
	case EV_MinimapHideQuest:
		HandleMinimapHideQuest();
		break;
	case EV_MinimapChangeZone :
		OnClickMyLocButton();
		break;
	case EV_MinimapCursedweaponList :
		if(!IsShowWindow("MinimapWnd_Expand"))
			return;
		HandleCursedWeaponList(a_Param);
		break;
	case EV_MinimapCursedweaponLocation :
		if(!IsShowWindow("MinimapWnd_Expand"))
			return;
		HandleCursedWeaponLoctaion(a_Param);
		break;
	case EV_BeginShowZoneTitleWnd :
		SetCurrentLocation();
		break;
	case EV_MinimapShowReduceBtn :
		class'UIAPI_WINDOW'.static.ShowWindow("MinimapWnd_Expand.btnReduce");
		break;
	case EV_MinimapHideReduceBtn :
		class'UIAPI_WINDOW'.static.HideWindow("MinimapWnd_Expand.btnReduce");
		break;
	case EV_MinimapUpdateGameTime :
		if(m_bShowGameTime)
			HandleUpdateGameTime(a_Param);
		break;
	case EV_ResolutionChanged :
		HandleResolutionChanged(a_Param);
		break;
	}
}


function OnShow()
{
	OnClickMyLocButton();
	//class'UIAPI_WINDOW'.static.ShowWindow( "MinimapWnd_Expand_back" );
//	m_hMinimapWnd.HideWindow();
	//class'MiniMapAPI'.static.RequestCursedWeaponList();
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_open_01" );
	SetSSQTypeText();	// ����������������� �ؽ�Ʈ����
	SetCurrentLocation();

		
	//class'UIAPI_WINDOW'.static.SetFocus("MinimapWnd_Expand_back");
	//m_hOwnerWnd.SetFocus();
	
//	class'MiniMapAPI'.static.RequestCursedWeaponLocation();
	
	CheckResolution();

	class'MiniMapAPI'.static.RequestCursedWeaponList();
	class'MiniMapAPI'.static.RequestCursedWeaponLocation();
	RequestFortressSiegeInfo();
	//~ FilterDungeonMapExpand();
}

function HandleResolutionChanged(String aParam)
{
	local int NewWidth;
	local int NewHeight;
	ParseInt(aParam, "NewWidth", NewWidth);
	ParseInt(aParam, "NewHeight", NewHeight);
	ResetMiniMapSize(NewWidth, NewHeight);
}


function SetSSQTypeText()
{
	local string SSQText;
	local MinimapWnd MinimapWndScript;
	MinimapWndScript = MinimapWnd( GetScript("MinimapWnd") );

	switch(MinimapWndScript.m_SSQStatus)
	{
	case 0 :
		SSQText=GetSystemString(973);
		break;
	case 1 :
		SSQText=GetSystemString(974);
		break;
	case 2 :
		SSQText=GetSystemString(975);
		break;
	case 3 :
		SSQText=GetSystemString(976);
		break;
	}
	class'UIAPI_TEXTBOX'.static.SetText("Minimapwnd_Expand.txtVarSSQType", SSQText);
}

function SetCurrentLocation()
{
	local string ZoneName;

	ZoneName=GetCurrentZoneName();
	class'UIAPI_TEXTBOX'.static.SetText("Minimapwnd_Expand.txtVarCurLoc", ZoneName);
}

function CheckResolution()
{
//	local int CurrentResolution;
	local int CurrentMaxWidth; 
	local int CurrentMaxHeight;
	//CurrentResolution = GetResolutionIndex();
	//CurrentMaxWidth	= ResolutionList[ CurrentResolution ].nWidth;
	//CurrentMaxHeight = ResolutionList[ CurrentResolution ].nHeight;

	//~ debug("MinimapExpand - Checkresolution");

	GetCurrentResolution (CurrentMaxWidth, CurrentMaxHeight);
	//~ debug ("���� �ػ�X:" @ CurrentMaxWidth);
	//~ debug ("���� �ػ�Y:" @ CurrentMaxHeight);
	ResetMiniMapSize(CurrentMaxWidth, CurrentMaxHeight);
}

function ResetMiniMapSize(int CurrentWidth, int CurrentHeight)
{
	local int adjustedwidth;
	local int adjustedheight;
	local int MainMapWidth;
	local int MainMapHeight;

	//~ debug("MinimapExpandWnd - ResetMinimapSize");
	
	MainMapWidth = CurrentWidth;
	MainMapHeight = CurrentHeight;
	
	//~ adjustedwidth = CurrentWidth - ((CurrentWidth * 3)/100) ;
	adjustedwidth = CurrentWidth - 14 ;
	adjustedheight = CurrentHeight - N_BUTTON_HEAD_AREA_BUFFER - 5 ;
	
	//~ if (CurrentWidth > (N_MAX_MINI_MAP_RES_X - m_ContinentOffset) )
	//~ {
		//~ adjustedwidth = (N_MAX_MINI_MAP_RES_X - m_ContinentOffset) - 8;
	
	if (CurrentWidth > N_MAX_MINI_MAP_RES_X )
	{
		adjustedwidth = N_MAX_MINI_MAP_RES_X - 14;
		MainMapWidth = N_MAX_MINI_MAP_RES_X ;
		//adjustedheight = CurrentHeight - N_BUTTON_HEAD_AREA_BUFFER;
		//debug ("AdjustedX:" @ adjustedwidth);
		//debug ("AdjustedY:" @ adjustedheight);
		//MiniMapCtrl.SetWindowSize(adjustedwidth, adjustedheight);
		//class'UIAPI_WINDOW'.static.SetWindowSize("MinimapWnd_Expand.Minimap", adjustedwidth, adjustedheight);
	}
	if (CurrentHeight > N_MAX_MINI_MAP_RES_Y)
	{
		adjustedheight = N_MAX_MINI_MAP_RES_Y - N_BUTTON_HEAD_AREA_BUFFER;
		MainMapHeight = N_MAX_MINI_MAP_RES_Y;
		//MiniMapCtrl.SetWindowSize(adjustedwidth, adjustedheight);
		//class'UIAPI_WINDOW'.static.SetWindowSize("MinimapWnd_Expand.Minimap", adjustedwidth, adjustedheight);
		//debug ("2AdjustedX:" @ adjustedwidth);
		//debug ("2AdjustedY:" @ adjustedheight);
	}
	m_hMinimapWnd.SetWindowSize(MainMapWidth+2 -m_ContinentOffset, MainMapHeight-2);
	MiniMapCtrLarge.SetWindowSize(adjustedwidth+2-m_ContinentOffset, adjustedheight-2);
	//~ TexMapStrokeGrow.SetWindowSize(adjustedwidth+2, adjustedheight-2);
	TexMapStroke.SetWindowSize(adjustedwidth+4-m_ContinentOffset, adjustedheight);
	//~ TexMapStroke.Move(-1,-1);
	//~ TexMapStrokeGrow.SetFocus();
//	OnClickMyLocButton();
}
	
function OnHide()
{
	//class'UIAPI_WINDOW'.static.HideWindow( "MinimapWnd_Expand_back" );
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_close_01" );
}

function HandlePartyMemberChanged( String a_Param )
{
	ParseInt( a_Param, "PartyMemberCount", m_PartyMemberCount );
}

function HandleMinimapAddTarget( String a_Param )
{
	local Vector Loc;
	
		//debug("~~~~~~~~~~~~~~~~"$a_Param);
	if( ParseFloat( a_Param, "X", Loc.x )
		&& ParseFloat( a_Param, "Y", Loc.y )
		&& ParseFloat( a_Param, "Z", Loc.z ) )
	{
		
		//debug (" �� �۵���1 :" @ Loc.x @ Loc.y @ Loc.z);
		class'UIAPI_MINIMAPCTRL'.static.AddTarget( "MinimapWnd_Expand.Minimap", Loc );
		SetLocContinent(Loc);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", Loc, false, false);
	}
		//debug (" �� �۵���2 :" @ Loc.x @ Loc.y @ Loc.z);
}

function HandleMinimapDeleteTarget( String a_Param )
{
	local Vector Loc;
	local int LocX;
	local int LocY;
	local int LocZ;

	if( ParseInt( a_Param, "X", LocX )
		&& ParseInt( a_Param, "Y", LocY )
		&& ParseInt( a_Param, "Z", LocZ ) )
	{
		Loc.x = float(LocX);
		Loc.y = float(LocY);
		Loc.z = float(LocZ);
		class'UIAPI_MINIMAPCTRL'.static.DeleteTarget( "MinimapWnd_Expand.Minimap", Loc );
	}
}

function HandleMinimapDeleteAllTarget()
{
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget( "MinimapWnd_Expand.Minimap" );
}

function HandleMinimapShowQuest()
{
	//~ Debug( "MinimapWnd_Expand.HandleMinimapShowQuest" );

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd_Expand.Minimap", true );
}

function HandleMinimapHideQuest()
{
	//~ Debug( "MinimapWnd_Expand.HandleMinimapHideQuest" );

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd_Expand.Minimap", false );
}


function RequestCursedWeaponLocation()
{
	//~ Debug( "MinimapWnd_Expand.RequestCursedweaponLocation" );
	//class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd_Expand.Minimap", false );
}

function OnComboBoxItemSelected( string sName, int index )
{
	local int CursedweaponComboBoxCurrentReservedData;

	if( sName == "CursedComboBox")
	{
		//QuestComboCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.QuestComboBox");
		CursedweaponComboBoxCurrentReservedData = class'UIAPI_COMBOBOX'.static.GetReserved("MinimapWnd_Expand.CursedComboBox",index);
		//LoadQuestSearchResult(CursedweaponComboBoxCurrentReservedData);
	}
	
}
function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
	case "TargetButton":
		OnClickTargetButton();
		break;
	case "MyLocButton":
		OnClickMyLocButton();
		break;
	case "PartyLocButton":
		OnClickPartyLocButton();
		break;
	//case "OpenGuideWnd":
	//	if( class'UIAPI_WINDOW'.static.IsShowWindow( "MinimapWnd_Expand.GuideWnd" ) )
	//	{
	//		class'UIAPI_WINDOW'.static.HideWindow( "MinimapWnd_Expand.GuideWnd" );
	//	}
	//	else
	//	{
	//		class'UIAPI_WINDOW'.static.ShowWindow( "MinimapWnd_Expand.GuideWnd" );
	//	}
	//	break;
	case "Pursuit":
//		class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd_Expand.Minimap");
		m_AdjustCursedLoc = true;
		class'MiniMapAPI'.static.RequestCursedWeaponLocation();
		break;
	case "CollapseButton":
		OnClickCollapseButton();
		break;
	case "btnReduce" :
		class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd_Expand.Minimap");
		class'UIAPI_WINDOW'.static.HideWindow("MinimapWnd_Expand.btnReduce");
		break;
	case "MapSelectTab1":
		//~ MiniMapCtrLarge.SetContinent(1);
		SetContinent(0);
		InitializeLocation();
		debug (a_ButtonID @ "Task1");
		break;
	case "MapSelectTab0":
		//~ MiniMapCtrLarge.SetContinent(0);
		SetContinent(1);
		InitializeLocation();
		debug (a_ButtonID @ "Task2");
		break;
		

	}
}

function OnClickCollapseButton()
{
	local MinimapWnd MinimapWndScript;
//	local bool ShowSystemMsgWnd;
	
	MinimapWndScript = MinimapWnd( GetScript("MinimapWnd") );
	MinimapWndScript.SetExpandState(false);

	m_hMinimapWnd.HideWindow();
	ShowWindowWithFocus("MinimapWnd");
}

function OnClickTargetButton()
{
	local Vector QuestLocation;

	if( GetQuestLocation( QuestLocation ) )
	{
		SetLocContinent( QuestLocation );
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", QuestLocation );
	}
}

function OnClickMyLocButton()
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();
	SetLocContinent(PlayerPosition);
	AdjustMapToPlayerPosition( true );
}

function AdjustMapToPlayerPosition( bool a_ZoomToTownMap )
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();

	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", PlayerPosition, a_ZoomToTownMap );
}

function OnClickPartyLocButton()
{
	local Vector PartyMemberLocation;

	m_PartyMemberCount = GetPartyMemberCount();
	//Debug( "m_PartyLocIndex=" $ m_PartyLocIndex $ " m_PartyMemberCount=" $ m_PartyMemberCount );

	
	
	if( 0 == m_PartyMemberCount )
		return;

	m_PartyLocIndex = ( m_PartyLocIndex + 1 ) % m_PartyMemberCount;
	if( GetPartyMemberLocation( m_PartyLocIndex, PartyMemberLocation ) )
	{
		SetLocContinent(PartyMemberLocation);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", PartyMemberLocation, false );
	}
}

function HandleCursedWeaponList( string param )
{

local int num;  
local int itemID;
local int i;
local string cursedName;
	
	ParseInt( param, "NUM", num );
//	debug ("numafdasf:"@ num);
	class'UIAPI_COMBOBOX'.static.Clear("MinimapWnd_Expand.CursedComboBox");
	
	for(i=0;i<num+1;++i)
	{
		if (i==0)
		{
			class'UIAPI_COMBOBOX'.static.AddStringWithReserved("MinimapWnd_Expand.CursedComboBox", GetSystemString(1463) , 0);
		}
		ParseInt( param, "ID" $ i-1, itemID );
		ParseString( param, "NAME" $ i-1, cursedName );
		
//		debug ("chooonsik:"@ cursedName @ itemID );
		class'UIAPI_COMBOBOX'.static.AddStringWithReserved("MinimapWnd_Expand.CursedComboBox", cursedName , itemID);
		class'UIAPI_COMBOBOX'.static.SetSelectedNum("MinimapWnd_Expand.CursedComboBox",0);
	}
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd_Expand.Minimap"); 
}

function HandleCursedWeaponLoctaion( string param )
{
	local int num;  
	local int itemID;
	local int itemID1;
	local int itemID2;
	local int isowndedo;
	local int isownded1;
	local int isownded2;


	local int x;
	local int y;
	local int z;
	local int i;
	local Vector CursedWeaponLoc1;
	local Vector CursedWeaponLoc2;
	local int CursedWeaponComboCurrentData;
	local string combocursedName;
	local string cursedName;
	local string cursedName1;
	local string cursedName2;
	local Vector cursedWeaponLocation;
	local bool combined;
	
	ParseInt( param, "NUM", num );

//	debug ("handleCursedWeaponLocation - ����:"@num);

	if(num==0)
	{
		if(m_AdjustCursedLoc)
		{
			SetLocContinent(GetPlayerPosition());
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", GetPlayerPosition());
		}
		class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd_Expand.Minimap");
		return;
	}
	else
	{
		for(i=0; i<num; ++i)
		{
			ParseInt( param, "ID" $ i, itemID );
			ParseString( param, "NAME" $ i, cursedName );

//			CursedWeaponComboCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("MinimapWnd_Expand.CursedComboBox");
//			combocursedName = class'UIAPI_COMBOBOX'.static.GetString("MinimapWnd_Expand.CursedComboBox", CursedWeaponComboCurrentData);

			ParseInt( param, "ISOWNED" $ i, isowndedo );
			ParseInt( param, "X" $ i, x );
			ParseInt( param, "Y" $ i, y );
			ParseInt( param, "Z" $ i, z );
				
			cursedWeaponLocation.x = x;
			cursedWeaponLocation.y = y;
			cursedWeaponLocation.z = z;
			
			Normal(cursedWeaponLocation);
			
			switch (i)
			{
			case 0:
				itemID1=itemID;
				cursedName1=cursedName;
				isownded1=isowndedo;
				CursedWeaponLoc1.x = cursedWeaponLocation.x;
				CursedWeaponLoc1.y = cursedWeaponLocation.y;
				CursedWeaponLoc1.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc1);
//				debug ("����1:"$cursedName1$", ��ġ:"@ CursedWeaponLoc1);
				break;
			case 1:
				itemID2=itemID;
				cursedName2=cursedName;
				isownded2=isowndedo;
				CursedWeaponLoc2.x = cursedWeaponLocation.x;
				CursedWeaponLoc2.y = cursedWeaponLocation.y;
				CursedWeaponLoc2.z = cursedWeaponLocation.z;
				Normal(CursedWeaponLoc2);
//				debug ("����2:"$cursedName2$", ��ġ:"@ CursedWeaponLoc2);
				break;
			}	
		}
	}

	// ���� ��������
	if(m_AdjustCursedLoc)
	{
		m_AdjustCursedLoc=false;

		CursedWeaponComboCurrentData = class'UIAPI_COMBOBOX'.static.GetSelectedNum("MinimapWnd_Expand.CursedComboBox");
		combocursedName = class'UIAPI_COMBOBOX'.static.GetString("MinimapWnd_Expand.CursedComboBox", CursedWeaponComboCurrentData);

		if(combocursedName==cursedName1)
		{
			SetLocContinent(cursedWeaponLoc1);
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", cursedWeaponLoc1, false);			
		}
		else if(combocursedName==cursedName2)
		{
			SetLocContinent(cursedWeaponLoc2);
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", cursedWeaponLoc2, false);			
		}
		else
		{
			
			OnClickMyLocButton();
		}
	}
	else
	{
		if(num==1)
		{
			DrawCursedWeapon("MinimapWnd_Expand.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
		}
		else if(num==2)
		{
			combined = class'UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd_Expand.Minimap", CursedWeaponLoc1.x, CursedWeaponLoc1.y, CursedWeaponLoc2.x, CursedWeaponLoc2.y);
			//debug ("�Ĺ���" @ combined); 

			//if (combined == false)
			//{
			//	tooltiptext1 = MakeFullSystemMsg( GetSystemMessage(1985), GetSystemString(1464),  "1") $"\\n" $MakeFullSystemMsg( GetSystemMessage(1986), GetSystemString(1499), "1");
			//	tooltiptext2 = MakeFullSystemMsg( GetSystemMessage(1985), GetSystemString(1464),  "1") $"\\n" $MakeFullSystemMsg( GetSystemMessage(1986), GetSystemString(1499), "1");
			//}


			if(combined)
			{
				class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd_Expand.Minimap","L2UI_CH3.MiniMap.cursedmapicon00","L2UI_CH3.MiniMap.cursedmapicon00", cursedWeaponLoc1,true, 0, -12, cursedName1$"\\n"$cursedName2);			
			}	
			else
			{
				//~ debug("ownded:"@isownded1@isownded2);
				
				DrawCursedWeapon("MinimapWnd_Expand.Minimap", itemID1, cursedName1, CursedWeaponLoc1, isownded1==0 , true);
				DrawCursedWeapon("MinimapWnd_Expand.Minimap", itemID2, cursedName2, CursedWeaponLoc2, isownded2==0 , false);

	//			class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd_Expand.Minimap","L2UI_CH3.MiniMap.cursedmapicon00","L2UI_CH3.MiniMap.cursedmapicon01_drop", cursedWeaponLoc1,true, 0, -12, cursedName1);
	//			class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd_Expand.Minimap","L2UI_CH3.MiniMap.cursedmapicon00","L2UI_CH3.MiniMap.cursedmapicon01_drop", cursedWeaponLoc2,false, 0, -12, cursedName2);
			}
		}


	}
		


}


function DrawCursedWeapon(string WindowName, int itemID, string cursedName, Vector vecLoc, bool bDropped, bool bRefresh)
{
	local string itemIconName;

	if(itemID==8190)
	{
		ItemIconName="L2UI_CH3.MiniMap.cursedmapicon01";
	}
	else if(itemID==8689)
	{
		ItemIconName="L2UI_CH3.MiniMap.cursedmapicon02";
	}

	if(bDropped)
		ItemIconName=ItemIconName$"_drop";

	class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName,ItemIconName,"L2UI_CH3.MiniMap.cursedmapicon00", vecLoc, bRefresh, 0, -12, cursedName);
}

function HandleUpdateGameTime(string a_Param)
{
	local int GameHour;
	local int GameMinute;

local string GameTimeString;

	ParseInt(a_Param, "GameHour", GameHour);
	ParseInt(a_Param, "GameMinute", GameMinute);

	GameTimeString = "";

	SelectSunOrMoon(GameHour);

	
	//~ if ( GameHour >= 12 )
	//~ {
		//~ GameTimeString="PM ";
		//~ GameHour -= 12;
	//~ }
	//~ else
	//~ {
		//~ GameTimeString="AM ";
	//~ }

	if ( GameHour == 0 )
		GameHour = 12;

	//~ if(GameHour<10)
		//~ GameTimeString=GameTimeString$"0"$string(GameHour)$" : ";
	//~ else
		GameTimeString=GameTimeString$string(GameHour)$" : ";

	if(GameMinute<10)
		GameTimeString=GameTimeString$"0"$string(GameMinute);
	else
		GameTimeString=GameTimeString$string(GameMinute);

	class'UIAPI_TEXTBOX'.static.SetText("MinimapWnd_Expand.txtGameTime", GameTimeString);
}

function SelectSunOrMoon(int GameHour)
{
	if ( GameHour >= 6 && GameHour <= 24 )
	{
		class'UIAPI_WINDOW'.static.ShowWindow("MinimapWnd_Expand.texSun");
		class'UIAPI_WINDOW'.static.HideWindow("MinimapWnd_Expand.texMoon");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("MinimapWnd_Expand.texMoon");
		class'UIAPI_WINDOW'.static.HideWindow("MinimapWnd_Expand.texSun");
	}
}

function SetContinent(int continent)
{
	m_MiniMapWndScript.m_CurContinent = continent;
	MiniMapCtrLarge.SetContinent(m_MiniMapWndScript.m_CurContinent);
	if (m_MiniMapWndScript.m_CurContinent == 1)
	{
		m_MapSelectTab.SetTopOrder(0, true);
		m_ContinentOffset = 224;
	}
	else if(m_MiniMapWndScript.m_CurContinent == 0)
	{
		m_MapSelectTab.SetTopOrder(1, true);
		m_ContinentOffset = 0;
	}
	CheckResolution();
}
function SetLocContinent(vector loc)
{
	m_MiniMapWndScript.m_CurContinent =  GetContinent(loc);
	MiniMapCtrLarge.SetContinent(m_MiniMapWndScript.m_CurContinent);
	if (m_MiniMapWndScript.m_CurContinent == 1)
	{
		m_MapSelectTab.SetTopOrder(0, true);
		m_ContinentOffset = 224;
	}
	else if(m_MiniMapWndScript.m_CurContinent == 0)
	{
		m_MapSelectTab.SetTopOrder(1, true);
		m_ContinentOffset = 0;
	}
	CheckResolution();
}
function int GetContinent(vector loc)
{
	if (loc.X < -163840)
	{
		return 1;		//Gracia
	}
	else
	{
		return 0;		//Aden
	}
}
function InitializeLocation()
{
	local Vector Location;
	if (m_MiniMapWndScript.m_CurContinent == 0) //Aden ���
	{
		Location.x = -86916;
		Location.y = 222183;
		Location.z = -4656;
		
	}
	else if (m_MiniMapWndScript.m_CurContinent == 1) //Gracia ���
	{
		Location.x = -181823;
		Location.y = 224580;
		Location.z = -4104;
	}
		
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd_Expand.Minimap", Location, false, false);
}
defaultproperties
{
}

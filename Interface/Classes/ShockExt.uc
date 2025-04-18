class ShockExt extends UICommonAPI;

const TIMER_ID = 9000;

var WindowHandle Me;

var ItemWindowHandle shotsWnd;
var ItemWindowHandle InvItem;

var ButtonHandle btnTimerStart;
var ButtonHandle btnCancelTargetOn;

var TextBoxHandle txtAutoUseStatus;
var TextBoxHandle txtCancelStatus;

var bool cancelON;
var bool autoUseON;

var ItemInfo mainItem;

var Color StatusOFF;
var Color StatusON;

function OnShow()
{
	
}

function OnHide()
{
	
}

function OnRegisterEvent()
{
	RegisterEvent( EV_ReceiveMagicSkillUse );
}

function OnLoad()
{
	cancelON = false;
	autoUseON = false;
	
	StatusON.R = 20; StatusON.G = 206; StatusON.B = 20;
	StatusOFF.R = 206; StatusOFF.G = 20; StatusOFF.B = 20;
	
	Me = GetWindowHandle( "ShockExt" );
	
	txtAutoUseStatus = GetTextBoxHandle( "descOnOff1" );
	txtCancelStatus = GetTextBoxHandle( "descOnOff" );
	
	shotsWnd = GetItemWindowHandle( "itemMain" );
	InvItem = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	
	txtAutoUseStatus.SetTextColor( StatusOFF );
	txtCancelStatus.SetTextColor( StatusOFF );
	
	txtAutoUseStatus.SetText( "OFF" );
	txtCancelStatus.SetText( "OFF" );
	
	shotsWnd.Clear();
}

function OnTimer( int TimerID )
{
	if ( TimerID == TIMER_ID )
	{
		if ( InvItem.FindItem( mainItem.ID ) > -1 )
		{
			Me.KillTimer( TIMER_ID );
			RequestUseItem( mainItem.ID );
			Me.SetTimer( TIMER_ID, 500 );
		}
		else
		{
			Me.KillTimer( TIMER_ID );
			MessageBox( "Can't find an item in inventory" );
			OnClickAutoUse();
		}
	}
}

function OnClickButton( string strID )
{
	switch ( strID )
	{
		case "btnStart":
			OnClickAutoUse();
		break;
		case "btnCancel":
			OnClickCancel();
		break;
	}
}

function OnClickAutoUse()
{
	local ItemInfo testInfo;
	
	if ( !shotsWnd.GetItem( 0, testInfo ) )
	{
		MessageBox( "Place an item!" );
		return;
	}
	
	if ( !autoUseON )
	{
		Me.KillTimer( TIMER_ID );
		Me.SetTimer( TIMER_ID, 500 );
		
		txtAutoUseStatus.SetText( "ON" );
		txtAutoUseStatus.SetTextColor( StatusON );
		autoUseON = true;
	}
	else
	{
		Me.KillTimer( TIMER_ID );
		
		txtAutoUseStatus.SetText( "OFF" );
		txtAutoUseStatus.SetTextColor( StatusOFF );
		autoUseON = false;
	}
}

function OnClickCancel()
{
	if ( !cancelON )
	{
		txtCancelStatus.SetTextColor( StatusON );
		txtCancelStatus.SetText( "ON" );
		cancelON = true;
	}
	else
	{
		txtCancelStatus.SetTextColor( StatusOFF );
		txtCancelStatus.SetText( "OFF" );
		cancelON = false;
	}
}

function OnEvent( int EventID, string param )
{
	switch (EventID)
	{
		case EV_ReceiveMagicSkillUse:
			if ( cancelON )
			{
				CancelTarget( param );
			}
		break;
	}
}

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	if ( a_WindowID == "itemMain" )
	{
		shotsWnd.Clear();
		mainItem = a_ItemInfo;
		shotsWnd.AddItem( mainItem );
	}
}

function CancelTarget( string param )
{
	local int SkillID;
	local int AttackerID;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	
	ParseInt( param, "AttackerID", AttackerID );
	ParseInt( param, "SkillID", SkillID );
	
	GetPlayerInfo( PlayerInfo );
	GetUserInfo( AttackerID, AttackerInfo );
	
	if ( PlayerInfo.nID == AttackerInfo.nID )
	{
		switch ( SkillID )
		{
			case 3282: //Maximum Clarity
			case 3284: //Divine Protection
			case 3429: //Life Force
				RequestTargetCancel();
			break;
		}
	}
}

defaultproperties
{
	
}
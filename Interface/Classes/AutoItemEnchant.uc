class AutoItemEnchant extends UICommonAPI;

const TIMER_ID = 9020;
const TIMER_AFTER_SCROLL_USE = 9021; //About 500
const TIMER_AFTER_ITEM_ADDED = 9022; //About 2000
const TIMER_AFTER_ENHCHANT_RESULT = 9023; //About 500
const TIMER_TO_COUNT_SCROLLS = 9024; //About 250

var WindowHandle Me;

var ButtonHandle BtnEnchant;
var ButtonHandle BtnHelp;
var ButtonHandle BtnStop;

var EditBoxHandle EnchantLvl;
var EditBoxHandle SafeEnchantLvl;
var EditBoxHandle BlessedEnchantLvl;

var ItemWindowHandle MainItemSlot;
var ItemWindowHandle ScrollSlot;
var ItemWindowHandle BlessedScrollSlot;

var ItemInfo MainInfo;
var ItemInfo ScrollInfo;
var ItemInfo BlessedScrollInfo;

var SliderCtrlHandle Slider0;
var SliderCtrlHandle Slider1;
var SliderCtrlHandle Slider2;

var TextBoxHandle txtItem;
var TextBoxHandle txtScroll;
var TextBoxHandle txtScrollCount;
var TextBoxHandle txtScrollCountBlessed;
var TextBoxHandle txtEnchValue;
var TextBoxHandle txtSlider0;
var TextBoxHandle txtSlider1;
var TextBoxHandle txtSlider2;

var TextureHandle texShadow;

var bool isWeapon;

var int DelayOnScrollUse;
var int DelayOnItemAdd;
var int DelayOnEnchResult;

var Color RedClr;
var Color GreenClr;
var Color WhiteClr;

function OnRegisterEvent()
{
	RegisterEvent( EV_EnchantShow );
	RegisterEvent( EV_EnchantHide );
	RegisterEvent( EV_EnchantResult );
	RegisterEvent( EV_EnchantPutTargetItemResult );
}

function OnEvent( int EventID, string param )
{
	if ( Me.IsShowWindow() )
	{
		if ( EventID == EV_EnchantPutTargetItemResult )
		{
			TryAddItem( param );
		}
		else if ( EventID == EV_EnchantShow )
		{
			//sysDebug( "Enchant Show" );
			
		}
		else if ( EventID == EV_EnchantResult )
		{
			//sysDebug( "Enchant Result" );
			EnchantResult( param );
		}
	}
}

function OnLoad()
{
	Me = GetWindowHandle( "AutoItemEnchant" );
	
	BtnEnchant = GetButtonHandle( "AutoItemEnchant.btnStart" );
	BtnHelp = GetButtonHandle( "AutoItemEnchant.btnHelp" );
	BtnStop = GetButtonHandle( "AutoItemEnchant.btnStop" );
	
	EnchantLvl = GetEditBoxHandle( "AutoItemEnchant.EnchantLvl" );
	SafeEnchantLvl = GetEditBoxHandle( "AutoItemEnchant.SafeEnchantLvl" );
	BlessedEnchantLvl = GetEditBoxHandle( "AutoItemEnchant.BlessedEnchantLvl" );
	
	MainItemSlot = GetItemWindowHandle( "AutoItemEnchant.mainItem" );
	ScrollSlot = GetItemWindowHandle( "AutoItemEnchant.scrollSimple" );
	BlessedScrollSlot = GetItemWindowHandle( "AutoItemEnchant.scrollBlessed" );
	
	Slider0 = GetSliderCtrlHandle( "AutoItemEnchant.Slider0" );
	Slider1 = GetSliderCtrlHandle( "AutoItemEnchant.Slider1" );
	Slider2 = GetSliderCtrlHandle( "AutoItemEnchant.Slider2" );
	
	txtItem = GetTextBoxHandle( "AutoItemEnchant.txtItem" );
	txtScroll = GetTextBoxHandle( "AutoItemEnchant.txtScrolls" );
	txtScrollCount = GetTextBoxHandle( "AutoItemEnchant.txtScrollCount" );
	txtScrollCountBlessed = GetTextBoxHandle( "AutoItemEnchant.txtScrollCountBlessed" );
	txtEnchValue = GetTextBoxHandle( "AutoItemEnchant.txtEnchValue" );
	txtSlider0 = GetTextBoxHandle( "AutoItemEnchant.txtSlider0" );
	txtSlider1 = GetTextBoxHandle( "AutoItemEnchant.txtSlider1" );
	txtSlider2 = GetTextBoxHandle( "AutoItemEnchant.txtSlider2" );
	
	texShadow = GetTextureHandle( "AutoItemEnchant.shadowEnch" );
	
	RedClr.R = 204; RedClr.G = 51; RedClr.B = 51;
	GreenClr.R = 51; GreenClr.G = 204; GreenClr.B = 51;
	WhiteClr.R = 204; WhiteClr.G = 204; WhiteClr.B = 204;
	
	txtItem.SetAlpha( 0 );
	txtItem.SetTextColor( RedClr );
	txtScroll.SetAlpha( 255 );
	txtScroll.SetTextColor( WhiteClr );
	
	DelayOnScrollUse = 250;
	DelayOnItemAdd = 2000;
	DelayOnEnchResult = 250;
	
	isWeapon = false;
	
	txtScrollCount.SetText( "" );
	txtScrollCountBlessed.SetText( "" );
	txtEnchValue.SetText( "" );
	
	txtSlider0.SetText( string( DelayOnScrollUse ) );
	txtSlider1.SetText( string( DelayOnItemAdd ) );
	txtSlider2.SetText( string( DelayOnEnchResult ) );
	
	EnchantLvl.SetString( "0" );
	SafeEnchantLvl.SetString( "3" );
	BlessedEnchantLvl.SetString( "0" );
	
	texShadow.HideWindow();
	btnStop.HideWindow();
}

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y )
{
	switch (a_WindowID)
	{
		case "mainItem":
			MainInfo = a_ItemInfo;
			AddMainItem( MainInfo );
			//sysDebug( "ON DROP" );
		break;
		case "scrollSimple":
			if ( IsBlessed( a_ItemInfo ) )
			{
				BlessedScrollInfo = a_ItemInfo;
				AddScrollItem( BlessedScrollInfo, true );
			}
			else
			{
				ScrollInfo = a_ItemInfo;
				AddScrollItem( ScrollInfo, false );
			}
			//sysDebug( "ON DROP Scroll" );
		break;
		case "scrollBlessed":
			if ( IsBlessed( a_ItemInfo ) )
			{
				BlessedScrollInfo = a_ItemInfo;
				AddScrollItem( BlessedScrollInfo, true );
			}
			else
			{
				ScrollInfo = a_ItemInfo;
				AddScrollItem( ScrollInfo, false );
			}
			//sysDebug( "ON DROP Blessed Scroll" );
		break;
	}
}

function OnClickButton( string Name )
{
	switch ( Name )
	{
		case "btnStart":
			OnClickStart();
		break;
		case "btnHelp":
			OnClickHelp();
		break;
		case "btnStop":
			class'EnchantAPI'.static.RequestExCancelEnchantItem();
			OnClickStop();
		break;
	}
}

function OnTimer( int TimerID )
{
	local ItemID SupportID;
	
	if (TimerID == TIMER_ID)
	{
		if (MainInfo.ID.ClassID > 0)
		{
			AnimationTwo();
		}
		else
		{
			AnimationOne();
		}
	}
	else if (TimerID == TIMER_AFTER_SCROLL_USE )
	{
		Me.KillTimer( TIMER_AFTER_SCROLL_USE );
		class'EnchantAPI'.static.RequestExTryToPutEnchantTargetItem( MainInfo.ID );
		//sysDebug( "Trying to add item..." );
	}
	else if (TimerID == TIMER_AFTER_ITEM_ADDED )
	{
		Me.KillTimer( TIMER_AFTER_ITEM_ADDED );
		//sysDebug( "Trying to enchant..." );
		ClearItemID( SupportID );
		class'EnchantAPI'.static.RequestEnchantItem(MainInfo.ID, SupportID);
	}
	else if (TimerID == TIMER_AFTER_ENHCHANT_RESULT )
	{
		Me.KillTimer( TIMER_AFTER_ENHCHANT_RESULT );
		//sysDebug( "NEW CYCLE" );
		OnClickStart();
	}
	else if (TimerID == TIMER_TO_COUNT_SCROLLS )
	{
		Me.KillTimer( TIMER_TO_COUNT_SCROLLS );
		if ( txtScrollCount.GetText() != "" )
		{
			txtScrollCount.SetText( string( CalcScrolls( ScrollInfo ) ) );
		}
		if ( txtScrollCountBlessed.GetText() != "" )
		{
			txtScrollCountBlessed.SetText( string( CalcScrolls( BlessedScrollInfo ) ) );
		}
	}
}

function AddMainItem( ItemInfo info )
{
	if ( info.CrystalType > 0 )
	{
		ScrollSlot.Clear();
		ClearItemID( ScrollInfo.ID );
		BlessedScrollSlot.Clear();
		ClearItemID( BlessedScrollInfo.ID );
		txtScrollCount.SetText( "" );
		txtScrollCountBlessed.SetText( "" );
		
		MainItemSlot.Clear();
		MainItemSlot.AddItem( info );
		
		if ( info.Enchanted > 0 )
		{
			texShadow.ShowWindow();
			txtEnchValue.SetText( "+" $ string( info.Enchanted ) );
		}
		else
		{
			texShadow.HideWindow();
			txtEnchValue.SetText( "" );
		}
		
		if ( info.ItemType == 0 )
		{
			isWeapon = true;
		}
		else
		{
			isWeapon = false;
		}
		
		Me.KillTimer( TIMER_ID );
		txtItem.SetAlpha( 255 );
		txtItem.SetTextColor( GreenClr );
		AnimationTwo();
		
	}
}

function AddScrollItem( ItemInfo info, bool isBlessed)
{
	local ItemInfo cInfo;
	
	if ( MainItemSlot.GetItem( 0, cInfo ) )
	{
		if ( GetGradeByIndex( cInfo.CrystalType ) == GetScrollGrade( info ) )
		{
			if ( !isBlessed )
			{
				if ( isWeapon )
				{
					if ( info.ItemType == 5 && info.ItemSubType == 19 )
					{
						ScrollSlot.Clear();
						ScrollSlot.AddItem( info );
						ScrollSlot.DisableWindow();
						txtScrollCount.SetText( string( CalcScrolls( info ) ) );
						Me.KillTimer( TIMER_ID );
						txtScroll.SetAlpha( 255 );
						txtScroll.SetTextColor( GreenClr );
					}
				}
				else
				{
					if ( info.ItemType == 5 && info.ItemSubType == 20 )
					{
						ScrollSlot.Clear();
						ScrollSlot.AddItem( info );
						ScrollSlot.DisableWindow();
						txtScrollCount.SetText( string( CalcScrolls( info ) ) );
						Me.KillTimer( TIMER_ID );
						txtScroll.SetAlpha( 255 );
						txtScroll.SetTextColor( GreenClr );
					}
				}
			}
			else
			{
				if ( isWeapon )
				{
					if ( info.ItemType == 5 && info.ItemSubType == 21 )
					{
						BlessedScrollSlot.Clear();
						BlessedScrollSlot.AddItem( info );
						BlessedScrollSlot.DisableWindow();
						txtScrollCountBlessed.SetText( string( CalcScrolls( info ) ) );
						Me.KillTimer( TIMER_ID );
						txtScroll.SetAlpha( 255 );
						txtScroll.SetTextColor( GreenClr );
					}
				}
				else
				{
					if ( info.ItemType == 5 && info.ItemSubType == 22 )
					{
						BlessedScrollSlot.Clear();
						BlessedScrollSlot.AddItem( info );
						BlessedScrollSlot.DisableWindow();
						txtScrollCountBlessed.SetText( string( CalcScrolls( info ) ) );
						Me.KillTimer( TIMER_ID );
						txtScroll.SetAlpha( 255 );
						txtScroll.SetTextColor( GreenClr );
					}
				}
			}
		}
		else
		{
			MessageBox( "Wrong grade!" );
		}
	}
	else
	{
		MessageBox( "Set item first!" );
	}
}

function OnClickStart()
{
	local ItemInfo cInfo;
	
	if ( !MainItemSlot.GetItem( 0, cInfo ) )
	{
		MessageBox( "Choose item!" );
		return;
	}
	
	if ( !ScrollSlot.GetItem( 0, cInfo ) && !BlessedScrollSlot.GetItem( 0, cInfo ) )
	{
		MessageBox( "Choose scroll!" );
		return;
	}
	
	if ( EnchantLvl.GetString() == "" || int( EnchantLvl.GetString() ) < 1 )
	{
		MessageBox( "Set enchant value!" );
		EnchantLvl.SetFocus();
		return;
	}
	if ( SafeEnchantLvl.GetString() == "" )
	{
		MessageBox( "Set safe enchant value for ews/eas!" );
		SafeEnchantLvl.SetFocus();
		return;
	}
	if ( BlessedEnchantLvl.GetString() == "" )
	{
		MessageBox( "Set blessed enchant value!" );
		BlessedEnchantLvl.SetFocus();
		return;
	}
	
	if ( ScrollSlot.GetItem( 0, cInfo ) && !BlessedScrollSlot.GetItem( 0, cInfo ) )
	{
		if ( CalcScrolls( ScrollInfo ) > 0 )
		{
			txtScrollCount.SetText( string( CalcScrolls( ScrollInfo ) ) );
			RequestUseItem( ScrollInfo.ID );
			Me.KillTimer( TIMER_AFTER_SCROLL_USE );
			Me.SetTimer( TIMER_AFTER_SCROLL_USE, DelayOnScrollUse );
		}
		else
		{
			MessageBox( "No scrolls available" );
			//ScrollInfo.Clear();
			OnClickStop();
			return;
		}
	}
	else if ( !ScrollSlot.GetItem( 0, cInfo ) && BlessedScrollSlot.GetItem( 0, cInfo ) )
	{
		if ( CalcScrolls( BlessedScrollInfo ) > 0 )
		{
			txtScrollCountBlessed.SetText( string( CalcScrolls( BlessedScrollInfo ) ) );
			RequestUseItem( BlessedScrollInfo.ID );
			Me.KillTimer( TIMER_AFTER_SCROLL_USE );
			Me.SetTimer( TIMER_AFTER_SCROLL_USE, DelayOnScrollUse );
		}
		else
		{
			MessageBox( "No blessed scrolls available" );
			//BlessedScrollInfo.Clear();
			OnClickStop();
			return;
		}
	}
	if ( ScrollSlot.GetItem( 0, cInfo ) && BlessedScrollSlot.GetItem( 0, cInfo ) )
	{
		if ( MainInfo.Enchanted < int( SafeEnchantLvl.GetString() ) )
		{
			if ( CalcScrolls( ScrollInfo ) > 0 )
			{
				txtScrollCount.SetText( string( CalcScrolls( ScrollInfo ) ) );
				RequestUseItem( ScrollInfo.ID );
				Me.KillTimer( TIMER_AFTER_SCROLL_USE );
				Me.SetTimer( TIMER_AFTER_SCROLL_USE, DelayOnScrollUse );
			}
			else
			{
				MessageBox( "No scrolls available" );
				OnClickStop();
				return;
			}
		}
		else
		{
			if ( CalcScrolls( BlessedScrollInfo ) > 0 )
			{
				txtScrollCountBlessed.SetText( string( CalcScrolls( BlessedScrollInfo ) ) );
				RequestUseItem( BlessedScrollInfo.ID );
				Me.KillTimer( TIMER_AFTER_SCROLL_USE );
				Me.SetTimer( TIMER_AFTER_SCROLL_USE, DelayOnScrollUse );
			}
			else
			{
				MessageBox( "No blessed scrolls available" );
				//BlessedScrollInfo.Clear();
				OnClickStop();
				return;
			}
		}
		
	}
	
	//1. If two scrolls exist:
	//  - ask what safe enchant you want with simple scroll
	//  - use simple scroll, until enchant != safe enchant
	//  - start enchanting using blessed scrolls, until desired enchant
	
	BtnEnchant.HideWindow();
	BtnHelp.HideWindow();
	BtnStop.ShowWindow();
}

function OnClickStop()
{
	BtnEnchant.ShowWindow();
	BtnHelp.ShowWindow();
	BtnStop.HideWindow();
	
	Me.KillTimer( TIMER_AFTER_SCROLL_USE );
	Me.KillTimer( TIMER_AFTER_ITEM_ADDED );
	Me.KillTimer( TIMER_AFTER_ENHCHANT_RESULT );
}

function TryAddItem( string param )
{
	local int ResultID;
	
	ParseInt( param, "Result", ResultID );
	
	//sysDebug("ON TRY");
	
	if ( ResultID == 0 )
	{
		class'EnchantAPI'.static.RequestExCancelEnchantItem();
	}
	else
	{
		//sysDebug( "Item Added!" );
		Me.KillTimer( TIMER_AFTER_ITEM_ADDED );
		Me.SetTimer( TIMER_AFTER_ITEM_ADDED, DelayOnItemAdd );
	}
}

function EnchantResult( string param )
{
	local int IntResult;
	local ItemID ItemID;
	local int64 Count;
	local int CountInt;
	local ItemInfo ResultItem;
	
	ParseInt(Param, "Result", IntResult );
	ParseItemID(param, ItemID );
	Parseint64(param, "Count", Count );
	ParseInt(param, "Count", CountInt );
	class'UIDATA_ITEM'.static.GetItemInfo(ItemID, ResultItem );
	
	switch (IntResult)
	{
		case 0:
			//sysDebug( "Successfull enchant from " $ MainInfo.Enchanted $ "to " $ MainInfo.Enchanted + 1 );
			MainInfo.Enchanted += 1;
			texShadow.ShowWindow();
			txtEnchValue.SetText( "+" $ string( MainInfo.Enchanted ) );
			Me.KillTimer( TIMER_TO_COUNT_SCROLLS );
			Me.SetTimer( TIMER_TO_COUNT_SCROLLS, 250 );
			if ( MainInfo.Enchanted != int( EnchantLvl.GetString() ) )
			{
				Me.KillTimer ( TIMER_AFTER_ENHCHANT_RESULT );
				Me.SetTimer ( TIMER_AFTER_ENHCHANT_RESULT, DelayOnEnchResult );
			}
			else
			{
				MessageBox( "Item successfully enchanted!" );
				OnClickStop();
			}
		break;
		case 1:
			MessageBox( "Item destroyed!" );
			MainItemSlot.Clear();
			ScrollSlot.Clear();
			BlessedScrollSlot.Clear();
			ClearItemID( MainInfo.ID );
			ClearItemID( ScrollInfo.ID );
			ClearItemID( BlessedScrollInfo.ID );
			txtScrollCount.SetText( "" );
			txtScrollCountBlessed.SetText( "" );
			txtEnchValue.SetText( "" );
			texShadow.HideWindow();
			txtScroll.SetAlpha( 255 );
			txtScroll.SetTextColor( WhiteClr );
			AnimationOne();
			OnClickStop();
		break;
		case 2:
			//Not appropriate item
			sysDebug( "Wrong item!" );
			OnClickStop();
		break;
		case 3:			//Fail with bless enchant
			//sysDebug( "Bless enchant failed!" );
			MainInfo.Enchanted = int( BlessedEnchantLvl.GetString() );
			texShadow.ShowWindow();
			txtEnchValue.SetText( "+" $ string( MainInfo.Enchanted ) );
			Me.KillTimer( TIMER_TO_COUNT_SCROLLS );
			Me.SetTimer( TIMER_TO_COUNT_SCROLLS, 250 );
			Me.KillTimer ( TIMER_AFTER_ENHCHANT_RESULT );
			Me.SetTimer ( TIMER_AFTER_ENHCHANT_RESULT, DelayOnEnchResult );
		break;
		case 4:
			MessageBox( "Item destroyed!" );
			MainItemSlot.Clear();
			ScrollSlot.Clear();
			BlessedScrollSlot.Clear();
			ClearItemID( MainInfo.ID );
			ClearItemID( ScrollInfo.ID );
			ClearItemID( BlessedScrollInfo.ID );
			txtScrollCount.SetText( "" );
			txtScrollCountBlessed.SetText( "" );
			txtEnchValue.SetText( "" );
			texShadow.HideWindow();
			txtScroll.SetAlpha( 255 );
			txtScroll.SetTextColor( WhiteClr );
			AnimationOne();
			OnClickStop();
		break;
		case 5:
			MessageBox( "Please contact DEADZ about this problem!" );
		break;
	}
}

function name GetGradeByIndex(int weapIndex)
{
	switch (weapIndex)
	{
		case 0:
			return 'NOGRADE';
		break;
		case 1:
			return 'D';
		break;
		case 2:
			return 'C';
		break;
		case 3:
			return 'B';
		break;
		case 4:
			return 'A';
		break;
		case 5:
		case 6:
		case 7:
			return 'S';
		break;
	}
}

function name GetScrollGrade( ItemInfo info )
{
	if ( InStr( info.Name, "D-Grade") > -1 )
	{
		return 'D';
	}
	else if ( InStr( info.Name, "C-Grade") > -1 )
	{
		return 'C';
	}
	else if ( InStr( info.Name, "B-Grade") > -1 )
	{
		return 'B';
	}
	else if ( InStr( info.Name, "A-Grade") > -1 )
	{
		return 'A';
	}
	else if ( InStr( info.Name, "S-Grade") > -1 )
	{
		return 'S';
	}
}

function AnimationOne()
{
	local int Alpha;
	
	Alpha = txtItem.GetAlpha();
	
	txtItem.SetTextColor( RedClr );
	
	if ( Alpha == 0 )
	{
		txtItem.SetAlpha( 255, 1.0f );
	}
	else if ( Alpha == 255 )
	{
		txtItem.SetAlpha( 0, 1.0f );
	}
	
	Me.KillTimer( TIMER_ID );
	Me.SetTimer( TIMER_ID, 1100 );
}

function AnimationTwo()
{
	local int Alpha;
	
	Alpha = txtScroll.GetAlpha();
	
	txtScroll.SetTextColor( RedClr );
	
	if ( Alpha == 0 )
	{
		txtScroll.SetAlpha( 255, 1.0f );
	}
	else if ( Alpha == 255 )
	{
		txtScroll.SetAlpha( 0, 1.0f );
	}
	
	Me.KillTimer( TIMER_ID );
	Me.SetTimer( TIMER_ID, 1100 );
}

function OnShow()
{
	AnimationOne();
}

function OnHide()
{
	Me.KillTimer( TIMER_ID );
	txtItem.SetAlpha( 255 );
	MainItemSlot.Clear();
	ScrollSlot.Clear();
	BlessedScrollSlot.Clear();
	ClearItemID( MainInfo.ID );
	ClearItemID( ScrollInfo.ID );
	ClearItemID( BlessedScrollInfo.ID );
	txtScrollCount.SetText( "" );
	txtScrollCountBlessed.SetText( "" );
	txtEnchValue.SetText( "" );
	texShadow.HideWindow();
	txtScroll.SetAlpha( 255 );
	txtScroll.SetTextColor( WhiteClr );
}

function bool IsBlessed( ItemInfo info )
{
	if ( info.ItemType == 5 && ( info.ItemSubType == 21 || info.ItemSubType == 22 ) )
	{
		return true;
	}
	else if ( info.ItemType == 5 && ( info.ItemSubType == 19 || info.ItemSubType == 20 ) )
	{
		return false;
	}
}

function int CalcScrolls( ItemInfo info )
{
	local ItemWindowHandle handle;
	
	handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
	
	if ( handle.FindItem( info.ID ) == -1 )
	{
		return 0;
	}
	
	if (handle.GetItem( handle.FindItem( info.ID ) , info ) )
	{
		return Int64ToInt( info.ItemNum );
	}
	else
	{
		return 0;
	}
}

function int GetEnchantValue( ItemInfo info )
{
	return info.Enchanted;
}

function int GetSpeedFromSliderTick( int iTick )
{
	local int ReturnSpeed;
	switch( iTick )
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

function OnModifyCurrentTickSliderCtrl( string strID, int iCurrentTick )
{
	local int Speed;
	Speed = GetSpeedFromSliderTick( iCurrentTick );
	switch(strID)
	{
	case "Slider0" :
		DelayOnScrollUse = Speed;
		txtSlider0.SetText( string( Speed ) );
		break;
	case "Slider1" :
		DelayOnItemAdd = Speed;
		txtSlider1.SetText( string( Speed ) );
		break;
	case "Slider2" :
		DelayOnEnchResult = Speed;
		txtSlider2.SetText( string( Speed ) );
		break;
	}
}

function OnClickHelp()
{
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help_deadz_autoitemenchant.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

defaultproperties
{
	
}
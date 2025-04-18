class InventoryWnd extends UICommonAPI;

const DIALOG_USE_RECIPE				= 1111;				// �����Ǹ� ����� �������� ���� ��
const DIALOG_POPUP					= 2222;				// �����ۻ�� �� ������ �˾��޽����� ��� ��
const DIALOG_DROPITEM				= 3333;				// �������� �ٴڿ� ���� ��(�Ѱ�)
const DIALOG_DROPITEM_ASKCOUNT		= 4444;				// �������� �ٴڿ� ���� ��(������, ������ �����)
const DIALOG_DROPITEM_ALL			= 5555;				// �������� �ٴڿ� ���� ��(MoveAll ������ ��)
const DIALOG_DESTROYITEM			= 6666;				// �������� �����뿡 ���� ��(�Ѱ�)
const DIALOG_DESTROYITEM_ALL		= 7777;				// �������� �����뿡 ���� ��(MoveAll ������ ��)
const DIALOG_DESTROYITEM_ASKCOUNT	= 8888;				// �������� �����뿡 ���� ��(������, ������ �����)
const DIALOG_CRYSTALLIZE			= 9999;				// �������� ����ȭ �Ҷ�
const DIALOG_NOTCRYSTALLIZE		= 9998;				// ����ȭ�� �Ұ����ϴٴ� ���
const DIALOG_DROPITEM_PETASKCOUNT	= 10000;			// ���κ����� �������� ��ӵǾ��� ��

const EQUIPITEM_Underwear = 0;
const EQUIPITEM_Head = 1;
const EQUIPITEM_Hair = 2;
const EQUIPITEM_Hair2 = 3;
const EQUIPITEM_Neck = 4;
const EQUIPITEM_RHand = 5;
const EQUIPITEM_Chest = 6;
const EQUIPITEM_LHand = 7;
const EQUIPITEM_REar = 8;
const EQUIPITEM_LEar = 9;
const EQUIPITEM_Gloves = 10;
const EQUIPITEM_Legs = 11;
const EQUIPITEM_Feet = 12;
const EQUIPITEM_RFinger = 13;
const EQUIPITEM_LFinger = 14;
const EQUIPITEM_LBracelet = 15;
const EQUIPITEM_RBracelet = 16;
const EQUIPITEM_Deco1 = 17;
const EQUIPITEM_Deco2 = 18;
const EQUIPITEM_Deco3 = 19;
const EQUIPITEM_Deco4 = 20;
const EQUIPITEM_Deco5 = 21;
const EQUIPITEM_Deco6 = 22;
const EQUIPITEM_Cloak = 23;
const EQUIPITEM_Waist = 24;
const EQUIPITEM_Max = 25;

const INVENTORY_ITEM_TAB = 0;
const QUEST_ITEM_TAB = 1;

var WindowHandle		m_hInventoryWnd;
var	String				m_WindowName;
var	ItemWindowHandle	m_invenItem;
var	ItemWindowHandle	m_questItem;
var	ItemWindowHandle	m_equipItem[ EQUIPITEM_Max ];
var	ItemWindowHandle	m_hHennaItemWindow;
var	TextBoxHandle		m_hAdenaTextBox;
var	TabHandle			m_invenTab;
var	ButtonHandle		m_sortBtn;
var 	ButtonHandle 		m_BtnRotateLeft;
var 	ButtonHandle		m_BtnRotateRight;

var 	TextureHandle		m_CloakSlot_Disable;
var 	TextureHandle		m_Talisman_Disable[ 6 ];


//~ var 	ButtonHandle 		m_BtnZoomIn;
//~ var 	ButtonHandle		m_BtnZoomOut;
//~ var 	ButtonHandle		m_BtnZoomReset;


var 	CharacterViewportWindowHandle	m_ObjectViewport;


var	array<ItemID>		m_itemOrder;				// �κ��丮 �������� ������ ���ÿ� �����Ѵ�.
var	Vector				m_clickLocation;			// ������ ����Ҷ� ��� ����� ���� �����ϰ� �ִ´�.

var Array<ItemInfo>		m_EarItemList;
var Array<ItemInfo>		m_FingerItemLIst;
var Array<ItemInfo>		m_DecoItemList;

var int m_invenCount;
var bool m_bCurrentState;
var int m_MaxInvenCount;
var int m_MaxQuestItemInvenCount;
//var int m_ExtraInvenCount;
var int m_MeshType;
var int m_NpcID;

var ButtonHandle		m_hBtnCrystallize;

//~ var bool g_RBraceTurnOn;

var WindowHandle ColorNickNameWnd;

var int m_selectedItemTab;

//INVENORY EXPAND
var ButtonHandle m_BtnWindowExpand;
var ButtonHandle btnInfo;
var TextureHandle m_tabbg;
var TextureHandle m_tabbgLine;
var TextureHandle m_InventoryItembg_expand;
var int useExtendedInventory;
var int extraSlotsCount;
var int currentInvenCol;

//var bool isTalisman;

var TaliWnd script_tali;
var ItemControlWnd script_item;

function OnRegisterEvent()
{
	RegisterEvent(EV_InventoryClear);
	RegisterEvent(EV_InventoryOpenWindow);
	RegisterEvent(EV_InventoryHideWindow);
	RegisterEvent(EV_InventoryAddItem);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryItemListEnd);
	RegisterEvent(EV_InventoryAddHennaInfo);
	RegisterEvent(EV_InventoryToggleWindow);
	RegisterEvent(EV_UpdateHennaInfo);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_ChangeCharacterPawn );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="InventoryWnd";

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	//~ g_RBraceTurnOn = false;
	
	InitScrollBar();
	
	
	GetINIInt("Inventory", "extraSlots", extraSlotsCount, "PatchSettings");
	GetINIInt("Inventory", "useExtender", useExtendedInventory, "PatchSettings");
	currentInvenCol = extraSlotsCount + 6 + 1;
	if ( (currentInvenCol < 6) && (currentInvenCol > 12) )
	{
		currentInvenCol = 6;
	}
	if ( useExtendedInventory == 1 )
	{
		resizeInventory(extraSlotsCount);
	}
	
	m_bCurrentState = false;
	m_selectedItemTab = INVENTORY_ITEM_TAB;
	
	script_tali = TaliWnd(GetScript("TaliWnd"));
	script_item = ItemControlWnd(GetScript("ItemControlWnd"));
	
	btnInfo.SetTooltipCustomType(MakeTooltipSimpleText("Fast item delete - Ctrl + Alt + Click"));
}

function InitHandle()
{
	m_hInventoryWnd=GetHandle(m_WindowName);
	m_invenItem	= ItemWindowHandle(GetHandle(m_WindowName $ ".InventoryItem"));
	m_questItem	= ItemWindowHandle(GetHandle(m_WindowName $ ".QuestItem"));
	m_hAdenaTextBox = TextBoxHandle( GetHandle(m_WindowName $ ".AdenaText") );
	m_invenTab	= TabHandle(GetHandle(m_WindowName $ ".InventoryTab"));
	m_sortBtn	= ButtonHandle(GetHandle(m_WindowName $ ".SortButton"));
	
	m_BtnRotateLeft= ButtonHandle(GetHandle(m_WindowName $ ".BtnRotateLeft"));
	m_BtnRotateRight= ButtonHandle(GetHandle(m_WindowName $ ".BtnRotateRight"));
	//~ m_BtnZoomIn	= ButtonHandle(GetHandle(m_WindowName $ ".BtnZoomIn"));
	//~ m_BtnZoomOut	= ButtonHandle(GetHandle(m_WindowName $ ".BtnZoomOut"));
	//~ m_BtnZoomReset = ButtonHandle(GetHandle(m_WindowName $ ".BtnZoomReset"));
	
	m_ObjectViewport = CharacterViewportWindowHandle(GetHandle("InventoryWnd.ObjectViewport"));
	
	m_equipItem[ EQUIPITEM_Underwear ] = ItemWindowHandle( GetHandle( "EquipItem_Underwear" ) );
	m_equipItem[ EQUIPITEM_Head ] = ItemWindowHandle( GetHandle( "EquipItem_Head" ) );
	m_equipItem[ EQUIPITEM_Hair ] = ItemWindowHandle( GetHandle( "EquipItem_Hair" ) );
	m_equipItem[ EQUIPITEM_Hair2 ] = ItemWindowHandle( GetHandle( "EquipItem_Hair2" ) );
	m_equipItem[ EQUIPITEM_Neck ] = ItemWindowHandle( GetHandle( "EquipItem_Neck" ) );
	m_equipItem[ EQUIPITEM_RHand ] = ItemWindowHandle( GetHandle( "EquipItem_RHand" ) );
	m_equipItem[ EQUIPITEM_Chest ] = ItemWindowHandle( GetHandle( "EquipItem_Chest" ) );
	m_equipItem[ EQUIPITEM_LHand ] = ItemWindowHandle( GetHandle( "EquipItem_LHand" ) );
	m_equipItem[ EQUIPITEM_REar ] = ItemWindowHandle( GetHandle( "EquipItem_REar" ) );
	m_equipItem[ EQUIPITEM_LEar ] = ItemWindowHandle( GetHandle( "EquipItem_LEar" ) );
	m_equipItem[ EQUIPITEM_Gloves ] = ItemWindowHandle( GetHandle( "EquipItem_Gloves" ) );
	m_equipItem[ EQUIPITEM_Legs ] = ItemWindowHandle( GetHandle( "EquipItem_Legs" ) );
	m_equipItem[ EQUIPITEM_Feet ] = ItemWindowHandle( GetHandle( "EquipItem_Feet" ) );
	m_equipItem[ EQUIPITEM_RFinger ] = ItemWindowHandle( GetHandle( "EquipItem_RFinger" ) );
	m_equipItem[ EQUIPITEM_LFinger ] = ItemWindowHandle( GetHandle( "EquipItem_LFinger" ) );
	m_equipItem[ EQUIPITEM_LBracelet ] = ItemWindowHandle( GetHandle( "EquipItem_LBracelet" ) );
	m_equipItem[ EQUIPITEM_RBracelet ] = ItemWindowHandle( GetHandle( "EquipItem_RBracelet" ) );
	m_equipItem[ EQUIPITEM_Deco1 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman1" ) );
	m_equipItem[ EQUIPITEM_Deco2 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman2" ) );
	m_equipItem[ EQUIPITEM_Deco3 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman3" ) );
	m_equipItem[ EQUIPITEM_Deco4 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman4" ) );
	m_equipItem[ EQUIPITEM_Deco5 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman5" ) );
	m_equipItem[ EQUIPITEM_Deco6 ] = ItemWindowHandle( GetHandle( "EquipItem_Talisman6" ) );
	m_equipItem[ EQUIPITEM_Cloak ] = ItemWindowHandle( GetHandle( "EquipItem_Cloak" ) );
	m_equipItem[ EQUIPITEM_Waist ] = ItemWindowHandle( GetHandle( "EquipItem_Waist" ) );
	
	m_equipItem[ EQUIPITEM_LHand ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Head ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Gloves ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Legs ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Feet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Hair2 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_LBracelet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_RBracelet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco1 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco2 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco3 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco4 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco5 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco6 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_CloakSlot_Disable = TextureHandle(GetHandle(m_WindowName $ ".CloakSlot_Disable"));
	m_Talisman_Disable[ 0 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman1_Disable"));
	m_Talisman_Disable[ 1 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman2_Disable"));
	m_Talisman_Disable[ 2 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman3_Disable"));
	m_Talisman_Disable[ 3 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman4_Disable"));
	m_Talisman_Disable[ 4 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman5_Disable"));
	m_Talisman_Disable[ 5 ] = TextureHandle(GetHandle(m_WindowName $ ".Talisman6_Disable"));
                                                                                        
	m_hHennaItemWindow = ItemWindowHandle( GetHandle( "HennaItem" ) );
	m_hBtnCrystallize = ButtonHandle(GetHandle(m_WindowName $ ".CrystallizeButton"));
	
	m_InventoryItembg_expand = TextureHandle(GetHandle("InventoryWnd.InventoryItembg_expand"));
	m_tabbg = TextureHandle(GetHandle("InventoryWnd.tabbkg"));
	m_tabbgLine = TextureHandle(GetHandle("InventoryWnd.tabbkg_line"));
	m_BtnWindowExpand = ButtonHandle(GetHandle(m_WindowName $ ".BtnWindowExpand"));
	btnInfo = ButtonHandle(GetHandle(m_WindowName $ ".BtnInfo"));
	
	ColorNickNameWnd = GetHandle("ColorNickNameWnd");
}

function InitHandleCOD()
{
	m_hInventoryWnd=GetWindowHandle(m_WindowName);
	m_invenItem	= GetItemWindowHandle(m_WindowName $ ".InventoryItem");
	m_questItem	= GetItemWindowHandle(m_WindowName $ ".QuestItem");
	m_hAdenaTextBox = GetTextBoxHandle( m_WindowName $ ".AdenaText" );
	m_invenTab	= GetTabHandle(m_WindowName $ ".InventoryTab");
	m_sortBtn	= GetButtonHandle(m_WindowName $ ".SortButton");
	
	m_BtnRotateLeft= GetButtonHandle(m_WindowName $ ".BtnRotateLeft");
	m_BtnRotateRight= GetButtonHandle(m_WindowName $ ".BtnRotateRight");
	//~ m_BtnZoomIn	= GetButtonHandle(m_WindowName $ ".BtnZoomIn");
	//~ m_BtnZoomOut	= getButtonHandle(m_WindowName $ ".BtnZoomOut");
	//~ m_BtnZoomReset = getButtonHandle(m_WindowName $ ".BtnZoomReset");
	
	m_ObjectViewport = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport");
	

	m_equipItem[ EQUIPITEM_Underwear ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Underwear" );
	m_equipItem[ EQUIPITEM_Head ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Head" );
	m_equipItem[ EQUIPITEM_Hair ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Hair" );
	m_equipItem[ EQUIPITEM_Hair2 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Hair2" );
	m_equipItem[ EQUIPITEM_Neck ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Neck" );
	m_equipItem[ EQUIPITEM_RHand ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_RHand" );
	m_equipItem[ EQUIPITEM_Chest ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Chest" );
	m_equipItem[ EQUIPITEM_LHand ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_LHand" );
	m_equipItem[ EQUIPITEM_REar ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_REar" );
	m_equipItem[ EQUIPITEM_LEar ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_LEar" );
	m_equipItem[ EQUIPITEM_Gloves ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Gloves" );
	m_equipItem[ EQUIPITEM_Legs ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Legs" );
	m_equipItem[ EQUIPITEM_Feet ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Feet" );
	m_equipItem[ EQUIPITEM_RFinger ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_RFinger" );
	m_equipItem[ EQUIPITEM_LFinger ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_LFinger" );
	m_equipItem[ EQUIPITEM_LBracelet ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_LBracelet" );
	m_equipItem[ EQUIPITEM_RBracelet ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_RBracelet" );
	m_equipItem[ EQUIPITEM_Deco1 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman1" );
	m_equipItem[ EQUIPITEM_Deco2 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman2" );
	m_equipItem[ EQUIPITEM_Deco3 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman3" );
	m_equipItem[ EQUIPITEM_Deco4 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman4" );
	m_equipItem[ EQUIPITEM_Deco5 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman5" );
	m_equipItem[ EQUIPITEM_Deco6 ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Talisman6" );
	m_equipItem[ EQUIPITEM_Cloak ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Cloak" ); 
	m_equipItem[ EQUIPITEM_Waist ] = GetItemWindowHandle( m_WindowName $ ".EquipItem_Waist" );
	
	m_equipItem[ EQUIPITEM_LHand ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Head ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Gloves ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Legs ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Feet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_equipItem[ EQUIPITEM_Hair2 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_LBracelet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_RBracelet ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco1 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco2 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco3 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco4 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco5 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	//~ m_equipItem[ EQUIPITEM_Deco6 ].SetDisableTex( "L2UI.InventoryWnd.Icon_dualcap" );
	m_CloakSlot_Disable = GetTextureHandle(m_WindowName $ ".CloakSlot_Disable");
	m_Talisman_Disable[ 0 ] = GetTextureHandle(m_WindowName $ ".Talisman1_Disable");
	m_Talisman_Disable[ 1 ] = GetTextureHandle(m_WindowName $ ".Talisman2_Disable");
	m_Talisman_Disable[ 2 ] = GetTextureHandle(m_WindowName $ ".Talisman3_Disable");
	m_Talisman_Disable[ 3 ] = GetTextureHandle(m_WindowName $ ".Talisman4_Disable");
	m_Talisman_Disable[ 4 ] = GetTextureHandle(m_WindowName $ ".Talisman5_Disable");
	m_Talisman_Disable[ 5 ] = GetTextureHandle(m_WindowName $ ".Talisman6_Disable");
                                                                                
	m_hHennaItemWindow = GetItemWindowHandle( m_WindowName$".HennaItem"  );
	m_hBtnCrystallize = GetButtonHandle(m_WindowName $ ".CrystallizeButton");
	
	m_InventoryItembg_expand = GetTextureHandle("InventoryWnd.InventoryItembg_expand");
	m_tabbg = GetTextureHandle("InventoryWnd.tabbkg");
	m_tabbgLine = GetTextureHandle("InventoryWnd.tabbkg_line");
	m_BtnWindowExpand = GetButtonHandle(m_WindowName $ ".BtnWindowExpand");
	btnInfo = GetButtonHandle(m_WindowName $ ".BtnInfo");

	ColorNickNameWnd = GetWindowHandle("ColorNickNameWnd");
}

function InitScrollBar()
{
	m_invenItem.SetScrollBarPosition( 0, 17, 0 );
	m_questItem.SetScrollBarPosition( 0, 17, 0 );
}

function OnEvent(int Event_ID, string param)
{
//	debug("Inven Event ID :" $string(Event_ID)$" "$param);
	switch( Event_ID )
	{
	case EV_InventoryClear:
		HandleClear();
		break;
	case EV_InventoryOpenWindow:
		HandleOpenWindow(param);
		break;
	case EV_InventoryHideWindow:
		HandleHideWindow();
		break;
	case EV_InventoryAddItem:
		//~ debug ("add item");
		HandleAddItem(param);
		break;
	case EV_InventoryUpdateItem:
		//~ debug ("update item" @ param);
		HandleUpdateItem(param);
		//FingerItemUpdate();
		break;
	case EV_InventoryItemListEnd:
		HandleItemListEnd();
		break;
	case EV_InventoryAddHennaInfo:
		HandleAddHennaInfo(param);
		break;
	case EV_UpdateHennaInfo:
		HandleUpdateHennaInfo(param);
		break;
	case EV_InventoryToggleWindow:
		HandleToggleWindow();
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_UpdateUserInfo:
		HandleUpdateUserInfo();
		break;
	case EV_Restart:
		HandleRestart();
		//~ SaveInventoryOrder();
		break;
	case EV_SetMaxCount:
		HandleSetMaxCount(param);
		//~ debug("Got Event SetMaxCount" @ param);
		break;
	case EV_ChangeCharacterPawn:
		HandleChangeCharacterPawn(param);
		break;
	default:
		break;
	};
}

function OnShow()
{
	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();

	UpdateHennaInfo();
	if ( useExtendedInventory == 1 )
	{
		resizeInventory(extraSlotsCount);
	}
}

function SwitchExtendedInventory ()
{
	GetINIInt("Inventory", "extraSlots", extraSlotsCount, "PatchSettings");
  
	if ( currentInvenCol != 6 )
	{
		resizeInventory(-1);
		useExtendedInventory = 0;
	} else 
	{
		resizeInventory(extraSlotsCount);
		useExtendedInventory = 1;
	}
	SetINIInt("Inventory", "useExtender", useExtendedInventory, "PatchSettings");
	
}

function resizeInventory (int nSlotsCount)
{
  local int Width;
  local int Height;
  local int tmp_Width;
  local int toExpandWidth;

  m_InventoryItembg_expand.GetWindowSize(Width,Height);
  nSlotsCount = nSlotsCount + 1;
  currentInvenCol = 6 + nSlotsCount;
  if ( nSlotsCount > 0 )
  {
    tmp_Width = (nSlotsCount + 1) * 36 + 1;
    m_BtnWindowExpand.SetTexture("L2UI_edKith.frames_df_Btn_Minimize","L2UI_edKith.frames_df_btn_Minimize_down","L2UI_edKith.frames_df_btn_Minimize_over");
  } else {
    tmp_Width = 1; //deafult 1
    m_BtnWindowExpand.SetTexture("L2UI_edKith.frames_df_btn_Expand","L2UI_edKith.frames_df_btn_Expand_down","L2UI_edKith.frames_df_btn_Expand_over");
  }
  if ( Width != tmp_Width )
  {
    if ( nSlotsCount > 0 )
    {
      currentInvenCol = 6 + nSlotsCount;
      toExpandWidth = 36 * nSlotsCount;
    } else {
      currentInvenCol = 6;
      toExpandWidth = 0;
    }
    m_hInventoryWnd.SetWindowSize(446 + toExpandWidth,394);
    m_invenItem.SetWindowSize(231 + toExpandWidth,288);
    m_questItem.SetWindowSize(231 + toExpandWidth,288);
    m_InventoryItembg_expand.SetWindowSize(1 + toExpandWidth,288);
    m_tabbg.SetWindowSize(242 + toExpandWidth,321);
    m_tabbgLine.SetWindowSize(69 + toExpandWidth,23);
    m_invenItem.SetCol(currentInvenCol);
    m_questItem.SetCol(currentInvenCol);
  }
}


function CheckShowCrystallizeButton()
{
	if( class'UIDATA_PLAYER'.static.HasCrystallizeAbility() )
		m_hBtnCrystallize.ShowWindow();
	else
		m_hBtnCrystallize.HideWindow();
}


function OnHide()
{
	if( m_bCurrentState )
		SaveInventoryOrder();
}

//Check GamingState - Start
function HandleRestart()
{
	m_bCurrentState = false;
}
function OnEnterState( name a_PrevStateName )
{
	m_bCurrentState = true;
}
function OnExitState( name a_NextStateName )
{
	m_bCurrentState = false;
}

// ItemWindow Event
function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	debug("item db_click");
	UseItem( a_hItemWindow, index );
	
}

function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	debug("OnRClickItem");
	UseItem( a_hItemWindow, index );
}

function OnSelectItemWithHandle( ItemWindowHandle a_hItemWindow, int a_Index )
{
	local int i;
	local ItemInfo info;
	local string ItemName;

	//TextLink
	if( IsKeyDown( IK_Shift ) )
	{
		a_hItemWindow.GetSelectedItem( info );
		ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName( info.Name, info.RefineryOp1, info.RefineryOp2 );
		SetItemTextLink( info.ID, ItemName );
		//printItemInfo(info);
		//sysDebug(string(info.ID.ServerID)$" + "$ string(info.ID.ClassID));
		//sysDebug(string(class'UIDATA_PLAYER'.static.GetPlayerID()));
	}
	
	//DeleteItem
	if( IsKeyDown( IK_Alt ) && IsKeyDown( IK_Ctrl ) )
	{
		a_hItemWindow.GetSelectedItem( info );
		RequestDestroyItem(info.ID, info.ItemNum);
	}
	
	if( a_hItemWindow == m_invenItem )
		return;

	if( a_hItemWindow == m_questItem )
		return;

	for( i = 0; i < EQUIPITEM_MAX; ++i )
	{
		if( a_hItemWindow != m_equipItem[ i ] )
			m_equipItem[ i ].ClearSelect();
	}
}

function OnDropItem( String strTarget, ItemInfo info, int x, int y )
{
	local int toIndex, fromIndex;

	// �κ��丮���� �� ���� �ƴϸ� ó������ �ʴ´�.
	debug("Inventory OnDropItem dest " $ strTarget $ ", source " $ info.DragSrcName $ " x:" $ x $ ", y:" $ y);
	if( !(info.DragSrcName == "InventoryItem" || info. DragSrcName == "QuestItem" || -1 != InStr( info.DragSrcName, "EquipItem" ) || info.DragSrcName == "PetInvenWnd") )
		return;

	
	if( strTarget == "InventoryItem" )
	{
		if( info.DragSrcName == "InventoryItem" )			// Change Item position
		{
			toIndex = m_invenItem.GetIndexAt( x, y, 1, 1 );
			
			// Exchange with another item
			if( toIndex >= 0 )
			{
				fromIndex = m_invenItem.FindItem(info.ID);
				if( toIndex != fromIndex )
					m_invenItem.SwapItems( fromIndex, toIndex );
			}
		}
		else if( -1 != InStr( info.DragSrcName, "EquipItem" ) )			// Unequip thie item
		{
			RequestUnequipItem(info.ID, info.SlotBitType);
		}
		else if( info.DragSrcName == "PetInvenWnd" )		// Pet -> Inventory
		{
			if( IsStackableItem(info.ConsumeType) && info.ItemNum > IntToInt64(1) )			// Multiple item?
			{
				if( info.AllItemCount > IntToInt64(0) )					// ���� �ű� ���ΰ�
				{
					if ( CheckItemLimit( info.ID, info.AllItemCount ) )
					{
						class'PetAPI'.static.RequestGetItemFromPet( info.ID, info.AllItemCount, false);
					}
				}
				else
				{
					DialogSetID(DIALOG_DROPITEM_PETASKCOUNT);
					DialogSetReservedItemID(info.ID);	// ServerID
					DialogSetParamInt64(info.ItemNum);
					DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name ) );
				}
			}
			else																// Single item?
			{
				class'PetAPI'.static.RequestGetItemFromPet( info.ID, IntToInt64(1), false);
			}
		}
	}
	else if( strTarget == "QuestItem" )
	{
		if( info.DragSrcName == "QuestItem" )			// Change Item position
		{
			toIndex = m_questItem.GetIndexAt( x, y, 1, 1 );
			if( toIndex >= 0 )			// Exchange with another item
			{
				fromIndex = m_questItem.FindItem(info.ID);	// ServerID
				if( toIndex != fromIndex )
				{
					// �ΰ��� while �� �߿� ������ �Ѱ����� ����.
					while( fromIndex < toIndex )		// ������ �����
					{
						m_questItem.SwapItems( fromIndex, fromIndex + 1 );
						++fromIndex;
					}

					while( toIndex < fromIndex )		// �ڷ� �о��
					{
						m_questItem.SwapItems( fromIndex, fromIndex - 1 );
						--fromIndex;
					}
				}
			}
			else						// move this item to last
			{
				fromIndex = m_invenItem.GetItemNum();
				while( toIndex < fromIndex - 1 )
				{
					m_invenItem.SwapItems( toIndex, toIndex + 1 );
					++toIndex;
				};
			}
		}
	}
	else if( -1 != InStr( strTarget, "EquipItem" ) ||  strTarget == "ObjectViewportDispatchMsg" )		// Equip the item
	{
		debug("Inven EquipItem: " $info.DragSrcName $" " $string(info.ItemType));
		if( info.DragSrcName == "PetInvenWnd" )				// Pet -> Equip
		{
			class'PetAPI'.static.RequestGetItemFromPet( info.ID, IntToInt64(1), true );
		}
		else if( -1 != InStr( info.DragSrcName, "EquipItem" ) )	//�ƹ��͵� ���� �ʴ´�. 
		{
		}
		else if( EItemType(info.ItemType) != ITEM_ETCITEM )
		{
			debug("RequestuseItem");
			RequestUseItem(info.ID);
		}
	}
	else if( strTarget == "TrashButton" )					// Destroy item( after confirmation )
	{
		if( IsStackableItem(info.ConsumeType) && info.ItemNum > IntToInt64(1) )			// Multiple item?
		{
			if( info.AllItemCount > IntToInt64(0) )				// ���� ���� ���ΰ�
			{				
				DialogSetID(DIALOG_DESTROYITEM_ALL);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetReservedInt2(info.AllItemCount);
				DialogShow(DIALOG_Modalless,DIALOG_Warning, MakeFullSystemMsg(GetSystemMessage(74), info.Name, ""));
			}
			else
			{
				DialogSetID(DIALOG_DESTROYITEM_ASKCOUNT);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetParamInt64(info.ItemNum);
				DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(73), info.Name ) );
			}
		}
		else																// Single item?
		{
			// �ļ��Ϸ� �Ҷ�, ����ȭ�� ������ ��Ȳ�̸� �׳� ����ȭ
			if( class'UIDATA_PLAYER'.static.HasCrystallizeAbility() && class'UIDATA_ITEM'.static.IsCrystallizable(info.ID) )			
			{
				DialogSetID(DIALOG_CRYSTALLIZE);
				DialogSetReservedItemID(info.ID);
				DialogShow(DIALOG_Modalless,DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2232), info.Name ) );
			}
			else
			{
				DialogSetID(DIALOG_DESTROYITEM);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(74), info.Name ) );
			}
		}
	}
	else if( strTarget == "CrystallizeButton" )
	{
		if( info.DragSrcName == "InventoryItem" || ( -1 != InStr( info.DragSrcName, "EquipItem" ) ) )
		{
			if( class'UIDATA_PLAYER'.static.HasCrystallizeAbility() && class'UIDATA_ITEM'.static.IsCrystallizable(info.ID) )			// Show Dialog asking confirmation
			{
				DialogSetID(DIALOG_CRYSTALLIZE);
				DialogSetReservedItemID(info.ID);
				DialogShow(DIALOG_Modalless,DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(336), info.Name ) );
			}
			else
			{
				DialogSetID(DIALOG_NOTCRYSTALLIZE);
				DialogShow(DIALOG_Modalless,DIALOG_Notice, MakeFullSystemMsg( GetSystemMessage(2171), info.Name ) );				
			}
		}
	}	
	//~ SaveInventoryOrder();
}

// ���� ������ â���� �������� �ű�� ���� OnDropItem ���� �ذ��ϵ��� �ϰ� ���⼭�� �ٴڿ� ������ ��Ȳ�� ó���Ѵ�.
function OnDropItemSource( String strTarget, ItemInfo info )
{
	if( strTarget == "Console" )
	{
		if( info.DragSrcName == "InventoryItem" || info.DragSrcName == "QuestItem"
			|| ( -1 != InStr( info.DragSrcName, "EquipItem" ) ) )
		{
			m_clickLocation = GetClickLocation();
			if( IsStackableItem(info.ConsumeType) && info.ItemNum > IntToInt64(1) )		// ������ �ִ� ������
			{
				if( info.AllItemCount > IntToInt64(0) )				// ���� ���� ���ΰ�
				{
					DialogHide();
					DialogSetID( DIALOG_DROPITEM_ALL );
					DialogSetReservedItemID(info.ID);	// ServerID
					DialogSetReservedInt2(info.AllItemCount);
					DialogShow(DIALOG_Modalless,DIALOG_Warning, MakeFullSystemMsg(GetSystemMessage(1833), info.Name, ""));
				}
				else												// ���ڸ� ��� ���ΰ�
				{
					DialogHide();
					DialogSetID( DIALOG_DROPITEM_ASKCOUNT );
					DialogSetReservedItemID(info.ID);	// ServerID
					DialogSetParamInt64(info.ItemNum);
					DialogShow(DIALOG_Modalless,DIALOG_NumberPad, MakeFullSystemMsg(GetSystemMessage(71), info.Name, ""));
				}
			}
			else
			{
				DialogHide();
				DialogSetID( DIALOG_DROPITEM );
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogShow(DIALOG_Modalless,DIALOG_Warning, MakeFullSystemMsg(GetSystemMessage(400), info.Name, ""));
			}
		}
	}
	//~ SaveInventoryOrder();
}

function bool IsEquipItem( out ItemInfo info )
{
	return info.bEquipped;
}

function bool IsQuestItem( out ItemInfo info )
{
	return EItemtype(info.ItemType) == ITEM_QUESTITEM;
}
 
function HandleClear()
{
	InvenClear();
	EquipItemClear();
	m_questItem.Clear();
	
	m_EarItemList.Length = 0;
	m_FingerItemLIst.Length = 0;
	m_DecoItemList.Length = 0;
}

function int EquipItemGetItemNum()
{
	local int i;
	local int ItemNum;

	for( i = 0; i < EQUIPITEM_Max; ++i )
	{
		if(m_equipItem[ i ].IsEnableWindow())	// ��Ʈ�������� �ϳ��� ����. 
		{
			ItemNum = ItemNum + m_equipItem[ i ].GetItemNum();
		}
	}

	return ItemNum;
}

function EquipItemClear()
{
	local int i;

	for( i = 0; i < EQUIPITEM_Max; ++i )
		m_equipItem[ i ].Clear();
}

function bool EquipItemFind( ItemID sID )
{
	local int i;
	local int Index;

	for( i = 0; i < EQUIPITEM_Max; ++i )
	{
		Index = m_equipItem[ i ].FindItem( sID );	// ServerID
		if( -1 != Index )
			return true;
	}

	return false;
}

function EquipItemDelete( ItemID sID )
{
	local int i;
	local int Index;
	local ItemInfo TheItemInfo;

	for( i = 0; i < EQUIPITEM_Max; ++i )
	{
		Index = m_equipItem[ i ].FindItem( sID );	// ServerID
		if( -1 != Index )
		{
			m_equipItem[ i ].Clear();

			// ȭ���� ������ ���, ���ڸ��� Ȱ ����� ǥ�õǾ���Ѵ�.
			if( i == EQUIPITEM_LHand )
			{
				if( m_equipItem[ EQUIPITEM_RHand ].GetItem( 0, TheItemInfo ) )
				{
					if( TheItemInfo.SlotBitType == 16384 )
					{
						m_equipItem[ EQUIPITEM_LHand ].Clear();
						m_equipItem[ EQUIPITEM_LHand ].AddItem( TheItemInfo );
						m_equipItem[ EQUIPITEM_LHand ].DisableWindow();
					}
					
				}
			}
			
			if ( i >= EQUIPITEM_Deco1 && i <= EQUIPITEM_Deco6) //TaliWnd
				script_tali.tal[i - 17].Clear();
			else if ( i == EQUIPITEM_Waist )
				script_item.item3.Clear();
			else if ( i == EQUIPITEM_RFinger )
				script_item.item2.Clear();
			else if ( ( i == EQUIPITEM_RHand ) )
				script_item.item4.Clear();
			else if ( i == EQUIPITEM_Neck )
				script_item.item1.Clear();
			else if ( i == EQUIPITEM_LHand )
			{
				script_item.item5.Clear();
				script_item.tex5.SetTexture("");
				script_item.Me.SetWindowSize( 164 , 42 );
			}
		}
	}
}

function EarItemUpdate()
{
	local int i;
	local int LEarIndex, REarIndex;

	LEarIndex = -1;
	REarIndex = -1;

	for( i = 0; i < m_EarItemList.Length; ++i )
	{
		switch( IsLOrREar( m_EarItemList[i].ID ) )
		{
		case -1:
			LEarIndex = i;
			break;
		case 0:
			m_EarItemList.Remove( i, 1 );
			break;
		case 1:
			REarIndex = i;
			break;
		}
	}

	if( -1 != LEarIndex )
	{
		//~ debug("���� �Ͱ���");
		m_equipItem[ EQUIPITEM_LEar ].Clear();
		m_equipItem[ EQUIPITEM_LEar ].AddItem( m_EarItemList[ LEarIndex ] );
	}

	if( -1 != REarIndex )
	{
		//~ debug("������ �Ͱ���");
		m_equipItem[ EQUIPITEM_REar ].Clear();
		m_equipItem[ EQUIPITEM_REar ].AddItem( m_EarItemList[ REarIndex ] );
	}
}

//~ Function RBraceletItemUpdate()
//~ {
	//~ local int i;
	//~ if (g_RBraceTurnOn)
	//~ {
		//~ m_equipItem[ EQUIPITEM_Deco1 ].EnableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco2 ].EnableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco3 ].EnableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco4 ].EnableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco5 ].EnableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco6 ].EnableWindow();
	//~ }
	//~ else
	//~ {
		//~ m_equipItem[ EQUIPITEM_Deco1 ].DisableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco2 ].DisableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco3 ].DisableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco4 ].DisableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco5 ].DisableWindow();
		//~ m_equipItem[ EQUIPITEM_Deco6 ].DisableWindow();
	//~ }
//~ }



function FingerItemUpdate()
{
	local int i;
	local int LFingerIndex, RFingerIndex;

	LFingerIndex = -1;
	RFingerIndex = -1;

	for( i = 0; i < m_FingerItemList.Length; ++i )
	{
		switch( IsLOrRFinger( m_FingerItemList[i].ID ) )
		{
		case -1:
			LFingerIndex = i;
			break;
		case 0:
			m_FingerItemList.Remove( i, 1 );
			break;
		case 1:
			RFingerIndex = i;
			break;
		}
	}

	if( -1 != LFingerIndex )
	{
		m_equipItem[ EQUIPITEM_LFinger ].Clear();
		m_equipItem[ EQUIPITEM_LFinger ].AddItem( m_FingerItemList[ LFingerIndex ] );
	}

	if( -1 != RFingerIndex )
	{
		m_equipItem[ EQUIPITEM_RFinger ].Clear();
		m_equipItem[ EQUIPITEM_RFinger ].AddItem( m_FingerItemList[ RFingerIndex ] );
		
		script_item.item2.Clear();
		script_item.item2.AddItem(m_FingerItemList[ RFingerIndex ]);
	}
}


//~ function DecoItemUpdate()
//~ {
	//~ local int i;
	//~ local int LFingerIndex, RFingerIndex;

	//~ LFingerIndex = -1;
	//~ RFingerIndex = -1;

	//~ for( i = 0; i < m_DecoItemList.Length; ++i )
	//~ {
		//~ switch( IsLOrRFinger( m_FingerItemList[i].ID ) )
		//~ {
		//~ case -1:
			//~ LFingerIndex = i;
			//~ break;
		//~ case 0:
			//~ m_FingerItemList.Remove( i, 1 );
			//~ break;
		//~ case 1:
			//~ RFingerIndex = i;
			//~ break;
		//~ }
	//~ }

	//~ if( -1 != LFingerIndex )
	//~ {
		//~ m_equipItem[ EQUIPITEM_LFinger ].Clear();
		//~ m_equipItem[ EQUIPITEM_LFinger ].AddItem( m_FingerItemList[ LFingerIndex ] );
	//~ }

	//~ if( -1 != RFingerIndex )
	//~ {
		//~ m_equipItem[ EQUIPITEM_RFinger ].Clear();
		//~ m_equipItem[ EQUIPITEM_RFinger ].AddItem( m_FingerItemList[ RFingerIndex ] );
	//~ }
//~ }


function EquipItemUpdate( ItemInfo a_info )
{
	local ItemWindowHandle hItemWnd;
	local ItemInfo TheItemInfo;
	local bool ClearLHand;
	local ItemInfo RHand;
	local ItemInfo LHand;
	local ItemInfo Legs;
	local ItemInfo Gloves;
	local ItemInfo Feet;
	local ItemInfo Hair2;
	local SkillInfo TalismanSkill;
	local int i;
	//~ local int j;
	local int decoIndex;
	//~ Debug ("���� ���� ���� Ÿ��:" @ a_Info.SlotBitType);
	//~ Debug ("���� ��Ż" @ a_Info.SlotBitType );
	
	//~ UpdateTalismanSlotActivation();
	//~ UpdateCloakSlotActivation();
	
	//~ if (!m_equipItem[ EQUIPITEM_Cloak ].IsEnableWindow())
	//~ if( m_equipItem[ EQUIPITEM_Cloak ].GetItem( 0, TheItemInfo ) )
	//~ {
		//~ Debug("Equip Item Cloak Check");
		//~ UpdateCloakSlotActivation();
	//~ }
	
	//isTalisman = false;
	
	switch( a_Info.SlotBitType )
	{
	case 1:		// SBT_UNDERWEAR
		hItemWnd = m_equipItem[ EQUIPITEM_Underwear ];
		break;
	case 2:		// SBT_REAR
	case 4:		// SBT_LEAR
	case 6:		// SBT_RLEAR
		for( i = 0; i < m_EarItemList.Length; ++i )
		{
			if( IsSameServerID(m_EarItemList[ i ].ID, a_Info.ID) )
			{
				m_EarItemList[ i ] = a_Info;
				break;
			}
		}

		// �� ã���� ���� �߰�
		if( i == m_EarItemList.Length )
		{
			m_EarItemList.Length = m_EarItemList.Length + 1;
			m_EarItemList[m_EarItemList.Length-1] = a_Info;
		}

		hItemWnd = None;
		EarItemUpdate();
		break;
	case 8:		// SBT_NECK
		hItemWnd = m_equipItem[ EQUIPITEM_Neck ];
		break;
	case 16:	// SBT_RFINGER
	case 32:	// SBT_LFINGER
	case 48:	// SBT_RLFINGER
		for( i = 0; i < m_FingerItemList.Length; ++i )
		{
			if( IsSameServerID(m_FingerItemList[ i ].ID, a_Info.ID) )
			{
				m_FingerItemList[ i ] = a_Info;
				break;
			}
		}

		// �� ã���� ���� �߰�
		if( i == m_FingerItemList.Length )
		{
			m_FingerItemList.Length = m_FingerItemList.Length + 1;
			m_FingerItemList[m_FingerItemList.Length-1] = a_Info;
		}

		hItemWnd = None;
		FingerItemUpdate();
		break;
	case 64:	// SBT_HEAD
		hItemWnd = m_equipItem[ EQUIPITEM_Head ];
		hItemWnd.EnableWindow();
		//~ UpdateCloakSlotActivation();
		break;
	case 128:	// SBT_RHAND
		hItemWnd = m_equipItem[ EQUIPITEM_RHand ];
		break;
	case 256:	// SBT_LHAND
		hItemWnd = m_equipItem[ EQUIPITEM_LHand ];
		hItemWnd.EnableWindow();
		break;
	case 512:	// SBT_GLOVES
		hItemWnd = m_equipItem[ EQUIPITEM_Gloves ];
		hItemWnd.EnableWindow();
		// Updates cloak slot activation when the cloak slot has not equipped. Only applied to Gloves, Chest, Legs, Feet slots.
		//~ if (!m_equipItem[ EQUIPITEM_Cloak ].IsEnableWindow())
		//~ {
			//~ UpdateCloakSlotActivation();
		//~ }
	
		break;
	case 1024:	// SBT_CHEST
		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];
		// Updates cloak slot activation when the cloak slot has not equipped. Only applied to Gloves, Chest, Legs, Feet slots.
		//~ if (!m_equipItem[ EQUIPITEM_Cloak ].IsEnableWindow())
		//~ {
			//~ UpdateCloakSlotActivation();
		//~ }
	
		break;
	case 2048:	// SBT_LEGS
		hItemWnd = m_equipItem[ EQUIPITEM_Legs ];
		hItemWnd.EnableWindow();
		// Updates cloak slot activation when the cloak slot has not equipped. Only applied to Gloves, Chest, Legs, Feet slots.
		//~ if (!m_equipItem[ EQUIPITEM_Cloak ].IsEnableWindow())
		//~ {
			//~ UpdateCloakSlotActivation();
		//~ }
	
		break;
	case 4096:	// SBT_FEET
		hItemWnd = m_equipItem[ EQUIPITEM_Feet ];
		hItemWnd.EnableWindow();
		// Updates cloak slot activation when the cloak slot has not equipped. Only applied to Gloves, Chest, Legs, Feet slots.
		//~ if( m_equipItem[ EQUIPITEM_Cloak ].GetItem( 0, TheItemInfo ) )
		
		//~ {
		//~ if (!m_equipItem[ EQUIPITEM_Cloak ].IsEnableWindow())
		//~ {
			//~ Debug("Equip Item Cloak Check");
			//~ UpdateCloakSlotActivation();
		//~ }
		//~ else
		//~ {
			//~ Debug("Equip Item Cloak None");
		//~ }
	
		break;
	case 8192:	// SBT_BACK
		
		hItemWnd = m_equipItem[ EQUIPITEM_Cloak ];
		//~ Debug ("���� ��Ż");
		hItemWnd.EnableWindow();
		break;
	
	case 16384:	// SBT_RLHAND
		hItemWnd = m_equipItem[ EQUIPITEM_RHand ];
		ClearLHand = true;

	//~ debug("������� ��ȣ?"@  a_Info.WeaponType);
	
		// RHand�� Bow�� ���Դµ�, LHand�� ȭ���� �ִ� ��� ȭ���� �״�� �����ش� - NeverDie
		if( IsBowOrFishingRod( a_Info ) )
		{
			if( m_equipItem[ EQUIPITEM_LHand ].GetItem( 0, TheItemInfo ) )
			{
				if( IsArrow( TheItemInfo ) )
					ClearLHand = false;
			}
		}
		
		// ������� ���������� ���� ���� ������� ��Ʈ�� �����ش�. 
		if( IsBowOrFishingRod( a_Info ) )
		{
			if( m_equipItem[ EQUIPITEM_LHand ].GetItem( 0, TheItemInfo ) )
			{
				if( IsArrow( TheItemInfo ) )
					ClearLHand = false;
			}
		}
		
		
		
		if( ClearLHand )	//LRHAND ��쿡�� ex1 , ex2 �� �ִ°� �ְ� ���°� �־ ���� ó���� �ʿ��մϴ�. ;; -innowind
		{
			if(Len(a_Info.IconNameEx1) !=0)
			{
				RHand = a_info;
				LHand = a_info;				
				RHand.IconIndex = 1;
				LHand.IconIndex = 2;
				//RHand.IconName = a_Info.IconNameEx1;
				//LHand.IconName = a_Info.IconNameEx2;
				m_equipItem[ EQUIPITEM_RHand ].Clear();
				m_equipItem[ EQUIPITEM_RHand ].AddItem( RHand );
				//m_equipItem[ EQUIPITEM_RHand ].DisableWindow();
				m_equipItem[ EQUIPITEM_LHand ].Clear();
				m_equipItem[ EQUIPITEM_LHand ].AddItem( LHand );
				m_equipItem[ EQUIPITEM_LHand ].DisableWindow();
				script_item.item4.Clear();
				script_item.item4.AddItem(a_Info);
				hItemWnd = None;	// ������ �̹����� ������ �ʵ��� �⺻ ������ �����ش�.
			}
			else	// Ȱ�̳� â���� �������̹����� �Ȱ��� ���.
			{
				m_equipItem[ EQUIPITEM_LHand ].Clear();
				m_equipItem[ EQUIPITEM_LHand ].AddItem( a_Info );
				m_equipItem[ EQUIPITEM_LHand ].DisableWindow();				
			}
			
		}
		break;
	case 32768:	// SBT_ONEPIECE
		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];
		Legs = a_Info;
		Legs.IconName = a_Info.IconNameEX2;	//���� �������� �׷��ش�. 
		m_equipItem[ EQUIPITEM_Legs ].Clear();		
		m_equipItem[ EQUIPITEM_Legs ].AddItem( Legs );
		m_equipItem[ EQUIPITEM_Legs ].DisableWindow();	
		break;
	case 65536:	// SBT_HAIR
		hItemWnd = m_equipItem[ EQUIPITEM_Hair ];
		break;
	case 131072:	// SBT_ALLDRESS
		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];
		Hair2 = a_info;	//������ head�� �����־�� ������ �޸� ������������ hair2�� �ֽ��ϴ�. - innowind
		Gloves = a_info;
		Legs = a_info;
		Feet = a_info;
		Hair2.IconName = a_Info.IconNameEx1;
		Gloves.IconName = a_Info.IconNameEx2;
		Legs.IconName = a_Info.IconNameEx3;
		Feet.IconName = a_Info.IconNameEx4;
		m_equipItem[ EQUIPITEM_Head ].Clear();
		m_equipItem[ EQUIPITEM_Head ].AddItem( Hair2 );
		m_equipItem[ EQUIPITEM_Head ].DisableWindow();
		m_equipItem[ EQUIPITEM_Gloves ].Clear();
		m_equipItem[ EQUIPITEM_Gloves ].AddItem( Gloves );
		m_equipItem[ EQUIPITEM_Gloves ].DisableWindow();
		m_equipItem[ EQUIPITEM_Legs ].Clear();
		m_equipItem[ EQUIPITEM_Legs ].AddItem( Legs );
		m_equipItem[ EQUIPITEM_Legs ].DisableWindow();
		m_equipItem[ EQUIPITEM_Feet ].Clear();
		m_equipItem[ EQUIPITEM_Feet ].AddItem( Feet );
		m_equipItem[ EQUIPITEM_Feet ].DisableWindow();
		break;
	case 262144:	// SBT_HAIR2
		hItemWnd = m_equipItem[ EQUIPITEM_Hair2 ];
		hItemWnd.EnableWindow();
		break;
	case 524288:	// SBT_HAIRALL
		hItemWnd = m_equipItem[ EQUIPITEM_Hair ];
		//Hair2 = a_info;
		//Hair2.IconName = a_Info.IconNameEx2;
		m_equipItem[ EQUIPITEM_Hair2 ].Clear();
		m_equipItem[ EQUIPITEM_Hair2 ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_Hair2 ].DisableWindow();
		break;
	case 1048576: //SBT_RBracelet
		hItemWnd = m_equipItem[ EQUIPITEM_RBracelet ];
		m_equipItem[ EQUIPITEM_RBracelet ].Clear();
		m_equipItem[ EQUIPITEM_RBracelet ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_RBracelet ].EnableWindow();
		
		//~ g_RBraceTurnOn = true;
		//~ RBraceletItemUpdate();
		
	

		break;

	case  2097152: 	 //SBT_LBracelet
		hItemWnd = m_equipItem[ EQUIPITEM_LBracelet ];
		m_equipItem[ EQUIPITEM_LBracelet ].Clear();
		m_equipItem[ EQUIPITEM_LBracelet ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_LBracelet ].EnableWindow();
		
		// Updates Talisman Item slot activation when the Bracelet slot has not equipped. 
		//~ if (!m_equipItem[ EQUIPITEM_Deco1 ].IsEnableWindow())
		//~ {
		//~ UpdateTalismanSlotActivation();
		//~ }
			
		break;

	case 4194304:	//SBT_Deco1;
	
		//~ debug ("������ ��ȣ" @ a_info.ItemType );

		decoIndex = GetDecoIndex(a_info.Id);
	
		if (decoIndex != -1)
		{
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].Clear();
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].AddItem( a_info );
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].EnableWindow();

			//TaliWnd

			if (GetTalismanSkillID(a_info.ID.ClassID) != -1)
				a_info.ID.ClassID = GetTalismanSkillID(a_info.ID.ClassID);
			GetSkillInfo( a_info.ID.ClassID, 1, TalismanSkill );
			a_info.IconName = TalismanSkill.TexName;
			a_info.ItemSubType = int(EShortCutItemType.SCIT_SKILL);

			script_tali.tal[decoIndex].Clear();
			script_tali.tal[decoIndex].AddItem(a_info);

			//TaliWnd	
		}
		break;
	case 268435456:
		hItemWnd = m_equipItem[ EQUIPITEM_Waist ];
		break;	
	}
	
	if( None != hItemWnd )
	{
		hItemWnd.Clear();
		//~ Debug("IconName="@a_Info.IconName);
		hItemWnd.AddItem( a_Info );
		//AddSystemMessageString("a_Info.Name = "$a_Info.Name);
		
		if ( a_Info.SlotBitType == 8 ) //Necklase
		{
			script_item.item1.Clear();
			script_item.item1.AddItem(a_Info);
		}
		
		
		if ( (a_Info.SlotBitType == 128) || (a_Info.SlotBitType == 16384)) // RLHand wxcept Duals
		{
			script_item.item4.Clear();
			script_item.item4.AddItem(a_Info);
		}
		
		if (a_Info.SlotBitType == 268435456) // Belt
		{
			script_item.item3.Clear();
			script_item.item3.AddItem(a_Info);
		}
		
		if ( (a_Info.SlotBitType == 256) ) // LHand
		{
			script_item.item5.Clear();
			script_item.Me.SetWindowSize( 200 , 42 );
			script_item.tex5.SetTexture("L2UI_CH3.etc.menu_outline");
			script_item.item5.AddItem(a_Info);
		}
		
	}
	
	//~ UpdateTalismanSlotActivation();
	//~ UpdateCloakSlotActivation();
}

function HandleOpenWindow(string param)
{
	local int open;
	ParseInt(param, "Open", open);

	if(open==0)
		return;
	
	OpenWindow();
}

function OpenWindow()
{
	m_hInventoryWnd.ShowWindow();
	m_hInventoryWnd.SetFocus();
}

function HandleHideWindow()
{
	HideWindow(m_WindowName);
}

function HandleAddItem(string param)
{
	//local int Order;
	local ItemInfo info;
	
	ParamToItemInfo( param, info );
	//Debug ("HandleAddItem"  );
	if( IsEquipItem(info) )		
		EquipItemUpdate( info );
	else if( IsQuestItem(info) )
	{
		m_questItem.AddItem( info );
	}
	else
	{
		//ParseInt( param, "Order", Order );
		//debug("InvenOrder: "$string(Order));
		//InvenAddItem( info, Order );
		InvenAddItem( info );
	}
}

function HandleUpdateItem(string param)
{
//	local int		Order;
	local string	type;
	local ItemInfo	info;
	local int		index;
	
//	debug("Inventory UpdateItem : " $ param);
	ParseString( param, "type", type );
	ParamToItemInfo( param, info );
	
//	debug("bEQUIPED:"@INFO.bEquipped);
	
	if( type == "add" )
	{
		if( IsEquipItem(info) )
		{
			EquipItemUpdate( info );
		}
		else if( IsQuestItem(info) )
		{
			m_questItem.AddItem(info);
			index = m_questItem.GetItemNum() - 1;
			while( index > 0 )						// ���� ������!
			{
				m_questItem.SwapItems(index-1, index);
				--index;
			}
		}
		else
		{
			//ParseInt( param, "Order", Order );
			//InvenAddItem( info, Order );
			InvenAddItem( info );
		}
	}
	else if( type == "update" )
	{
//		debug("������Ʈ? " $ param);
		if( IsEquipItem(info) )
		{
//			debug("������Ţ������?? " $ param);
			
			if( EquipItemFind(info.ID) )		// match found
			{
			
//				debug("������ ? " $ param);
				EquipItemUpdate( info );
			}
			else			// not found in equipItemList. In this case, move the item from InvenItemList to EquipItemList
			{
//				debug("������ ���� ���μ���1 �κ��丮���� �����.");
//				debug("������?? " $ param);
				InvenDelete( info );
//				debug("������ ���� ���μ���2");
				EquipItemUpdate( info );
			}
		}
		else if( IsQuestItem(info) )
		{
			index = m_questItem.FindItem(info.ID);	// ServerID
			if( index != -1 )
			{
				m_questItem.SetItem(index, info);
			}
			else		// In this case, Equipped item is being unequipped.
			{
				EquipItemDelete(info.ID);
				m_questItem.AddItem(info);
			}
		}
		else
		{
			index = m_invenItem.FindItem(info.ID);	// ServerID
			if( index != -1 )
			{
				m_invenItem.SetItem( index, info );
			}
			else		// In this case, Equipped item is being unequipped.
			{
				EquipItemDelete(info.ID);
				//InvenAddItem( info, 0 );
				InvenAddItem( info );
			}
		}
	}
	else if( type == "delete" )
	{
		if( IsEquipItem(info) )
		{
			EquipItemDelete(info.ID);
		}
		else if( IsQuestItem(info) )
		{
			index = m_questItem.FindItem(info.ID);	// ServerID
			m_questItem.DeleteItem(index);
		}
		else
		{
			InvenDelete( info );
		}
	}

	UpdateItemUsability();

	SetAdenaText();
	SetItemCount();
}

function HandleItemListEnd()
{
	SetAdenaText();
	SetItemCount();
	UpdateItemUsability();
}

function UpdateItemUsability()
{
	m_invenItem.SetItemUsability();
	m_questItem.SetItemUsability();
}

function HandleAddHennaInfo(string param)
{
	/*
	local int hennaID, isActive;

	ParseInt( param, "ID", hennaID );
	ParseInt( param, "bActive", isActive );
	*/
	UpdateHennaInfo();
}

function HandleUpdateHennaInfo(string param)
{
	UpdateHennaInfo();
}

function UpdateHennaInfo()
{
	local int i;
	local int HennaInfoCount;
	local int HennaID;
	local int IsActive;
	local ItemInfo HennaItemInfo;
	local UserInfo PlayerInfo;
	local int ClassStep;

	if( GetPlayerInfo( PlayerInfo ) )
	{
		ClassStep = GetClassStep( PlayerInfo.nSubClass );
		switch( ClassStep )
		{
		case 1:
		case 2:
		case 3:
			m_hHennaItemWindow.SetRow( ClassStep );
			break;
		default:
			m_hHennaItemWindow.SetRow( 0 );
			break;
		}
	}

	m_hHennaItemWindow.Clear();

	HennaInfoCount = class'HennaAPI'.static.GetHennaInfoCount();
	if( HennaInfoCount > ClassStep )
		HennaInfoCount = ClassStep;

	for( i = 0; i < HennaInfoCount; ++i )
	{
		if( class'HennaAPI'.static.GetHennaInfo( i, HennaID, IsActive ) )
		{
			if( !class'UIDATA_HENNA'.static.GetItemName( HennaID, HennaItemInfo.Name ) )
				break;
			if( !class'UIDATA_HENNA'.static.GetDescription( HennaID, HennaItemInfo.Description ) )
				break;
			if( !class'UIDATA_HENNA'.static.GetIconTex( HennaID, HennaItemInfo.IconName ) )
				break;

			if( 0 == IsActive )
				HennaItemInfo.bDisabled = true;
			else
				HennaItemInfo.bDisabled = false;

			m_hHennaItemWindow.AddItem( HennaItemInfo );			
		}
	}
}

function SetAdenaText()
{
	local string adenaString;
	
	adenaString = MakeCostString( Int64ToString(GetAdena()) );

	m_hAdenaTextBox.SetText(adenaString);
	m_hAdenaTextBox.SetTooltipString( ConvertNumToText(Int64ToString(GetAdena())) );
	//debug("SetAdenaText " $ adenaString );
}

function UseItem( ItemWindowHandle a_hItemWindow, int index )
{
	local ItemInfo	info;
	local ItemInfo item1i,item2i,item3i,item4i,item5i;

	if( a_hItemWindow.GetItem(index, info) )
	{
		if( !info.bDisabled )		// lpislhy
		{
			if( info.bRecipe )					// ������(������)�� ����� ������ �����
			{
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetID(DIALOG_USE_RECIPE);
				DialogShow(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(798));
			}
			else if( info.PopMsgNum > 0 )			// �˾� �޽����� �����ش�.
			{
				DialogSetID(DIALOG_POPUP);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogShow(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(info.PopMsgNum));
			}
			else
			{
				debug ("Sending Request to Server:");
				RequestUseItem(info.ID);

				script_item.item1.GetItem(0, item1i);
				script_item.item2.GetItem(0, item2i);
				script_item.item3.GetItem(0, item3i);
				script_item.item4.GetItem(0, item4i);
				script_item.item5.GetItem(0, item5i);
				//AddSystemMessageString("GOT ITEM INFO");
				switch (info.ID)
				{
					case item1i.ID:
					script_item.item1.Clear();
					//script_tali.tal4.DisableWindow();
					//AddSystemMessageString("4th ITEM INFO clear");
					break;
					case item2i.ID:
					script_item.item2.Clear();
					//script_tali.tal4.DisableWindow();
					//AddSystemMessageString("4th ITEM INFO clear");
					break;
					case item3i.ID:
					script_item.item3.Clear();
					//script_tali.tal4.DisableWindow();
					//AddSystemMessageString("4th ITEM INFO clear");
					break;
					case item4i.ID:
					script_item.item4.Clear();
					//script_tali.tal4.DisableWindow();
					//AddSystemMessageString("4th ITEM INFO clear");
					break;
					case item5i.ID:
					script_item.item5.Clear();
					script_item.Me.SetWindowSize( 164 , 42 );
					script_item.tex5.SetTexture("");
					//script_tali.tal4.DisableWindow();
					//AddSystemMessageString("4th ITEM INFO clear");
					break;
				}
			}
		}
	}
}

function int GetMyInventoryLimit()
{
	//~ debug ("MyInventoryLimit:" @ class'UIDATA_PLAYER'.static.GetInventoryLimit());
	//~ return class'UIDATA_PLAYER'.static.GetInventoryLimit();
	return m_MaxInvenCount;
}

function int GetQuestItemInventoryLimit()
{
	return m_MaxQuestItemInvenCount;
}

function SetItemCount()
{
	local int limit;
	local int count;
	local TextBoxHandle handle;

	if(m_selectedItemTab == INVENTORY_ITEM_TAB)
	{
		count = m_invenCount + EquipItemGetItemNum();
		limit = GetMyInventoryLimit();
	}
	else if(m_selectedItemTab == QUEST_ITEM_TAB)
	{
		count = m_questItem.GetItemNum();
		limit = GetQuestItemInventoryLimit();
	}

	//count = m_invenCount + m_questItem.GetItemNum() + EquipItemGetItemNum();
	//count = m_invenCount + EquipItemGetItemNum() + m_questItem.GetItemNum();
	//count = m_invenCount + m_questItem.GetItemNum() + EquipItemGetItemNum();

	if(CREATE_ON_DEMAND==0)
		handle = TextBoxHandle(GetHandle(m_WindowName $ ".ItemCount"));
	else
		handle = GetTextBoxHandle(m_WindowName $ ".ItemCount");

	handle.SetText("(" $ count $ "/" $ limit $ ")");
	debug("SetItemCount : count " $ count $ ", limit : " $ limit );
}

function HandleDialogOK()
{
	local int id;
	local INT64 reserved2;
	local ItemID sID;
	local INT64 number;
	
	if( DialogIsMine() )
	{
		id = DialogGetID();
		reserved2 = DialogGetReservedInt2();
		number = StringToInt64(DialogGetString());
		sID = DialogGetReservedItemID();	// ItemID
		
		if( id == DIALOG_USE_RECIPE || id == DIALOG_POPUP )
		{
			RequestUseItem(sID);
		}
		else if( id == DIALOG_DROPITEM )
		{
			RequestDropItem( sID, IntToInt64(1), m_clickLocation );
		}
		else if( id == DIALOG_DROPITEM_ASKCOUNT )
		{
			if(number == IntToInt64(0)) 
				number = IntToInt64(1);					// �ƹ� ���ڵ� �Է����� ������ 1�� ������� ó��
			RequestDropItem( sID, number, m_clickLocation );
		}
		else if( id == DIALOG_DROPITEM_ALL )
		{
			RequestDropItem( sID, reserved2, m_clickLocation );
		}
		else if( id == DIALOG_DESTROYITEM )
		{
			RequestDestroyItem(sID, IntToInt64(1));
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if( id == DIALOG_DESTROYITEM_ASKCOUNT )
		{
			RequestDestroyItem(sID, number);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if( id == DIALOG_DESTROYITEM_ALL)
		{
			RequestDestroyItem(sID, reserved2);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if( id == DIALOG_CRYSTALLIZE )
		{
			RequestCrystallizeItem(sID,IntToInt64(1));
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if ( id == DIALOG_DROPITEM_PETASKCOUNT )
		{
			class'PetAPI'.static.RequestGetItemFromPet( sID, number, false);
		}
	}
}

function HandleUpdateUserInfo()
{
	if( m_hInventoryWnd.IsShowWindow() )
	{
		InvenLimitUpdate();
		EarItemUpdate();
		FingerItemUpdate();
		CheckShowCrystallizeButton();
		UpdateTalismanSlotActivation();
		UpdateCloakSlotActivation();
	}
	else
	{
		FingerItemUpdate();
	}
}

function HandleToggleWindow()
{
	if( m_hInventoryWnd.IsShowWindow() )
	{
		m_hInventoryWnd.HideWindow();
		PlayConsoleSound(IFST_INVENWND_CLOSE);
	}
	else
	{
		if( IsShowInventoryWndUponEvent() )
		{
			RequestItemList();
			m_hInventoryWnd.ShowWindow();
			PlayConsoleSound(IFST_INVENWND_OPEN);
		}
	}
}

//����â��, ����â��, ȭ��â��, ��ȯâ, ��������, �Ǹ�â, �����Ǹ�, ���α��� â�� ������ ��� �����ϴ� ��ƾ
//�ٸ������ ���λ��� â���� ���� �����Ҷ��� �������� --;; - innowind
function bool IsShowInventoryWndUponEvent()
{
	local WindowHandle m_warehouseWnd;
	local WindowHandle m_privateShopWnd;
	local WindowHandle m_tradeWnd;
	local WindowHandle m_shopWnd;
	local WindowHandle m_multiSellWnd;
	local WindowHandle m_deliverWnd;
	local PrivateShopWnd m_scriptPrivateShopWnd;
	local WindowHandle m_PostBoxWnd, m_PostWriteWnd, m_PostDetailWnd_General, m_PostDetailWnd_SafetyTrade; 
	//branch
	local WindowHandle m_BR_CashShopWnd;
	local WindowHandle m_BR_BuyingWnd;
	//end of branch

	//��ǰ �κ��丮 �߰�
	local WindowHandle m_ProductInventoryWnd;

	if(CREATE_ON_DEMAND==0)
	{
		m_warehouseWnd = GetHandle( "WarehouseWnd" );		//����â��, ����â��, ȭ��â��
		m_privateShopWnd = GetHandle( "PrivateShopWnd" );	//�����Ǹ�, ���α���
		m_tradeWnd = GetHandle( "TradeWnd" );				//��ȯ
		m_shopWnd = GetHandle( "ShopWnd" );				//��������, �Ǹ�
		m_multiSellWnd = GetHandle( "MultiSellWnd" );				//��������, �Ǹ�
		m_deliverWnd = GetHandle( "DeliverWnd" );				//ȭ������
		m_scriptPrivateShopWnd = PrivateShopWnd( GetScript("PrivateShopWnd") );

		m_PostBoxWnd = GetHandle( "PostBoxWnd" );
		m_PostWriteWnd = GetHandle( "PostWriteWnd" );
		m_PostDetailWnd_General = GetHandle( "PostDetailWnd_General" );
		m_PostDetailWnd_SafetyTrade = GetHandle( "PostDetailWnd_SafetyTrade" );
		
		//branch
		m_BR_CashShopWnd = GetHandle( "BR_CashShopWnd" );	// ���� ����
		m_BR_BuyingWnd = GetHandle( "BR_BuyingWnd" );	// ���� ����
		//end of branch

		m_ProductInventoryWnd = GetHandle( "ProductInventoryWnd" ); // �ǸŴ���
	}
	else
	{
		m_warehouseWnd = GetWindowHandle( "WarehouseWnd" );					//����â��, ����â��, ȭ��â��
		m_privateShopWnd = GetWindowHandle( "PrivateShopWnd" );					//�����Ǹ�, ���α���
		m_tradeWnd = GetWindowHandle( "TradeWnd" );							//��ȯ
		m_shopWnd = GetWindowHandle( "ShopWnd" );							//��������, �Ǹ�
		m_multiSellWnd = GetWindowHandle( "MultiSellWnd" );						//��������, �Ǹ�
		m_deliverWnd = GetWindowHandle( "DeliverWnd" );							//ȭ������
		m_scriptPrivateShopWnd = PrivateShopWnd( GetScript("PrivateShopWnd") );

		m_PostBoxWnd = GetWindowHandle( "PostBoxWnd" );
		m_PostWriteWnd = GetWindowHandle( "PostWriteWnd" );
		m_PostDetailWnd_General = GetWindowHandle( "PostDetailWnd_General" );
		m_PostDetailWnd_SafetyTrade = GetWindowHandle( "PostDetailWnd_SafetyTrade" );
		
		//branch
		m_BR_CashShopWnd = GetWindowHandle( "BR_CashShopWnd" );	// ���� ����
		m_BR_BuyingWnd = GetWindowHandle( "BR_BuyingWnd" );	// ���� ����
		//end of branch

		m_ProductInventoryWnd = GetWindowHandle( "ProductInventoryWnd" ); // �ǸŴ���
	}

	if( m_warehouseWnd.IsShowWindow() )
		return false;

	if( m_warehouseWnd.IsShowWindow() )
		return false;

	if( m_tradeWnd.IsShowWindow() )
		return false;
	
	if( m_shopWnd.IsShowWindow() )
		return false;
	
	if( m_multiSellWnd.IsShowWindow() )
		return false;
	
	if( m_deliverWnd.IsShowWindow() )
		return false;
	
	if( m_privateShopWnd.IsShowWindow() && m_scriptPrivateShopWnd.m_type == PT_Sell )
		return false;

	if (m_PostBoxWnd.IsShowWindow() || m_PostWriteWnd.IsShowWindow() || m_PostDetailWnd_General.IsShowWindow() || m_PostDetailWnd_SafetyTrade.IsShowWindow() )
		return false;
		
	//branch
	if( m_BR_CashShopWnd.IsShowWindow() || m_BR_BuyingWnd.IsShowWindow() )
		return false;
	//end of branch

	if( m_ProductInventoryWnd.IsShowWindow() )
		return false;

	return true;
}

function int IsLOrREar( ItemID sID )
{
	local ItemID LEar;
	local ItemID REar;
	local ItemID LFinger;
	local ItemID RFinger;

	GetAccessoryItemID( LEar, REar, LFinger, RFinger );

	if( IsSameServerID(sID, LEar) )
		return -1;
	else if( IsSameServerID(sID, REar) )
		return 1;
	else
		return 0;
}

function int IsLOrRFinger( ItemID sID )
{
	local ItemID LEar;
	local ItemID REar;
	local ItemID LFinger;
	local ItemID RFinger;

	GetAccessoryItemID( LEar, REar, LFinger, RFinger );

	if( IsSameServerID(sID, LFinger) )
		return -1;
	else if( IsSameServerID(sID, RFinger) )
		return 1;
	else
		return 0;
}

function bool IsBowOrFishingRod( ItemInfo a_Info )
{
	//~ debug("������� ��ȣ?"@  a_Info.WeaponType);
	
	if( 6 == a_Info.WeaponType || 10 == a_Info.WeaponType || 12 == a_Info.WeaponType )
		return true;

	return false;
}

function int IsDecoItem( ItemInfo a_Info )
{
	return a_Info.SlotBitType;
}

function bool IsArrow( ItemInfo a_Info )
{
	return a_Info.bArrow;
}

//Inven Item Order, ttmayrin
function InvenLimitUpdate()
{
	local int Count;
	local int CurLimit;
	local int InvenLimit;
	local int AddedCount;
	local int DeletedCount;
	
	local ItemInfo ClearItem;
	local ItemInfo CurItem;

	local UserInfo user;

	//Default Item
	//������ ������ ���� ���� 
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	
	if( GetPlayerInfo( user ) )
	{
		
		ClearItemID( ClearItem.ID );		
		InvenLimit = user.nInvenLimit;
		CurLimit = m_invenItem.GetItemNum();
		debug("User InvenLimit : "$string(InvenLimit)$"InvenItem: "$string(CurLimit));
		if( CurLimit < InvenLimit )
		{
			AddedCount = InvenLimit - CurLimit;
			for( Count=0; Count<AddedCount; Count++ )
				m_invenItem.AddItem( ClearItem );
		}
		else if ( CurLimit > InvenLimit )
		{
			DeletedCount = CurLimit - InvenLimit;
			for ( Count = m_InvenItem.GetItemNum()- 1; Count >= 0; Count-- )
			{
				if (DeletedCount > 0)
				{
					m_InvenItem.GetItem(Count, CurItem );
					if (!IsValidItemID(CurItem.ID))
					{
						m_invenItem.DeleteItem(Count);
						DeletedCount--;
					}
					if (DeletedCount <= 0)
					{
						break;
					}					
				}
			}
		}
	}
}

//function InvenAddItem( ItemInfo newItem, int order )
function InvenAddItem( ItemInfo newItem )
{
	local int idx;
	local int CurLimit;
	local int FindIdx;
	
	local ItemInfo curItem;
	
	FindIdx = -1;
	
	if( m_invenItem.GetItem( newItem.Order, curItem ) )
	{
		if( !IsValidItemID( curItem.ID ) )
		{
			//FindIdx = Order;
			FindIdx = newItem.Order;
		}
	}
	
	if( FindIdx < 0 )
	{
		CurLimit = m_invenItem.GetItemNum();
		for( idx=0; idx<CurLimit; idx++ )
		{
			if( m_invenItem.GetItem( idx, curItem ) )
			{
				if( !IsValidItemID( curItem.ID ) )
				{
					FindIdx = idx;
					break;
				}
			}
		}
	}
	
	if( FindIdx > -1 )
	{
		m_invenItem.SetItem( FindIdx, newItem );
	}
	else
	{
		m_invenItem.AddItem( newItem );
	}
		
	m_invenCount++;
}

function InvenDelete( ItemInfo item )
{
	local int FindIdx;
	local ItemInfo ClearItem;
	
	ClearItemID( ClearItem.ID );
	
	//������ Ȱ��ȭ �κ� �ؽ��� ó��
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	FindIdx = m_invenItem.FindItem( item.ID );
	if( FindIdx != -1 )
	{
		m_invenItem.SetItem( FindIdx, ClearItem );
		m_invenCount--;
	}
}

function InvenClear()
{
	m_invenItem.Clear();
	InvenLimitUpdate();
	m_invenCount = 0;
}

function SaveInventoryOrder()
{
	local int idx;
	local int InvenLimit;
	local ItemInfo item;
	local array<ItemID> IDList;
	local array<int> OrderList;

	InvenLimit = m_invenItem.GetItemNum();

	debug("inven_limit" $ InvenLimit);

	for( idx=0; idx<InvenLimit; idx++ )
	{
		if( m_invenItem.GetItem( idx, item ) )
		{
			if( IsValidItemID( item.ID ) )
			{
				IDList.Insert(IDList.Length, 1);
				IDList[IDList.Length-1] = item.ID;
				
				OrderList.Insert(OrderList.Length, 1);
				OrderList[OrderList.Length-1] = item.Order;
			}
		}
	}

	debug("idlist_length" $ IDList.Length);
	debug("orderlist_length" $ OrderList.Length);
	
	if( IDList.Length > 0 )
	{
		debug("Saving Inventory");
		RequestSaveInventoryOrder( IDList, OrderList );
	}
	SetINIInt("Inventory", "extraSlots", extraSlotsCount, "PatchSettings");
	//SetINIInt("Inventory", "useExtender", useExtendedInventory, "PatchSettings");
}

function OnClickButton( string strID )
{	
	switch( strID )
	{
		case "SortButton":
			if(m_invenTab.GetTopIndex() == 0)	//�κ��丮 ������ ���� Ȱ��ȭ �Ǿ� ���� ����
			{							// ��¥�� �𽺿��̺� �Ҳ����� ������������..
				SortItem(m_invenItem);	//�κ��丮 ����
				SaveInventoryOrder();
			}
			break;
		case "InventoryTab0":	//�κ��丮 ������ �� Ŭ��
			m_sortBtn.EnableWindow();
			m_selectedItemTab = INVENTORY_ITEM_TAB;
			SetItemCount();
			break;
		case "InventoryTab1":	//����Ʈ ������ �� Ŭ��
			m_sortBtn.DisableWindow();
			m_selectedItemTab = QUEST_ITEM_TAB;
			SetItemCount();
			break;
		case "BtnWindowExpand":
			SwitchExtendedInventory();
			break;
		//~ case "BtnZoomReset":
			//~ debug ("ResetScale");
			//~ m_ObjectViewport.SetCharacterScale(0.4f);
			//~ break;
		
	}
}

function OnLButtonDown (WindowHandle  a_WindowHandle, int X, int Y)
{
	//~ debug ("ClickedDown");
	
	if (a_WindowHandle == m_BtnRotateLeft)
	{
		//~ debug ("ClickedDown Button Left");
		//~ class'UIAPI_CharacterViewportWindow'.static.StartRotation( "InventoryWnd.ObjectViewport", "false");
		m_ObjectViewport.StartRotation(false);
	}
	else if (a_WindowHandle == m_BtnRotateRight)
	{
		//~ debug ("ClickedDown Button Right");
		//~ class'UIAPI_CharacterViewportWindow'.static.StartRotation( "InventoryWnd.ObjectViewport", "true");
		m_ObjectViewport.StartRotation(true);
	}
	//~ else if (a_WindowHandle == m_BtnZoomIn)
	//~ {
		//~ m_ObjectViewport.StartZoom(false);
	//~ }
	//~ else if (a_WindowHandle == m_BtnZoomOut)
	//~ {
		//~ m_ObjectViewport.StartZoom(true);
	//~ }
}

function OnLButtonUp (WindowHandle  a_WindowHandle, int X, int Y)
{
	//~ debug ("ClickedUp");
	if (a_WindowHandle == m_BtnRotateLeft)
	{
		//~ class'UIAPI_CharacterViewportWindow'.static.EndRotation( "InventoryWnd.ObjectViewport");
		m_ObjectViewport.EndRotation();
	}
	else if (a_WindowHandle == m_BtnRotateRight)
	{
		//~ class'UIAPI_CharacterVisewportWindow'.static.EndRotation( "InventoryWnd.ObjectViewport");
		m_ObjectViewport.EndRotation();
	}
	//~ else if (a_WindowHandle == m_BtnZoomIn)
	//~ {
		//~ m_ObjectViewport.EndZoom();
	//~ }
	//~ else if (a_WindowHandle == m_BtnZoomOut)
	//~ {
		//~ m_ObjectViewport.EndZoom();
	//~ }
}


//#ifdef CT26P3
function SortItem( ItemWindowHandle ItemWnd)
{
	local int i, j;
	local int invenLimit;
	local ItemInfo item;
	local EItemType eItemType;


	local int numAsset;
	local int numWeapon;
	local int numArmor;
	local int numAccessary;
	local int numEtcItem;

	local int numAncientCrystalEnchantAm;
	local int numAncientCrystalEnchantWp;
	local int numCrystalEnchantAm;
	local int numCrystalEnchantWp;

	local int numBlessEnchantAm;
	local int numBlessEnchantWp;
	local int numEnchantAm;
	local int numEnchantWp;

	local int numIncEnchantPropAm;
	local int numIncEnchantPropWp;

	local int numPotion;
	local int numElixir;

	local int numArrow;
	local int numBolt;

	local int numRecipe;

	local int nextSlot;

	local int testInt;


	local Array<ItemInfo> AssetList;
	local Array<ItemInfo> WeaponList;
	local Array<ItemInfo> ArmorList;
	local Array<ItemInfo> AccesaryList;
	local Array<ItemInfo> EtcItemList;

	// etc item ����
	local Array<ItemInfo> AncientCrystalEnchantAmList;
	local Array<ItemInfo> AncientCrystalEnchantWpList;
	local Array<ItemInfo> CrystalEnchantAmList;
	local Array<ItemInfo> CrystalEnchantWpList;

	local Array<ItemInfo> BlessEnchantAmList;
	local Array<ItemInfo> BlessEnchantWpList;

	local Array<ItemInfo> EnchantAmList;
	//local Array<ItemInfo> EnchantAttrList;
	local Array<ItemInfo> EnchantWpList;

	local Array<ItemInfo> IncEnchantPropAmList;
	local Array<ItemInfo> IncEnchantPropWpList;

	local Array<ItemInfo> PotionList;
	local Array<ItemInfo> ElixirList;

	local Array<ItemInfo> ArrowList;
	local Array<ItemInfo> BoltList;

	local Array<ItemInfo> RecipeList;

	// ���� �� ������ ���� ����
	local ItemInfo temp;

	debug("Sorting Inven Item");

	numAsset = 0;
	numWeapon = 0;
	numArmor = 0;
	numAccessary = 0;
	numPotion = 0;
	numEtcItem = 0;

	numAncientCrystalEnchantAm = 0;
	numAncientCrystalEnchantWp = 0;
	numCrystalEnchantAm = 0;
	numCrystalEnchantWp = 0;
	numBlessEnchantAm = 0;
	numBlessEnchantWp = 0;
	numIncEnchantPropAm = 0;
	numIncEnchantPropWp = 0;
	numEnchantAm = 0;
	numEnchantWp = 0;
	numPotion = 0;
	numElixir = 0;
	numArrow = 0;
	numBolt = 0;
	numRecipe = 0;

	nextSlot = 0;

	invenLimit = m_invenItem.GetItemNum();

	// 1. �����۵��� �������� ����
	for (i = 0; i < invenLimit; ++i)
	{
		m_invenItem.GetItem(i, item);

		if(!IsValidItemID(item.ID))
		{
			continue;
		}

		eItemType = EItemType(item.ItemType);

		switch (eItemType)
		{
		case ITEM_ASSET:
			AssetList[numAsset] = item;
			numAsset = numAsset + 1;
			break;

		case ITEM_WEAPON:
			WeaponList[numWeapon] = item;
			numWeapon = numWeapon + 1;
			break;

		case ITEM_ARMOR:
			ArmorList[numArmor] = item;
			numArmor = numArmor + 1;
			break;

		case ITEM_ACCESSARY:
			AccesaryList[numAccessary] = item;
			numAccessary = numAccessary + 1;
			break;

		case ITEM_ETCITEM:
			testInt = item.ItemSubType;
			debug("ggggggg" $ testInt);
			//debug(int(item.ItemSubType));
			switch (EEtcItemType(item.ItemSubType))
			{
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM:
				AncientCrystalEnchantAmList[numAncientCrystalEnchantAm] = item;
				numAncientCrystalEnchantAm = numAncientCrystalEnchantAm + 1;
				break;
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP:
				AncientCrystalEnchantWpList[numAncientCrystalEnchantWp] = item;
				numAncientCrystalEnchantWp = numAncientCrystalEnchantWp + 1;
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM:
				CrystalEnchantAmList[numCrystalEnchantAm] = item;
				numCrystalEnchantAm = numCrystalEnchantAm + 1;
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP:
				CrystalEnchantWpList[numCrystalEnchantWp] = item;
				numCrystalEnchantWp = numCrystalEnchantWp + 1;
				break;
			case ITEME_BLESS_ENCHT_AM:
				BlessEnchantAmList[numBlessEnchantAm] = item;
				numBlessEnchantAm = numBlessEnchantAm + 1;
				break;
			case ITEME_BLESS_ENCHT_WP:
				BlessEnchantWpList[numBlessEnchantWp] = item;
				numBlessEnchantWp = numBlessEnchantWp + 1;
				break;
			case ITEME_ENCHT_AM:
				EnchantAmList[numEnchantAm] = item;
				numEnchantAm = numEnchantAm + 1;
				break;
			case ITEME_ENCHT_WP:
				EnchantWpList[numEnchantWp] = item;
				numEnchantWp = numEnchantWp + 1;
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM:
				IncEnchantPropAmList[numIncEnchantPropAm] = item;
				numIncEnchantPropAm = numIncEnchantPropAm + 1;
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP:
				IncEnchantPropWpList[numIncEnchantPropWp] = item;
				numIncEnchantPropWp = numIncEnchantPropWp + 1;
				break;
			case ITEME_POTION:
				PotionList[numPotion] = item;
				numPotion = numPotion + 1;
				break;
			case ITEME_ELIXIR:
				ElixirList[numElixir] = item;
				numElixir = numElixir + 1;
				break;
			case ITEME_ARROW:
				ArrowList[numArrow] = item;
				numArrow = numArrow + 1;
				break;
			case ITEME_BOLT:
				BoltList[numBolt] = item;
				numBolt = numBolt + 1;
				break;
			case ITEME_RECIPE:
				RecipeList[numRecipe] = item;
				numRecipe = numRecipe + 1;
				break;
			default:
				EtcItemList[numEtcItem] = item;
				numEtcItem = numEtcItem + 1;
				break;
			}
			break;

		default:
			debug("huh???");
			EtcItemList[numEtcItem] = item;
			numEtcItem = numEtcItem + 1;
			break;
		}
	}

	// 2. ���� �� �����۵��� �� ����Ʈ �� ���Լ����� ����
	for (i = 0; i < numAsset; ++i)
	{
		for (j = 0; j < numAsset - i; ++j)
		{
			if (j < numAsset - 1)
			{
				if (AssetList[j].Weight < AssetList[j + 1].Weight)
				{
					temp = AssetList[j];
					AssetList[j] = AssetList[j + 1];
					AssetList[j + 1] = temp;
				}
			}
		}
	}
	for (i = 0; i < numWeapon; ++i)
	{
		for (j = 0; j < numWeapon - i; ++j)
		{
			if (j < numWeapon - 1)
			{
				if (WeaponList[j].Weight < WeaponList[j + 1].Weight)
				{
					temp = WeaponList[j];
					WeaponList[j] = WeaponList[j + 1];
					WeaponList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numArmor; ++i)
	{
		for (j = 0; j < numArmor - i; ++j)
		{
			if (j < numArmor - 1)
			{
				if (ArmorList[j].Weight < ArmorList[j + 1].Weight)
				{
					temp = ArmorList[j];
					ArmorList[j] = ArmorList[j + 1];
					ArmorList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numAccessary; ++i)
	{
		for (j = 0; j < numAccessary - i; ++j)
		{
			if (j < numAccessary - 1)
			{
				if (AccesaryList[j].Weight < AccesaryList[j + 1].Weight)
				{
					temp = AccesaryList[j];
					AccesaryList[j] = AccesaryList[j + 1];
					AccesaryList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numAncientCrystalEnchantAm; ++i)
	{
		for (j = 0; j < numAncientCrystalEnchantAm - i; ++j)
		{
			if (j < numAncientCrystalEnchantAm - 1)
			{
				if (AncientCrystalEnchantAmList[j].Weight < AncientCrystalEnchantAmList[j + 1].Weight)
				{
					temp = AncientCrystalEnchantAmList[j];
					AncientCrystalEnchantAmList[j] = AncientCrystalEnchantAmList[j + 1];
					AncientCrystalEnchantAmList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numAncientCrystalEnchantWp; ++i)
	{
		for (j = 0; j < numAncientCrystalEnchantWp - i; ++j)
		{
			if (j < numAncientCrystalEnchantWp - 1)
			{
				if (AncientCrystalEnchantWpList[j].Weight < AncientCrystalEnchantWpList[j + 1].Weight)
				{
					temp = AncientCrystalEnchantWpList[j];
					AncientCrystalEnchantWpList[j] = AncientCrystalEnchantWpList[j + 1];
					AncientCrystalEnchantWpList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numCrystalEnchantAm; ++i)
	{
		for (j = 0; j < numCrystalEnchantAm - i; ++j)
		{
			if (j < numCrystalEnchantAm - 1)
			{
				if (CrystalEnchantAmList[j].Weight < CrystalEnchantAmList[j + 1].Weight)
				{
					temp = CrystalEnchantAmList[j];
					CrystalEnchantAmList[j] = CrystalEnchantAmList[j + 1];
					CrystalEnchantAmList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numCrystalEnchantWp; ++i)
	{
		for (j = 0; j < numCrystalEnchantWp - i; ++j)
		{
			if (j < numCrystalEnchantWp - 1)
			{			
				if (CrystalEnchantWpList[j].Weight < CrystalEnchantWpList[j + 1].Weight)
				{
					temp = CrystalEnchantWpList[j];
					CrystalEnchantWpList[j] = CrystalEnchantWpList[j + 1];
					CrystalEnchantWpList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numBlessEnchantAm; ++i)
	{
		for (j = 0; j < numBlessEnchantAm - i; ++j)
		{
			if (j < numBlessEnchantAm - 1)
			{
				if (BlessEnchantAmList[j].Weight < BlessEnchantAmList[j + 1].Weight)
				{
					temp = BlessEnchantAmList[j];
					BlessEnchantAmList[j] = BlessEnchantAmList[j + 1];
					BlessEnchantAmList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numBlessEnchantWp; ++i)
	{
		for (j = 0; j < numBlessEnchantWp - i; ++j)
		{
			if (j < numBlessEnchantWp - 1)
			{
				if (BlessEnchantWpList[j].Weight < BlessEnchantWpList[j + 1].Weight)
				{
					temp = BlessEnchantWpList[j];
					BlessEnchantWpList[j] = BlessEnchantWpList[j + 1];
					BlessEnchantWpList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numEnchantAm; ++i)
	{
		for (j = 0; j < numEnchantAm - i; ++j)
		{
			if (j < numEnchantAm - 1)
			{
				if (EnchantAmList[j].Weight < EnchantAmList[j + 1].Weight)
				{
					temp = EnchantAmList[j];
					EnchantAmList[j] = EnchantAmList[j + 1];
					EnchantAmList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numEnchantWp; ++i)
	{
		for (j = 0; j < numEnchantWp - i; ++j)
		{
			if (j < numEnchantWp - 1)
			{
				if (EnchantWpList[j].Weight < EnchantWpList[j + 1].Weight)
				{
					temp = EnchantWpList[j];
					EnchantWpList[j] = EnchantWpList[j + 1];
					EnchantWpList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numIncEnchantPropAm; ++i)
	{
		for (j = 0; j < numIncEnchantPropAm - i; ++j)
		{
			if (j < numIncEnchantPropAm - 1)
			{
				if (IncEnchantPropAmList[j].Weight < IncEnchantPropAmList[j + 1].Weight)
				{
					temp = IncEnchantPropAmList[j];
					IncEnchantPropAmList[j] = IncEnchantPropAmList[j + 1];
					IncEnchantPropAmList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numIncEnchantPropWp; ++i)
	{
		for (j = 0; j < numIncEnchantPropWp - i; ++j)
		{
			if (j < numIncEnchantPropWp - 1)
			{
				if (IncEnchantPropWpList[j].Weight < IncEnchantPropWpList[j + 1].Weight)
				{
					temp = IncEnchantPropWpList[j];
					IncEnchantPropWpList[j] = IncEnchantPropWpList[j + 1];
					IncEnchantPropWpList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numPotion; ++i)
	{
		for (j = 0; j < numPotion - i; ++j)
		{
			if (j < numPotion - 1)
			{
				if (PotionList[j].Weight < PotionList[j + 1].Weight)
				{
					temp = PotionList[j];
					PotionList[j] = PotionList[j + 1];
					PotionList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numElixir; ++i)
	{
		for (j = 0; j < numElixir - i; ++j)
		{
			if (j < numElixir - 1)
			{
				if (ElixirList[j].Weight < ElixirList[j + 1].Weight)
				{
					temp = ElixirList[j];
					ElixirList[j] = ElixirList[j + 1];
					ElixirList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numArrow; ++i)
	{
		for (j = 0; j < numArrow - i; ++j)
		{
			if (j < numArrow - 1)
			{
				if (ArrowList[j].Weight < ArrowList[j + 1].Weight)
				{
					temp = ArrowList[j];
					ArrowList[j] = ArrowList[j + 1];
					ArrowList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numBolt; ++i)
	{
		for (j = 0; j < numBolt - i; ++j)
		{
			if (j < numBolt - 1)
			{
				if (BoltList[j].Weight < BoltList[j + 1].Weight)
				{
					temp = BoltList[j];
					BoltList[j] = BoltList[j + 1];
					BoltList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numRecipe; ++i)
	{
		for (j = 0; j < numRecipe - i; ++j)
		{
			if (j < numRecipe - 1)
			{
				if (RecipeList[j].Weight < RecipeList[j + 1].Weight)
				{
					temp = BoltList[j];
					RecipeList[j] = RecipeList[j + 1];
					RecipeList[j + 1] = temp;
				}
			}
		}
	}

	for (i = 0; i < numEtcItem; ++i)
	{
		for (j = 0; j < numEtcItem - i; ++j)
		{
			if (j < numEtcItem - 1)
			{
				if (EtcItemList[j].Weight < EtcItemList[j + 1].Weight)
				{
					temp = EtcItemList[j];
					EtcItemList[j] = EtcItemList[j + 1];
					EtcItemList[j + 1] = temp;
				}
			}
		}
	}

	// 3. �κ��� �ٽ� ����
	InvenClear();
	
	for (i = 0; i < numAsset; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, AssetList[i]);
	}	
	nextSlot = nextSlot + numAsset;

	for (i = 0; i < numWeapon; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, WeaponList[i]);
	}
	nextSlot = nextSlot + numWeapon;

	for (i = 0; i < numArmor; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, ArmorList[i]);
	}
	nextSlot = nextSlot + numArmor;

	for (i = 0; i < numAccessary; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, AccesaryList[i]);
	}
	nextSlot = nextSlot + numAccessary;

	for (i = 0; i < numAncientCrystalEnchantAm; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, AncientCrystalEnchantAmList[i]);
	}
	nextSlot = nextSlot + numAncientCrystalEnchantAm;

	for (i = 0; i < numAncientCrystalEnchantWp; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, AncientCrystalEnchantWpList[i]);
	}
	nextSlot = nextSlot + numAncientCrystalEnchantWp;

	for (i = 0; i < numCrystalEnchantAm; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, CrystalEnchantAmList[i]);
	}
	nextSlot = nextSlot + numCrystalEnchantAm;

	for (i = 0; i < numCrystalEnchantWp; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, CrystalEnchantWpList[i]);
	}
	nextSlot = nextSlot + numCrystalEnchantWp;

	for (i = 0; i < numBlessEnchantAm; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, BlessEnchantAmList[i]);
	}
	nextSlot = nextSlot + numBlessEnchantAm;

	for (i = 0; i < numBlessEnchantWp; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, BlessEnchantWpList[i]);
	}
	nextSlot = nextSlot + numBlessEnchantWp;

	for (i = 0; i < numEnchantAm; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, EnchantAmList[i]);
	}
	nextSlot = nextSlot + numEnchantAm;

	for (i = 0; i < numEnchantWp; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, EnchantWpList[i]);
	}
	nextSlot = nextSlot + numEnchantWp;

	for (i = 0; i < numIncEnchantPropAm; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, IncEnchantPropAmList[i]);
	}
	nextSlot = nextSlot + numIncEnchantPropAm;

	for (i = 0; i < numIncEnchantPropWp; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, IncEnchantPropWpList[i]);
	}
	nextSlot = nextSlot + numIncEnchantPropWp;

	for (i = 0; i < numPotion; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, PotionList[i]);
	}
	nextSlot = nextSlot + numPotion;

	for (i = 0; i < numElixir; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, ElixirList[i]);
	}
	nextSlot = nextSlot + numElixir;

	for (i = 0; i < numArrow; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, ArrowList[i]);
	}
	nextSlot = nextSlot + numArrow;

	for (i = 0; i < numBolt; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, BoltList[i]);
	}
	nextSlot = nextSlot + numBolt;

	for (i = 0; i < numRecipe; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, RecipeList[i]);
	}
	nextSlot = nextSlot + numRecipe;

	for (i = 0; i < numEtcItem; ++i)
	{
		m_invenItem.SetItem(nextSlot + i, EtcItemList[i]);
	}
	nextSlot = nextSlot + numEtcItem;
	
	// TTP #42420 m_invenCount�� InvenClear() ���� �ʱ�ȭ�ϹǷ� �ٽ� ������ ��� �մϴ�. - gorillazin 10.10.29.
	m_invenCount = nextSlot;

	debug("[Sorting Inven Item]" $ nextSlot $ "items sorted complete!!");
}
//#endif //CT26P3 - gorillazin

function UpdateTalismanSlotActivation()
{
	local int Count;
	local int i;
	local UserInfo user;
	local ItemInfo DisableItem;
	
	DisableItem.IconName = "L2UI_CT1.Inventory_DF_TalismanSlot_Disable";   	//Find This and Fill Out with the Final.
	
	
	
	if( GetPlayerInfo( user ) )
	{
		Count = user.nTalismanNum;
		//~ debug ("Talisman Activation" @ user.nTalismanNum);
		
		if (Count > 0)
		{
			for (i = 0; i<Count; i++)
			{
				m_Talisman_Disable[ i ].HideWindow();
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].Clear();
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].AddItem( DisableItem );
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].DisableWindow();
				m_equipItem[ EQUIPITEM_Deco1 + i ].EnableWindow();
			}
		}
		else
		{
			for (i = 0; i<6; i++)
			{
				m_Talisman_Disable[ i ].ShowWindow();
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].Clear();
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].AddItem( DisableItem );
				m_equipItem[ EQUIPITEM_Deco1 + i ].DisableWindow();
			}
		}
		//~ {
			//~ for (i = 0; i<Count; i++)
			//~ {
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].ClearItem();
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].AddItem( DisableItem );
				//~ m_equipItem[ EQUIPITEM_Deco1 + i ].DisableWindow();
			//~ }
		//~ }
	}
} 
	
function UpdateCloakSlotActivation()
{
	//~ local int i;
	local UserInfo user;
	local ItemInfo DisableItem;
	
	DisableItem.IconName = "L2UI_CT1.Inventory_DF_CloakSlot_Disable";  	//Find This and Fill Out with the Final.
	
	if( GetPlayerInfo( user ) )
	{
		//~ debug ("FullArmor" @  user.nFullArmor);
		if (user.nFullArmor > 0)
		{
			m_CloakSlot_Disable.HideWindow();

			//~ for (i = 0; i<Count; i++)
			//~ {
				//~ m_equipItem[ EQUIPITEM_Cloak ].Clear();
				m_equipItem[ EQUIPITEM_Cloak ].EnableWindow();
			//~ }
		}
		else
		{

			m_CloakSlot_Disable.ShowWindow();
			m_equipItem[ EQUIPITEM_Cloak ].DisableWindow();
		}
	}
	else
	{
		//~ debug("UserInfoRetrival Failed");
	}
}

function OnTimer(int TimerID)
{
	
}


function HandleSetMaxCount(string param)
{
	local int ExtraBeltCount;
	ParseInt (param, "Inventory", m_MaxInvenCount);
	ParseInt (param, "questItem", m_MaxQuestItemInvenCount);
	ParseInt (param, "extrabelt", ExtraBeltCount);
	//~ debug ("SetMaxCount Called");
	m_invenItem.SetExpandItemNum(0, ExtraBeltCount);
	InvenLimitUpdate();
	SetItemCount();
}


function HandleChangeCharacterPawn(string param)
{
	ParseInt (param, "MeshType", m_MeshType);
	switch (m_MeshType)
	{
		case 0:
		// �޸�_����_��
		m_ObjectViewport.SetCharacterScale(1.f);
		m_ObjectViewport.SetCharacterOffsetX(-2);
		m_ObjectViewport.SetCharacterOffsetY(-6);                                       
		break;
		case 1:
		// �޸�_����_��
		m_ObjectViewport.SetCharacterScale(1.03f);
		m_ObjectViewport.SetCharacterOffsetX(-2);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		case 8:
		// �޸�_����_��
		m_ObjectViewport.SetCharacterScale(1.047f);
		m_ObjectViewport.SetCharacterOffsetX(2);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		case 9:
		// �޸�_����_��
		m_ObjectViewport.SetCharacterScale(1.07f);
		m_ObjectViewport.SetCharacterOffsetX(-1);
		m_ObjectViewport.SetCharacterOffsetY(-9);                                       
		break;
		case 6:
		// ����_����_��
		m_ObjectViewport.SetCharacterScale(0.98f);
		m_ObjectViewport.SetCharacterOffsetX(-2);
		m_ObjectViewport.SetCharacterOffsetY(-7);                                       
		break;
		case 7:
		// ����_����_��
		m_ObjectViewport.SetCharacterScale(1.04f);
		m_ObjectViewport.SetCharacterOffsetX(-4);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		// case q
		// ����_����_��
		// SetCharacterOffsetX(-2);
		// SetCharacterOffsetY(-7);
		// ����_����_��
		// SetCharacterOffsetX(-4);
		// SetCharacterOffsetY(-8);
		case 2:
		// �ٿ�_����_��
		m_ObjectViewport.SetCharacterScale(0.99f);
		m_ObjectViewport.SetCharacterOffsetX(-1);
		m_ObjectViewport.SetCharacterOffsetY(-7);                                       
		break;
		case 3:
		// �ٿ�_����_��
		m_ObjectViewport.SetCharacterScale(1.015f);
		m_ObjectViewport.SetCharacterOffsetX(-1);
		m_ObjectViewport.SetCharacterOffsetY(-7);
		break;
		// �ٿ�_����_��
		// SetCharacterOffsetX(-1);
		// SetCharacterOffsetY(-7);
		// �ٿ�_����_��
		// SetCharacterOffsetX(-1);
		// SetCharacterOffsetY(-7);
		case 10:
		// ��ũ_����_��                             
		m_ObjectViewport.SetCharacterScale(0.953f);
		m_ObjectViewport.SetCharacterOffsetX(0);
		m_ObjectViewport.SetCharacterOffsetY(-9);                                       
		break;
		case 11:
		// ��ũ_����_��
		m_ObjectViewport.SetCharacterScale(0.97f);
		m_ObjectViewport.SetCharacterOffsetX(2);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		case 12:
		// ��ũ_����_��
		m_ObjectViewport.SetCharacterScale(0.955f);
		m_ObjectViewport.SetCharacterOffsetX(-2);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		case 13:
		// ��ũ_����_��
		m_ObjectViewport.SetCharacterScale(0.985f);
		m_ObjectViewport.SetCharacterOffsetX(0);
		m_ObjectViewport.SetCharacterOffsetY(-8);                                       
		break;
		case 4:
		// �����_��
		m_ObjectViewport.SetCharacterScale(1.043f);
		m_ObjectViewport.SetCharacterOffsetX(0);
		m_ObjectViewport.SetCharacterOffsetY(-2);                                       
		break;
		case 5:
		// �����_��
		m_ObjectViewport.SetCharacterScale(1.09f);
		m_ObjectViewport.SetCharacterOffsetX(0);
		m_ObjectViewport.SetCharacterOffsetY(-6);                                       
		break;
		case 14:
		// ī����_��
		m_ObjectViewport.SetCharacterScale(0.993f);
		m_ObjectViewport.SetCharacterOffsetX(-5);
		m_ObjectViewport.SetCharacterOffsetY(-6);                                       
		break;
		case 15:
		// ī����_��
		m_ObjectViewport.SetCharacterScale(1.01f);
		m_ObjectViewport.SetCharacterOffsetX(0);
		m_ObjectViewport.SetCharacterOffsetY(-6);                                       
		break;
	}
}
defaultproperties
{
    
}

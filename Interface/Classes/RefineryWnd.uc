class RefineryWnd extends UICommonAPI;

const DIALOGID_GemstoneCount = 0;

const C_ANIMLOOPCOUNT = 1;
const C_ANIMLOOPCOUNT1 = 1;
const C_ANIMLOOPCOUNT2 = 1;
const C_ANIMLOOPCOUNT3 = 1;

var bool IsResult;
var bool procedure1stat;
var bool procedure2stat;
var bool procedure3stat;
var bool procedure4stat;

var ItemInfo RefineItemInfo;
var ItemInfo RefinerItemInfo;
var ItemInfo GemstoneItemInfo;
var ItemInfo RefinedITemInfo;
var ItemInfo TmpRefineItemInfo, TmpRefinerItemInfo, TmpGemstoneItemInfo;

var WindowHandle m_RefineryWnd_Main;
var WindowHandle m_RefineResultBackPattern;
var WindowHandle m_Highlight1;
var WindowHandle m_Highlight2;
var WindowHandle m_Highlight3;
var WindowHandle m_SeletedItemHighlight1;
var WindowHandle m_SeletedItemHighlight2;
var WindowHandle m_SeletedItemHighlight3;
var WindowHandle m_DragBox1;
var WindowHandle m_DragBox2;
var WindowHandle m_DragBox3;
var WindowHandle m_DragBoxResult;
var WindowHandle m_RefineAnimation;
var WindowHandle m_ResultAnimation1;
var WindowHandle m_ResultAnimation2;
var WindowHandle m_ResultAnimation3;

var AnimTextureHandle m_RefineAnim;
var AnimTextureHandle m_ResultAnim1;
var AnimTextureHandle m_ResultAnim2;
var AnimTextureHandle m_ResultAnim3;

var ButtonHandle m_OkBtn;
var ButtonHandle m_RefineryBtn;
var ButtonHandle m_RepeatBtn;

var ItemWindowHandle m_DragboxItem1;
var ItemWindowHandle m_DragBoxItem2;
var ItemWindowHandle m_DragBoxItem3;
var ItemWindowHandle m_ResultBoxItem;

var TextBoxHandle m_InstructionText;
var TextBoxHandle m_hGemstoneNameTextBox;
var TextBoxHandle m_hGemstoneCountTextBox;
var TextBoxHandle m_hAugmentInfoTextBox;

//var TextListBoxHandle m_hAugmentInfoTextListBox;

//���� ��� ���� ID
var ItemID m_TargetItemID;
//���� ������ ID
var ItemID m_RefineItemID;
//������ ���̵�
var ItemID m_GemStoneItemID;
//������ ���� ī��Ʈ
var INT64 m_NecessaryGemstoneCount;
var INT64 m_GemstoneCount;
var INT64 TmpNeededGems;
var string m_GemstoneName;

var InventoryWnd InventoryWndScript;
var RefOptionWnd RefOptionWndScript;
var WindowHandle InventoryWnd;
var WindowHandle OptionWnd;


var ProgressCtrlHandle m_hRefineryWndRefineryProgress;

function OnRegisterEvent()
{
	RegisterEvent( EV_Restart );                      //����ŸƮ �̺�Ʈ�� �߰���. (2009.12.2)
	RegisterEvent( EV_ShowRefineryInteface );
	RegisterEvent( EV_RefineryConfirmTargetItemResult );
	RegisterEvent( EV_RefineryConfirmRefinerItemResult );
	RegisterEvent( EV_RefineryConfirmGemStoneResult );
	RegisterEvent( EV_RefineryRefineResult );
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	IsResult = false;
	procedure1stat = false;
    procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	
// ���ϸ��̼� �ؽ��ĵ鿡 ���� Ƚ���� �����Ѵ�.
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	m_ResultAnim1.SetLoopCount( C_ANIMLOOPCOUNT1 );
	m_ResultAnim2.SetLoopCount( C_ANIMLOOPCOUNT2 );
	m_ResultAnim3.SetLoopCount( C_ANIMLOOPCOUNT3 );
	m_hRefineryWndRefineryProgress.SetProgressTime(1900);
	m_hRefineryWndRefineryProgress.HideWindow();

	// �ϼ� �� �Ʒ� �κ��� �����. ����â�� ������ ���.
	//m_RefineryWnd_Main.ShowWindow();
	//debug("������");
	//ResetReady();
	InventoryWndScript = InventoryWnd( GetScript( "InventoryWnd" ) );
	RefOptionWndScript = RefOptionWnd( GetScript( "RefOptionWnd" ) );
}

function InitHandle()
{
	m_RefineryWnd_Main = GetHandle( "RefineryWnd" );
	m_RefineResultBackPattern = GetHandle( "RefineryWnd.BackPattern");
    m_Highlight1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd.DropHighlight");
	m_SeletedItemHighlight1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd");
	m_DragBoxResult = GetHandle( "RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetHandle( "RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetHandle( "RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetHandle( "RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetHandle( "RefineryWnd.RefineResultAnimation03");

    m_RefineAnim = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim") );
    m_ResultAnim1 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation01.RefineResult1") );
    m_ResultAnim2 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation02.RefineResult2") );
    m_ResultAnim3 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation03.RefineResult3") );

	m_DragboxItem1 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox1Wnd.ItemDragBox1") );
	m_DragBoxItem2 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox2Wnd.ItemDragBox2") );
	m_DragBoxItem3 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox3Wnd.ItemDragBox3") );
	m_ResultBoxItem = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBoxResultWnd.ItemRefined") );

	m_RefineryBtn = ButtonHandle ( GetHandle ("RefineryWnd.btnRefine") );
	m_OkBtn= ButtonHandle ( GetHandle ("RefineryWnd.btnClose") );
	m_RepeatBtn= ButtonHandle ( GetHandle ("RefineryWnd.btnRepeat") );

	m_InstructionText = TextBoxHandle ( GetHandle ("RefineryWnd.txtInstruction") );
	m_hGemstoneNameTextBox = TextBoxHandle( GetHandle( "txtGemstoneName" ) );
	m_hGemstoneCountTextBox = TextBoxHandle( GetHandle( "txtGemstoneCount" ) );
	m_hAugmentInfoTextBox = TextBoxHandle( GetHandle( "RefineryWnd.AugmentInfo" ) );
	
	OptionWnd = GetHandle( "RefOptionWnd" );
	
	//m_hAugmentInfoTextListBox = TextListBoxHandle( GetHandle( "RefineryWnd.AugmentInfo2" ) );

	InventoryWnd = GetHandle("InventoryWnd");
}

function InitHandleCOD()
{
	m_RefineryWnd_Main = GetWindowHandle( "RefineryWnd" );
	m_RefineResultBackPattern = GetWindowHandle( "RefineryWnd.BackPattern");
    m_Highlight1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd.DropHighlight");
	m_SeletedItemHighlight1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd");
	m_DragBoxResult = GetWindowHandle( "RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetWindowHandle( "RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetWindowHandle( "RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetWindowHandle( "RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetWindowHandle( "RefineryWnd.RefineResultAnimation03");

    m_RefineAnim = GetAnimTextureHandle( "RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim");
    m_ResultAnim1 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation01.RefineResult1");
    m_ResultAnim2 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation02.RefineResult2");
    m_ResultAnim3 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation03.RefineResult3");

	m_DragboxItem1 = GetItemWindowHandle( "RefineryWnd.ItemDragBox1Wnd.ItemDragBox1");
	m_DragBoxItem2 = GetItemWindowHandle( "RefineryWnd.ItemDragBox2Wnd.ItemDragBox2");
	m_DragBoxItem3 = GetItemWindowHandle( "RefineryWnd.ItemDragBox3Wnd.ItemDragBox3");
	m_ResultBoxItem = GetItemWindowHandle( "RefineryWnd.ItemDragBoxResultWnd.ItemRefined");

	m_RefineryBtn = GetButtonHandle ( "RefineryWnd.btnRefine");
	m_OkBtn= GetButtonHandle ( "RefineryWnd.btnClose");
	m_RepeatBtn= GetButtonHandle ( "RefineryWnd.btnRepeat");

	m_InstructionText = GetTextBoxHandle("RefineryWnd.txtInstruction");
	m_hGemstoneNameTextBox = GetTextBoxHandle( "txtGemstoneName" );
	m_hGemstoneCountTextBox = GetTextBoxHandle( "txtGemstoneCount" );
	m_hAugmentInfoTextBox = GetTextBoxHandle("RefineryWnd.AugmentInfo");
	
	OptionWnd = GetWindowHandle( "RefOptionWnd" );
	
	//m_hAugmentInfoTextListBox = GetTextListBoxHandle("RefineryWnd.AugmentInfo2");

	InventoryWnd = GetWindowHandle("InventoryWnd");

	m_hRefineryWndRefineryProgress=GetProgressCtrlHandle("RefineryWnd.RefineryProgress");
}

function OnShow()
{
	ResetReady();
	if (!InventoryWnd.IsShowWindow())
	{
		ExecuteEvent(EV_InventoryToggleWindow);	
	}
	
	//if (OptionWnd.IsShowWindow())
		//OnClickOptionButton();
	
	
	//~ ExecuteEvent(EV_InventoryOpenWindow);
	//~ InventoryWndScript.OpenWindow();
}

function OnHide()
{
	/*RefOptionWndScript.h_aPVPM.SetCheck(false);
	RefOptionWndScript.h_pPVPM.SetCheck(false);
	RefOptionWndScript.h_aRefl.SetCheck(false);
	RefOptionWndScript.h_pRefl.SetCheck(false);
	RefOptionWndScript.h_aWM.SetCheck(false);
	RefOptionWndScript.h_pWM.SetCheck(false);
	RefOptionWndScript.h_Cel.SetCheck(false);
	RefOptionWndScript.h_Heal.SetCheck(false);
	RefOptionWndScript.h_Refr.SetCheck(false);
	RefOptionWndScript.h_SpellRefr.SetCheck(false);
	RefOptionWndScript.h_SkillRefr.SetCheck(false);
	RefOptionWndScript.h_INT.SetCheck(false);
	RefOptionWndScript.h_CON.SetCheck(false);
	RefOptionWndScript.h_STR.SetCheck(false);
	RefOptionWndScript.h_aHealEmp.SetCheck(false);
	RefOptionWndScript.h_pHealEmp.SetCheck(false);
	RefOptionWndScript.h_aProm.SetCheck(false);
	RefOptionWndScript.h_aHydr.SetCheck(false);
	RefOptionWndScript.h_aStone.SetCheck(false);
	RefOptionWndScript.h_aTemp.SetCheck(false);
	RefOptionWndScript.h_aSF.SetCheck(false);
	RefOptionWndScript.h_aSolar.SetCheck(false);
	RefOptionWndScript.h_aAura.SetCheck(false);*/
}

function ResetBools()
{
	procedure1stat = false;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_RefineAnim.Stop();
	m_ResultAnim1.Stop();
	m_ResultAnim2.Stop();
	m_ResultAnim3.Stop();
	m_hRefineryWndRefineryProgress.Reset();
}

// �ʱ�ȭ 
function ResetReady()
{
	m_RefineryBtn.SetNameText(GetSystemstring(1477));
	IsResult = false;
	procedure1stat = false;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_GemstoneName = "";
	m_RefineryWnd_Main.ShowWindow();
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.ShowWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.HideWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineAnim.Stop();
	m_ResultAnim1.Stop();
	m_ResultAnim2.Stop();
	m_ResultAnim3.Stop();
	// ResetProgressBar
	m_InstructionText.SetText(GetSystemMessage(1957));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hAugmentInfoTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.Clear();
	m_DragBoxItem2.Clear();
	m_DragBoxItem3.Clear();
	m_RefineryBtn.DisableWindow();
	m_RepeatBtn.DisableWindow();
	m_hRefineryWndRefineryProgress.Reset();
	//MoveItemBoxes( true );
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.DisableWindow();
	m_DragBoxItem3.DisableWindow();
	Playsound("ItemSound2.smelting.Smelting_dragin");
	m_OkBtn.EnableWindow();
}      
       

// Restart �� �ʱ�ȭ , show, sound ��� ����. 
function ResetReadyForRestart()
{
	m_RefineryBtn.SetNameText(GetSystemstring(1477));
	IsResult = false;
	procedure1stat = false;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_GemstoneName = "";
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.ShowWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.HideWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineAnim.Stop();
	m_ResultAnim1.Stop();
	m_ResultAnim2.Stop();
	m_ResultAnim3.Stop();
	// ResetProgressBar
	m_InstructionText.SetText(GetSystemMessage(1957));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hAugmentInfoTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.Clear();
	m_DragBoxItem2.Clear();
	m_DragBoxItem3.Clear();
	m_RefineryBtn.DisableWindow();
	m_hRefineryWndRefineryProgress.Reset();
	//MoveItemBoxes( true );
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.DisableWindow();
	m_DragBoxItem3.DisableWindow();
	m_OkBtn.EnableWindow();
}  

// ���� ��� Ȯ�� ��� �� ó���� �͵�
function OnRefineryConfirmTargetItemResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.ShowWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	procedure1stat = true;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_InstructionText.SetText(GetSystemMessage(1958));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.EnableWindow();
	m_DragBoxItem3.DisableWindow();
	m_RefineryBtn.DisableWindow();
}      

// ���� ������ Ȯ�� �� ó���� �͵�
function OnRefineryConfirmRefinerItemResult()
{
	local String GemstoneName;
	local String Instruction;

	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.ShowWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.ShowWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = false;
	procedure4stat = false;

	GemstoneName = class'UIDATA_ITEM'.static.GetItemName( m_GemStoneItemID );
	m_GemstoneName = GemstoneName;
	Instruction = MakeFullSystemMsg( GetSystemMessage( 1959 ), GemstoneName, Int64ToString( m_NecessaryGemstoneCount ) );
	m_InstructionText.SetText( Instruction );
	m_hGemstoneNameTextBox.SetText( GemstoneName );
	m_hGemstoneCountTextBox.SetText( MakeCostStringInt64(  m_NecessaryGemstoneCount ) );
	m_hGemstoneCountTextBox.SetTooltipString( ConvertNumToTextNoAdena( Int64ToString( m_NecessaryGemstoneCount ) ) );
	
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.EnableWindow();
	m_DragBoxItem3.EnableWindow();
	m_RefineryBtn.DisableWindow();
}      

// ���� ������ ������ ��� Ȯ�� �� ó���� �͵�
function OnRefineryConfirmGemStoneResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.ShowWindow();
	m_SeletedItemHighlight3.ShowWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = true;
	procedure4stat = false;
	
	m_InstructionText.SetText(GetSystemMessage(1984));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_RefineryBtn.EnableWindow();
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	//m_DragBoxItem3.SetTooltip(m_GemstoneName @ "(" @m_NecessaryGemstoneCount @ ")");
	
}	

// ���� ��� �� ó���� �͵�
function OnRefineryRefineResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_DragBox1.HideWindow();
	m_DragBox2.HideWindow();
	m_DragBox3.HideWindow();
	//MoveItemBoxes( true );
	m_DragBoxResult.ShowWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = true;
	procedure4stat = true;
	m_InstructionText.SetText(GetSystemMessage(1962));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
}

//Event
function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	// Refinery Window Open
	case EV_ShowRefineryInteface:
		if (procedure1stat == false)
		{
			ShowRefineryInterface();
		}
		break;
	// Target Item Validation Result
	case EV_RefineryConfirmTargetItemResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnTargetItemValidationResult( a_Param );
		break;
	// Refiner Item Validation Result
	case EV_RefineryConfirmRefinerItemResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnRefinerItemValidationResult( a_Param );
		break;
	// Gemstone Validation Result
	case EV_RefineryConfirmGemStoneResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnGemstoneValidationResult( a_Param );
		break;
	// Final Refine Result
	case EV_RefineryRefineResult:
		
		OnRefineDoneResult( a_Param );
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_Restart :                  // �ɼ�>����ŸƮ �� ��쿡��
		ResetReadyForRestart();        // �ʱ�ȭ��Ų��.
		break;

	default:
		break;
	}	
}

// ����â �����ִ� �Լ� 
function ShowRefineryInterface()
{
	ResetReady();
}

// �������� �÷� ���� ��� �б�
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	switch (a_WindowID)
	{
		case "ItemDragBox1":
			//debug("�巡�� �ڽ� 1�� ������ �÷� ������." @ procedure1stat @ procedure2stat @ procedure3stat);
			if (procedure1stat == false && procedure2stat == false && procedure3stat == false)
				ValidateFirstItem( a_ItemInfo );
			
		break;
		case "ItemDragBox2":
			//debug("�巡�� �ڽ� 2�� ������ �÷� ������." @ procedure1stat @ procedure2stat @ procedure3stat);
			if(procedure1stat == true && procedure2stat == false && procedure3stat == false)
				ValidateSecondItem( a_ItemInfo );
		break;
		case "ItemDragBox3":
			//debug("�巡�� �ڽ� 3�� ������ �÷� ������." @ procedure1stat @ procedure2stat @ procedure3stat);
			if(procedure1stat == true && procedure2stat == true && procedure3stat == false )
			ValidateGemstoneItem( a_ItemInfo);
		break;
	}
}

// ������  �������� ������û
function ValidateFirstItem(ItemInfo a_ItemInfo)
{
	RefineItemInfo = a_ItemInfo;
	m_TargetItemID = a_ItemInfo.ID;

	class'RefineryAPI'.static.ConfirmTargetItem( m_TargetItemID );
}

//������ �������� ���������� ����
function OnTargetItemValidationResult(string a_Param)
{
	local int ItemValidationResult1;
	local ItemID scID;
	
	ParseItemID(a_Param, scID);
	ParseInt(a_Param, "Result", ItemValidationResult1);
	
	switch (ItemValidationResult1)
	{
	//Case Granted
	case 1:
		if (IsSameServerID(scID, RefineItemInfo.ID))
		{
			if( !m_DragBoxItem1.SetItem( 0, RefineItemInfo ) )
				m_DragBoxItem1.AddItem( RefineItemInfo );

			OnRefineryConfirmTargetItemResult();
		}
		break;
	//Case Declined
	case 0:
		break;
	}	
}

//������ ���� ��û
function ValidateSecondItem(ItemInfo a_ItemInfo)
{
	RefinerItemInfo = a_ItemInfo;
	m_RefineItemID = a_ItemInfo.ID;
	class'RefineryAPI'.static.ConfirmRefinerItem( m_TargetItemID, m_RefineItemID );
}

//�������� ���� ���� �� ����
function OnRefinerItemValidationResult(string a_Param)
{
	local ItemID scID;
	local ItemID GemstoneID;
	local int ItemValidationResult2;
	local INT64 RequiredGemstoneAmount;
	
	//debug ("�ι�° �̺�Ʈ ����:������");
	
	ParseItemID(a_Param, scID);
	ParseItemIDWithIndex(a_Param, GemstoneID, 1);
	ParseInt(a_Param, "Result", ItemValidationResult2);
	ParseINT64(a_Param, "GemStoneCount", RequiredGemstoneAmount);
	
	m_GemStoneItemID = GemstoneID;
	m_NecessaryGemstoneCount = RequiredGemstoneAmount;
	TmpNeededGems = m_NecessaryGemstoneCount;
	
	switch( ItemValidationResult2 )
	{
	case 1:
		if (IsSameServerID(scID, RefinerItemInfo.ID))
		{
			RefinerItemInfo.ItemNum = IntToInt64(1) ;
			if( !m_DragBoxItem2.SetItem( 0, RefinerItemInfo ) )
				m_DragBoxItem2.AddItem( RefinerItemInfo );
			OnRefineryConfirmRefinerItemResult();
			TmpRefinerItemInfo = RefinerItemInfo;
		}
		break;
	case 0:
		break;
	}
}

//������ ������û
function ValidateGemstoneItem(ItemInfo a_ItemInfo)
{
	GemstoneItemInfo = a_ItemInfo;
	m_GemStoneItemID = a_ItemInfo.ID;
//	debug( string(a_ItemInfo.AllItemCount ));
//	if( a_Iteminfo.AllItemCount > IntToInt64(0) )
	if( a_ItemInfo.itemNum > IntToInt64(0) )
	{
		if(m_NecessaryGemstoneCount <= a_ItemInfo.itemNum)
		{
			m_GemstoneCount = m_NecessaryGemstoneCount;
		}
		else
		{
			m_GemstoneCount = a_ItemInfo.itemNum;
		}
		class'RefineryAPI'.static.ConfirmGemStone( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount );
	}
	else												// ���ڸ� ��� ���ΰ�
	{
		DialogSetID( DIALOGID_GemstoneCount );
		DialogSetParamInt64( a_ItemInfo.ItemNum );
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage( 72 ), a_ItemInfo.Name, "" ) );
	}	
}      

//�������� ���� ���� �� ����
function OnGemstoneValidationResult(String a_Param)
{
	local ItemID scID;
	local int ItemValidationResult3;
	local INT64 RequiredMoreGemstoneAmount;
	local INT64 GemstoneAmountChecked;
	
	//debug ("����° �̺�Ʈ ����:������");
	
	ParseItemID(a_Param, scID);
	ParseInt(a_Param, "Result", ItemValidationResult3);
	ParseINT64(a_Param, "NecessaryGemStoneCount", RequiredMoreGemstoneAmount);
	ParseINT64(a_Param, "GemStoneCount", GemstoneAmountChecked);
	
	m_GemStoneItemID = scID;
	
	m_NecessaryGemstoneCount = GemstoneAmountChecked + RequiredMoreGemstoneAmount;
	
	
	switch (ItemValidationResult3)
	{
	case 1:
		if (IsSameServerID(scID, GemstoneItemInfo.ID))
		{
			if( !m_DragBoxItem3.SetItem( 0, GemstoneItemInfo ) )
			{
				GemstoneItemInfo.ItemNum = GemstoneAmountChecked;
				m_DragBoxItem3.AddItem( GemstoneItemInfo );	
			}

			OnRefineryConfirmGemStoneResult();
			TmpGemstoneItemInfo = GemstoneItemInfo;
			
		}
		break;
	case 0:
		break;
	}	
}

// ��ư�� ��������
function OnClickButton( string strID )
{
	switch (strID)
	{
		case "btnRefine":
			if(IsResult) //��� ȭ���϶�
			{
				OnClickCancelButton();
				ShowRefineryInterface();
				
			}
			else //���� ȭ���϶�
			{
				//debug("Button ������");
				Playsound("Itemsound2.smelting.smelting_loding");
				OnClickRefineButton();
			}
			break;
		case "btnClose":
			OnClickCancelButton();
			break;
		case "btnRepeat":
			OnClickRepeatButton();
			break;
		case "btnRefOption":
			OnClickOptionButton();
			break;
	}
}

function OnClickOptionButton()
{
	local RefOptionWnd script_a;
	script_a = RefOptionWnd(GetScript("RefOptionWnd"));
	
	if (OptionWnd.IsShowWindow())
	{
		OptionWnd.HideWindow();
		
			
		script_a.h_aPVPM.EnableWindow();
		script_a.h_pPVPM.EnableWindow();
		script_a.h_aRefl.EnableWindow();
		script_a.h_pRefl.EnableWindow();
		script_a.h_aWM.EnableWindow();
		script_a.h_pWM.EnableWindow();
		script_a.h_Cel.EnableWindow();
		script_a.h_Heal.EnableWindow();
		script_a.h_Refr.EnableWindow();
		script_a.h_SpellRefr.EnableWindow();
		script_a.h_SkillRefr.EnableWindow();
		script_a.h_INT.EnableWindow();
		script_a.h_CON.EnableWindow();
		script_a.h_STR.EnableWindow();
		script_a.h_aHealEmp.EnableWindow();
		script_a.h_pHealEmp.EnableWindow();
		script_a.h_aProm.EnableWindow();
		script_a.h_aHydr.EnableWindow();
		script_a.h_aTemp.EnableWindow();
		script_a.h_aStone.EnableWindow();
		script_a.h_aSF.EnableWindow();
		script_a.h_aSolar.EnableWindow();
		script_a.h_aAura.EnableWindow();
		script_a.h_aCombo.EnableWindow();
		script_a.h_aCombo.SetCheck(false);
	}
	else
	{
		OptionWnd.ShowWindow();
		
		script_a.h_aPVPM.EnableWindow();
		script_a.h_pPVPM.EnableWindow();
		script_a.h_aRefl.EnableWindow();
		script_a.h_pRefl.EnableWindow();
		script_a.h_aWM.EnableWindow();
		script_a.h_pWM.EnableWindow();
		script_a.h_Cel.EnableWindow();
		script_a.h_Heal.EnableWindow();
		script_a.h_Refr.EnableWindow();
		script_a.h_SpellRefr.EnableWindow();
		script_a.h_SkillRefr.EnableWindow();
		script_a.h_INT.EnableWindow();
		script_a.h_CON.EnableWindow();
		script_a.h_STR.EnableWindow();
		script_a.h_aHealEmp.EnableWindow();
		script_a.h_pHealEmp.EnableWindow();
		script_a.h_aProm.EnableWindow();
		script_a.h_aHydr.EnableWindow();
		script_a.h_aTemp.EnableWindow();
		script_a.h_aStone.EnableWindow();
		script_a.h_aSF.EnableWindow();
		script_a.h_aSolar.EnableWindow();
		script_a.h_aAura.EnableWindow();
		script_a.h_aCombo.EnableWindow();
		script_a.h_aCombo.SetCheck(false);
	}
		
}

function OnClickCancelButton()
{
	m_RefineryWnd_Main.HideWindow();
	Playsound("Itemsound2.smelting.smelting_dragout");
	m_hRefineryWndRefineryProgress.Stop();
	m_RefineAnim.Stop();
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	
	procedure1stat = false;
    procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
}

// ���� ��ư�� ������ �� ó���� �͵�
function OnClickRefineButton()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.ShowWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineryBtn.DisableWindow();
	m_OkBtn.DisableWindow();
	//~ procedure1stat = true;
	//~ procedure2stat = true;
	//~ procedure3stat = true;
	//~ procedure4stat = true;
	//PlayRefineAnimation();
	//MoveItemBoxes( false );
	OnRefineRequest();
}

function OnClickRepeatButton()
{
	local INT64 GemCount, LSCount;
	
	GemCount = GetInventoryItemCount(TmpGemstoneItemInfo.ID);
	LSCount = GetInventoryItemCount(TmpRefinerItemInfo.ID);
	
	if (LSCount > IntToInt64(0) && GemCount >= TmpNeededGems)
	{
		OnClickCancelButton();
		ShowRefineryInterface();
		
		//AddSystemMessageString("GEMS - " $ Int64ToString(GemCount));
		//AddSystemMessageString("LS's - " $ Int64ToString(LSCount));
		
		class'RefineryAPI'.static.ConfirmCancelItem( TmpRefineItemInfo.ID );
		class'RefineryAPI'.static.RequestRefineCancel( TmpRefineItemInfo.ID );

		
		m_RefineResultBackPattern.HideWindow();
		m_Highlight1.HideWindow();
		m_Highlight2.HideWindow();
		m_Highlight3.HideWindow();
		m_DragBoxResult.HideWindow();
		m_ResultAnimation1.HideWindow();
		m_ResultAnimation2.HideWindow();
		m_ResultAnimation3.HideWindow();
		//m_RefineryBtn.DisableWindow();
		//m_OkBtn.DisableWindow();
		
		class'RefineryAPI'.static.RequestRefine( TmpRefineItemInfo.ID, TmpRefinerItemInfo.ID, TmpGemstoneItemInfo.ID, m_NecessaryGemstoneCount);

		
	} else if (GemCount < TmpNeededGems)
	{
		m_hAugmentInfoTextBox.SetText( "Not enough gems!");
		if (RefOptionWndScript.b_Stop.IsShowWindow())
			RefOptionWndScript.OnClickStopButton();
	} 
	else
	{
		m_hAugmentInfoTextBox.SetText( "Not enough lifestones!");
		if (RefOptionWndScript.b_Stop.IsShowWindow())
			RefOptionWndScript.OnClickStopButton();
	} 
		
}       

function PlayRefineAnimation()
{
	m_InstructionText.SetText("");
	m_RefineAnim.Stop();
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	m_RefineAnim.Play();
	//debug("smelting_loding");
//	Playsound("Itemsound2.smelting.smelting_loding");
//	Playsound("ItemSound2.smelting.smelting_loding");
	m_hRefineryWndRefineryProgress.Start();

}

//���� ����Ʈ �ִϸ��̼��� ���� Ȯ�� �� ���� ��û
function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	switch ( a_WindowHandle )
	{
	case m_RefineAnim:
		//m_RefineAnim.Stop();
		m_RefineAnimation.HideWindow();
		m_DragBox1.HideWindow();
		m_DragBox2.HideWindow();
		m_DragBox3.HideWindow();
		OnRefineRequest();
		break;
	case m_ResultAnim1:
	case m_ResultAnim2:
	case m_ResultAnim3:
		OnResultAnimEnd();
		break;
	}
}

function OnResultAnimEnd()
{
	//m_ResultAnim1.Stop();
	m_ResultAnimation1.HideWindow();
	//m_ResultAnim2.Stop();
	m_ResultAnimation2.HideWindow();
	//m_ResultAnim3.Stop();
	m_ResultAnimation3.HideWindow();
}

// ������ ������ ��û�ϴ� �Լ� 
function OnRefineRequest()
{
	if (procedure1stat && procedure2stat && procedure3stat && !procedure4stat)
	{
		class'RefineryAPI'.static.RequestRefine( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_NecessaryGemstoneCount);
		procedure1stat = true;
		procedure2stat = true;
		procedure3stat = true;
		procedure4stat = true;
	}
}

function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch (Quality)
	{
	case 1:
		R = 187;
		G = 181;
		B = 138;
	break;
	case 2:
		R = 132;
		G = 174;
		B = 216;
	break;
	case 3:
		R = 193;
		G = 112;
		B = 202;
	break;
	case 4:
		R = 225;
		G = 109;
		B = 109;
	break;
	default:
		R = 187;
		G = 181;
		B = 138;
	break;
	}
}

//���� �Ϸῡ ���� ��� Ȯ�� 
function OnRefineDoneResult(string a_Param)
{
	local int Option1;
	local int Option2;
	local int RefineResult;
	local int Quality;
	
	local Color TextColor;
	local int ColorR, ColorG, ColorB;
	
	local string str1,str2,str3,str4,str5,str6;
	local string uString;
	local int i,j,k,l;
	
	//debug ("���ÿϷ�: ��� Ȯ��");
	ParseInt(a_Param, "Option1", Option1);
	ParseInt(a_Param, "Option2", Option2);
	ParseInt(a_Param, "Result", RefineResult);
	
	m_hRefineryWndRefineryProgress.SetPos(0);
	//~ progFATIGUE.SetPos(RemainTime);
	
	m_OkBtn.EnableWindow();
	m_RepeatBtn.EnableWindow();
	
	switch (RefineResult)
	{
	case 1:
		//���� ���� �ɼǿ� ���� ������ ������Ʈ�ϰ� ���ϸ��̼� ����
		// ��ư�� Ȱ��ȭ ��Ű�� �ڵ�
		// ������ ������Ʈ�� UI�� ���� �� ��.?
		RefineItemInfo.RefineryOp1 = Option1;
		RefineItemInfo.RefineryOp2 = Option2;
		
		if (Option2 != 0)
		{
			Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Option2 );
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		
		TextColor.R = ColorR;
		TextColor.G = ColorG;
		TextColor.B = ColorB;
		
		
		class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Option1, str1, str2, str3 );
		class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Option2, str4, str5, str6);
		
		str1 = ReplaceTextWith(str1, "\\n", "");
		str2 = ReplaceTextWith(str2, "\\n", "");
		str3 = ReplaceTextWith(str3, "\\n", "");
		str4 = ReplaceTextWith(str4, "\\n", "");
		
		uString = str1 @ str2 @ str3 @ str4; 
		
		m_hAugmentInfoTextBox.SetText( uString );
		m_hAugmentInfoTextBox.SetTextColor( TextColor );
		
		if (RefOptionWndScript.isAutoBegin)
		{
			if (!RefOptionWndScript.h_aCombo.IsChecked())
			{
				for (i = 0; i < 6; i++)
					for (j = 0; j < 3; j++)
						if (Option1 == (RefOptionWndScript.Stats[i] - 1638 * j ) )
						{
							AddSystemMessageString("Got Stat");
							RefOptionWndScript.OnClickStopButton();
							break;
						}
					for (j =0; j < 10; j++)
						if (Option1 == ( ( RefOptionWndScript.Stats[i] - 8322 ) - 4 * j ) )
						{
							AddSystemMessageString("Got Stat");
							RefOptionWndScript.OnClickStopButton();
							break;
						}
				
				for (i = 0; i < 32; i++)
				{
					for (j = 0; j < 3; j++)
						if ( Option2 == (RefOptionWndScript.Skills[i] - 1638 * j ) )
						{
							AddSystemMessageString("Got Skill");
							RefOptionWndScript.OnClickStopButton();
							break;
						}
					for (j = 0; j < 10; j++)
						if ( Option2 == ( ( RefOptionWndScript.Skills[i] - 8358 ) - 178 * j ) )
						{
							AddSystemMessageString("Got Skill");
							RefOptionWndScript.OnClickStopButton();
							break;
						}
				}
					
			}
			else
			{
				for (i = 0; i < 6; i++)
				{
					for (j = 0; j < 3; j++)
						if (Option1 == (RefOptionWndScript.Stats[i] - 1638 * j ) )
						{
							for (k = 0; k < 32; k++)
							{
								for (l = 0; l < 3; l++)
									if ( Option2 == (RefOptionWndScript.Skills[k] - 1638 * l ) )
									{
										AddSystemMessageString("Got Combo");
										RefOptionWndScript.OnClickStopButton();
										break;
									}
								for (l = 0; l < 10; l++)
									if ( Option2 == ( ( RefOptionWndScript.Skills[k] - 8358 ) - 178 * l ) )
									{
										AddSystemMessageString("Got Combo");
										RefOptionWndScript.OnClickStopButton();
										break;
									}
							}
		
						}
					for (j =0; j < 10; j++)
						if (Option1 == ( ( RefOptionWndScript.Stats[i] - 8322 ) - 4 * j ) )
						{
							for (k = 0; k < 32; k++)
							{
								for (l = 0; l < 3; l++)
									if ( Option2 == (RefOptionWndScript.Skills[k] - 1638 * l ) )
									{
										AddSystemMessageString("Got Combo");
										RefOptionWndScript.OnClickStopButton();
										break;
									}
								for (l = 0; l < 10; l++)
									if ( Option2 == ( ( RefOptionWndScript.Skills[k] - 8358 ) - 178 * l ) )
									{
										AddSystemMessageString("Got Combo");
										RefOptionWndScript.OnClickStopButton();
										break;
									}
							}
						}
				}
			}
		}
		

		if( !m_ResultBoxItem.SetItem( 0, RefineItemInfo ) )
			m_ResultBoxItem.AddItem( RefineItemInfo );
		
		TmpRefineItemInfo = RefineItemInfo;

		OnRefineryRefineResult();

		Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Option2 );
		if( 0 >= Quality )
			Quality = 1;
		else if( 4 < Quality )
			Quality = 4;

		m_RefineResultBackPattern.ShowWindow();
		m_RefineResultBackPattern.SetAlpha( 0 );
		m_RefineResultBackPattern.SetAlpha( 255, 1.f );
		PlayResultAnimation( Quality );
		m_RefineryBtn.SetNameText(GetSystemstring(1731));
		m_RefineryBtn.EnableWindow();
		IsResult = true;
		break;
		
	case 0:
		OnClickCancelButton();
		break;
	}	
}

function HandleDialogOK()
{
	local int ID;

	if( DialogIsMine() )
	{
		ID = DialogGetID();

		switch( ID )
		{
		case DIALOGID_GemstoneCount:
			m_GemstoneCount = StringToInt64( DialogGetString() );
			class'RefineryAPI'.static.ConfirmGemStone( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount );
			break;
		}		
	}
}

// ���� �Ϸ� �ִϸ��̼� ���
function PlayResultAnimation(int Grade)
{
	m_ResultAnim1.SetLoopCount( C_ANIMLOOPCOUNT1 );
	m_ResultAnim2.SetLoopCount( C_ANIMLOOPCOUNT2 );
	m_ResultAnim3.SetLoopCount( C_ANIMLOOPCOUNT3 );
	switch(Grade)
	{
	case 1:
		m_ResultAnimation1.ShowWindow();
		Playsound("ItemSound2.smelting.smelting_finalB");
		m_ResultAnim1.Play();
		break;
	case 2:
		m_ResultAnimation2.ShowWindow();
		Playsound("ItemSound2.smelting.smelting_finalC");
		m_ResultAnim2.Play();
		break;
	case 3:
		m_ResultAnimation3.ShowWindow();
		Playsound("ItemSound2.smelting.smelting_finalD");
		m_ResultAnim3.Play();
		break;
	case 4:
		m_ResultAnimation1.ShowWindow();
		m_ResultAnimation2.ShowWindow();
		m_ResultAnimation3.ShowWindow();
		Playsound("ItemSound2.smelting.smelting_finalD");
		m_ResultAnim1.Play();
		m_ResultAnim2.Play();
		m_ResultAnim3.Play();
		break;
	
	}
}

function MoveItemBoxes( bool a_Origin )
{
	local Rect Item1Rect;
	local Rect Item2Rect;
	local Rect Item3Rect;
	local Rect ResultRect;

	if( a_Origin )
	{
		m_DragBox1.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 77, 51 );
		m_DragBox1.ClearAnchor();
		m_DragBox2.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 157, 51 );
		m_DragBox2.ClearAnchor();
		m_DragBox3.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 117, 91 );
		m_DragBox3.ClearAnchor();
	}
	else
	{
		Item1Rect = m_DragBox1.GetRect();
		Item2Rect = m_DragBox2.GetRect();
		Item3Rect = m_DragBox3.GetRect();
		ResultRect = m_DragBoxResult.GetRect();

		m_DragBox1.Move( ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 1.5f );
		m_DragBox2.Move( ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 1.5f );
		m_DragBox3.Move( ResultRect.nX - Item3Rect.nX, ResultRect.nY - Item3Rect.nY, 1.5f );
	}
}

defaultproperties
{
}

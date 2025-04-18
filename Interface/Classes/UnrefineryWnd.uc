class UnrefineryWnd extends UICommonAPI;

var WindowHandle m_UnRefineryWnd_Main;
var WindowHandle m_ItemtoUnRefineWnd;
var WindowHandle m_ItemtoUnRefineAnim;
var WindowHandle m_hSelectedItemHighlight;
var WindowHandle m_ResultAnimation1;
//var AnimTextureHandle m_ResultAnim1;

var bool IsResult;

var TextBoxHandle m_InstructionText;
var TextBoxHandle m_AdenaText;

var ButtonHandle m_hUnrefineButton;
var ButtonHandle m_OkBtn;

var ItemWindowHandle m_ItemDragBox;

var ProgressCtrlHandle  m_UnRefineryProgress;

var ItemInfo CurrentItem;
//var bool procedure1stat;
//var bool procedureopenstat;
var int64 m_Adena;

var ProgressCtrlHandle m_hUnrefineryWndUnRefineryProgress;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowRefineryCancelInteface );
	RegisterEvent(EV_RefineryConfirmCancelItemResult );
	RegisterEvent(EV_RefineryRefineCancelResult );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_ResultAnimation1 = GetHandle( "UnrefineryWnd.RefineResultAnimation01");
		//m_ResultAnim1 = AnimTextureHandle ( GetHandle( "UnrefineryWnd.RefineResultAnimation01.RefineResult1") );
		m_UnRefineryWnd_Main = GetHandle ("UnrefineryWnd");
		m_UnRefineryProgress = ProgressCtrlHandle(GetHandle("UnRefineryProgress"));
		m_ItemtoUnRefineWnd = GetHandle ("Itemtounrefine");
		m_ItemtoUnRefineAnim = GetHandle ("ItemtounrefineAnim");
		m_hSelectedItemHighlight = GetHandle( "SelectedItemHighlight" );
		m_ItemDragBox = ItemWindowHandle (GetHandle ("UnRefineryWnd.Itemtounrefine.ItemUnrefine"));
		m_InstructionText = TextBoxHandle ( GetHandle ("UnrefineryWnd.txtInstruction") );
		m_AdenaText = TextBoxHandle ( GetHandle ("UnrefineryWnd.txtAdenaInstruction") );
		m_hUnrefineButton = ButtonHandle( GetHandle( "btnUnRefine" ) );	
		m_OkBtn= ButtonHandle(GetHandle( "btnClose" ) );
	}
	else
	{
		m_ResultAnimation1 = GetWindowHandle( "UnrefineryWnd.RefineResultAnimation01");
		//m_ResultAnim1 = GetAnimTextureHandle ( "UnrefineryWnd.RefineResultAnimation01.RefineResult1");
		m_UnRefineryWnd_Main = GetWindowHandle("UnrefineryWnd");
		m_UnRefineryProgress = GetProgressCtrlHandle("UnRefineryProgress");
		m_ItemtoUnRefineWnd = GetWindowHandle("Itemtounrefine");
		m_ItemtoUnRefineAnim = GetWindowHandle("ItemtounrefineAnim");
		m_hSelectedItemHighlight = GetWindowHandle( "SelectedItemHighlight" );
		m_ItemDragBox = GetItemWindowHandle ( "UnRefineryWnd.Itemtounrefine.ItemUnrefine");
		m_InstructionText = GetTextBoxHandle ( "UnrefineryWnd.txtInstruction");
		m_AdenaText = GetTextBoxHandle ( "UnrefineryWnd.txtAdenaInstruction");
		m_hUnrefineButton = GetButtonHandle( "btnUnRefine" );	
		m_OkBtn= GetButtonHandle("btnClose" );

		m_hUnrefineryWndUnRefineryProgress=GetProgressCtrlHandle("UnrefineryWnd.UnRefineryProgress");
	}
	
	//procedure1stat = false;
	//procedureopenstat = false;
}

function OnShow()
{
	ResetReady();
}

// �ʱ�ȭ 
function ResetReady()
{
	//procedure1stat = false;
	//procedureopenstat = false;
	IsResult = false;
	m_UnRefineryWnd_Main.ShowWindow();
	m_ItemtoUnRefineWnd.ShowWindow();
	m_ItemtoUnRefineAnim.ShowWindow();
	m_hSelectedItemHighlight.HideWindow();
	m_ResultAnimation1.HideWindow();
	//m_ResultAnim1.Stop();
	m_UnRefineryProgress.SetProgressTime(2000);
	m_UnRefineryProgress.Reset();
	m_hUnrefineButton.DisableWindow();
	m_ItemDragBox.Clear();
	m_InstructionText.SetText( GetSystemMessage( 1963 ) );
	SetAdenaText( "0" );
	m_AdenaText.SetTooltipString( "" );
	// ResetProgressBar
	Playsound("ItemSound2.smelting.Smelting_dragin");
	m_OkBtn.EnableWindow();
}      


//function DoneUnRefine()
//{
//	procedure1stat = true;
//	m_UnRefineryWnd_Main.ShowWindow();
//	m_ItemtoUnRefineWnd.ShowWindow();
//	m_ItemtoUnRefineAnim.HideWindow();
//}

//Event
function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	// UnRefinery Window Open
	case EV_ShowRefineryCancelInteface:
		//if (procedureopenstat == false)
		//{
			Playsound("ItemSound2.smelting.Smelting_dragin");
			ResetReady();
		//}
		break;
	// Target Item Validation Result
	case EV_RefineryConfirmCancelItemResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnTargetItemValidationResult( a_Param );
		break;
	// Final Refine Result
	case EV_RefineryRefineCancelResult:
		Playsound("ItemSound2.smelting.smelting_finalA");
		OnUnRefineDoneResult( a_Param );
		break;
	default:
		break;
	}	
}

// �������� �÷� ���� ��� �б�
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	switch (a_WindowID)
	{
		case "ItemUnrefine":
			//if (procedure1stat == false)
				ValidateItem( a_ItemInfo );
		break;
	}
}

// �������� ������û
function ValidateItem(ItemInfo a_ItemInfo)
{
	CurrentItem = a_ItemInfo;
	class'RefineryAPI'.static.ConfirmCancelItem( a_ItemInfo.ID );
}

//�������� ���������� ����
function OnTargetItemValidationResult(string a_Param)
{
	local int ItemServerID;
	local int ItemClassID;
	local int Option1;
	local int Option2;
	local int ItemValidationResult;
	local String AdenaText;
	//local String AdenaNum;
	
	//debug ("������ ���� ����");
	
	ParseInt(a_Param, "CancelItemServerID", ItemServerID);
	ParseInt(a_Param, "CancelItemClassID", ItemClassID);
	ParseInt(a_Param, "Option1", Option1);
	ParseInt(a_Param, "Option2", Option2);
	ParseInt64(a_Param, "Adena", m_Adena);
	ParseInt(a_Param, "Result", ItemValidationResult);

	//ParseString(a_Param, "Adena", AdenaNum);
	
	switch (ItemValidationResult)
	{
	//Case Granted
	case 1:
		m_hUnrefineButton.EnableWindow();
		if( !m_ItemDragBox.SetItem( 0, CurrentItem ) )
			m_ItemDragBox.AddItem( CurrentItem );
		AdenaText = MakeCostStringInt64( m_Adena );
		SetAdenaText( AdenaText );
		
		m_ItemtoUnRefineAnim.HideWindow();
		m_hSelectedItemHighlight.ShowWindow();
		
		m_InstructionText.SetText( "" );
		
		//procedureopenstat = true;
			if (CheckAdena() == false)
			{
				m_hUnrefineButton.DisableWindow();
				m_InstructionText.SetText( GetSystemMessage(279) );
			}
		break;
	//Case Declined
	case 0:
		break;
	}
	
	// ������ ������Ʈ�� UI�� ���� �� ��.?	
}

function SetAdenaText( String a_AdenaText )
{
	local string adenatext;
	adenatext = ConvertNumToText(a_AdenaText);
	m_AdenaText.SetText( a_AdenaText @ GetSystemString(469));
	m_AdenaText.SetTextColor( GetNumericColor( a_AdenaText ) );
	if (int(a_AdenaText) == 0)
	m_AdenaText.SetTooltipString( "" );	
	else 
	m_AdenaText.SetTooltipString( adenatext );
}

// ��ư�� ��������
function OnClickButton( string strID )
{
	switch (strID)
	{
	case "btnUnRefine":
		if(IsResult)
		{
			m_hUnrefineButton.SetNameText(GetSystemstring(1479));
			ResetReady();
		}
		else
		{
			OnClickUnRefineButton();
		}
		//Playsound("Itemsound2.smelting.smelting_loding");
		break;
	case "btnClose":
		m_UnRefineryProgress.reset();
		Playsound("Itemsound2.smelting.smelting_dragout");
		m_UnRefineryWnd_Main.HideWindow();
		break;
	}
}

function OnClickUnRefineButton()
{
	local INT64 Diff;
	local INT64 CurAdena;

	CurAdena = GetAdena();
	Diff = CurAdena - m_Adena;
	if( Diff >= IntToInt64(0) )
	{
		// �� ����
		m_hUnrefineButton.DisableWindow();
		//m_ResultAnim1.SetLoopCount( 1 );
		//m_UnRefineryProgress.start();
		//m_ResultAnimation1.ShowWindow();
		OnUnRefineRequest();
		Playsound("ItemSound2.smelting.smelting_loding");
		
		//m_ResultAnim1.Play();
		//PlayProgressiveBar();
		m_OkBtn.DisableWindow();
		
	}
	else
	{
		// �� ����
		DialogShow(DIALOG_Modalless, DIALOG_OK, GetSystemMessage( 279 ) );
	}	
}

function bool CheckAdena()
{
	local INT64 Diff;
	local INT64 CurAdena;

	CurAdena = GetAdena();
	Diff = CurAdena - m_Adena;
	if( Diff >= IntToInt64(0) )
		return true;
	else
		return false;
}

function PlayProgressiveBar()
{
	m_hUnrefineryWndUnRefineryProgress.Start();
}

//���� ����Ʈ �ִϸ��̼��� ���� Ȯ�� �� ���� ��û
//~ function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
//~ {
	//~ switch ( a_WindowHandle )
	//~ {
	//~ case m_RefineResult1:
		//~ OnUnRefineRequest();
		//~ break;
	//~ }
//~ }

//~ function OnProgressTimeUp( String aWindowID )
//~ {
	//~ debug("��� ����");
	//~ switch ( aWindowID )
	//~ {
		//~ case "UnRefineryProgress":
			//~ OnUnRefineRequest();
		//~ break;
	//~ }
//~ }

/*function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	switch ( a_WindowHandle )
	{
	case m_ResultAnim1:
		m_ResultAnimation1.HideWindow();
		OnUnRefineRequest();
		break;
	}
}*/

// ������ �������� ��û�ϴ� �Լ� 
function OnUnRefineRequest()
{
	class'RefineryAPI'.static.RequestRefineCancel( CurrentItem.ID );
}

//���� �Ϸῡ ���� ��� Ȯ�� 
function OnUnRefineDoneResult(string a_Param)
{
	local int UnRefineResult;
	
	IsResult = true;
	
	ParseInt(a_Param, "Result", UnRefineResult);

	m_OkBtn.EnableWindow();
	//debug ("������ ���� ���� �Ϸ�");
	m_hUnrefineryWndUnRefineryProgress.SetPos(0);
	debug("UnRefineResult"@UnRefineResult);
	switch (UnRefineResult)
	{
	case 1:
		CurrentItem.RefineryOp1 = 0;
		CurrentItem.RefineryOp2 = 0;
		if( !m_ItemDragBox.SetItem( 0, CurrentItem ) )
			m_ItemDragBox.AddItem( CurrentItem );
		m_InstructionText.SetText( MakeFullSystemMsg( GetSystemMessage( 1965 ), CurrentItem.Name, "" ) );
		//m_hUnrefineButton.DisableWindow();
		m_hUnrefineButton.SetNameText(GetSystemstring(1731));
		m_hUnrefineButton.EnableWindow();
		//procedure1stat = true;
		m_hUnrefineButton.SetNameText(GetSystemstring(1479));
		ResetReady();
		break;
	case 0:
		m_hUnrefineButton.EnableWindow();
		//procedure1stat = false;
		//procedureopenstat = false;
		m_UnRefineryWnd_Main.HideWindow();
		break;
	}

	// ��ư�� Ȱ��ȭ ��Ű�� �ڵ�
	// ������ ������Ʈ�� UI�� ���� �� ��.?
}

function OnProgressTimeUp(string strID)
{
	if (strID == "UnRefineryProgress")
	{
		//~ if (!m_PauseBool)
			OnUnRefineRequest();
	}
}
defaultproperties
{
}

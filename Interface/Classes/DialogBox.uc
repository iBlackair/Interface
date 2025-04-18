class DialogBox	extends UICommonAPI;

const INPUT_DEFAULT_MAXLENGTH = 64;
//���� ����(2010.03.03)
const INPUT_NUMBERPAD_MAXLENGTH = 14;

var WindowHandle	m_dialogHandle;
var ButtonHandle	m_okHandle;
var ButtonHandle	m_cancelHandle;
var ButtonHandle	m_centerHandle;
var EditBoxHandle	m_editHandle;
var TextBoxHandle	m_textHandle;
//var UIScript	m_hostWndScript;

var string		m_strTargetScript;
var string		m_strEditMessage;
var EDialogType	m_type;
var int			m_id;
var bool		m_bInUse;
var INT64		m_paramInt;
var int			m_reservedInt;
var INT64		m_reservedInt2;
var int			m_reservedInt3;
var ItemID		m_reservedItemID;
var ItemInfo	m_reservedItemInfo;
var int			m_editMaxLength;					// editbox�� maxLength�� ������ �ش�(��ȸ��). �� ���̾�α׸� ���� xml���� ������ �⺻���� ���ư�. -1�� �ƴ϶�� ���� ���õ� ���̴�.
var int			m_editMaxLength_prev;				// ���� ���̸� ����� �ֱ� ���� ����.

var DialogDefaultAction		m_defaultAction;			// Which action to take, when "Enter" key is pressed.

var ProgressCtrlHandle	m_hDialogBoxDialogProgress;

//public
//		only public functions should be exposed to other scripts.
//		Functions in DialogBox.uc should not be used directly by other scripts. They should use them through UICommonAPI.
//
function ShowDialog( EDialogModalType modalType, EDialogType style, string message, string target )
{
	if( m_bInUse )
	{
		//debug("Error!! DialogBox in Use");
		return;
	}
	if (modalType == DIALOG_Modal)
	{
		m_dialogHandle.SetModal(true);
	}
	else if (modalType == DIALOG_Modalless)
	{
		m_dialogHandle.SetModal(false);
	}


	m_dialogHandle.ShowWindow();
	SetWindowStyle( style );
	SetMessage( message );
	
	m_dialogHandle.SetFocus();

	if( m_editHandle.IsShowWindow() )
	{
		m_editHandle.SetFocus();
		if( m_editMaxLength != -1 )
		{
			m_editMaxLength_prev = m_editHandle.GetMaxLength();
			m_editHandle.SetMaxLength(m_editMaxLength);
		}
		else
			m_editHandle.SetMaxLength(INPUT_DEFAULT_MAXLENGTH);
	}
	m_strTargetScript = target;
	m_bInUse = true;
}

function HideDialog()
{
	m_dialogHandle.HideWindow();
	Initialize();
}

//branch
//function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
//{
//	if (nKey == IK_Enter )
//	{
//		DoDefaultAction();
//	}
//}
//end of branch

function SetDefaultAction( DialogDefaultAction defaultAction )
{
	//debug("DialogBox SetDefaultAction " $ defaultAction );
	m_defaultAction = defaultAction;
}

function string GetTarget()
{
	//debug("Dialog::GetTarget() returns: " $ m_strTargetScript );
	return m_strTargetScript;
}

function string GetEditMessage()
{
	//debug("Dialog::GetEditMessage() returns: " $ m_strEditMessage );
	return m_strEditMessage;
}

function SetEditMessage(string strMsg)
{
	m_editHandle.SetString( strMsg );
}

function int GetID()
{
	return m_id;
}

function SetID( int id )
{
	//debug("DialogBox SetID " $ id );
	m_id = id;
}

function SetEditType( string strType )
{
	m_editHandle.SetEditType( strType );
}

function SetParamInt64( INT64 param )
{
	m_paramInt = param;
}

function SetReservedInt( int value )
{
	m_reservedInt = value;
	//debug("DialogBox SetReservedInt to " $ value);
}

function SetReservedInt2( INT64 value )
{
	m_reservedInt2 = value;
	//debug("DialogBox SetReservedInt2 to " $ value);
}

function SetReservedInt3( int value )
{
	m_reservedInt3 = value;
	//debug("DialogBox SetReservedInt to " $ value);
}

function SetReservedItemID( ItemID ID )
{
	m_reservedItemID = ID;
}
function SetReservedItemInfo( ItemInfo info)
{
	m_reservedItemInfo = info;
}
function int GetReservedInt()
{
	return m_reservedInt;
}

function INT64 GetReservedInt2()
{
	return m_reservedInt2;
}

function int GetReservedInt3()
{
	return m_reservedInt3;
}

function ItemID GetReservedItemID()
{
	return m_reservedItemID;
}
function GetReservedItemInfo(out ItemInfo info)
{
	info = m_reservedItemInfo;
}
function SetEditBoxMaxLength(int maxLength)
{
	if( maxLength >= 0 )
		m_editMaxLength = maxLength;
}

function OnLoad()
{
	//DialogReadingText = TextBoxHandle ( GetHandle ( "DialogBox.DialogReadingText" ) );
	//m_dialogEdit = EditBoxHandle( GetHandle("DialogBox.DialogBoxEdit") );
	if(CREATE_ON_DEMAND==0)
	{
		m_dialogHandle = GetHandle("DialogBox");
		m_okHandle	= ButtonHandle( GetHandle("DialogBox.OKButton") );
		m_cancelHandle = ButtonHandle( GetHandle("DialogBox.CancelButton") );
		m_centerHandle = ButtonHandle( GetHandle("DialogBox.CenterOKButton") );
		m_editHandle = EditBoxHandle( GetHandle("DialogBox.DialogBoxEdit") );
		m_textHandle = TextBoxHandle ( GetHandle ("DialogBox.DialogReadingText") );
	}
	else
	{
		m_dialogHandle = GetWindowHandle("DialogBox");
		m_okHandle	=  GetButtonHandle("DialogBox.OKButton");
		m_cancelHandle = GetButtonHandle("DialogBox.CancelButton");
		m_centerHandle = GetButtonHandle("DialogBox.CenterOKButton");
		m_editHandle = GetEditBoxHandle("DialogBox.DialogBoxEdit");
		m_textHandle = GetTextBoxHandle ("DialogBox.DialogReadingText");

		m_hDialogBoxDialogProgress=GetProgressCtrlHandle("DialogBox.DialogProgress");
	}

	Initialize();
	SetButtonName( 1337, 1342 );
	SetMessage("Message uninitialized");
}

//function SetHostWndScript(UIScript host)
//{
//	m_hostWndScript = host;
//}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "OKButton":
	case "CenterOKButton":
		HandleOK();
		break;
	case "CancelButton":
		HandleCancel();
		break;
	case "num0":
	case "num1":
	case "num2":
	case "num3":
	case "num4":
	case "num5":
	case "num6":
	case "num7":
	case "num8":
	case "num9":
	case "numAll":
	case "numBS":
	case "numC":
		HandleNumberClick( strID );
		break;
	default:
		break;
	}
}

function OnHide()
{
	if( m_type == DIALOG_Progress )
		m_hDialogBoxDialogProgress.Stop();

	SetEditType( "normal" );
	//debug("����Ʈ�޽��� ���� " @ class'UIAPI_EDITBOX'.static.GetString( "DialogBox.DialogBoxEdit" ));
	SetEditMessage("");
	//debug("����Ʈ�޽��� ���� " @ class'UIAPI_EDITBOX'.static.GetString( "DialogBox.DialogBoxEdit" ));

	// EditBox�� maxLength�� ���� ��� ��������.
	if( m_editMaxLength != -1 )
	{
		m_editMaxLength = -1;
		m_editHandle.SetMaxLength(m_editMaxLength_prev);
	}
	m_editHandle.Clear();

}

//function OnCompleteEditBox( String strID )
//{
//	if( strID == "DialogBoxEdit" )
//	{
//		debug("DialogBox OnCompleteEditBox");
//		HandleOK();
//	}
//}

function OnChangeEditBox( String strID )
{
	local string strInput;
	local string strComma;
	local color TextColor;
	local string strResult;		//branch
	
	if( strID == "DialogBoxEdit" )
	{
		if( m_type == DIALOG_NumberPad )
		{
			//branch
			strResult = m_editHandle.GetString();
			if ( m_paramInt > IntToInt64(0) && StringToInt64(strResult) > m_paramInt ) {
				m_editHandle.SetString( Int64ToString(m_paramInt) );
			}
			//end of branch			

			//���� ����(2010.03.03)
			m_textHandle.SetText("");
			m_editHandle.SetMaxLength( INPUT_NUMBERPAD_MAXLENGTH );
			strInput = m_editHandle.GetString();
			if(Len(strInput)>0)
			{
				//Set Comma String
				strComma = MakeCostString( strInput );
				m_textHandle.SetText( ConvertNumToTextNoAdena( strInput ) );
				
				//Set Numeric Color
				TextColor= GetNumericColor( strComma );
				m_editHandle.SetFontColor( TextColor );
			}
		}
		else
		{
			//�ѹ��е尡 �ƴ� ��쿡 �⺻ ������
			TextColor= GetNumericColor( MakeCostString( "1" ) );
			m_editHandle.SetFontColor( TextColor );	
		}
	}
}

function Initialize()
{
	m_strTargetScript = "";
	m_bInUse = false;
	SetEditType( "normal" );
	m_paramInt = IntToInt64(0);
	m_reservedInt = 0;
	m_reservedInt2 = IntToInt64(0);
	m_editMaxLength = -1;
//	m_hostWndScript	= None;
	SetDefaultAction( EDefaultNone );
}

function HideAll()
{
	//debug("HideAll");
	m_editHandle.HideWindow();
	m_okHandle.HideWindow();
	m_cancelHandle.HideWindow();
	m_centerHandle.HideWindow();
	class'UIAPI_WINDOW'.static.HideWindow("DialogBox.NumberPad");
	class'UIAPI_WINDOW'.static.HideWindow("DialogBox.DialogProgress");
}

function SetWindowStyle( EDialogType style )
{
	local Rect bodyRect, numpadRect;
	HideAll();
	bodyRect = class'UIAPI_WINDOW'.static.GetRect( "DialogBox.DialogBody" );
	numpadRect = class'UIAPI_WINDOW'.static.GetRect( "DialogBox.NumberPad" );
	m_type = style;

	switch( style )
	{
	case DIALOG_OKCancel:
		m_okHandle.ShowWindow();
		m_cancelHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_OK:
		m_centerHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_OKCancelInput:		// two Button(ok, cancel), and a EditBox
		m_editHandle.ShowWindow();
		m_textHandle.SetText( "" );
		m_okHandle.ShowWindow();
		m_cancelHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_OKInput:			// one Button(ok), and a EditBox
		m_editHandle.ShowWindow();
		m_textHandle.SetText( "" );
		m_centerHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_Warning:
		m_okHandle.ShowWindow();
		m_cancelHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_Notice:
		m_centerHandle.ShowWindow();
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		break;
	case DIALOG_NumberPad:
		m_editHandle.ShowWindow();
		m_textHandle.SetText( "" );
		m_okHandle.ShowWindow();
		m_cancelHandle.ShowWindow();
		ShowWindow("DialogBox.NumberPad");
		m_dialogHandle.SetWindowSize( bodyRect.nWidth + numpadRect.nWidth, bodyRect.nHeight );

		SetEditType("number");
		break;
	case DIALOG_Progress:
		m_okHandle.ShowWindow();
		m_cancelHandle.ShowWindow();
		ShowWindow("DialogBox.DialogProgress");
		m_dialogHandle.SetWindowSize( bodyRect.nWidth, bodyRect.nHeight );
		if( m_paramInt == IntToInt64(0) )
		{
			//debug("DialogBox Error!! DIALOG_Progress needs parameter");
		}
		else
		{
			m_hDialogBoxDialogProgress.SetProgressTime( Int64ToInt(m_paramInt) );
			m_hDialogBoxDialogProgress.Reset();
			m_hDialogBoxDialogProgress.Start();
		}
		break;
	}

	if( style == DIALOG_Progress )
	{
		m_dialogHandle.SetAnchor( "", "BottomCenter", "BottomCenter", 0, 0 );
	}
	else
	{
		m_dialogHandle.SetAnchor( "", "CenterCenter", "CenterCenter", 0, 0 );
	}
}

function SetMessage( string strMessage )
{
	class'UIAPI_TEXTBOX'.static.SetText( "DialogBox.DialogText", strMessage );
}

function SetButtonName( int indexOK, int indexCancel )
{
	m_okHandle.SetButtonName( indexOK );
	m_centerHandle.SetButtonName( indexOK );
	m_cancelHandle.SetButtonName( indexCancel );
}

function HandleOK()
{
	if( m_editHandle.IsShowWindow() )
		m_strEditMessage = m_editHandle.GetString();
	else
		m_strEditMessage = "";

	//branch
	SetDefaultAction( EDefaultNone );			// ��ư�� ���� OK �ϸ� ���� default action�� �������� �����Ƿ� ���⼭�� ���ش�.
	//end of branch
	
	//���̾�α׸� �������� ���� ���ؼ��� Clear�� �������� �̺�Ʈ�� �� �������� ������.
	m_dialogHandle.HideWindow();
	m_bInUse = false;
	ExecuteEvent( EV_DialogOK );
//	if ( m_hostWndScript == None )
//		ExecuteEvent( EV_DialogOK );
//	else
//		m_hostWndScript.OnEvent(EV_DialogOK,"");
}

function HandleCancel()
{
	//branch
	SetDefaultAction( EDefaultNone );			// ��ư�� ���� Cancel �ϸ� ���� default action�� �������� �����Ƿ� ���⼭�� ���ش�.
	//end of branch

	m_dialogHandle.HideWindow();
	m_bInUse = false;
	ExecuteEvent( EV_DialogCancel );
//	if ( m_hostWndScript == None )
//		ExecuteEvent( EV_DialogCancel );
//	else
//		m_hostWndScript.OnEvent( EV_DialogCancel,"" );
}

function HandleNumberClick( string strID )
{
//branch
	local string strResult;
	switch( strID )
	{
	case "num0":
		//���� ����(2010.03.03)
		if( m_editHandle.GetString() != "" )
		{
			m_editHandle.AddString( "0" );
		}
		break;
	case "num1":
		m_editHandle.AddString( "1" );
		break;
	case "num2":
		m_editHandle.AddString( "2" );
		break;
	case "num3":
		m_editHandle.AddString( "3" );
		break;
	case "num4":
		m_editHandle.AddString( "4" );
		break;
	case "num5":
		m_editHandle.AddString( "5" );
		break;
	case "num6":
		m_editHandle.AddString( "6" );
		break;
	case "num7":
		m_editHandle.AddString( "7" );
		break;
	case "num8":
		m_editHandle.AddString( "8" );
		break;
	case "num9":
		m_editHandle.AddString( "9" );
		break;
	case "numAll":
		if( m_paramInt >= IntToInt64(0) )
			m_editHandle.SetString( Int64ToString(m_paramInt) );
		break;
	case "numBS":
		m_editHandle.SimulateBackspace();
		break;
	case "numC":
		//���� ����(2010.03.03)
		m_editHandle.SetString( "" );
		break;
	default:
		break;
	}
	
//branch
	strResult = m_editHandle.GetString();
	if ( m_paramInt > IntToInt64(0) && StringToInt64(strResult) > m_paramInt ) {
		m_editHandle.SetString( Int64ToString(m_paramInt) );
	}
//end of branch
}

// ���̾�α��� �ð��� ������
function OnProgressTimeUp( string strID )
{
	if( strID == "DialogProgress" ) {
		//branch
		if ( m_defaultAction == EDefaultNone ) {
			HandleCancel();
			SetDefaultAction( EDefaultNone );
		}
		else {
			DoDefaultAction();
		}
		//end of branch
	}
}

function DoDefaultAction()
{
	//debug("DialogBox DoDefaultAction");
	switch( m_defaultAction )
	{
	case EDefaultOK:
		HandleOK();
		break;
	case EDefaultCancel:
		HandleCancel();
		break;
	case EDefaultNone:
	//branch
		//HandleCancel();
	//end of branch
		break;
	default:
		break;
	};

	SetDefaultAction( EDefaultNone );			// ���̾�α׸� ��� �� ���� ���̾�α��� ����Ʈ �׼��� ������ ���� �ʾƾ� �ϹǷ� �ѹ� �ϰ��� �ʱ�ȭ �� �ش�.
}
defaultproperties
{
}

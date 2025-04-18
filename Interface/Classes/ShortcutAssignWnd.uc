//////////////////////////////////////////////////////////////////////////////////////////////
//  L 2    S H O R T C U T    U S E R    C U S T O M    A S S I G N    W I N D O W
//////////////////////////////////////////////////////////////////////////////////////////////


class ShortcutAssignWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////////////////////
//Initialization Header
//////////////////////////////////////////////////////////////////////////////////////////////

const DIALOGID_proc1= 0;
const DIALOGID_proc2= 1;
const DIALOGID_proc3= 2;




var	WindowHandle 	Me;
var	WindowHandle 	DisableBox;
var	WindowHandle 	GeneralKeyWnd;
var	WindowHandle 	GeneralKeySetting;
var	WindowHandle 	EnterKeySetting;
var	WindowHandle 	CFrameWnd386;
var	WindowHandle 	CFrameWnd385;
var	WindowHandle	EnterkeyWnd;
var 	WindowHandle	OptionWnd;

var	ListCtrlHandle 	GeneralKeyList;
var	ListCtrlHandle 	EnterKeyList;

var	EditBoxHandle 	InputKey;
var	EditBoxHandle 	KeySettingInput;
var	CheckBoxHandle 	Chk_EnterChatting;
var	CheckBoxHandle 	Chk_NewKeySystem;
var	CheckBoxHandle 	AltCheck;
var	CheckBoxHandle 	CtrlCheck;
var	CheckBoxHandle 	ShiftCheck;
var	ButtonHandle 	ResetAllBtn;
var	ButtonHandle 	Btn_AssignCurrent;
//~ var	ButtonHandle 	Btn_ResetCurrent;
var	ButtonHandle 	Btn_OK;
var	ButtonHandle 	Btn_Cancel;
var	ButtonHandle 	Btn_Apply;
var	ButtonHandle 	Btn_SaveCurrentKey;
var	ButtonHandle 	Btn_CancelCurrentKey;
var 	TextBoxHandle	assignShortKeyText;
var 	TextBoxHandle	selectedkeygrouptext;
var 	TextBoxHandle	TextCurrent;
var	TabHandle	Tab_KeyGroup;

var	WindowHandle 	AirKeySetting;		// 비행정 키셋팅 윈도우 추가되었음 - CT2_Final
var	WindowHandle	AirkeyWnd;

var	ListCtrlHandle	AirKeyList;

var	WindowHandle 	AirTransKeySetting;		// 비행변신 키셋팅 윈도우 추가되었음 - CT2_Final
var	WindowHandle	AirTranskeyWnd;

var	ListCtrlHandle	AirTransKeyList;

var	FlightShipCtrlWnd			scriptShip;
var	FlightTransformCtrlWnd		scriptTrans;



var array<ShortcutCommandItem> m_DefaultGeneralKeyShortcutList;
var array<ShortcutCommandItem> m_DefaultEnterKeyShortcutList;
var array<ShortcutCommandItem> m_DefaultFlightShortcutList;			// 비행정
var array<ShortcutCommandItem> m_DefaultFlightTransShortcutList;		// 비행 변신체


var array<string> m_datasheetKeyReplace;
var array<string> m_datasheetKeyReplaced;


var string m_mainkey;
var string m_subkey1;
var string m_subkey2;


var int m_currentListCtrlIndex;

var string m_WindowName;

//////////////////////////////////////////////////////////////////////////////////////////
//Array Data Sheets
//////////////////////////////////////////////////////////////////////////////////////////

function DataSheetAssignKeyReplacement()
{
	m_datasheetKeyReplace[1]="LEFTMOUSE";
	m_datasheetKeyReplace[2]="RIGHTMOUSE";
	m_datasheetKeyReplace[3]="BACKSPACE";
	m_datasheetKeyReplace[4]="ENTER";
	m_datasheetKeyReplace[5]="SHIFT";
	m_datasheetKeyReplace[6]="CTRL";
	m_datasheetKeyReplace[7]="ALT";
	m_datasheetKeyReplace[8]="PAUSE";
	m_datasheetKeyReplace[9]="CAPSLOCK";
	m_datasheetKeyReplace[10]="ESCAPE";
	m_datasheetKeyReplace[11]="SPACE";
	m_datasheetKeyReplace[12]="PAGEUP";
	m_datasheetKeyReplace[13]="PAGEDOWN";
	m_datasheetKeyReplace[14]="END";
	m_datasheetKeyReplace[15]="HOME";
	m_datasheetKeyReplace[16]="LEFT";
	m_datasheetKeyReplace[17]="UP";
	m_datasheetKeyReplace[18]="RIGHT";
	m_datasheetKeyReplace[19]="DOWN";
	m_datasheetKeyReplace[20]="SELECT";
	m_datasheetKeyReplace[21]="PRINT";
	m_datasheetKeyReplace[22]="PRINTSCRN";
	m_datasheetKeyReplace[23]="INSERT";
	m_datasheetKeyReplace[24]="DELETE";
	m_datasheetKeyReplace[25]="HELP";
	m_datasheetKeyReplace[26]="NUMPAD0";
	m_datasheetKeyReplace[27]="NUMPAD1";
	m_datasheetKeyReplace[28]="NUMPAD2";
	m_datasheetKeyReplace[29]="NUMPAD3";
	m_datasheetKeyReplace[30]="NUMPAD4";
	m_datasheetKeyReplace[31]="NUMPAD5";
	m_datasheetKeyReplace[32]="NUMPAD6";
	m_datasheetKeyReplace[33]="NUMPAD7";
	m_datasheetKeyReplace[34]="NUMPAD8";
	m_datasheetKeyReplace[35]="NUMPAD9";
	m_datasheetKeyReplace[36]="GREYSTAR";
	m_datasheetKeyReplace[37]="GREYPLUS";
	m_datasheetKeyReplace[38]="SEPARATOR";
	m_datasheetKeyReplace[39]="GREYMINUS";
	m_datasheetKeyReplace[40]="NUMPADPERIOD";
	m_datasheetKeyReplace[41]="GREYSLASH";
	m_datasheetKeyReplace[42]="NUMLOCK";
	m_datasheetKeyReplace[43]="SCROLLLOCK";
	m_datasheetKeyReplace[44]="UNICODE";
	m_datasheetKeyReplace[45]="SEMICOLON";
	m_datasheetKeyReplace[46]="EQUALS";
	m_datasheetKeyReplace[47]="COMMA";
	m_datasheetKeyReplace[48]="MINUS";
	m_datasheetKeyReplace[49]="SLASH";
	m_datasheetKeyReplace[50]="TILDE";
	m_datasheetKeyReplace[51]="LEFTBRACKET";
	m_datasheetKeyReplace[52]="BACKSLASH";
	m_datasheetKeyReplace[53]="RIGHTBRACKET";
	m_datasheetKeyReplace[54]="SINGLEQUOTE";
	m_datasheetKeyReplace[55]="PERIOD";
	m_datasheetKeyReplace[56]="MIDDLEMOUSE";
	m_datasheetKeyReplace[57]="MOUSEWHEELDOWN";
	m_datasheetKeyReplace[58]="MOUSEWHEELUP";
	m_datasheetKeyReplace[59]="UNKNOWN16";
	m_datasheetKeyReplace[60]="UNKNOWN17";
	m_datasheetKeyReplace[61]="BACKSLASH";
	m_datasheetKeyReplace[62]="UNKNOWN19";
	m_datasheetKeyReplace[63]="UNKNOWN5C";
	m_datasheetKeyReplace[64]="UNKNOWN5D";
	m_datasheetKeyReplace[65]="UNKNOWN0C";
	m_datasheetKeyReplaced[1]=GetSystemString(1670);
	m_datasheetKeyReplaced[2]=GetSystemString(1671);
	m_datasheetKeyReplaced[3]=GetSystemString(1517);
	m_datasheetKeyReplaced[4]="Enter";
	m_datasheetKeyReplaced[5]="Shift";
	m_datasheetKeyReplaced[6]="Ctrl";
	m_datasheetKeyReplaced[7]="Alt";
	m_datasheetKeyReplaced[8]="Pause";
	m_datasheetKeyReplaced[9]="CapsLock";
	m_datasheetKeyReplaced[10]="ESC";
	m_datasheetKeyReplaced[11]=GetSystemString(1672);
	m_datasheetKeyReplaced[12]="PageUp";
	m_datasheetKeyReplaced[13]="PageDown";
	m_datasheetKeyReplaced[14]="End";
	m_datasheetKeyReplaced[15]="Home";
	m_datasheetKeyReplaced[16]="Left";
	m_datasheetKeyReplaced[17]="Up";
	m_datasheetKeyReplaced[18]="Right";
	m_datasheetKeyReplaced[19]="Down";
	m_datasheetKeyReplaced[20]="Select";
	m_datasheetKeyReplaced[21]="Print";
	m_datasheetKeyReplaced[22]="PrintScrn";
	m_datasheetKeyReplaced[23]="Insert";
	m_datasheetKeyReplaced[24]="Delete";
	m_datasheetKeyReplaced[25]="Help";
	m_datasheetKeyReplaced[26]=GetSystemString(1657);
	m_datasheetKeyReplaced[27]=GetSystemString(1658);
	m_datasheetKeyReplaced[28]=GetSystemString(1659);
	m_datasheetKeyReplaced[29]=GetSystemString(1660);
	m_datasheetKeyReplaced[30]=GetSystemString(1661);
	m_datasheetKeyReplaced[31]=GetSystemString(1662);
	m_datasheetKeyReplaced[32]=GetSystemString(1663);
	m_datasheetKeyReplaced[33]=GetSystemString(1664);
	m_datasheetKeyReplaced[34]=GetSystemString(1665);
	m_datasheetKeyReplaced[35]=GetSystemString(1666);
	m_datasheetKeyReplaced[36]="*";
	m_datasheetKeyReplaced[37]="+";
	m_datasheetKeyReplaced[38]="Separator";
	m_datasheetKeyReplaced[39]="-";
	m_datasheetKeyReplaced[40]=".";
	m_datasheetKeyReplaced[41]="/";
	m_datasheetKeyReplaced[42]="NumLock";
	m_datasheetKeyReplaced[43]="ScrollLock";
	m_datasheetKeyReplaced[44]="Unicode";
	m_datasheetKeyReplaced[45]=";";
	m_datasheetKeyReplaced[46]="=";
	m_datasheetKeyReplaced[47]=",";
	m_datasheetKeyReplaced[48]="-";
	m_datasheetKeyReplaced[49]="/";
	m_datasheetKeyReplaced[50]="`";
	m_datasheetKeyReplaced[51]="[";
	m_datasheetKeyReplaced[52]="";
	m_datasheetKeyReplaced[53]="]";
	m_datasheetKeyReplaced[54]="'";
	m_datasheetKeyReplaced[55]=".";
	m_datasheetKeyReplaced[56]=GetSystemString(1669);
	m_datasheetKeyReplaced[57]=GetSystemString(1667);
	m_datasheetKeyReplaced[58]=GetSystemString(1668);
	m_datasheetKeyReplaced[59]="-";
	m_datasheetKeyReplaced[60]="=";
	m_datasheetKeyReplaced[61]=GetSystemString(1676);
	m_datasheetKeyReplaced[62]=GetSystemString(1673);
	m_datasheetKeyReplaced[63]=GetSystemString(1674);
	m_datasheetKeyReplaced[64]=GetSystemString(1675);
	m_datasheetKeyReplaced[65]=GetSystemString(1677);

}

function bool IsStandAloneKey(String KeyName)
{
	switch(KeyName)
	{
		case "ESCAPE":
		case "F1":
		case "F2":
		case "F3":
		case "F4":
		case "F5":
		case "F6":
		case "F7":
		case "F8":
		case "F9":
		case "F10":
		case "F11":
		case "F12":
		case "HOME":
		case "END":
		case "PAGEUP":
		case "PAGEDOWN":
		case "DELETE":
		case "TAB":
		case "ALT":
		case "CTRL":
		case "SHIFT":
		return true;
		break;
		default:
		return false;
	}
}


function bool IsValidKey(string KeyName)
{
	switch(KeyName)
	{
	case "NUMLOCK":
	case "UNKNOWN15":
	case "UNKNOWN19":
	case "UNKNOWN5B":
	case "UNKNOWN5C":
	case "UNKNOWN5D":
	case "UNKNOWN0C":
	case "INSERT":
	case "LEFT":
	case "RIGHT":
	case "UP":
	case "DOWN":
		return false;
		break;
	Default:
		return true;
	}
}


function bool IsReleaseActionItems(string ActionName)
{
	switch (ActionName)
	{
		case "LeftTurn":
		case "RightTurn":
		case "MoveForward":
		case "MoveBackward":
			return true;
			break;
		Default:
			return false;	
	}
}


/////////////////////////////////////////////////////////////////////////////////////////
// Custom Converting Functions
/////////////////////////////////////////////////////////////////////////////////////////

function string MakeUserInputKeyCombinationName(string MainKey, bool subkeybool1, bool subkeybool2, bool subkeybool3)
{
	local string SubKey1;
	local string SubKey2;
	local string SubKey3;
	local string outputtext;
	SubKey1 = "";
	SubKey2 = "";
	SubKey3 = "";
	if (MainKey != "CTRL" ^^ MainKey != "ALT" ^^ MainKey != "SHIFT")
	{
		if (subkeybool3 == true)
			subkey3 = "SHIFT";
		if (subkeybool2 == true)
			subkey2 = "CTRL";
		if (subkeybool1 == true)
			subkey1 ="ALT";
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey2);
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, "");
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey2);
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey1, SubKey3);
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey2, SubKey3);
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, SubKey2, "");
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == true)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, "", "");
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == false)
			outputtext = MakeFullShortcutKeyCombinationName(MainKey, "", "");
		return outputtext;
	}
}

function  MakeSystemUserInputKeyCombination(string MainKey, bool subkeybool1, bool subkeybool2, bool subkeybool3)
{
	local string SubKey1;
	local string SubKey2;
	local string SubKey3;
	SubKey1 = "";
	SubKey2 = "";
	SubKey3 = "";
	if (MainKey != "CTRL" ^^ MainKey != "ALT" ^^ MainKey != "SHIFT")
	{
		if (subkeybool3 == true)
			subkey3 = "SHIFT";
		if (subkeybool2 == true)
			subkey2 = "CTRL";
		if (subkeybool1 == true)
			subkey1 ="ALT";
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey2;
		}
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = "";
		}
		if ( subkeybool1 == true && subkeybool2 == true && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey2;
		}
		if ( subkeybool1 == true && subkeybool2 == false && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey1;
			m_subkey2 = SubKey3;
		}
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey2;
			m_subkey2 = SubKey3;
		}
		if ( subkeybool1 == false && subkeybool2 == true && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = SubKey2;
			m_subkey2 = "";
		}
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == true)
		{
			m_mainkey = MainKey;
			m_subkey1 = "";
			m_subkey2 = "";
		}
		if ( subkeybool1 == false && subkeybool2 == false && subkeybool3 == false)
		{
			m_mainkey = MainKey;
			m_subkey1 = "";
			m_subkey2 = "";
		}
	}
}


function String GetShortcutItemNameWithID(int ID)
{
	local ShortcutScriptData AliasList;
	local string OutName;
	class'ShortcutAPI'.static.RequestShortcutScriptData(ID, AliasList);
	OutName = GetSystemString(AliasList.sysString);
	return OutName;
}

function string MakeFullShortcutKeyCombinationName(string MainKey, string SubKey1, string SubKey2)
{
	local string MainKeyOut;
	local string SubKeyOut1;
	local string SubKeyOut2;
	local string OutKey;
	
	MainKeyOut = MainKey;
	SubKeyOut1 = "";
	SubKeyOut2 = "";
	
	Switch(SubKey1)
	{
		case "NONE":
			SubKeyOut1 = "";
			break;
		case "CTRL":
			SubKeyOut1 = "Ctrl + ";
			break;
		case "SHIFT":
			SubKeyOut1 = "Shift + ";
			break;
		case "ALT":
			SubKeyOut1 = "Alt + ";
			break;
		case "":
			SubKeyOut1 = "";
			break;
	}
	
	Switch(SubKey2)
	{
		case "NONE":
			SubKeyOut2 = "";
			break;
		case "CTRL":
			SubKeyOut2 = "Ctrl + ";
			break;
		case "SHIFT":
			SubKeyOut2 = "Shift + ";
			break;
		case "ALT":
			SubKeyOut2 = "Alt + ";
			break;
		case "":
			SubKeyOut2 = "";
			break;
	}
	if (SubKeyOut1 == SubKeyOut2)
	{
		SubKeyOut2 = "";
	}
	OutKey = SubKeyOut1 $ SubKeyOut2 $ GetUserReadableKeyName(MainKeyOut);
	return OutKey;
}

function String GetKeySettingDescriptionWithID(int ID)
{
	local ShortcutScriptData AliasList;
	local string OutName;
	class'ShortcutAPI'.static.RequestShortcutScriptData(ID, AliasList);
	OutName = GetSystemMessage(AliasList.sysMsg);
	return OutName;
}

function String GetUserReadableKeyName(String input)
{
	local int i;
	local String output;
	for (i= 0 ; i < m_datasheetKeyReplace.Length ; ++i)
	{
		if (m_datasheetKeyReplace[i] == input)
			output = m_datasheetKeyReplaced[i];
	}
	if (output == "")
		output = input;
	return output;
}

//////////////////////////////////////////////////////////////////////////////////////////
//Reserved function Sets
//////////////////////////////////////////////////////////////////////////////////////////

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="OptionWnd.ShortcutTab";

	if(CREATE_ON_DEMAND==0)
		InitializeWindowHandles();
	else
		InitializeWindowHandlesCOD();
//	InitializeUIEvents();
	DataSheetAssignKeyReplacement();
	
	AddExtraShortcuts();
	class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", m_DefaultEnterKeyShortcutList);
	class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", m_DefaultGeneralKeyShortcutList);
	class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", m_DefaultFlightShortcutList);	// 비행정 관련 추가
	class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", m_DefaultFlightTransShortcutList);	
	
	scriptShip = FlightShipCtrlWnd ( GetScript("FlightShipCtrlWnd") );
	scriptTrans = FlightTransformCtrlWnd ( GetScript("FlightTransformCtrlWnd") ); 
	
}

// Add extra shortcuts not defined in default command list (c) void 
function AddExtraShortcuts()
{
	local ShortcutCommandItem it;
	local int i, j;
	local int hiddenStart;
	local int extraCount;
	extraCount = 2;

	hiddenStart = 1000 + extraCount * 12;

	for (i = 0; i < 12; i++) {
		for (j = 0; j < 12; j++) {
			it.sCommand = "UseShortcutItem Num=" $ i * 12 + j;
			it.Key = GetOptionString("HiddenShortcuts", (i + 1) $ "_" $ j + 1);
			if (it.Key == "")
				continue;
			it.SubKey1 = GetOptionString("HiddenShortcuts", (i+1) $ "_" $ j + 1 $ "_mod1");
			it.SubKey2 = GetOptionString("HiddenShortcuts", (i+1) $ "_" $ j + 1 $ "_mod2");
			it.sAction = "PRESS";
			it.id = hiddenStart + i;

			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", it);
		}
	}
	
	// Command to lock/unlock target
	it.sCommand = "TargetLockUnlock";
	GetINIString("TargetUnlock", "key", it.Key, "PatchSettings");
	GetINIString("TargetUnlock", "key_mod1", it.SubKey1, "PatchSettings");
	GetINIString("TargetUnlock", "key_mod2", it.SubKey2, "PatchSettings");
	it.sAction = "PRESS";
	it.id = hiddenStart + 12;

	class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", it);
	
}

function OnClickListCtrlRecord(string ID)
{
	local LVDataRecord Record;
	local int CurrentID;
	local string CurrentCommand;
	local string CurrentMainKey;
	local string CurrentSubkey1;
	local string CurrentSubkey2;

	AssignCurrentSelectedKeyfromtheListCtrl();
	if (Tab_KeyGroup.GetTopIndex() == 0)
		GeneralKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		EnterKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
		AirKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가
		AirTransKeyList.GetSelectedRec(Record);

	CurrentID = Record.LVDataList[0].nReserved1;
	CurrentCommand = Record.LVDataList[5].szData;
	CurrentMainKey = Record.LVDataList[2].szData;
	CurrentSubkey1 = Record.LVDataList[3].szData;
	CurrentSubkey2 = Record.LVDataList[4].szData;
	selectedkeygrouptext.SetText(GetShortcutItemNameWithID(CurrentID));
	TextCurrent.SetText(GetKeySettingDescriptionWithID(CurrentID));
	KeySettingInput.SetString(MakeFullShortcutKeyCombinationName(CurrentMainKey,CurrentSubKey1,CurrentSubKey2));
}

function OnClickButton(string Name)
{
	local string str_reduntedstr;
		
	class'ShortcutAPI'.static.UnlockShortcut();
	switch( Name )
	{
		case "TabCtrl0":
			GeneralKeySetting.ShowWindow();
			HandleUpdateGeneralKeyListControl();
			Switch2KeyBrowsingMode();
			GeneralKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태

		break;
		case "TabCtrl1":
			EnterKeySetting.ShowWindow();
			HandleUpdateEnterKeyListControl();
			Switch2KeyBrowsingMode();
			EnterKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태

		break;
		case "TabCtrl2":	// 비행정 탭을 눌렀을 경우
			AirKeySetting.ShowWindow();	// 비행정 키 셋팅을 보여준다. 
			HandleUpdateAirKeyListControl();	// 비행정 키 컨트롤 리스트 처리
			Switch2KeyBrowsingMode();
			AirKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태
		break;
		case "TabCtrl3":	// 비행정 탭을 눌렀을 경우
			AirTransKeySetting.ShowWindow();	// 비행정 키 셋팅을 보여준다. 
			HandleUpdateAirTransKeyListControl();	// 비행정 키 컨트롤 리스트 처리
			Switch2KeyBrowsingMode();
			AirTransKeyList.SetSelectedIndex(0,true); //첫번째 목록 선택 상태
		break;
		case "ResetAllBtn":
			Switch2KeyBrowsingMode();
			OnResetAllBtnClickPopUpMessage();
		break;
		case "Btn_AssignCurrent":
			Switch2KeyInputMode();
			AssignCurrentSelectedKeyfromtheListCtrl();
		break;
		//~ case "Btn_ResetCurrent":
		//~ break;
		case "Btn_OK":
			HandleResetUI2Default();
			OptionWnd.HideWindow();
			Switch2KeyBrowsingMode();
			class'ShortcutAPI'.static.Save();
		break;
		case "Btn_Cancel":
			HandleResetUI2Default();
			OptionWnd.HideWindow();
			Switch2KeyBrowsingMode();
		break;
		case "Btn_Apply":
			Switch2KeyBrowsingMode();
			class'ShortcutAPI'.static.Save();
		break;
		case "Btn_SaveCurrentKey":
			str_reduntedstr = CheckShortcutItemRedundency();
			if (str_reduntedstr == "")
			{
				DeleteCurrentShortcutItem();
				SetCurrentKeyAsShortKey();
				Switch2KeyBrowsingMode();
				HandleUpdateGeneralKeyListControl();
				HandleUpdateEnterKeyListControl();
				HandleUpdateAirKeyListControl();
				HandleUpdateAirTransKeyListControl();
				if (Tab_KeyGroup.GetTopIndex() == 0)
					GeneralKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
				if (Tab_KeyGroup.GetTopIndex() == 1)
					EnterKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
				if (Tab_KeyGroup.GetTopIndex() == 2)
					AirKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
				if (Tab_KeyGroup.GetTopIndex() == 3)
					AirTransKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
			}
			else	
			{
				DisableBox.ShowWindow();
				DisableBox.SetFocus();
				DialogSetID( DIALOGID_proc3 );
				DialogSetDefaultOK();	
				DialogShow(DIALOG_Modalless, DIALOG_WARNING, MakeFullSystemMsg( GetSystemMessage( 2048 ),  str_reduntedstr) );
			}
			
		break;
		case "Btn_CancelCurrentKey":
			Switch2KeyBrowsingMode();
		break;
	}
}

function OnDBClickListCtrlRecord(string ID)
{
	if (ID == "GeneralKeyList" || ID == "EnterKeyList" ||  ID == "AirKeyList"  ||  ID == "AirTransKeyList" )
	{
		Switch2KeyInputMode();
		AssignCurrentSelectedKeyfromtheListCtrl();
	}
}

function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		case "Chk_EnterChatting":
			if (Chk_EnterChatting.IsChecked() == true)
			{
				SetOptionBool( "Game", "EnterChatting", true );
				HandleSwitchEnterchatting();
			}
			else
			{
				SetOptionBool( "Game", "EnterChatting", false );
				HandleSwitchEnterchatting();
			}
		break;
	}
}

function OnShow()
{
	// Reset Window Handle Objects
	KeySettingInput.HideWindow();
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	// Switch back to Shortcut Key Browsing Mode
	class'ShortcutAPI'.static.UnlockShortcut();
	
	HandleUpdateGeneralKeyListControl();
	HandleUpdateEnterKeyListControl();
	HandleUpdateAirKeyListControl();
	HandleUpdateAirTransKeyListControl();
	
	if (DisableBox.IsShowWindow())
		DisableBox.SetFocus();

	// onShow 이벤트가 발생 했을때, 탭의 현재 위치를 파악해서
	// 각 키보드 정보 리스트를 첫번째가 선택 되도록 세팅 한다.
	switch( Tab_KeyGroup.GetTopIndex() )
	{
		case 0: GeneralKeyList.SetSelectedIndex(0,true);
				break;
		case 1: EnterKeyList.SetSelectedIndex(0,true);
				break;
		case 2: AirKeyList.SetSelectedIndex(0,true);
				break;
		case 3: AirTransKeyList.SetSelectedIndex(0,true);
				break;
	}
}


function OnHide()
{
	// 1 
	class'ShortcutAPI'.static.UnlockShortcut();
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{

		case EV_DialogOK:
			HandleDialogOK();
		break;
		
		case EV_DialogCancel:
			HandleDialogCancel();
		break;
		
		case EV_ShortcutInit:
			//~ debug("OXYZEN: ShortcutInit Received");
			//ResetActivateKeyGroup();
			//~ HandleSwitchEnterchatting();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			//~ class'ShortcutAPI'.static.Save();
			//HandleSwitchEnterchatting();
		break;
		
		case EV_StateChanged:
			switch( a_Param )
			{
				case "GAMINGSTATE":
					//Activate UI.
					//~ KeySettingInput.Clear();
					UIActivationUponStateChanges(true);	// 로그인시 숏컷 할당이 가능하도록 활성화해준다. 
					//ResetActivateKeyGroup();
					HandleSwitchEnterchatting();
					class'ShortcutAPI'.static.RequestList();
					
				break;
				case "LOGINSTATE":
					//Deactivate UI.
					//~ KeySettingInput.Clear();
					UIActivationUponStateChanges(false);
					
				break;
			}
		break;
			
		case EV_ShortcutDataReceived:
			//~ if (Me.IsShowWindow())
			//~ {
				//ResetActivateKeyGroup();
				//~ HandleSwitchEnterchatting();
				HandleUpdateGeneralKeyListControl();
				HandleUpdateEnterKeyListControl();
				HandleUpdateAirKeyListControl();
				HandleUpdateAirTransKeyListControl();
				//HandleSwitchEnterchatting();
			//~ }
		break;
	}
}


function OnKeyDown(WindowHandle a_WindowHandle, EInputKey Key)
{
	local string MainKey;
	local bool subkeybool1;
	local bool subkeybool2;
	local bool subkeybool3;
	subkeybool1 = false;
	subkeybool2 = false;
	subkeybool3 = false;
	if (KeySettingInput.IsShowWindow())
	{
		Me.SetFocus();
		MainKey = class'InputAPI'.static.GetKeyString(Key);
		if (MainKey == "MOUSEY")
		{
			MainKey = "";
			subkeybool3 = false;
			subkeybool2 = false;
			subkeybool1 = false;
			KeySettingInput.Clear();
		}
		else if (IsValidKey(Mainkey))
		{
			
			subkeybool3 = class'InputAPI'.static.IsShiftPressed();
			subkeybool2 = class'InputAPI'.static.IsCtrlPressed();
			subkeybool1 = class'InputAPI'.static.IsAltPressed();

			if (Tab_KeyGroup.GetTopIndex() == 1)
			{
				subkeybool3 = false;
				subkeybool2 = false;
				subkeybool1 = false;
			}
			if (subkeybool3 ^^ !subkeybool2 ^^ !subkeybool1)
				subkeybool3 = false;
			if (Tab_KeyGroup.GetTopIndex() == 0)
			{
				if (!subkeybool1 && !subkeybool2 && !subkeybool3)
				{
					if (IsStandAloneKey(MainKey))
					{
						//debug("OXYZEN: Key Input Value" @ IsStandAloneKey(MainKey) @ subkeybool1@ subkeybool2 @ subkeybool3);
						KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
						MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
					}
					else 
					{
						DisableBox.ShowWindow();
						DisableBox.SetFocus();
						MainKey = "";
						DialogSetID( DIALOGID_proc2 );
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_OK,  GetSystemMessage(2272));
					}
				}
				else
				{
					//debug("OXYZEN: Key Input Value2" @ IsStandAloneKey(MainKey) @ subkeybool1@ subkeybool2 @ subkeybool3);
					KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
					MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
				}
			}
			else
			{
				KeySettingInput.SetString(MakeUserInputKeyCombinationName(MainKey, subkeybool1, subkeybool2, subkeybool3));
				MakeSystemUserInputKeyCombination(MainKey, subkeybool1, subkeybool2, subkeybool3);
			}
		}
	}
}

function HandleDialogOK()
{
	
	if( DialogIsMine() )
	{
		if ( DialogGetID() == DIALOGID_proc1  )
		{
			class'ShortcutAPI'.static.RestoreDefault();
			class'ShortcutAPI'.static.Save();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			ActiveFlightShort();	//비행상태의 숏컷그룹을 액티브해줌
		}
		else if ( DialogGetID() == DIALOGID_proc2  )
		{
			DisableBox.HideWindow();
		}
		else if ( DialogGetID() == DIALOGID_proc3 )
		{
			DeleteCurrentShortcutItem();
			SwapReduntedShortcutItemwithCurrentShortcutItem();
			SetCurrentKeyAsShortKey();
			DisableBox.HideWindow();
			Switch2KeyBrowsingMode();
			HandleUpdateGeneralKeyListControl();
			HandleUpdateEnterKeyListControl();
			HandleUpdateAirKeyListControl();
			HandleUpdateAirTransKeyListControl();
			if (Tab_KeyGroup.GetTopIndex() == 0)
				GeneralKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
			if (Tab_KeyGroup.GetTopIndex() == 1)
				EnterKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
			if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
				AirKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
			if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가
				AirTransKeyList.SetSelectedIndex(m_currentListCtrlIndex,false);
		}
	}
}

function HandleDialogCancel()
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
		case DIALOGID_proc1:
		case DIALOGID_proc2:
			break;
		case DIALOGID_proc3:
			DisableBox.HideWindow();
			break;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
//Custom function Sets
/////////////////////////////////////////////////////////////////////////////////////////

function InitializeWindowHandles()
{
	CFrameWnd385		=	GetHandle( "CFrameWnd385" );
	CFrameWnd386		=	GetHandle( "CFrameWnd386" );
	DisableBox		=	GetHandle( "DisableBox" );
	GeneralKeyWnd 	= 	GetHandle( "GeneralKeyWnd" );
	Me 				=	GetHandle( "ShortcutTab" );
	EnterKeySetting		=	GetHandle("EnterKeySetting");
	EnterkeyWnd		=	GetHandle("EnterkeyWnd" );
	GeneralKeySetting	=	GetHandle("GeneralKeySetting");
	OptionWnd	=	GetHandle(	"OptionWnd"	);
	Btn_Apply			=	ButtonHandle ( GetHandle( "Btn_Apply" ) );
	Btn_AssignCurrent	=	ButtonHandle ( GetHandle( "Btn_AssignCurrent" ) );
	Btn_Cancel		=	ButtonHandle ( GetHandle( "Btn_Cancel" ) );
	Btn_CancelCurrentKey	=	ButtonHandle ( GetHandle( "Btn_CancelCurrentKey" ) );
	Btn_OK			=	ButtonHandle ( GetHandle( "Btn_OK" ) );
	//~ Btn_ResetCurrent	=	ButtonHandle ( GetHandle( "ShortcutTab.Btn_ResetCurrent" ) );
	Btn_SaveCurrentKey	=	ButtonHandle ( GetHandle( "Btn_SaveCurrentKey" ) );
	ResetAllBtn		=	ButtonHandle ( GetHandle( "ResetAllBtn" ) );
	Chk_EnterChatting	=	CheckBoxHandle ( GetHandle( "Chk_EnterChatting" ) );
	KeySettingInput	=	EditBoxHandle ( GetHandle( "KeySettingInput" ) );
	EnterKeyList		=	ListCtrlHandle ( GetHandle( "EnterKeyList" ) );
	GeneralKeyList		= 	ListCtrlHandle ( GetHandle( "GeneralKeyList" ) );
	assignShortKeyText	=	TextBoxHandle ( GetHandle( "assignShortKeyText" ) );
	selectedkeygrouptext	=	TextBoxHandle ( GetHandle( "selectedkeygrouptext" ) );
	TextCurrent		=	TextBoxHandle ( GetHandle( "TextCurrent" ) );
	Tab_KeyGroup	=	TabHandle( GetHandle(	"TabCtrl"	) );
	
	AirKeySetting		=	GetHandle(m_WindowName$"."$"AirKeySetting");				// 공중용 추가
	AirkeyWnd			=	GetHandle(m_WindowName$"."$"AirKeySetting.AirKeyWnd" );
	AirKeyList			=	ListCtrlHandle( GetHandle (m_WindowName$"."$ "AirKeySetting.AirKeyList" ) );
	
	AirTransKeySetting		=	GetHandle(m_WindowName$"."$"AirTransKeySetting");				// 공중용 추가
	AirTranskeyWnd			=	GetHandle(m_WindowName$"."$"AirTransKeySetting.AirTransKeyWnd" );
	AirTransKeyList			=	ListCtrlHandle( GetHandle (m_WindowName$"."$ "AirTransKeySetting.AirTransKeyList" ) );

}

function InitializeWindowHandlesCOD()
{
	CFrameWnd385		=	GetWindowHandle( m_WindowName$"."$"CFrameWnd385" );
	CFrameWnd386		=	GetWindowHandle( m_WindowName$"."$"CFrameWnd386" );
	Me 				=	GetWindowHandle( m_WindowName );
	DisableBox			=	GetWindowHandle( m_WindowName$"."$"DisableBox" );
	GeneralKeySetting	=	GetWindowHandle(m_WindowName$"."$"GeneralKeySetting");
	GeneralKeyWnd 		= 	GetWindowHandle( m_WindowName$"."$"GeneralKeySetting.GeneralKeyWnd" );		
	EnterKeySetting		=	GetWindowHandle(m_WindowName$"."$"EnterKeySetting");
	EnterkeyWnd		=	GetWindowHandle(m_WindowName$"."$"EnterKeySetting.EnterkeyWnd" );
	EnterKeyList		=	GetListCtrlHandle (m_WindowName$"."$ "EnterKeySetting.EnterKeyList" );
	
	AirKeySetting		=	GetWindowHandle(m_WindowName$"."$"AirKeySetting");				// 공중용 추가
	AirkeyWnd			=	GetWindowHandle(m_WindowName$"."$"AirKeySetting.AirKeyWnd" );		// 공중용 추가
	AirKeyList			=	GetListCtrlHandle (m_WindowName$"."$ "AirKeySetting.AirKeyList" );		// 공중용 추가
	
	AirTransKeySetting	=	GetWindowHandle(m_WindowName$"."$"AirTransKeySetting");				// 공중용 추가
	AirTranskeyWnd		=	GetWindowHandle(m_WindowName$"."$"AirTransKeySetting.AirTransKeyWnd" );		// 공중용 추가
	AirTransKeyList		=	GetListCtrlHandle (m_WindowName$"."$ "AirTransKeySetting.AirTransKeyList" );		// 공중용 추가
	
	OptionWnd	=	GetWindowHandle(	"OptionWnd"	);
	Btn_Apply			=	GetButtonHandle ( m_WindowName$"."$"Btn_Apply" );
	Btn_AssignCurrent	=	GetButtonHandle (m_WindowName$"."$ "CFrameWnd386.Btn_AssignCurrent" );
	Btn_Cancel		=	GetButtonHandle ( m_WindowName$"."$"Btn_Cancel" );
	Btn_CancelCurrentKey	=	GetButtonHandle ( m_WindowName$"."$"CFrameWnd386.Btn_CancelCurrentKey" );
	Btn_OK			=	GetButtonHandle ( m_WindowName$"."$"Btn_OK" );
	//~ Btn_ResetCurrent	=	ButtonHandle ( "ShortcutTab.Btn_ResetCurrent" );
	Btn_SaveCurrentKey	=	GetButtonHandle ( m_WindowName$"."$"CFrameWnd386.Btn_SaveCurrentKey" );
	ResetAllBtn		=	GetButtonHandle ( m_WindowName$"."$"OptionCheckboxGroup.ResetAllBtn" );
	Chk_EnterChatting	=	GetCheckBoxHandle (m_WindowName$"."$ "OptionCheckboxGroup.Chk_EnterChatting" );
	KeySettingInput	=	GetEditBoxHandle ( m_WindowName$"."$"CFrameWnd386.KeySettingInput" );
	
	
	GeneralKeyList		= 	GetListCtrlHandle ( m_WindowName$"."$"GeneralKeySetting.GeneralKeyWnd.GeneralKeyList" );
	assignShortKeyText	=	GetTextBoxHandle (m_WindowName$"."$ "CFrameWnd386.assignShortKeyText" );
	selectedkeygrouptext	=	GetTextBoxHandle ( m_WindowName$"."$"CFrameWnd386.selectedkeygrouptext" );
	TextCurrent		=	GetTextBoxHandle (m_WindowName$"."$ "CFrameWnd385.TextCurrent" );
	Tab_KeyGroup	=	GetTabHandle(m_WindowName$"."$"TabCtrl"	);
}

function OnRegisterEvent()
{
	registerEvent( 	EV_DialogOK	);
	registerEvent( 	EV_DialogCancel	);
	registerEvent(	EV_ShortcutInit	);
	registerEvent(	EV_StateChanged	);
	registerEvent(	EV_ShortcutDataReceived	);
}

function UIActivationUponStateChanges(bool bTurnOff)
{
	if (bTurnOff == false)
	{
		DisableBox.ShowWindow();
		DisableBox.SetFocus();
	}
	else if (bTurnOff == true)
	{
		DisableBox.HideWindow();
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
//	WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//	Don't meddle with activating/deactivating!!!! - lpislhy
/////////////////////////////////////////////////////////////////////////////////////////////////////
//function ResetActivateKeyGroup()
//{
		//class'ShortcutAPI'.static.ActivateGroup("CameraControl");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateDefaultShortcut");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
		//class'ShortcutAPI'.static.ActivateGroup("GamingStateShortcut");	
		//class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		//~ class'ShortcutAPI'.static.ActivateGroup("GamingStateShortcut");	
//}

// 빌더 캐릭터일경우, 빌더 숏컷 그룹을 불러온다.
function ResetGMKeyActivate()
{
	if( IsBuilderPC() )
		class'ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
	else
		class'ShortcutAPI'.static.DeactivateGroup("GamingStateGMShortcut");
}


// 엔터채팅으로 변경해준다. 
function HandleSwitchEnterchatting()
{
	local bool bEnterChat;
	bEnterChat = GetOptionBool("Game", "EnterChatting");
	//~ ResetActivateKeyGroup();
	if (bEnterChat)
	{
		
		class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		Chk_EnterChatting.SetCheck(true);
	}
	else
	{
		class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
		Chk_EnterChatting.SetCheck(false);
	}
}

function HandleResetUI2Default()
{
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	Btn_AssignCurrent.ShowWindow();
	//~ Btn_ResetCurrent.ShowWindow();
	KeySettingInput.HideWindow();
}

function HandleUpdateGeneralKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	GeneralKeyList.DeleteAllItem();
	class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;

		if (l_Action == "PRESS")
		{
			GeneralKeyList.InsertRecord( Record );
		}
	}
}

function HandleUpdateEnterKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	
	local ShortcutCommandItem it;
	
	EnterKeyList.DeleteAllItem();
	
	AddExtraShortcuts();
	class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	
	for (i = 0; i < CurrentShortcutList.Length; i++) 
	{
		it = CurrentShortcutList[i];
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		if (l_sCommand == "TargetLockUnlock")
		{
			data1.szData = "Lock Target";
		}
		else
		{
			data1.szData = GetShortcutItemNameWithID(l_id);
		}
		
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;	
		if (l_Action == "PRESS")
		{
			EnterKeyList.InsertRecord( Record );
		}	
	}
}

// 공중 키 컨트롤을 업데이트한다.
function HandleUpdateAirKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	AirKeyList.DeleteAllItem();
	
	class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
		
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;
		if (l_Action == "PRESS")
		{
			AirKeyList.InsertRecord( Record );
		}
	}
}

// 공중 키 컨트롤을 업데이트한다. // 비행 변신체
function HandleUpdateAirTransKeyListControl()
{
	local int i;
	local int j;
	local ShortcutCommandItem tempShortcutItem;
	local string l_sCommand;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local string l_State;
	local int l_id;
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;
	local LVData data3;
	local LVData data4;
	local LVData data5;
	local LVData data6;
	local LVData data7;
	local LVData data8;
	local Array<ShortcutCommandItem> CurrentShortcutList;
	AirTransKeyList.DeleteAllItem();
	
	class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{
		for(j=CurrentShortcutList.Length-1;i<j;j--)
		{
			if(CurrentShortcutList[i].id > CurrentShortcutList[j].id) 
			{
				tempShortcutItem = CurrentShortcutList[i];
				CurrentShortcutList[i] = CurrentShortcutList[j];
				CurrentShortcutList[j] = tempShortcutItem;
			}
		}
	}
	
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_sCommand = CurrentShortcutList[i].sCommand;
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		l_State = CurrentShortcutList[i].sState;
		data1.nReserved1 = l_id;
		data1.szData = GetShortcutItemNameWithID(l_id);
		Record.LVDataList[0] = data1;
		data2.szData = MakeFullShortcutKeyCombinationName(l_key, l_subkey1, l_subkey2);
		Record.LVDataList[1] = data2;
		data3.szData = l_key;
		Record.LvDataList[2] = data3;
		data4.szData = l_subkey1;
		Record.LvDataList[3] = data4;
		data5.szData = l_subkey2;
		Record.LvDataList[4] = data5;
		data6.szData = l_sCommand;
		Record.LvDataList[5] = data6;
		data7.szData = l_State;
		Record.LvDataList[6] = data7;
		data8.szData = l_Action;
		Record.LvDataList[7] = data8;
		if (l_Action == "PRESS")
		{
			AirTransKeyList.InsertRecord( Record );
		}
	}
}

function OnResetAllBtnClickPopUpMessage()
{
	DialogSetID( DIALOGID_proc1 );
	DialogSetDefaultOK();	
	DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 2152 ) );
}


function AssignCurrentSelectedKeyfromtheListCtrl()
{
	local LVDataRecord Record;
	local string CurrentCommand;
	local string CurrentMainKey;
	local string CurrentSubkey1;
	local string CurrentSubkey2;
	local int CurrentID;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		GeneralKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		EnterKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가 
		AirKeyList.GetSelectedRec(Record);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 추가 	// 비행 변신체
		AirTransKeyList.GetSelectedRec(Record);
	CurrentID = Record.LVDataList[0].nReserved1;
	CurrentCommand = Record.LVDataList[5].szData;
	CurrentMainKey = Record.LVDataList[2].szData;
	CurrentSubkey1 = Record.LVDataList[3].szData;
	CurrentSubkey2 = Record.LVDataList[4].szData;
	selectedkeygrouptext.SetText(GetShortcutItemNameWithID(CurrentID));
	TextCurrent.SetText(GetKeySettingDescriptionWithID(CurrentID));
	KeySettingInput.SetString(MakeFullShortcutKeyCombinationName(CurrentMainKey,CurrentSubKey1,CurrentSubKey2));
}

function Switch2KeyInputMode()
{
	class'ShortcutAPI'.static.LockShortcut();
	KeySettingInput.ShowWindow();
	KeySettingInput.DisableWindow();
	Me.SetFocus();
	Btn_SaveCurrentKey.ShowWindow();
	Btn_CancelCurrentKey.ShowWindow();
	Btn_AssignCurrent.HideWindow();
	//~ Btn_ResetCurrent.HideWindow();
}

function Switch2KeyBrowsingMode()
{
	Btn_SaveCurrentKey.HideWindow();
	Btn_CancelCurrentKey.HideWindow();
	Btn_AssignCurrent.ShowWindow();
	//~ Btn_ResetCurrent.ShowWindow();
	KeySettingInput.HideWindow();
	class'ShortcutAPI'.static.UnlockShortcut();
}

function SetCurrentKeyAsShortKey()
{
	local ShortcutCommandItem item;
	local LVDataRecord Record;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = m_subkey1;
		item.subkey2 =  m_subkey2;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = m_subkey1;
			item.subkey2 =  m_subkey2;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);		// 비행정과 비행변신체를 동시에 바꿔주어야 한다.	
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련	// 비행 변신체
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = Record.LVDataList[5].szData;
		item.key = m_mainkey;
		item.subkey1 = "";
		item.subkey2 =  "";
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);		// 비행정과 비행변신체를 동시에 바꿔주어야 한다.
		m_currentListCtrlIndex = Record.LVDataList[0].nReserved1;
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop" $ Record.LVDataList[5].szData;
			item.key = m_mainkey;
			item.subkey1 = "";
			item.subkey2 =  "";
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		}
	}
}

function DeleteCurrentShortcutItem()
{
	local ShortcutCommandItem item;
	local LVDataRecord Record;
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 =  Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = m_mainkey;
			item.subkey1 = m_subkey1;
			item.subkey2 =  m_subkey2;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련	//비행 변신체 관련
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = "";
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "";
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);
		}
	}
}


function string CheckShortcutItemRedundency()
{
	local int i;
	local array<ShortcutCommandItem> CurrentShortcutList;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local int l_id;
	local string str_redunteditem;
	
	str_redunteditem = "";
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 수정
		class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련 수정
		class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		l_key = CurrentShortcutList[i].key;
		l_subkey1 = CurrentShortcutList[i].subkey1;
		l_subkey2 = CurrentShortcutList[i].subkey2;
		l_id = CurrentShortcutList[i].id;
		l_Action = CurrentShortcutList[i].sAction;
		
		if (m_mainkey == l_key && m_subkey1 == l_subkey1 && m_subkey2 == l_subkey2)
			str_redunteditem = GetShortcutItemNameWithID(l_id) @ "-" @ MakeFullShortcutKeyCombinationName(m_mainkey, m_subkey1, m_subkey2);
	}
	
	return str_redunteditem;
	
}

function SwapReduntedShortcutItemwithCurrentShortcutItem()
{
	local int i;
	local ShortcutCommandItem item;
	local string l_command;
	local string l_key;
	local string l_subkey1;
	local string l_subkey2;
	local string l_Action;
	local int l_id;
	local LVDataRecord Record;
	local array<ShortcutCommandItem> CurrentShortcutList;
	
	
	if (Tab_KeyGroup.GetTopIndex() == 0)
		class'ShortcutAPI'.static.GetGroupCommandList("GamingStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 1)
		class'ShortcutAPI'.static.GetGroupCommandList("TempStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가
		class'ShortcutAPI'.static.GetGroupCommandList("FlightStateShortcut", CurrentShortcutList);
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련 추가	// 비행 변신체
		class'ShortcutAPI'.static.GetGroupCommandList("FlightTransformShortcut", CurrentShortcutList);
		
	for( i=0 ; i < CurrentShortcutList.Length ; ++i )
	{	
		
		if (m_mainkey == CurrentShortcutList[i].key && m_subkey1 == CurrentShortcutList[i].subkey1 && m_subkey2 == CurrentShortcutList[i].subkey2 )
		{
			l_command = CurrentShortcutList[i].sCommand;
			l_key = CurrentShortcutList[i].key;
			l_subkey1 = CurrentShortcutList[i].subkey1;
			l_subkey2 = CurrentShortcutList[i].subkey2;
			l_id = CurrentShortcutList[i].id;
			l_Action = CurrentShortcutList[i].sAction;
			break;
		}
	}
	if (Tab_KeyGroup.GetTopIndex() == 0)
	{
		GeneralKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 =  Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData;
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 =  Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData;
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("GamingStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 1)
	{
		EnterKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("TempStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 2)	// 비행정 관련
	{
		AirKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightStateShortcut", item);
		}
	}
	else if (Tab_KeyGroup.GetTopIndex() == 3)	// 비행정 관련
	{
		AirTransKeyList.GetSelectedRec(Record);
		item.sCommand = l_command;
		item.key = Record.LVDataList[2].szData;
		item.subkey1 = Record.LVDataList[3].szData;
		item.subkey2 = Record.LVDataList[4].szData;
		item.sState = Record.LvDataList[6].szData; 
		item.sAction =  Record.LvDataList[7].szData;
		class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);	
		if (IsReleaseActionItems(Record.LVDataList[5].szData))
		{
			item.sCommand = "stop"$l_command;
			item.key = Record.LVDataList[2].szData;
			item.subkey1 = Record.LVDataList[3].szData;
			item.subkey2 = Record.LVDataList[4].szData;
			item.sState = Record.LvDataList[6].szData; 
			item.sAction =  "Release";
			class'ShortcutAPI'.static.AssignCommand("FlightTransformShortcut", item);
		}
	}
}

// 비행선 or 비행변신 상태일때 해당 숏컷 그룹을 액티브 시켜준다. 
function ActiveFlightShort()
{
	//scriptShip
	//scriptTrans
	if( scriptShip.Me.IsShowWindow())	// 비행정 조종 상태일때	// 비행정 숏컷 그룹을 액티브 해준다. 
	{
		//scriptShip.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//기존 엔터채팅 옵션을 저장해둔다. 		
		SetOptionBool( "Game", "EnterChatting", true );	//강제 엔터 채팅
		Chk_EnterChatting.SetCheck(true);
		Chk_EnterChatting.DisableWindow();			// 디스에이블
			
		class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");		//숏컷 그룹 지정	
		scriptShip.updateLockButton();	// 잠금 상태를 업데이트 한다. 			
			
		scriptShip.ChatEditBox.ReleaseFocus();
	}
	else if( scriptTrans.Me.IsShowWindow())
	{
		//scriptTrans.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//기존 엔터채팅 옵션을 저장해둔다. 		
		
		SetOptionBool( "Game", "EnterChatting", true );	//강제 엔터 채팅
		Chk_EnterChatting.SetCheck(true);
		Chk_EnterChatting.DisableWindow();			// 디스에이블
		
		scriptTrans.updateLockButton();	// 잠금 상태를 업데이트 한다. 
		class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");	//숏컷 그룹 지정
	}
}

defaultproperties
{
    
}

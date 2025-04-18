class ChatFilterWnd extends UIScriptEx;
	
var TabHandle m_ChatFilterTab;

var EditBoxHandle EditBox_KeyWord0;
var EditBoxHandle EditBox_KeyWord1;
var EditBoxHandle EditBox_KeyWord2;

var ButtonHandle Keyword_Reset0;
var ButtonHandle Keyword_Reset1;
var ButtonHandle Keyword_Reset2;

var CheckBoxHandle KeywordFilterBox;
var CheckBoxHandle KeywordSoundBox;

var ComboBoxHandle m_ChannelAssignComboBox;
var TextBoxHandle m_txtSelectAssignChatTitle;
 
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
	{
		EditBox_KeyWord0 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord0" ));
		EditBox_KeyWord1 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord1" ));
		EditBox_KeyWord2 = EditBoxHandle (GetHandle("ChatFilterWnd.Editbox_KeyWord2" ));
					                                                 
		Keyword_Reset0 = ButtonHandle(GetHandle("ChatFilterWnd.Keyword_Reset0"));
		Keyword_Reset1 = ButtonHandle(GetHandle("ChatFilterWnd.Keyword_Reset1"));
		Keyword_Reset2 = ButtonHandle(GetHandle("ChatFilterWnd.Keyword_Reset2"));
								  
		KeywordFilterBox   = CheckBoxHandle  (GetHandle("ChatFilterWnd.KeywordFilterBox" ));
		KeywordSoundBox = CheckBoxHandle   (GetHandle("ChatFilterWnd.KeywordSoundBox" ));
		
		m_ChatFilterTab = TabHandle (GetHandle("ChatFilterWnd.ChatFilterTab"));
		
		m_ChannelAssignComboBox = ComboBoxHandle (GetHandle("ChatFilterWnd.ChattingFilterGroup.ChannelAssignComboBox"));
		m_txtSelectAssignChatTitle = TextBoxHandle (GetHandle("ChatFilterWnd.ChattingFilterGroup.txtSelectAssignChatTitle"));
	}
	else
	{
		EditBox_KeyWord0 = GetEditBoxHandle("ChatFilterWnd.Editbox_KeyWord0" );
		EditBox_KeyWord1 = GetEditBoxHandle("ChatFilterWnd.Editbox_KeyWord1" );
		EditBox_KeyWord2 = GetEditBoxHandle("ChatFilterWnd.Editbox_KeyWord2" );
					                                                 
		Keyword_Reset0 = GetButtonHandle("ChatFilterWnd.Keyword_Reset0");
		Keyword_Reset1 = GetButtonHandle("ChatFilterWnd.Keyword_Reset1");
		Keyword_Reset2 = GetButtonHandle("ChatFilterWnd.Keyword_Reset2");
								  
		KeywordFilterBox   = GetCheckBoxHandle("ChatFilterWnd.KeywordFilterBox" );
		KeywordSoundBox = GetCheckBoxHandle("ChatFilterWnd.KeywordSoundBox" );
		
		m_ChatFilterTab = GetTabHandle("ChatFilterWnd.ChatFilterTab");
		
		m_ChannelAssignComboBox = GetComboBoxHandle ("ChatFilterWnd.ChattingFilterGroup.ChannelAssignComboBox");
		m_txtSelectAssignChatTitle = GetTextBoxHandle ("ChatFilterWnd.ChattingFilterGroup.txtSelectAssignChatTitle");
	}

	InitTabOrder();
	//~ SetComboxIDSelect(-1, 1);
	//~ m_ChannelAssignComboBox.DisableWindow();
}


function InitTabOrder()
{
	
	class'UIAPI_WINDOW'.static.SetTabOrder("ChatFilterWnd", "ChatFilterWnd.EditBox_KeyWord0", "ChatFilterWnd.EditBox_KeyWord2");
	class'UIAPI_WINDOW'.static.SetTabOrder("ChatFilterWnd.EditBox_KeyWord0", "ChatFilterWnd.EditBox_KeyWord1", "ChatFilterWnd");
	class'UIAPI_WINDOW'.static.SetTabOrder("ChatFilterWnd.EditBox_KeyWord1", "ChatFilterWnd.EditBox_KeyWord2", "ChatFilterWnd.EditBox_KeyWord0");
	class'UIAPI_WINDOW'.static.SetTabOrder("ChatFilterWnd.EditBox_KeyWord2", "ChatFilterWnd.EditBox_KeyWord0", "ChatFilterWnd.EditBox_KeyWord1");
}
  
function OnShow()
{
	local string tempstring;
	GetINIString("global", "Keyword0", tempstring, "chatfilter.ini");
	EditBox_KeyWord0.SetString(tempstring);
	GetINIString("global", "Keyword1", tempstring, "chatfilter.ini");
	EditBox_KeyWord1.SetString(tempstring);
	GetINIString("global", "Keyword2", tempstring, "chatfilter.ini");
	EditBox_KeyWord2.SetString(tempstring);
	//~ SetComboxIDSelect(-1, 1);
	//~ FillOutComboBoxHandle();
}

function FillOutComboBoxHandle()
{
	m_ChannelAssignComboBox.Clear();
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(355), 1);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(188), 2);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(128), 3);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(559), 4);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1961), 5);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1962), 6);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1963), 7);
	m_ChannelAssignComboBox.AddStringWithReserved(GetSystemString(1964), 8);
}

// ä�� ���� ������

function OnClickButton(string strID)
{
	//~ local ChatWnd script;

	//~ script = ChatWnd( GetScript("ChatWnd") );
	if( strID == "ChatFilterOK" )
	{
		SaveChatFilterOption();
		class'UIAPI_WINDOW'.static.HideWindow( "ChatFilterWnd" );
	}
	else if( strID == "ChatFilterCancel" )
	{
		class'UIAPI_WINDOW'.static.HideWindow( "ChatFilterWnd" );
		EditBox_KeyWord0.SetString("");
		EditBox_KeyWord1.SetString("");
		EditBox_KeyWord2.SetString("");
	}
	else if( strID == "Keyword_Reset0" )
	{
		EditBox_KeyWord0.SetString("");
	}
	else if( strID == "Keyword_Reset1" )
	{
		EditBox_KeyWord1.SetString("");
	}	
	else if( strID == "Keyword_Reset2" )
	{
		EditBox_KeyWord2.SetString("");
	}
}

function OnClickCheckBox( String strID )
{
	local ChatWnd	script;
	local int chatType;

	script = ChatWnd( GetScript("ChatWnd") );
	chatType = script.m_chatType.ID;

	if( strID == "CheckBoxSystem" )
	{
		// ū ī�װ��� üũ �Ǿ����� ���ο� ���� ���� ī�װ��� checkbox�� Ȱ��/��Ȱ�� �Ѵ�.
		if( !class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxSystem" ) )
		{
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxDamage", true );
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxItem", true );
		}
		else
		{
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxDamage", false );
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxItem", false );
		}
	}
//	else if( strID == "CheckBoxChat" )
//	{
//		// ū ī�װ��� üũ �Ǿ����� ���ο� ���� ���� ī�װ��� checkbox�� Ȱ��/��Ȱ�� �Ѵ�.
//		if( !class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxChat" ) )
///		{
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxNormal", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxShout", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxPledge", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxParty", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxTrade", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxWhisper", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxAlly", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxHero", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxUnion", true );
	//	}
	//	else
	//	{
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxNormal", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxShout", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxPledge", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxParty", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxTrade", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxWhisper", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxAlly", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxHero", true );
	//		class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxUnion", true );
	//	}
//
//	}
	 else if ( strID == "SystemMsgBox")
	 {
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.SystemMsgBox" ) )
		{
			class'UIAPI_CHECKBOX'.static.EnableWindow( "ChatFilterWnd.DamageBox" );
			class'UIAPI_CHECKBOX'.static.EnableWindow( "ChatFilterWnd.ItemBox" );
		}
		else
		{
			class'UIAPI_CHECKBOX'.static.DisableWindow( "ChatFilterWnd.DamageBox" );
			class'UIAPI_CHECKBOX'.static.DisableWindow( "ChatFilterWnd.ItemBox" );
		}
	}
	
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxNormal", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxShout", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxPledge", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxParty", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxTrade", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxWhisper", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxAlly", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxHero", false );
	class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxUnion", false );
	debug ("Released Button:" @ string(script.m_chatType.ID) );
	switch( script.m_chatType.ID )
		{
			//~ debug ("Released Button:" @ string(script.m_chatType.ID) );
		case 3:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxPledge", true );
			break;
		case 2:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxParty", true );
			break;
		case 1:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxTrade", true );
			break;
		case 4:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxAlly", true );
			break;
		case 5:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxHero", true );
			break;
		case 6:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxUnion", true );
			break;
		case 7:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxShout", true );
			break;
		case 8:
			class'UIAPI_CHECKBOX'.static.SetDisable( "ChatFilterWnd.CheckBoxBattle", true );
			break;
			
		default:
			break;
		}
}

function SaveChatFilterOption()
{
	local ChatWnd	script;
	local int chatType;
	local bool bChecked;
	
	script = ChatWnd( GetScript("ChatWnd") );
	chatType = script.m_chatType.UI;
	
	script.m_filterInfo[chatType].bSystem = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxSystem" ) );
	script.m_filterInfo[chatType].bUseitem = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxItem" ) );
	script.m_filterInfo[chatType].bDamage = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxDamage" ) );
	script.m_filterInfo[chatType].bChat = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxChat" ) );
	script.m_filterInfo[chatType].bNormal = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxNormal" ) );
	script.m_filterInfo[chatType].bParty = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxParty" ) );
	script.m_filterInfo[chatType].bShout = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxShout" ) );
	script.m_filterInfo[chatType].bTrade = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxTrade" ) );
	script.m_filterInfo[chatType].bClan = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxPledge" ) );
	script.m_filterInfo[chatType].bWhisper = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxWhisper" ) );
	script.m_filterInfo[chatType].bAlly = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxAlly" ) );
	script.m_filterInfo[chatType].bHero = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxHero" ) );
	script.m_filterInfo[chatType].bUnion = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxUnion" ) );
	script.m_filterInfo[chatType].bBattle = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxBattle" ) );
	script.m_NoNpcMessage = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxNPC" ) );	// NPC ��� ���͸� - 2010.9.8 winkey
	script.m_NoUnionCommanderMessage = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.CheckBoxCommand" ) );
	script.m_KeywordFilterSound = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.KeywordSoundBox" ) );
	script.m_KeywordFilterActivate = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.KeywordFilterBox" ) );
	script.m_Keyword0 = EditBox_KeyWord0.GetString();
	script.m_Keyword1 = EditBox_KeyWord1.GetString();
	script.m_Keyword2 = EditBox_KeyWord2.GetString();
	
	
	// �ý��۸޽�������â - SystemMsgBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.SystemMsgBox" );
	SetOptionBool( "Game", "SystemMsgWnd", bChecked );

	// ������ - DamageBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.DamageBox" );
	SetOptionBool( "Game", "SystemMsgWndDamage", bChecked );

	// �Ҹ𼺾����ۻ�� - ItemBox
	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.ItemBox" );
	SetOptionBool( "Game", "SystemMsgWndExpendableItem", bChecked );
	
	if (GetOptionBool( "Game", "SystemMsgWnd" ) )
	{
		 class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
	} 
	else 
	{
		class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
	}
	
	
	SetINIBool(script.m_sectionName[chatType],"system", bool(script.m_filterInfo[chatType].bSystem), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"damage", bool(script.m_filterInfo[chatType].bDamage), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"useitems", bool(script.m_filterInfo[chatType].bUseItem), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"chat", bool(script.m_filterInfo[chatType].bChat), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"normal", bool(script.m_filterInfo[chatType].bNormal), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"party", bool(script.m_filterInfo[chatType].bParty), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"shout", bool(script.m_filterInfo[chatType].bShout), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"market", bool(script.m_filterInfo[chatType].bTrade), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"pledge", bool(script.m_filterInfo[chatType].bClan), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"tell", bool(script.m_filterInfo[chatType].bWhisper), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"ally", bool(script.m_filterInfo[chatType].bAlly), "chatfilter.ini");	
	SetINIBool(script.m_sectionName[chatType],"hero", bool(script.m_filterInfo[chatType].bHero), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"union", bool(script.m_filterInfo[chatType].bUnion), "chatfilter.ini");
	SetINIBool(script.m_sectionName[chatType],"battle", bool(script.m_filterInfo[chatType].bBattle), "chatfilter.ini");
	
	//Global Setting
	SetINIBool("global","npc", bool(script.m_NoNpcMessage), "chatfilter.ini");						// NPC ��� ���͸� - 2010.9.8 winkey
	SetINIBool("global","command", bool(script.m_NoUnionCommanderMessage), "chatfilter.ini");
	SetINIBool("global","keywordsound", bool(script.m_KeywordFilterSound), "chatfilter.ini");
	SetINIBool("global","keywordactivate", bool(script.m_KeywordFilterActivate), "chatfilter.ini");
	
	 
	SetINIString("global", "Keyword0", script.m_Keyword0, "chatfilter.ini");
	SetINIString("global", "Keyword1", script.m_Keyword1, "chatfilter.ini");
	SetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini");
	
	script.m_KeywordFilterSound = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.KeywordSoundBox" ) );
	script.m_KeywordFilterActivate = int( class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.KeywordFilterBox" ) );
	
	
}


function OnComboBoxItemSelected(string StrID, int IndexID)
{
	local ChatWnd script;

	script = ChatWnd( GetScript("ChatWnd") );
	switch(strID)
	{
		case "ChannelAssignComboBox" :
			script.ChangeTabChannel(IndexID + 1);
			script.HandleTabClick("");
		break;
	}
}


function SetComboxIDSelect(int Index, int ID)
{
	FillOutComboBoxHandle();
	
	if (Index == -1 )
	{
		m_ChannelAssignComboBox.DisableWindow();
		m_txtSelectAssignChatTitle.DisableWindow();
		m_ChannelAssignComboBox.SetSelectedNum(0);
	}
	else
	{
		m_ChannelAssignComboBox.EnableWindow();
		m_txtSelectAssignChatTitle.EnableWindow();
		m_ChannelAssignComboBox.SetSelectedNum(ID-1);
	}
}
defaultproperties
{
}

class UIToolWnd extends UICommonAPI;

const DIALOGID_Gohome = 0;

var WindowHandle Me;
var ButtonHandle transBtn;
var ButtonHandle debugBtn;
var ButtonHandle uiBtn;
var ButtonHandle reloaduiBtn;
var ButtonHandle evemsgBtn;
var ButtonHandle uioffBtn;
var ButtonHandle showWBtn;
var ButtonHandle skillBtn;
var ButtonHandle killBtn;
var ButtonHandle weightBtn;
var ButtonHandle diaBtn;

var EditBoxHandle HEdit0;
var EditBoxHandle HEdit;

var EditBoxHandle NEdit;

var ListCtrlHandle WindowListCtrl;

var array<string> arrWinList;


//var DialogBox	dScript;

//var INT64 tempN;
//var bool tempB;
//var bool tempResultB;
//var String tempOper;
//var EditBoxHandle m_ResultEditBox;

var WindowHandle m_dialogWnd;

function OnLoad()
{
	OnRegisterEvent();
	
	Me = GetWindowHandle( "UIToolWnd" );
	transBtn = GetButtonHandle( "UIToolWnd.transBtn" );
	debugBtn = GetButtonHandle( "UIToolWnd.debugBtn" );
	uiBtn = GetButtonHandle( "UIToolWnd.uiBtn" );
	reloaduiBtn = GetButtonHandle( "UIToolWnd.reloaduiBtn" );
	evemsgBtn = GetButtonHandle( "UIToolWnd.evemsgBtn" );
	uioffBtn = GetButtonHandle( "UIToolWnd.uioffBtn" );
	showWBtn = GetButtonHandle( "UIToolWnd.showWBtn" );
	skillBtn = GetButtonHandle( "UIToolWnd.skillBtn" );
	killBtn = GetButtonHandle( "UIToolWnd.killBtn" );
	weightBtn = GetButtonHandle( "UIToolWnd.weightBtn" );
	diaBtn = GetButtonHandle( "UIToolWnd.diaBtn" );

	HEdit0 = GetEditBoxHandle( "UIToolWnd.HEdit0" );
	HEdit = GetEditBoxHandle( "UIToolWnd.HEdit" );

	NEdit = GetEditBoxHandle( "UIToolWnd.NEdit" );
	
	WindowListCtrl = GetListCtrlHandle( "UIToolWnd.WindowListCtrl" );

	setArr();
}

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}






function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
		case "initBtn":
			initButtonClick();
			break;
		case "transBtn":
			if( transBtn.GetButtonName() == "���� ��" )
			{
				ExecuteCommand("//���� ��");
				transBtn.SetNameText( "���� ��" );
			}
			else
			{
				ExecuteCommand("//hide on");
				transBtn.SetNameText( "���� ��" );
			}
			break;

		case "debugBtn":
			ExecuteCommand("///uidebug");
			break;

		case "uiBtn":
			//Me.MoveTo( 1000, 0 );
			ExecuteCommand("///ui");			
			break;

		case "reloaduiBtn":
			ExecuteCommand("///reloadui");
			break;

		case "evemsgBtn":
			if( evemsgBtn.GetButtonName() == "EveMsg ON" )
			{
				evemsgBtn.SetNameText( "EveMsg OFF" );
			}
			else
			{
				evemsgBtn.SetNameText( "EveMsg ON" );
			}
			ExecuteCommand("///eventmsg");
			break;
			///gfx
			///delgfxall
			///delgfx "�����̸�"

		case "showWBtn":			
			ExecuteCommand("///show windowname");
			break;

		case "skillBtn":			
			ExecuteCommand("//setskill 7029 3");
			break;

		case "killBtn":			
			ExecuteCommand("//�׾�");
			break;
			
		case "weightBtn":
			if( weightBtn.GetButtonName() == "���� ��" )
			{
				ExecuteCommand("//���� ��");
				weightBtn.SetNameText( "���� ��" );
			}
			else
			{
				ExecuteCommand("//���� ��");
				weightBtn.SetNameText( "���� ��" );
			}
			break;	

		case "gfxBtn":			
			ExecuteCommand("///gfx");
			break;
		case "delgfxBtn":
			ExecuteCommand("///delgfxall");
			break;

		case "loadBtn":
			loadButtonClick();
			break;
		case "htmlBtn":
			htmlButtonClick();
			break;

		case "winBtn":
			winButtonClick();
			break;
	}
}



function initButtonClick()
{
	ExecuteCommand("//���� ��");
	ExecuteCommand("//�ӵ� 5");
	ExecuteCommand("///uidebug");
}


function loadButtonClick()
{
	local string str;
	local array<string> arrStr;
	
	//arrStr[0] = "";
	//arrStr[1] = "";

	str = HEdit0.GetString();	
	Split( str, ".", arrStr );

	if( arrStr[1] != "")
	{
		//debug("111@@@"$str);
		ExecuteCommand("//loadhtml "$str );
	}
	else
	{
		//debug("222@@@"$str);
		ExecuteCommand("//loadhtml "$str$".htm" );
	}
	
}


function htmlButtonClick()
{
	local RecommendBonusHelpHtmlWnd Script;
	local string str;
	local array<string> arrStr;
	
	//arrStr[0] = "";
	//arrStr[1] = "";

	str = HEdit.GetString();	
	Split( str, ".", arrStr );

	ShowWindow( "RecommendBonusHelpHtmlWnd" );

	Script = RecommendBonusHelpHtmlWnd( GetScript( "RecommendBonusHelpHtmlWnd" ) );
	
	if( arrStr[1] != "" )
	{
		Script.ShowHelp( "..\\L2text\\"$str );
	}
	else
	{
		Script.ShowHelp( "..\\L2text\\"$str$".htm" );
	}
}


function winButtonClick()
{	
	local WindowHandle NewWindow;
	local string str;

	str = NEdit.GetString();

	if( str != "" )
	{
		NewWindow = GetWindowHandle( NEdit.GetString() );
		NewWindow.ShowWindow();
		NewWindow.SetFocus();
	}	
}

//���ڵ带 Ŭ���ϸ�....
function OnClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord	record;	
	
	switch(ListCtrlID)
	{
		case "WindowListCtrl" :
			WindowListCtrl.GetSelectedRec( record );
			class'UIAPI_EDITBOX'.static.SetString( "UIToolWnd.NEdit", record.LVDataList[0].szData );
			break;
	}
}

//���ڵ带 ����Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord	record;	
	local WindowHandle NewWindow;

	switch(ListCtrlID)
	{
		case "WindowListCtrl" :
			WindowListCtrl.GetSelectedRec( record );
			
			NewWindow = GetWindowHandle( record.LVDataList[0].szData );
			NewWindow.ShowWindow();
			NewWindow.SetFocus();
			break;
	}
}

function MakeWindowList()
{
	local LVDataRecord Record;
	local int i;	

	for( i = 0 ; i < arrWinList.Length ; i++)
	{
		Record.LVDataList.length = 1;
		Record.LVDataList[0].szData = arrWinList[i];
		class'UIAPI_LISTCTRL'.static.InsertRecord( "UIToolWnd.WindowListCtrl", Record );
	}

	
}

function setArr()
{
	//itemIDList.Insert(itemIDList.Length,1); itemIDList[itemIDList.Length - 1] = item;

	arrWinList[0]="AbnormalStatusWnd";
arrWinList[1]="ActionWnd";
arrWinList[2]="AgeWnd";
arrWinList[3]="AITimerWnd";
arrWinList[4]="AttributeEnchantWnd";
arrWinList[5]="AttributeRemoveWnd";
arrWinList[6]="AuctionBtnWnd";
arrWinList[7]="AuctionNextWnd";
arrWinList[8]="AuctionWnd";
arrWinList[9]="BenchMarkMenuWnd";
arrWinList[10]="BirthdayAlarmBtn";
arrWinList[11]="BirthdayAlarmWnd";
arrWinList[12]="BlockCounter";
arrWinList[13]="BlockCurTriggerWnd";
arrWinList[14]="BlockCurWnd";
arrWinList[15]="BlockEnterWnd";
arrWinList[16]="BoardWnd";
arrWinList[17]="CalculatorWnd";
arrWinList[18]="CharacterCreateMenuWnd";
arrWinList[19]="ChatFilterWnd";
arrWinList[20]="ChatWnd";
arrWinList[21]="ClanDrawerWnd";
arrWinList[22]="ClanWnd";
arrWinList[23]="CleftCounter";
arrWinList[24]="CleftCurTriggerWnd";
arrWinList[25]="CleftCurWnd";
arrWinList[26]="CleftEnterWnd";
arrWinList[27]="ColorNickNameWnd";
arrWinList[28]="ConsoleWnd";
arrWinList[29]="CouponEventWnd";
arrWinList[30]="DeliverWnd";
arrWinList[31]="DepthOfField";
arrWinList[32]="DetailStatusWnd";
arrWinList[33]="DialogBox";
arrWinList[34]="DominionWarInfoWnd";
arrWinList[35]="DuelManager";
arrWinList[36]="EventMatchGMFenceWnd";
arrWinList[37]="EventMatchGMMsgWnd";
arrWinList[38]="EventMatchGMWnd";
arrWinList[39]="EventMatchObserverWnd";
arrWinList[40]="EventMatchSpecialMsgWnd";
arrWinList[41]="FileListWnd";
arrWinList[42]="FileRegisterWnd";
arrWinList[43]="FileWnd";
arrWinList[44]="FishViewportWnd";
arrWinList[45]="FlightShipCtrlWnd";
arrWinList[46]="FlightTeleportWnd";
arrWinList[47]="FlightTransformCtrlWnd";
arrWinList[48]="GametipWnd";
arrWinList[49]="GMClanWnd";
arrWinList[50]="GMDetailStatusWnd";
arrWinList[51]="GMFindTreeWnd";
arrWinList[52]="GMInventoryWnd";
arrWinList[53]="GMMagicSkillWnd";
arrWinList[54]="GMQuestWnd";
arrWinList[55]="GMSnoopWnd";
arrWinList[56]="GMWarehouseWnd";
arrWinList[57]="GMWnd";
arrWinList[58]="GuideWnd";
arrWinList[59]="HelpHtmlWnd";
arrWinList[60]="HennaInfoWnd";
arrWinList[61]="HennaListWnd";
arrWinList[62]="HeroTowerWnd";
arrWinList[63]="InventoryWnd";
arrWinList[64]="InviteClanPopWnd";
arrWinList[65]="ItemDescWnd";
arrWinList[66]="ItemEnchantWnd";
arrWinList[67]="KillpointCounterWnd";
arrWinList[68]="KillpointRankTrigger";
arrWinList[69]="KillPointRankWnd";
arrWinList[70]="LoadingAniWnd";
arrWinList[71]="LoadingWnd";
arrWinList[72]="LoadingWnd_cn";
arrWinList[73]="LoadingWnd_e";
arrWinList[74]="LoadingWnd_j";
arrWinList[75]="LoadingWnd_k";
arrWinList[76]="LoadingWnd_ph";
arrWinList[77]="LoadingWnd_th";
arrWinList[78]="LoadingWnd_tw";
arrWinList[79]="LobbyMenuWnd";
arrWinList[80]="LoginMenuWnd";
arrWinList[81]="MacroEditWnd";
arrWinList[82]="MacroInfoWnd";
arrWinList[83]="MacroListWnd";
arrWinList[84]="MagicSkillDrawerWnd";
arrWinList[85]="MagicskillGuideWnd";
arrWinList[86]="MagicSkillWnd";
arrWinList[87]="MailBtnWnd";
arrWinList[88]="ManorCropInfoChangeWnd";
arrWinList[89]="ManorCropInfoSettingWnd";
arrWinList[90]="ManorCropSellChangeWnd";
arrWinList[91]="ManorCropSellWnd";
arrWinList[92]="ManorInfoWnd";
arrWinList[93]="ManorSeedInfoChangeWnd";
arrWinList[94]="ManorSeedInfoSettingWnd";
arrWinList[95]="ManorShopWnd";
arrWinList[96]="MenuWnd";
arrWinList[97]="MiniGame1Wnd";
arrWinList[98]="MiniMapDrawerWnd";
arrWinList[99]="MinimapWnd";
arrWinList[100]="MinimapWnd_Expand";
arrWinList[101]="MoviePlayerWnd";
arrWinList[102]="MSViewerWnd";
arrWinList[103]="MultiSellWnd";
arrWinList[104]="NewPetitionFeedBackResultWnd";
arrWinList[105]="NewPetitionFeedBackWnd";
arrWinList[106]="NewPetitionFeedBackWnd_2nd";
arrWinList[107]="NewPetitionWnd";
arrWinList[108]="NewUserPetitionDrawerWnd";
arrWinList[109]="NewUserPetitionWnd";
arrWinList[111]="NPCDialogWnd";
arrWinList[112]="ObserverWnd";
arrWinList[113]="OlympiadBuff1Wnd";
arrWinList[114]="OlympiadBuff2Wnd";
arrWinList[115]="OlympiadBuffWnd";
arrWinList[116]="OlympiadControlWnd";
arrWinList[117]="OlympiadGuideWnd";
arrWinList[118]="OlympiadPlayer1Wnd";
arrWinList[119]="OlympiadPlayer2Wnd";
arrWinList[120]="OlympiadPlayerWnd";
arrWinList[121]="OlympiadTargetWnd";
arrWinList[122]="OnScreenMessageWnd";
arrWinList[123]="OptionWnd";
arrWinList[124]="PartyMatchMakeRoomWnd";
arrWinList[125]="PartyMatchOutWaitListWnd";
arrWinList[126]="PartyMatchRoomWnd";
arrWinList[127]="PartyMatchWaitListWnd";
arrWinList[128]="PartyMatchWnd";
arrWinList[129]="PartyMatchWndCommon";
arrWinList[130]="PartyWnd";
arrWinList[131]="PartyWndCompact";
arrWinList[132]="PartyWndOption";
arrWinList[133]="PCCafeEventWnd";
arrWinList[134]="PetitionFeedBackWnd";
arrWinList[135]="PetitionWnd";
arrWinList[136]="PetStatusWnd";
arrWinList[137]="PetWnd";
arrWinList[138]="PostBoxWnd";
arrWinList[139]="PostDetailWnd_General";
arrWinList[140]="PostDetailWnd_SafetyTrade";
arrWinList[141]="PostEffectTestWnd";
arrWinList[142]="PostReceiverListAddWnd";
arrWinList[143]="PostReceiverListWnd";
arrWinList[144]="PostWriteWnd";
arrWinList[145]="PremiumItemAlarmWnd";
arrWinList[146]="PremiumItemBtnWnd";
arrWinList[147]="PremiumItemGetWnd";
arrWinList[148]="PrivateMarketWnd";
arrWinList[149]="PrivateShopWnd";
arrWinList[150]="ProgressBox";
arrWinList[151]="PVPCounter";
arrWinList[152]="PVPCounterTrigger";
arrWinList[153]="PVPDetailedWnd";
arrWinList[154]="QuestAlarmWnd";
arrWinList[155]="QuestBtnWnd";
arrWinList[156]="QuestHTMLWnd";
arrWinList[157]="QuestListWnd";
arrWinList[158]="QuestTreeDrawerWnd";
arrWinList[159]="QuestTreeWnd";
arrWinList[160]="RadarMapWnd";
arrWinList[161]="RadarOptionWnd";
arrWinList[162]="RecipeBookWnd";
arrWinList[163]="RecipeBuyListWnd";
arrWinList[164]="RecipeBuyManufactureWnd";
arrWinList[165]="RecipeManufactureWnd";
arrWinList[166]="RecipeShopWnd";
arrWinList[167]="RecipeTreeWnd";
arrWinList[168]="RecommendBonusHelpHtmlWnd";
arrWinList[169]="RecommendBonusWnd";
arrWinList[170]="RefineryWnd";
arrWinList[171]="ReplayListWnd";
arrWinList[172]="ReplayLogoWnd";
arrWinList[173]="ReplayLogoWnd_cn";
arrWinList[174]="ReplayLogoWnd_e";
arrWinList[175]="ReplayLogoWnd_j";
arrWinList[176]="ReplayLogoWnd_k";
arrWinList[177]="ReplayLogoWnd_ph";
arrWinList[178]="ReplayLogoWnd_th";
arrWinList[179]="ReplayLogoWnd_tw";
arrWinList[180]="RestartMenuWnd";
arrWinList[181]="SceneEditorDrawerWnd";
arrWinList[182]="SceneEditorSlideWnd";
arrWinList[183]="SceneEditorWnd";
arrWinList[184]="SeedShopWnd";
arrWinList[185]="SelectDeliverWnd";
arrWinList[186]="ShaderBuild";
arrWinList[187]="ShopWnd";
arrWinList[188]="Shortcut";
arrWinList[189]="ShortcutAssignWnd";
arrWinList[190]="ShortcutWnd";
arrWinList[191]="SiegeInfoWnd";
arrWinList[192]="SkillEnchantInfoWnd";
arrWinList[193]="SkillEnchantWnd";
arrWinList[194]="SkillTrainClanTreeWnd";
arrWinList[195]="SkillTrainInfoWnd";
arrWinList[196]="SkillTrainListWnd";
arrWinList[197]="SSAOWnd";
arrWinList[198]="SSQMainBoard";
arrWinList[199]="StatusWnd";
arrWinList[200]="SummonedStatusWnd";
arrWinList[201]="SummonedWnd";
arrWinList[202]="SystemMenuWnd";
arrWinList[203]="SystemMsgWnd";
arrWinList[204]="SystemTutorialBtnWnd";
arrWinList[205]="SystemTutorialWnd";
arrWinList[206]="TargetStatusWnd";
arrWinList[207]="TeleportBookMarkDrawerWnd";
arrWinList[208]="TeleportBookMarkWnd";
arrWinList[209]="Tooltip";
arrWinList[210]="TownMapWnd";
arrWinList[211]="TradeWnd";
arrWinList[212]="TutorialBtnWnd";
arrWinList[213]="TutorialViewerWnd";
arrWinList[214]="UICommonAPI";
arrWinList[215]="UIDevWnd";
arrWinList[216]="UIEditor_ControlManager";
arrWinList[217]="UIEditor_DocumentInfo";
arrWinList[218]="UIEditor_FileManager";
arrWinList[219]="UIEditor_PropertyController";
arrWinList[220]="UIEditor_Worksheet";
arrWinList[221]="UITestWnd";
arrWinList[222]="UIToolWnd";
arrWinList[223]="UnionDetailWnd";
arrWinList[224]="UnionMatchDrawerWnd";
arrWinList[225]="UnionMatchMakeRoomWnd";
arrWinList[226]="UnionMatchWnd";
arrWinList[227]="UnionWnd";
arrWinList[228]="UniversalToolTip";
arrWinList[229]="UnrefineryWnd";
arrWinList[230]="UserPetitionWnd";
arrWinList[231]="WarehouseWnd";
arrWinList[232]="WeatherWnd";
arrWinList[233]="XMasSealWnd";
arrWinList[234]="ZoneTitleWnd";

	MakeWindowList();
}
defaultproperties
{
}

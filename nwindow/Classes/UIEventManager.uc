class UIEventManager extends Interactions
	//dynamicrecompile
	native;	

const MAX_PartyMemberCount = 9;
const CREATE_ON_DEMAND = 1;
var string mmand;
enum EGMCommandType
{
	GMCOMMAND_None,
	GMCOMMAND_StatusInfo,
	GMCOMMAND_ClanInfo,
	GMCOMMAND_SkillInfo,
	GMCOMMAND_QuestInfo,
	GMCOMMAND_InventoryInfo,
	GMCOMMAND_WarehouseInfo,
};

enum ELanguageType
{
	LANG_None,
	LANG_Korean,
	LANG_English,
	LANG_Japanese,
	LANG_Taiwan,
	LANG_Chinese,
	LANG_Thai,
	LANG_Philippine,
	LANG_Indonesia,
	LANG_Russia,
	LANG_Russian
};

enum EIMEType
{
	IME_NONE,
	IME_KOR,
	IME_ENG,
	IME_JPN,
	IME_CHN,
	IME_TAIWAN_CHANGJIE,
	IME_TAIWAN_DAYI,
	IME_TAIWAN_NEWPHONETIC,
	IME_TAIWAN_BOSHAMY,
	IME_CHN_MS,
	IME_CHN_JB,
	IME_CHN_ABC,
	IME_CHN_WUBI,
	IME_CHN_WUBI2,
	IME_THAI,
	IME_RUSSIA,
	IME_RUSSIAN
};

enum EXMLControlType
{
	XCT_None,
	XCT_FrameWnd,
	XCT_Button,
	XCT_TextBox,
	XCT_EditBox,
	XCT_TextureCtrl,
	XCT_ChatListBox,
	XCT_TabControl,
	XCT_ItemWnd,
	XCT_CheckBox,
	XCT_ComboBox,
	XCT_ProgressCtrl,
	XCT_MultiEdit,
	XCT_ListCtrl,
	XCT_ListBox,
	XCT_StatusBarCtrl,
	XCT_NameCtrl,
	XCT_MinimapWnd,
	XCT_ShortcutItemWnd,
	XCT_XMLTreeCtrl,
	XCT_SliderCtrl,
	XCT_EffectButton,
	XCT_TextListBox,
	XCT_RadarWnd,
	XCT_HtmlViewer,
	XCT_RadioButton,
	XCT_InvenWeightWnd,
	XCT_StatusIconCtrl,
	XCT_BarCtrl,
	XCT_ScrollWnd,
	XCT_FishViewportWnd,
	XCT_VIPShopItemInfoWnd,
	XCT_VIPShopNeededItemWnd,
	XCT_DrawPanel,
	XCT_RadarMapCtrl,
	XCT_PropertyController,
	XCT_FlashCtrl,
	XCT_CharacterViewportWnd,
	XCT_SceneCameraCtrl,
	XCT_SceneNpcCtrl,
	XCT_ScenePcCtrl,
	XCT_SceneScreenCtrl,
	XCT_SceneMusicCtrl
};

enum ETrackerAlignType
{
	TAT_Left,
	TAT_Center,
	TAT_Right,
	TAT_Width,
	TAT_Height
};

enum EControlPropertyGroupType
{
	CPGT_None,
	CPGT_Single,			//체크박스가 나온다						ex) <Iconable> <Frame>
	CPGT_SingleRequired,	//아무것도 안나온다						ex) <DefaultProperty>
	CPGT_Multiple,			//부모에 +버튼이 나오고, X버튼이 등장	ex) <ComboBox>의 <ComboItem>
	CPGT_MultipleRequired,	//부모에 +버튼이 나오고, X버튼이 등장하지만 모두 지울수는 없음	ex) <ListCtrl>의 <ListColumnType>
	CPGT_Choice,			//옵션버튼이 나온다						ex) <Size>의 <RelativeSize>와 <AbsoluteSize>
};

enum EControlPropertyItemType
{
	CPIT_None,
	CPIT_Boolean,
	CPIT_Integer,
	CPIT_String
};

enum EControlPropertyRestrictionType
{
	CPRT_None,
	CPRT_Integer,
	CPRT_String
};

enum ETextLinkType
{
	TLT_None,
	TLT_ServerItem,	//서버에 Request하거나 Cache에서 받아옴
	TLT_LocalItem,	//Client의 Item정보를 이용
	TLT_User,		//자동 귓속말
	TLT_SKill,		//Client의 Skill정보를 이용
	TLT_URL			//URL 링크 타입
};

enum EControlOrderWay
{
	COW_None,
	COW_Top,
	COW_Up,
	COW_Down,
	COW_Bottom,
};

enum EProgressBarType
{
	PBT_None,
	PBT_RightLeft,
	PBT_LeftRight,
	PBT_TopBottom,
	PBT_BottomTop,
};

enum ETextureAutoRotateType
{
	ETART_None,
	ETART_Camera,
	ETART_Pawn
};
enum EItemWindowType
{
	ITEMWNDTYPE_ScrollType,
	ITEMWNDTYPE_SideButtonType,
	ITEMWNDTYPE_UpDownButtonType
};
const EV_Test	= 10;
const EV_LoginOK	= 20;
const EV_LoginFail	= 30;
const EV_Restart	= 40;
const EV_Die	= 50;
const EV_CardKeyLogin	= 60;
const EV_RegenStatus	= 70;
const EV_RadarTransitionFinished	= 80;
const EV_ShortcutCommand	= 90;			// 스트링으로 커맨드를 실행한다.
const EV_ShortcutCommandSlot = 91;			// 번호로 단축키를 실행한다.
const EV_MagicSkillList	= 100;
const EV_SetRadarZoneCode	= 110;
const EV_RaidRecord	= 120;
const EV_ShowGuideWnd	= 130;
const EV_ShowScreenMessage	= 140;
const EV_ShowScreenNPCZoomMessage = 141;
const EV_GamingStateEnter	= 150;
const EV_GamingStateExit	= 160;
const EV_ServerAgeLimitChange	= 170;
const EV_UpdateUserInfo	= 180;
const EV_UpdateHP	= 190;
const EV_UpdateMaxHP	= 200;
const EV_UpdateMP	= 210;
const EV_UpdateMaxMP	= 220;
const EV_UpdateCP	= 230;
const EV_UpdateMaxCP	= 240;
const EV_UpdatePetInfo	= 250;
const EV_UpdateHennaInfo	= 260;
//const EV_InventoryItem	= 270;		//사용안함 2006.11.6 ttmayrin
const EV_ReceiveAttack	= 280;
const EV_ReceiveMagicSkillUse	= 290;
const EV_ReceiveTargetLevelDiff	= 300;
const EV_ShowReplayQuitDialogBox	= 310;
const EV_ClanInfo	= 320;
const EV_ClanInfoUpdate	= 330;
const EV_ClanMyAuth	= 340;
const EV_ClanAuthGradeList	= 350;
const EV_ClanCrestChange	= 360;
const EV_ClanAuth	= 370;
const EV_ClanAuthMember	= 380;
const EV_ClanSetAcademyMaster	= 390;	//todo : 지우자 - lpislhy
const EV_ClanAddMember	= 400;
const EV_ClanAddMemberMultiple	= 410;
const EV_ClanDeleteAllMember	= 420;
const EV_ClanMemberInfo	= 430;
const EV_ClanMemberInfoUpdate	= 440;
const EV_ClanDeleteMember	= 450;
const EV_ClanWarList	= 460;
const EV_ClanClearWarList	= 470;
const EV_ClanSubClanUpdated	= 480;
const EV_ClanSkillList	= 490;
const EV_ClanSkillListRenew	= 500;
const EV_MinFrameRateChanged	= 510;
const EV_PartyMemberChanged	= 520;
const EV_ShowPCCafeCouponUI	= 530;
const EV_ToggleShowPCCafeEventWnd= 531;
const EV_ChatMessage	= 540;
const EV_ChatWndStatusChange	= 550;
const EV_ChatWndSetString	= 560;
const EV_ChatWndSetFocus	= 570;
const EV_ChatWndMsnStatus	= 571;
const EV_ChatWndMacroCommand = 572;
const EV_SystemMessage	= 580;
const EV_JoypadLButtonDown	= 590;
const EV_JoypadLButtonUp	= 600;
const EV_JoypadRButtonDown	= 610;
const EV_JoypadRButtonUp	= 620;
const EV_ShortcutUpdate	= 630;
const EV_ShortcutPageUpdate	= 640;
const EV_ShortcutClear	= 650;
const EV_ShortcutJoypad	= 660;
const EV_ShortcutPageDown	= 670;
const EV_ShortcutPageUp	= 680;
const EV_ShowShortcutWnd	= 690;
const EV_ShortcutInit = 691;
const EV_ShortcutDataReceived = 692;
const EV_ShortcutKeyAssignChanged = 693;
const EV_QuestListStart	= 700;
const EV_QuestList	= 710;
const EV_QuestListEnd	= 720;
const EV_QuestSetCurrentID	= 730;
const EV_SSQStatus	= 740;
const EV_SSQMainEvent	= 750;
const EV_SSQSealStatus	= 760;
const EV_SSQPreInfo	= 770;
const EV_RecipeShowBuyListWnd	= 780;
const EV_RecipeShopSellItem	= 790;
const EV_RecipeShopItemInfo	= 800;
const EV_RecipeShowRecipeTreeWnd	= 810;
const EV_RecipeShowBookWnd	= 820;
const EV_RecipeAddBookItem	= 830;
const EV_RecipeItemMakeInfo	= 840;
const EV_RecipeShopShowWnd	= 850;
const EV_RecipeShopAddBookItem	= 860;
const EV_RecipeShopAddShopItem	= 870;
const EV_HeroShowList	= 880;
const EV_HeroRecord	= 890;
const EV_OlympiadTargetShow	= 900;
const EV_OlympiadMatchEnd	= 910;
const EV_OlympiadUserInfo	= 920;
const EV_OlympiadBuffShow	= 930;
const EV_OlympiadBuffInfo	= 940;
const EV_AbnormalStatusNormalItem	= 950;
const EV_AbnormalStatusEtcItem	= 960;
const EV_AbnormalStatusShortItem	= 970;
const EV_TargetUpdate	= 980;
const EV_TargetHideWindow	= 990;
const EV_ShowBuffIcon	= 1000;
const EV_PetWndShow	= 1010;
const EV_PetWndShowNameBtn	= 1020;
const EV_PetWndRegPetNameFailed	= 1030;
const EV_PetStatusShow	= 1040;
const EV_PetStatusSpelledList	= 1050;
const EV_PetInventoryItemStart	= 1060;
const EV_PetInventoryItemList	= 1070;
const EV_PetInventoryItemUpdate	= 1080;
const EV_SummonedWndShow	= 1090;
const EV_SummonedStatusShow	= 1100;
const EV_SummonedStatusSpelledList	= 1110;
const EV_SummonedStatusRemainTime	= 1120;
const EV_PetSummonedStatusClose	= 1130;
const EV_PartyAddParty	= 1140;
const EV_PartyUpdateParty	= 1150;
const EV_PartyDeleteParty	= 1160;
const EV_PartyDeleteAllParty	= 1170;
const EV_PartySpelledList	= 1180;
const EV_PartyRenameMember = 1181;
const EV_ShowBBS	= 1190;
const EV_ShowBoardPacket	= 1200;
const EV_ShowHelp	= 1210;
const EV_LoadHelpHtml	= 1220;
const EV_LoadPetitionHtml	= 1221;
const EV_MacroShowListWnd	= 1230;
const EV_MacroUpdate	= 1240;
const EV_MacroList	= 1250;
const EV_MacroShowEditWnd	= 1260;
const EV_MacroDeleted	= 1270;
const EV_SkillListStart	= 1280;
const EV_SkillList	= 1290;
const EV_ActionListStart	= 1300;
const EV_ActionList	= 1310;
const EV_ActionListNew = 1311;
const EV_ActionPetListStart	= 1320;
const EV_ActionPetList	= 1330;
const EV_ActionSummonedListStart	= 1340;
const EV_ActionSummonedList	= 1350;
const EV_CommandChannelStart	= 1360;
const EV_CommandChannelEnd	= 1370;
const EV_CommandChannelInfo	= 1380;
const EV_CommandChannelPartyList	= 1390;
const EV_CommandChannelPartyUpdate = 1395;
const EV_CommandChannelRoutingType	= 1400;
const EV_CommandChannelPartyMember	= 1420;
const EV_RestartMenuShow	= 1430;
const EV_RestartMenuHide	= 1440;
const EV_SiegeInfo	= 1450;
const EV_SiegeInfoClanListStart	= 1460;
const EV_SiegeInfoClanList	= 1470;
const EV_SiegeInfoClanListEnd	= 1480;
const EV_SiegeInfoSelectableTime	= 1490;
const EV_IMEStatusChange	= 1500;
const EV_ArriveNewTutorialQuestion	= 1510;
const EV_ArriveShowQuest	= 1520;
const EV_ArriveNewMail	= 1530;
const EV_PartyMatchStart	= 1540;
const EV_PartyMatchRoomStart	= 1550;
const EV_PartyMatchRoomClose	= 1560;
const EV_PartyMatchList	= 1570;
const EV_PartyMatchRoomMember	= 1580;
const EV_PartyMatchRoomMemberUpdate	= 1590;
const EV_PartyMatchChatMessage	= 1600;
const EV_PartyMatchWaitListStart	= 1610;
const EV_PartyMatchWaitList	= 1620;
const EV_PartyMatchCommand	= 1630;
const EV_HennaListWndShowHideEquip	= 1640;
const EV_HennaListWndAddHennaEquip	= 1650;
const EV_HennaInfoWndShowHideEquip	= 1660;
const EV_HennaListWndShowHideUnEquip	= 1670;
const EV_HennaListWndAddHennaUnEquip	= 1680;
const EV_HennaInfoWndShowHideUnEquip	= 1690;
const EV_CalculatorWndShowHide	= 1700;
const EV_DialogOK	= 1710;
const EV_DialogCancel	= 1720;

const EV_RadarAddTarget	= 1730;
const EV_RadarDeleteTarget	= 1740;
const EV_RadarDeleteAllTarget	= 1750;
const EV_RadarColor	= 1760;
const EV_ShowTownMap	= 1770;

const EV_ShowMinimap	= 1780;
const EV_MinimapAddTarget	= 1790;
const EV_MinimapDeleteTarget	= 1800;
const EV_MinimapDeleteAllTarget	= 1810;
const EV_MinimapShowQuest	= 1820;
const EV_MinimapHideQuest	= 1830;
const EV_MinimapChangeZone	= 1840;
const EV_MinimapCursedWeaponList	= 1850;
const EV_MinimapCursedWeaponLocation	= 1860;
//const EV_MinimapCursedWeaponTooltipShow = 1861;
//const EV_MinimapCursedWeaponTooltipHide = 1862;
const EV_MinimapShowReduceBtn	= 1870;
const EV_MinimapHideReduceBtn	= 1880;
const EV_MinimapUpdateGameTime	= 1890;

const EV_LanguageChanged	= 1900;
const EV_PCCafePointInfo	= 1910;
const EV_ShowPetitionWnd	= 1920;
const EV_ShowUserPetitionWnd	= 1921;
const EV_PetitionChatMessage	= 1930;
const EV_EnablePetitionFeedback	= 1940;
const EV_TradeStart	= 1950;
const EV_TradeAddItem	= 1960;
const EV_TradeDone	= 1970;
const EV_TradeOtherOK	= 1980;
const EV_TradeUpdateInventoryItem	= 1990;
const EV_TradeRequestStartExchange	= 2000;
const EV_SkillTrainListWndShow	= 2010;
const EV_SkillTrainListWndHide	= 2020;
const EV_SkillTrainListWndAddSkill	= 2030;
const EV_SkillTrainInfoWndShow	= 2040;
const EV_SkillTrainInfoWndHide	= 2050;
const EV_SkillTrainInfoWndAddExtendInfo	= 2060;

// 스킬 인챈트 관련 메세지 분리- lancelot 2007. 3. 21.(스킬 인챈트 관련 필요없어지는 이벤트들 09.1.9)
//const EV_SkillEnchantListWndShow			= 2061; 
//const EV_SkillEnchantListWndHide			= 2062;
//const EV_SkillEnchantListWndAddItem			= 2063;
const EV_SkillEnchantInfoWndShow			= 2064;
const EV_SkillEnchantInfoWndAddSkill		= 2065;
const EV_SkillEnchantInfoWndHide			= 2066;
const EV_SkillEnchantInfoWndAddExtendInfo	= 2067;


const EV_SetMaxCount	= 2070;
const EV_ShopOpenWindow	= 2080;
const EV_OnEndTransactionList = 2081;
const EV_ShopAddItem	= 2090;
const EV_WarehouseOpenWindow	= 2100;
const EV_WarehouseAddItem	= 2110;
const EV_WarehouseDeleteItem = 2111;
const EV_PrivateShopOpenWindow	= 2120;
const EV_PrivateShopAddItem	= 2130;
const EV_SelectDeliverClear	= 2140;
const EV_SelectDeliverAddName	= 2150;
const EV_DeliverOpenWindow	= 2160;
const EV_DeliverAddItem	= 2170;
const EV_ShowEventMatchGMWnd	= 2180;
const EV_EventMatchCreated	= 2190;
const EV_EventMatchDestroyed	= 2200;
const EV_EventMatchManage	= 2210;
const EV_EventMatchPartyLeader = 2211;
const EV_StartEventMatchObserver	= 2220;
const EV_EventMatchUpdateTeamName	= 2230;
const EV_EventMatchUpdateScore	= 2240;
const EV_EventMatchUpdateTeamInfo	= 2250;
const EV_EventMatchUpdateUserInfo	= 2260;
const EV_EventMatchGMMessage	= 2270;
const EV_ShowGMWnd	= 2280;
const EV_GMObservingUserInfoUpdate	= 2290;
const EV_GMObservingSkillListStart	= 2300;
const EV_GMObservingSkillList	= 2310;
const EV_GMObservingQuestListStart	= 2320;
const EV_GMObservingQuestList	= 2330;
const EV_GMObservingQuestListEnd	= 2340;
const EV_GMObservingQuestItem	= 2350;
const EV_GMObservingWarehouseItemListStart	= 2360;
const EV_GMObservingWarehouseItemList	= 2370;
const EV_GMObservingClan	= 2380;
const EV_GMObservingClanMemberStart	= 2390;
const EV_GMObservingClanMember	= 2400;
const EV_GMObservingInventoryAddItem = 2401;
const EV_GMObservingInventoryClear = 2402;
const EV_GMAddHennaInfo = 2403;
const EV_GMUpdateHennaInfo = 2404;
const EV_GMSnoop	= 2410;
const EV_BeginShowZoneTitleWnd	= 2420;
const EV_TutorialViewerWndShow	= 2430;
const EV_TutorialViewerWndHide	= 2440;
const EV_ObserverWndShow	= 2450;
const EV_ObserverWndHide	= 2460;

// fishviewport
const EV_FishViewportWndShow		= 2470;
const EV_FishViewportWndHide		= 2480;
const EV_FishViewportWndInit		= 2490;
const EV_FishRankEventButtonShow	= 250;
const EV_FishRankEventButtonHide	= 2510;
const EV_FishViewportWndInitFishStatus=2520;
const EV_FishViewportWndSetFishStatus=2521;
const EV_FishViewportWndFinalAction=2522;

const EV_MultiSellInfoListBegin		= 2530;
const EV_MultiSellResultItemInfo	= 2535;
const EV_MultiSellOutputItemInfo	= 2540;
const EV_MultiSellInputItemInfo	= 2550;
const EV_MultiSellInfoListEnd	= 2560;
const EV_InventoryClear	= 2570;
const EV_InventoryOpenWindow	= 2580;
const EV_InventoryHideWindow	= 2590;
const EV_InventoryAddItem	= 2600;
const EV_InventoryUpdateItem	= 2610;
const EV_InventoryItemListEnd	= 2620;
const EV_InventoryAddHennaInfo	= 2630;
const EV_InventoryToggleWindow = 2631;

// manor
const EV_ManorCropSellWndShow	= 2640;
const EV_ManorCropSellWndAddItem	= 2645;
const EV_ManorCropSellWndSetCropSell	= 2646;
const EV_ManorCropSellChangeWndShow	= 2647;
const EV_ManorCropSellChangeWndAddItem	= 2648;
const EV_ManorCropSellChangeWndSetCropNameAndRewardType	= 2649;

const EV_ManorInfoWndSeedShow		= 2650;
const EV_ManorInfoWndSeedAdd		= 2651;
const EV_ManorInfoWndCropShow		= 2652;
const EV_ManorInfoWndCropAdd		= 2653;
const EV_ManorInfoWndDefaultShow	= 2654;
const EV_ManorInfoWndDefaultAdd		= 2655;

const EV_ManorSeedInfoSettingWndShow		= 2656;
const EV_ManorSeedInfoSettingWndAddItem		= 2657;
const EV_ManorSeedInfoSettingWndAddItemEnd	= 2658;
const EV_ManorSeedInfoSettingWndChangeValue	= 2659;
const EV_ManorSeedInfoChangeWndShow			= 2660;
const EV_ManorCropInfoSettingWndShow		= 2665;
const EV_ManorCropInfoSettingWndAddItem		= 2666;
const EV_ManorCropInfoSettingWndAddItemEnd	= 2667;
const EV_ManorCropInfoSettingWndChangeValue	= 2668;
const EV_ManorCropInfoChangeWndShow			= 2670;

const EV_ManorShopWndOpen					= 2680;
const EV_ManorShopWndAddItem				= 2690;

const EV_ShowPlaySceneInterface=3000;	//solasys

const EV_DuelAskStart = 2700;
const EV_DuelReady = 2710;
const EV_DuelStart = 2720;
const EV_DuelEnd = 2730;
const EV_DuelUpdateUserInfo = 2740;
const EV_DuelEnemyRelation = 2750;
const EV_ShowRefineryInteface = 2760;
const EV_RefineryConfirmTargetItemResult = 2770;
const EV_RefineryConfirmRefinerItemResult = 2780;
const EV_RefineryConfirmGemStoneResult = 2790;
const EV_RefineryRefineResult = 2800;
const EV_ShowRefineryCancelInteface = 2810;
const EV_RefineryConfirmCancelItemResult = 2820;
const EV_RefineryRefineCancelResult = 2830;

//QuestListWnd
const EV_QuestInfoStart	= 2840;
const EV_QuestInfo = 2850;

//ItemEnchantWnd
const EV_EnchantShow		= 2860;
const EV_EnchantHide		= 2870;
const EV_EnchantItemList	= 2880;
const EV_EnchantResult		= 2890;

// 아이템 인첸트 Ver2, ttmayrin
const EV_EnchantPutTargetItemResult		= 2891;
const EV_EnchantPutSupportItemResult	= 2892;

// AttributeEnchant
const EV_AttributeEnchantItemShow	= 2893;
const EV_AttributeEnchantItemList	= 2894;
const EV_AttributeEnchantResult		= 2895;
const EV_RemoveAttributeEnchantWndShow = 2896;
const EV_RemoveAttributeEnchantItemData = 2897;
const EV_RemoveAttributeEnchantResult = 2898;

const EV_ResolutionChanged = 2900;

//Tracker
const EV_TrackerAttach						= 2920;
const EV_TrackerDetach						= 2930;

//UIEditor
const EV_EditorSetProperty					= 2940;
const EV_EditorUpdateProperty				= 2950;

//Tooltip
const EV_RequestTooltipInfo					= 2960;

// PC, NPC 정보 보내줌 - lancelot 2007. 2. 14.
const EV_NotifyObject						= 2970;
const EV_NotifyPartyMemberPosition			= 2971;

// Builder Minimap Travel Event - neverdie 2007. 3. 14.
const EV_MinimapTravel						= 2980;

const EV_MinimapRegionInfoBtnClick			= 2990;

const EV_TextLinkLButtonClick				= 3000;
const EV_TextLinkRButtonClick				= 3010;

// lobby
const EV_LobbyMenuButtonEnable				= 3020;
const EV_LobbyAddCharacterName				= 3021;
const EV_LobbyCharacterSelect				= 3022;
const EV_LobbyClearCharacterName			= 3023;
const EV_LobbyStartButtonClick				= 3024;
const EV_LobbyShowDialog					= 3025;
const EV_LobbyGetSelectedCharacterIndex		= 3026;

// solasys-동영상
const EV_ShowMoviePlayer					= 3030;
const EV_EndMoviePlayer						= 3040;

const EV_ITEM_AUCTION_INFO					= 3050;
const EV_ITEM_AUCTION_NEXT_INFO				= 3051;

// Mouse Over,Out
const EV_MouseOver							= 3060;
const EV_MouseOut							= 3070;

const EV_ShowWindow							= 3080;		// EV_ShowWindow Name="WindowName"

// solasys-동영상
const EV_ResizeMoviePlayer					= 3090;
const EV_FullScreenMoviePlayer				= 3100;

//for pet window, ttmayrin
const EV_PartySummonAdd						= 3110;
const EV_PartySummonUpdate					= 3120;
const EV_PartySummonDelete					= 3130;

// 영지정보관련
const EV_ShowCastleInfo						= 3140;
const EV_AddCastleInfo						= 3150;
const EV_ShowFortressInfo					= 3160;
const EV_AddFortressInfo					= 3170;
const EV_ShowAgitInfo						= 3180;
const EV_AddAgitInfo						= 3190;
const EV_ShowFortressSiegeInfo				= 3200;

const EV_ShowFortressMapInfo				= 3201;
const EV_FortressMapBarrackInfo				= 3202;

// Character Create
const EV_CharacterCreateSetClassDesc		= 3210;
const EV_CharacterCreateClearClassDesc		= 3220;
const EV_CharacterCreateClearSetupWnd		= 3230;
const EV_CharacterCreateClearWnd			= 3240;
const EV_CharacterCreateClearName			= 3250;
const EV_CharacterCreateEnableRotate		= 3260;

// NPC 대화창
const EV_NPCDialogWndShow					= 3270;
const EV_NPCDialogWndHide					= 3280;
const EV_NPCDialogWndLoadHtmlFromString		= 3290;

const EV_ItemDescWndShow					= 3300;
const EV_ItemDescWndLoadHtmlFromString		= 3310;
const EV_ItemDescWndSetWindowTitle			= 3320;
const EV_QuestIDWndLoadHtmlFromString		= 3321;
const EV_QuestHtmlWndLoadHtmlFromString		= 3322;
const EV_QuestHtmlWndShow					= 3323;
const EV_QuestHtmlWndHide					= 3324;

// XMas Seal
const EV_ToggleXMasSealWndShowHide			= 3330;
const EV_OpenDialogQuit						= 3340;
const EV_OpenDialogRestart					= 3350;

const EV_FinishRotate						= 3360;

// 지하 콜로세움 PVP
const EV_PVPMatchRecord						= 3370;
const EV_PVPMatchRecordEachUserInfo 		= 3380;
const EV_PVPMatchUserDie					= 3390;

const EV_ToggleDetailStatusWnd			= 3400;

const EV_StateChanged					= 3410;

//solasys-포그테스트
const EV_AirStateOn						= 3420;
const EV_AirStateOff					= 3430;

const EV_ShowChangeNicknameNColor		= 3440;
//Premium Service - UserBookMark .. by elsacred
const EV_BookMarkList						= 3450;
const EV_BookMarkShow						= 3451;

//Premium Service - PremiumItem .. by elsacred
const EV_PremiumItemAlarm					= 3460;
const EV_PremiumItemList					= 3461;

// 크라테큐브 - lancelot 2008. 6. 16.
const EV_CrataeCubeRecordBegin				= 3470;
const EV_CrataeCubeRecordItem				= 3480;
const EV_CrataeCubeRecordEnd				= 3490;
const EV_CrataeCubeRecordMyItem				= 3500;
const EV_CrataeCubeRecordRetire				= 3501;

// Reset Device - NeverDie
const EV_ResetDevice						= 3510;
const EV_ShowMiniGame1						= 3520;

// AirShip, ttmayrin
const EV_AirShipUpdate						= 3530;
const EV_AirShipState						= 3540;
const EV_AirShipAltitude					= 3541;
const EV_AirShipTeleportListStart			= 3542;
const EV_AirShipTeleportList				= 3543;

// AI-UI event
const EV_AITimer							= 3550;

const EV_BirthdayItemAlarm					= 3560;

// 영지전 - lancelot 2008. 8. 22.
const EV_ShowDominionWarJoinListStart		= 3570;
const EV_ShowDominionWarJoinListEnemyDominionInfo = 3571;
const EV_ShowDominionWarJoinListEnd			= 3572;

const EV_ResultJoinDominionWar				= 3580;
const EV_DominionInfoCnt					= 3590;
const EV_DominionInfo						= 3600;
const EV_DominionsOwnPos					= 3610;
const EV_DominionWarChannelSet				= 3620;
const EV_DominionWarStart					= 3630;
const EV_DominionWarEnd						= 3640;

// Cleft, ttmayrin
const EV_CleftListInfo						= 3690;
const EV_CleftListStart						= 3700;
const EV_CleftListAdd						= 3710;
const EV_CleftListRemove					= 3720;
const EV_CleftListClose						= 3730;
const EV_CleftStateTeam						= 3740;
const EV_CleftStatePlayer					= 3750;
const EV_CleftStateResult					= 3760;

// FlightTransform
const EV_FlightTransform					= 3800;
const EV_ReserveShortCut					= 3801;

// CharacterViewport
const EV_ChangeCharacterPawn				= 3810;

// Block 뒤집기, elsacred
const EV_BlockRemainTime					= 3820;
const EV_BlockListStart						= 3830;
const EV_BlockListAdd						= 3840;
const EV_BlockListRemove					= 3850;
const EV_BlockListClose						= 3860;
const EV_BlockListVote						= 3870;
const EV_BlockListTimeUpset					= 3880;
const EV_BlockStateTeam						= 3890;
const EV_BlockStatePlayer					= 3900;
const EV_BlockStateResult					= 3910;

// 연합매칭 - lancelot
const EV_MpccRoomInfo						= 4000;
const EV_ListMpccWaitingStart				= 4010;
const EV_ListMpccWaitingRoomInfo			= 4020;
const EV_DismissMpccRoom					= 4030;
const EV_ManageMpccRoomMember				= 4040;
const EV_MpccRoomMemberStart				= 4050;
const EV_MpccRoomMemberInfo					= 4060;
const EV_MpccRoomChatMessage				= 4070;
const EV_MpccPartyMasterList				= 4080;

// 활력 시스템 활력 포인트 - elsacred
const EV_VitalityPointInfo					= 4100;

// 시드(Seed) 주기(Phase) 정보 - elsacred
const EV_ShowSeedMapInfo					= 4200;

// PawnViewer
const EV_PawnViewerWndAddItem				= 4300;
const EV_PawnViewerWndAddHairMeshName		= 4320;
const EV_PawnViewerWndAddFaceTextureName	= 4330;
const EV_PawnViewerWndUpdateHairAccCoord	= 4340;

const EV_PawnViewerWndClearAnimList			= 4350;
const EV_PawnViewerWndAddAnimName			= 4360;

const EV_MSViewerWndAddSkill				= 4400;
const EV_MSViewerWndShow					= 4410;

// SceneEditor
const EV_SceneListUpdate					= 4500;
const EV_SceneDataUpdate					= 4510;
const EV_SceneDataSave						= 4520;
const EV_UpdateSceneTreeData				= 4530;
const EV_CurSceneIndexInit					= 4540;
const EV_SlideShow							= 4550;

//SkillEnchant Result
const EV_SkillEnchantResult					= 4600;

// 우편 시스템 - elsacred
const EV_Notice_Post_Arrived				= 4700;
const EV_StartReceivedPostList				= 4710;
const EV_AddReceivedPostList				= 4720;
const EV_EndReceivedPostList				= 4730;
const EV_ReplyReceivedPostStart				= 4740;
const EV_ReplyReceivedPostAddItem			= 4741;
const EV_ReplyReceivedPostEnd				= 4742;
const EV_StartSentPostList					= 4750;
const EV_AddSentPostList					= 4760;
const EV_EndSentPostList					= 4770;
const EV_ReplySentPostStart					= 4780;
const EV_ReplySentPostAddItem				= 4781;
const EV_ReplySentPostEnd					= 4782;
const EV_PostWriteOpen						= 4790;
const EV_PostWriteAddItem					= 4791;
const EV_PostWriteEnd						= 4792;
const EV_DeleteReceivedPost					= 4793;
const EV_OpenStateReceivedPost				= 4794;
const EV_ReceivedStateReceivedPost			= 4795;
const EV_DeleteSentPost						= 4796;
const EV_OpenStateSentPost					= 4797;
const EV_ReceivedStateSentPost				= 4798;
const EV_ReplyWritePost						= 4799;

// 진정 개선 - jin 2009.03.31.
const EV_ShowNewUserPetitionWnd				= 4800;
const EV_AddNewUserPetitionCategoryStepOne	= 4810;
const EV_ShowNewUserPetitionDescription		= 4820;
const EV_AddNewUserPetitionCategoryStepTwo	= 4830;
const EV_ShowNewUserPetitionContents		= 4840;
const EV_ShowNewUserPetitionHtml			= 4850;

//
const EV_ShowPrivateMarketList				= 4860;
const EV_AddPrivateMarketList				= 4861;

//
const EV_UsePartyMatchAction				= 4870;

const EV_EffectViewerAddEffect				= 4880; //add Effectitem to EffectViwer
const EV_EffectViewerShow					= 4881;	//show EffectViwer

// couple action - lancelot 2009. 10. 14.
const EV_ShowAskCoupleActionDialog			= 4900;

// For PartyLootingModfication system - jdh84 2009.10.20
const EV_AskPartyLootingModify		= 4910; //파티루팅변경을 물어옴
const EV_PartyLootingHasModified	= 4911; //파티루팅이 변경됨
const EV_MembershipType				= 4912; //멤버쉽상태를 알려줌
//      0: 무소속 1: 파티장 2: 파티원 3: 방장이면서 파티장 4: 방장
//      5:방에 입장한 파티원 6: 파티에 소속되지 않고 방에만 입장한 유저)
const EV_PartyHasDismissed			= 4913; //파티가 해체되었다는 메시지. 모든 파티원들에게
const EV_BecamePartyMember			= 4914; //파티의 멤버가됨
const EV_BecamePartyMaster			= 4915; //파티장이됨
const EV_OustPartyMember			= 4916; //파티에서 추방당함
const EV_WithdrawParty				= 4917; //파티에서 탈퇴함
const EV_HandOverPartyMaster        = 4918; //파티장을 양도함
const EV_RecvPartyMaster			= 4919; //파티장을 양도받음

//동맹문장등록 
const EV_CommandAddAllianceCrestFile	= 4920;

//branch - 아래에 지정되어 있다.
// For halloween event - lancelot 2009. 10. 7
//const EV_BR_EventHalloweenHelp		= 9100;
//const EV_BR_EventHalloweenShow		= 9101;
//const EV_BR_EventRankerNowList		= 9102;
//const EV_BR_EventRankerLastList		= 9103;
//end of branch

// For expand quest alarm - by jin
const EV_ExpandQuestAlarmKillMonster	= 4930;

// For new vote system = by jin
const EV_ReceiveNewVoteSystemInfo	= 4940;
const EV_ShowNewVoteSystemHelp		= 4941;

//#ifdef POSTEFFECT_EDIT
// For Controling PostEffect - by elsacred 2010.01.13
const EV_PostEffectShow = 4950;
//endif

//URL Link has clicked - jdh84 
const EV_UrlLinkClick = 4960;


const EV_ReceiveFriendList = 4970;	// 친구 목록 보내주는 event
const EV_ConfirmAddingPostFriend = 4980; // 추가 친구 추가 성공 여부 알려주는 event
const EV_ReceivePostFriendList = 4990;	// 추가 친구 목록 보내주는 event
const EV_ReceivePledgeMemberList = 5000; // 혈맹원 목록 보내주는 event
//#ifdef L2_WEATHER_SYSTEM
const EV_ShowWeatherWnd = 5010;
//#endif

const EV_ReplayRecStarted = 5020;
const EV_ReplayRecEnded = 5021;

const EV_EnterOlympiadObserverMode = 5030;

const EV_ListCtrlLoseSelected = 5040; //리스트컨트롤이 셀렉트를 취소할때 가는 이벤트

//#ifdef HDRRENDERING_EDIT
// For Controling HDR render - by sori
const EV_HDRRenderTestWndShow = 5050;
//#endif

const EV_SkillCancel = 5060;

const EV_SetEnterChatting = 5090;
const EV_UnSetEnterChatting = 5091;

// #ifdef CT26P2_0825
// 네비트 강림 관련 - 2010.7.7. winkey
const EV_NavitAdventPointInfo = 5100; 
const EV_NavitAdventEffect = 5110;
const EV_NavitAdventTimeChange = 5120;
// #endif


////////////////////////////////////////////////////////////////////////////
//branch !! Edited by Overseas Branch : Enyheid

const EV_BR_CashShopToggleWindow	= 9010;
const EV_BR_CashShopAddItem			= 9020;
const EV_BR_SetNewList				= 9021;
const EV_BR_ProductListEnd			= 9022;
const EV_BR_SetRecentProduct		= 9025;
const EV_BR_SetNewProductInfo		= 9030;
const EV_BR_AddEachProductInfo		= 9040;
const EV_BR_SETGAMEPOINT			= 9050;
const EV_BR_RESULT_BUY_PRODUCT		= 9060;
const EV_BR_SHOW_CONFIRM			= 9070;
const EV_BR_HIDE_CONFIRM			= 9071;
const EV_BR_PREMIUM_STATE			= 9080;
const EV_BR_FireEventStateInfo		= 9090;
const EV_BR_FireEventTimeInfo		= 9091;

// For halloween event - lancelot 2009. 10. 7
const EV_BR_EventHalloweenHelp		= 9100;
const EV_BR_EventHalloweenShow		= 9101;
const EV_BR_EventRankerNowList		= 9102;
const EV_BR_EventRankerLastList		= 9103;
const EV_BR_EventChristmasShow		= 9110;
const EV_BR_EventCommonHtml1		= 9111;
const EV_BR_EventCommonHtml2		= 9112;
const EV_BR_EventCommonHtml3		= 9113;
const EV_BR_MinigameMyRanking		= 9120;
const EV_BR_MinigameAllRanking		= 9121;
const EV_BR_EventValentineShow		= 9130;
const EV_BR_Die_EnableNPC			= 9140;

// TTP #42287 NPC 자가 부활 아이템 버튼을 Disable 해야 할 때도 있습니다. - gorillazin 10.10.15.
const EV_BR_RestartByNPCButtonEnable = 9150;
//

//end of branch !! Edited by Overseas Branch : Enyheid
////////////////////////////////////////////////////////////////////////////

// NEW_GOODS_INVENTORY : 상품 인벤토리 - 2010.11.3 winkey
const EV_ShowGoodsInventoryWnd		= 5130;
const EV_GoodsInventoryItemList		= 5131;
const EV_GoodsInventoryItemDesc		= 5132;
const EV_GoodsInventoryNoti			= 5133;
const EV_GoodsInventoryError		= 5134;		// 사용안함, 삭제 예정
const EV_GoodsInventoryResult		= 5135;

// SECONDARY_AUTH : 2차 비밀번호 - 2010.11.6 winkey
const EV_SecondaryAuthCreate		= 5140;
const EV_SecondaryAuthVerify		= 5141;
const EV_SecondaryAuthBlocked		= 5142;
const EV_SecondaryAuthSuccess		= 5143;
const EV_SecondaryAuthCreateFail	= 5144;
const EV_SecondaryAuthVerifyFail	= 5145;
const EV_SecondaryAuthFailEtc		= 5146;



enum EEventMatchObsMsgType
{
	MESSAGE_GM,
	MESSAGE_Finish,
	MESSAGE_Start,
	MESSAGE_GameOver,
	MESSAGE_1,
	MESSAGE_2,
	MESSAGE_3,
	MESSAGE_4,
	MESSAGE_5,
};

enum ETextAlign
{
	TA_Undefined,
	TA_Left, 
	TA_Center,
	TA_Right,
	TA_MacroIcon,
};

enum ETextVAlign
{
	TVA_Undefined,
	TVA_Top, 
	TVA_Middle,
	TVA_Bottom,
};
  
enum ETextureCtrlType
{
	TCT_Stretch,
	TCT_Normal,
	TCT_Tile,
	TCT_Draggable,
	TCT_Control,	//툴팁을 표시할 수 있다
	TCT_Mask,
};
 
enum ETextureLayer
{
	TL_None,
	TL_Normal,
	TL_Background,	
};

enum ENameCtrlType
{
	NCT_Normal,
	NCT_Item
};

enum EItemType
{
	ITEM_WEAPON, 
	ITEM_ARMOR, 
	ITEM_ACCESSARY, 	
	ITEM_QUESTITEM, 
	ITEM_ASSET, 
	ITEM_ETCITEM
};

enum EItemParamType
{
	ITEMP_WEAPON,
	ITEMP_ARMOR,
	ITEMP_SHIELD,
	ITEMP_ACCESSARY, 
	ITEMP_ETC,
};

enum EEtcItemType
{
	ITEME_NONE,
	ITEME_SCROLL,
	ITEME_ARROW,
	ITEME_POTION,
	ITEME_SPELLBOOK,
	ITEME_RECIPE,
	ITEME_MATERIAL,
	ITEME_PET_COLLAR,
	ITEME_CASTLE_GUARD,
	ITEME_DYE,
	ITEME_SEED,
	ITEME_SEED2,
	ITEME_HARVEST,
	ITEME_LOTTO,
	ITEME_RACE_TICKET,
	ITEME_TICKET_OF_LORD,
	ITEME_LURE,
	ITEME_CROP,
	ITEME_MATURECROP,
	ITEME_ENCHT_WP,
	ITEME_ENCHT_AM,
	ITEME_BLESS_ENCHT_WP,
	ITEME_BLESS_ENCHT_AM,
	ITEME_COUPON,
	ITEME_ELIXIR,
	ITEME_ENCHT_ATTR,	//CT26P3 - gorillazin
//#ifdef L2_KAMAEL
//solasys
	ITEME_BOLT,
//#endif	

//#ifdef CT26P3
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP,
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM,

	//branch: 러시아 캐시 아이템을 위해 추가
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM,			
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP,			
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM,	
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP,
	ITEME_ENCHT_ATTR_RUNE,
	ITEME_ENCHT_ATTRT_RUNE_SELECT,
	//end of branch

	ITEME_TELEPORTBOOKMARK,
//#endif //CT26P3 - gorillazin
};

enum ESkillCategory
{
	SKILL_Active,
	SKILL_Passive,
};

enum EActionCategory
{
	ACTION_NONE,
	ACTION_BASIC,
	ACTION_PARTY,
	ACTION_SOCIAL,
	ACTION_PET,
	ACTION_SUMMON,
};

enum EXMLTreeNodeItemType
{
	XTNITEM_BLANK,
	XTNITEM_TEXT,
	XTNITEM_TEXTURE,
};

enum EServerAgeLimit
{
	SERVER_AGE_LIMIT_15,
	SERVER_AGE_LIMIT_18,
	SERVER_AGE_LIMIT_Free,
};

enum EInterfaceSoundType
{
	IFST_CLICK1,
	IFST_CLICK2,
	IFST_CLICK_FAILED,
	IFST_PICKUP,
	IFST_TRASH_BASKET,
	IFST_WINDOW_OPEN,
	IFST_WINDOW_CLOSE,
	IFST_QUEST_TUTORIAL,
	IFST_MINIMAP_OPEN_CLOSE,
	IFST_COOLTIME_END,
	IFST_PETITION,
	IFST_STATUSWND_OPEN,
	IFST_STATUSWND_CLOSE,
	IFST_INVENWND_OPEN,
	IFST_INVENWND_CLOSE,
	IFST_MAPWND_OPEN,
	IFST_MAPWND_CLOSE,
	IFST_SYSTEMWND_OPEN,
	IFST_SYSTEMWND_CLOSE,
};

enum EChatType
{
	CHAT_NORMAL,
	CHAT_SHOUT,		// '!'
	CHAT_TELL,		// '\'
	CHAT_PARTY,		// '#'
	CHAT_CLAN,		// '@'
	CHAT_SYSTEM,		// ''
	CHAT_USER_PET,	// '&'
	CHAT_GM_PET,		// '*'
	CHAT_MARKET,		// '+'
	CHAT_ALLIANCE,	// '%'	
	CHAT_ANNOUNCE,	// ''
	CHAT_CUSTOM,		// ''
	CHAT_L2_FRIEND,	// ''
	CHAT_MSN_CHAT,	// ''
	CHAT_PARTY_ROOM_CHAT,	// ''		14
	CHAT_COMMANDER_CHAT,				// 15
	CHAT_INTER_PARTYMASTER_CHAT,
	CHAT_HERO,
	CHAT_CRITICAL_ANNOUNCE,
	CHAT_SCREEN_ANNOUNCE,
	CHAT_DOMINIONWAR,					// 20
	CHAT_MPCC_ROOM,
	CHAT_NPC_NORMAL,		// NPC 대사 필터링 - 2010.9.8 winkey
	CHAT_NPC_SHOUT
};

enum ESystemMsgType
{
	SYSTEM_NONE,
	SYSTEM_BATTLE,
	SYSTEM_SERVER,
	SYSTEM_DAMAGE,
	SYSTEM_POPUP,
	SYSTEM_ERROR,
	SYSTEM_PETITION,
	SYSTEM_USEITEMS,
};

enum ESystemMsgParamType
{
	SMPT_STRING,
	SMPT_NUMBER,
	SMPT_NPCID,
	SMPT_ITEMID,
	SMPT_SKILLID,
	SMPT_CASTLEID,
	SMPT_BIGNUMBER,
	SMPT_ZONENAME,
};

enum EMoveType
{
	MVT_NONE,
    MVT_SLOW,
    MVT_FAST,
};

enum EEnvType
{
	ET_NONE,
	ET_GROUND,
	ET_UNDERWATER,
	ET_AIR,
	ET_HOVER,
};

enum EControlReturnType
{
	CRTT_NO_CONTROL_USE,
	CRTT_CONTROL_USE,
	CRTT_USE_AND_HIDE,
};

enum EShortCutItemType
{
	SCIT_NONE,
	SCIT_ITEM,
	SCIT_SKILL,
	SCIT_ACTION,
	SCIT_MACRO,
	SCIT_RECIPE,
	SCIT_BOOKMARK,
};

enum EInventoryUpdateType
{
	IVUT_NONE,
	IVUT_ADD,
	IVUT_UPDATE,
	IVUT_DELETE,
};

enum ERestartPointType
{
	RPT_VILLAGE,
	RPT_AGIT,
	RPT_CASTLE,
	RPT_FORTRESS,
	RPT_BATTLE_CAMP,
	RPT_ORIGINAL_PLACE,
	//branch
	RPT_VILLAGE_BY_DISMOUNT		// 0303 국내 버전에서 누락되어서 추가. 다음 merge에서 확인 필요
	//RPT_BRANCH_START=20,			// 아래로 이동
	//RPT_AGATHION,
	//RPT_NPC
	//end of branch
};

//branch : ERestartPointType에 들어가야 하지만 uc는 enum에 숫자를 부여할 수 없어서 이렇게...
const RPT_BRANCH_START=20;
const RPT_AGATHION=21;
const RPT_NPC=22;
//end of branch

enum ECastleSiegeDefenderType
{
	CSDT_NOT_DEFENDER,
	CSDT_CASTLE_OWNER,
	CSDT_WAITING_CONFIRM,
	CSDT_APPROVED,
	CSDT_REJECTED,
};

enum ETooltipSourceType
{
	NTST_TEXT,
	NTST_ITEM,
	NTST_LIST,
};

//enum EtcSkillAcquireType
const	ESTT_NORMAL=0;
const	ESTT_FISHING=1;	// 낚시
const	ESTT_CLAN=2;		// 혈맹
const 	ESTT_SUB_CLAN=3;	// 하위 혈맹 스킬
const	ESTT_TRANSFORM=4;		// 변신 스킬
const	ESTT_SUBJOB=5;		// CT1.5
const	ESTT_COLLECT=6;		// CT2 Final
const	ESTT_BISHOP_SHARING=7;		// CT2.5 Skill Sharing	
const	ESTT_ELDER_SHARING=8;		// CT2.5 Skill Sharing	
const	ESTT_SILEN_ELDER_SHARING=9;			// CT2.5 Skill Sharing

// 이거말고 UIScript.uc에 있는 GetMaxLevel() 함수 써주세요 - lancelot 2007. 11. 13.
//const	MAX_Level = 80;

const	CLAN_AUTH_VIEW = 1;
const	CLAN_AUTH_EDIT = 2;

const	CLAN_MAIN = 0;
const	CLAN_KNIGHT1 = 100;
const	CLAN_KNIGHT2 = 200;
const	CLAN_KNIGHT3 = 1001;
const	CLAN_KNIGHT4 = 1002;
const	CLAN_KNIGHT5 = 2001;
const	CLAN_KNIGHT6 = 2002;
const	CLAN_ACADEMY = -1;

const	CLAN_KNIGHTHOOD_COUNT = 8;

const	CLAN_AUTH_GRADE1 = 1;
const	CLAN_AUTH_GRADE2 = 2;
const	CLAN_AUTH_GRADE3 = 3;
const	CLAN_AUTH_GRADE4 = 4;
const	CLAN_AUTH_GRADE5=5;
const	CLAN_AUTH_GRADE6=6;
const	CLAN_AUTH_GRADE7=7;
const	CLAN_AUTH_GRADE8=8;
const	CLAN_AUTH_GRADE9=9;

//struct native constructive
struct native ItemID
{
	var int ClassID;
	var int ServerID;
};

const MAX_RELATED_QUEST = 10;
//branch
const MAX_INCLUDE_ITEM = 10;
//end of branch

//struct native constructive
struct native ItemInfo
{
	var ItemID Id;
	var string Name;
	var string AdditionalName;
	var string IconName;
	var string IconNameEx1;
	var string IconNameEx2;
	var string IconNameEx3;
	var string IconNameEx4;
	var string ForeTexture;
	var string Description;
	var string DragSrcName;
	var string IconPanel;
	var int DragSrcReserved;
	var string MacroCommand;
	var int ItemType;
	var int ItemSubType;
	var INT64 ItemNum;
	var INT64 Price;
	var int Level;
	var int SlotBitType;
	var int Weight;
	var int MaterialType;
	var int WeaponType;
	var int PhysicalDamage;
	var int MagicalDamage;
	var int PhysicalDefense;
	var int MagicalDefense;
	var int ShieldDefense;
	var int ShieldDefenseRate;
	var int Durability; 
	var int CrystalType;
	var int RandomDamage;
	var int Critical;
	var int HitModify;
	var int AttackSpeed;
	var int MpConsume;
	var int ArmorType;
	var int AvoidModify;
	var int Damaged;
	var int Enchanted;
	var int MpBonus;
	var int SoulshotCount;
	var int SpiritshotCount;
	var int PopMsgNum;
	var int BodyPart;
	var int RefineryOp1;
	var int RefineryOp2;
	var int CurrentDurability;
	var int CurrentPeriod;
	// [칠월칠석, 방어구 각인] item enchant option - by jin 09/08/05
	var int EnchantOption1;
	var int EnchantOption2;
	var int EnchantOption3;
	//
	var int Reserved;
	var INT64 Reserved64;
	var INT64 DefaultPrice;
	var int ConsumeType;
	var int Blessed;
	var INT64 AllItemCount;
	var int IconIndex;
	var bool bEquipped;
	var bool bRecipe;  
	var bool bArrow; 
	var bool bShowCount;
	var bool bDisabled;
	var bool bIsLock;
	var int AttackAttributeType;		// 속성 - lancelot 2007. 4.27.
	var int AttackAttributeValue;
	var int DefenseAttributeValueFire;
	var int DefenseAttributeValueWater;
	var int DefenseAttributeValueWind;
	var int DefenseAttributeValueEarth;
	var int DefenseAttributeValueHoly;
 	var int DefenseAttributeValueUnholy;
	var int RelatedQuestID[MAX_RELATED_QUEST];
	//branch
	var int IsBRPremium;
	var int IncludeItem[MAX_INCLUDE_ITEM];
	var int BR_CurrentEnergy;
	var int BR_MaxEnergy;
	//end of branch

	// 서버로 부터 받은 아이템의 인벤토리에서의 순서를 저장 - gorillazin 11.02.18.
	var int Order;
};

//struct native constructive
struct native LVTexture
{
	var texture objTex;
	var int		X;
	var int		Y;
	var int		Width;
	var int		Height;
	var int		U;
	var int		V;
	var int		UL;
	var int		VL;
};

//struct native constructive
struct native LVData
{
	var bool hasIcon;//텍스쳐와 스트링을 동시에 사용. 텍스쳐는 아이콘처럼 사용
	var int nsortPrior;

	var string szData;
	var string szReserved;

	var bool bUseTextColor;
	var Color TextColor;

	var int nReserved1;
	var int nReserved2;
	var int nReserved3;
	
	//Main Texture(텍스쳐 하나만 설정할때, Centeralign된다)
	var string szTexture;
	var int nTextureWidth;
	var int nTextureHeight;
	
	//Texture Array
	var array<LVTexture> arrTexture;
};

//struct native constructive
struct native LVDataRecord
{	
	var array<LVData> LVDataList;
	var string szReserved;
	var INT64 nReserved1;
	var INT64 nReserved2;
	var INT64 nReserved3;
};

//struct native constructive
struct native UserInfo
{
	var int nID;
	var string Name;
	var string strNickName;
	var string RealName;
	var int nSex;
	var int Class;
	var int nLevel;
	var int nClassID;
	var int nSubClass;
	var int nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var int nCurCP;
	var int nMaxCP;
	var INT64 nCurExp;
	
	var int nUserRank;
	var int nClanID;
	var int nAllianceID;
	var int nCarryWeight;
	var int nCarringWeight;
	
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nPhysicalAvoid;
	var int nWaterMaxSpeed;
	var int nWaterMinSpeed;
	var int nAirMaxSpeed;
	var int nAirMinSpeed;
	var int nGroundMaxSpeed;
	var int nGroundMinSpeed;
	var float fNonAttackSpeedModifier;
	var int nMagicCastingSpeed;
	
	var int nStr;
	var int nDex;
	var int nCon;
	var int nInt;
	var int nWit;
	var int nMen;
	
	var int nCriminalRate;
	var int nDualCount;
	var int nPKCount;
	var int nSociality;
	var int nRemainSulffrage;
	
	var bool bHero;
	var bool bNobless;
	var bool bNpc;
	var bool bPet;
	var bool bCanBeAttacked;
	
	var vector Loc;

	// 캐릭터 속성 - lancelot 2007. 5. 18.
	var int AttrAttackType;
	var int AttrAttackValue;
	var int AttrDefenseValFire;
	var int AttrDefenseValWater;
	var int AttrDefenseValWind;
	var int AttrDefenseValEarth;
	var int AttrDefenseValHoly;
	var int AttrDefenseValUnholy;
	
	// 변신
	var int nTransformID;
	var bool m_bPawnChanged;
	
	//Inven Item Order, ttmayrin
	var int nInvenLimit;

	// 2008/03/05 PvP Point Restrain - NeverDie
	var int PvPPointRestrain;

	// 2008/03/05 PvP Point - NeverDie
	var int PvPPoint;

	var color NicknameColor;

	var int nVitality;

	// Decoy - anima
	var int nMasterID;

	// 2008/8/4 Talisman Num
	var int nTalismanNum;
	// 2008/8/7 FullArmor Check
	var int nFullArmor;

	var int JoinedDominionID;		// lancelot 2008. 8. 28.
	var bool WantHideName;
	var int DominionIDForVirtualName;
	
	// EXP percent rate - 2010/05/19 sori
	var float fExpPercentRate;
};

//struct native constructive
struct native SkillInfo
{
	var String SkillName;
	var String SkillDesc;
	var int SkillID;
	var int SkillLevel;
	var int OperateType;	// 0 - A1 이상상태를 걸지 않는 액티브 스킬, 1 - A2 이상상태를 거는 액티브 스킬, 2 - P 패시브 스킬, 3 - T 토글 스킬 	
	var int MpConsume;
	var int HpConsume;
	var int CastRange;
	var int CastStyle;
	var float HitTime;
	var bool IsUsed;
	var int IsMagic;
	var String AnimName;
	var String SkillPresetName;
	var String TexName;
	var String IconPanel;
	var int	IconType;		// Skill 그룹핑
	var bool IsDebuff;
	var String EnchantName;
	var String EnchantDesc;
	var int Enchanted;
	var int EnchantSkillLevel;
	var String EnchantIcon;
	var int RumbleSelf;
	var int RumbleTarget;
};

//struct native constructive
struct native PetInfo
{
	var int nID;
	var string Name;
	var int nLevel;
	var int nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var INT64 nCurExp;
	var INT64 nMaxExp;
	var INT64 nMinExp;
	
	var int nCarryWeight;
	var int nCarringWeight;
	
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nPhysicalAvoid;
	var int nMovingSpeed;
	var int nMagicCastingSpeed;
	var int nSoulShotCosume;
	var int nSpiritShotConsume;
	
	var int nFatigue;
	var int nMaxFatigue;
	var bool bIsPetOrSummoned;
	var int nEvolutionID;
};

//struct native constructive
struct native MacroInfo
{
	var int		Id;
	var string	Name;
	var string	IconName;
	var string	IconTextureName;
	var string	Description;
	var string	CommandList[12];
};

struct native Rect
{
	var int nX;
	var int nY;
	var int nWidth;
	var int nHeight;
};

//struct native constructive
struct native ClanMemberInfo
{
	var	int	clanType;
	var	string	sName;
	var	int	Level;
	var	int	ClassID;
	var	int	gender;
	var	int	Race;
	var	int	Id;
	var	int	bHaveMaster;
};

//struct native constructive
struct native ClanInfo
{
	var array<ClanMemberInfo>	m_array;
	var string					m_sName;
	var string					m_sMasterName;
};

struct native ResolutionInfo
{
	var int nWidth;
	var int nHeight;
	var int nColorBit;
};

//struct native constructive
struct native FileNameInfo
{
	var string fileName;
	var bool bIsFile;
};
//struct native constructive
struct native DriveInfo
{
	var string driveChar;
};
enum EDrawItemType
{
	DIT_BLANK,
	DIT_TEXT,
	DIT_TEXTURE,
	DIT_SPLITLINE,
	//branch
	DIT_TEXTLINK,
	//end of branch
};

//struct native constructive
struct native DrawItemInfo
{
	var EDrawItemType eType;
	
	var int		nOffSetX;
	var int		nOffSetY;
	var bool	bLineBreak;
	
	//For BLANK
	var int		b_nHeight;
	
	//For TEXT
	var int		t_ID;
	var string	t_strText;
	var color	t_color;
	var bool	t_bDrawOneLine;
	//branch : one line이 아닐 때 text width를 설정할 수 있게
	var int		t_MaxWidth;
	
	//For TEXTURE
	var int		u_nTextureWidth;
	var int		u_nTextureHeight;
	var int		u_nTextureUWidth;
	var int		u_nTextureUHeight;
	var string	u_strTexture;
	
	//For Dynamic Text
	var string Condition;
};

//struct native constructive
struct native CustomTooltip
{
	var int MinimumWidth;
	var int SimpleLineCount;
	var Array<DrawItemInfo> DrawList;
};

//struct native constructive
struct native XMLTreeNodeItemInfo
{
	var EXMLTreeNodeItemType eType;
	
	var int		nOffSetX;
	var int		nOffSetY;
	var bool	bLineBreak;
	var bool	bStopMouseFocus;
	
	//For E_XMLTREE_NODEITEM_BLANK
	var int		b_nHeight;
	
	//For E_XMLTREE_NODEITEM_TEXT
	var int		t_nTextID;
	var string	t_strText;
	var color	t_color;
	var bool	t_bDrawOneLine;

	var ETextVAlign t_vAlign;
	var int		t_nMaxHeight;
	var	int		t_nMaxWidth;
	
	//For E_XMLTREE_NODEITEM_TEXTURE
	var int		u_nTextureWidth;
	var int		u_nTextureHeight;
	var int		u_nTextureUWidth;
	var int		u_nTextureUHeight;
	var string	u_strTexture;
	var string	u_strTextureMouseOn;
	var string	u_strTextureExpanded;

	//Reserved
	var int		nReserved;	
	var int		nReserved2;	
};

//struct native constructive
struct native XMLTreeNodeInfo
{
	var string	strName;
	
	var int		nOffSetX;
	var int		nOffSetY;
	
	var int		bDrawBackground;
	
	//For Back Texture
	var int		bTexBackHighlight;
	var int		nTexBackHighlightHeight;
	var int		nTexBackWidth;
	var int		nTexBackUWidth;
	var int		nTexBackOffSetX;
	var int		nTexBackOffSetY;
	var int		nTexBackOffSetBottom;
	
	//Expanded Texture
	var string	strTexExpandedLeft;
	var string	strTexExpandedRight;
	var int		nTexExpandedOffSetX;
	var int		nTexExpandedOffSetY;
	var int		nTexExpandedHeight;
	var int		nTexExpandedRightWidth;
	var int		nTexExpandedLeftUWidth;
	var int		nTexExpandedLeftUHeight;
	var int		nTexExpandedRightUWidth;
	var int		nTexExpandedRightUHeight;
	
	//For Tree Expand Button
	var int		bShowButton;
	var int		nTexBtnWidth;
	var int		nTexBtnHeight;
	var int		nTexBtnOffSetX;
	var int		nTexBtnOffSetY;
	var string	strTexBtnExpand;
	var string	strTexBtnCollapse;
	var string	strTexBtnExpand_Over;
	var string	strTexBtnCollapse_Over;
	
	//For Tooltip
	var CustomTooltip ToolTip;
	var bool bFollowCursor;
};

//struct native constructive
struct native StatusIconInfo
{
	var int		ServerID;
	var string	Name;
	var string	IconName;
	var int		Size;
	var string	Description;
	var string  BackTex;

	var int		RemainTime;
	var ItemID	Id;
	var int		Level;
	
	var bool	bShow;
	var bool	bShortItem;
	var bool	bEtcItem;
	var bool	bDeBuff;
};

//struct native constructive
struct native GameTipData
{
	var int Id;
	var int Priority;
	var int TargetLevel;
	var bool Validity;
	var String TipMsg;
};

//struct native constructive
struct native HennaInfo
{
	var int HennaID;
	var int ClassID; 
	var int Num;
	var int Fee;
	var int CanUse;
	var int INTnow;
	var int INTchange;
	var int STRnow;
	var int STRchange;
	var int CONnow;
	var int CONchange;
	var int MENnow;
	var int MENchange;
	var int DEXnow;
	var int DEXchange;
	var int WITnow;
	var int WITchange;
};

//struct native constructive
struct native EventMatchUserData
{
	var int UserID;
	var String UserName;
	var int HPNow;
	var int HPMax;
	var int MPNow;
	var int MPMax;
	var int CPNow;
	var int CPMax;
	var int UserLv;
	var int UserClass;
	var int UserGender;
	var int UserRace;
	var Array<int> BuffIDList;
	var Array<int> BuffRemainList;
};

// lancelot 2006. 10. 11.
//struct native constructive
struct native SystemMsgData
{
	var String Group;
	var Color FontColor;
	var String Sound;
	var String Voice;
	var int WindowType;
	var int FontType;
	var int LifeTime;
	var int AnimationType;
	var int BackgroundType;
	var String SysMsg;
	var String OnScrMsg;
};


//struct native constructive
struct native EventMatchTeamData
{
	var int Score;
	var String TeamName;
	var int PartyMemberCount;
	var EventMatchUserData User[ MAX_PartyMemberCount ];
};

//struct native constructive
struct native ShortcutCommandItem
{
	var string sCommand;
	var string Key;
	var string subkey1;
	var string subkey2;
	var string sState;
	var string sCategory;
	var string sAction;
	var int		id;
};

//struct native constructive
struct native ShortcutScriptData
{
	var int id;
	var string sCommand;
	var int sysString;
	var int sysMsg;
};

struct native EventMatchData
{
	var EventMatchTeamData Team[ 2 ];
};

//struct native constructive
struct native RequestItem
{
	var int id;
	var INT64 amount;
};

native function ExecuteEvent( int a_EventID, optional string a_Param );

//Param
native function ParamAdd( out string strParam, string strName, string strValue );
native function ParamAddINT64( out string strParam, string strName, INT64 sValue );
native function bool ParseString( string a_strCmd, string a_strMatch, out string a_strResult );
native function bool ParseInt( string a_strCmd, string a_strMatch, out int a_Result );
native function bool ParseINT64( string a_strCmd, string a_strMatch, out INT64 a_Result );
native function bool ParseFloat( string a_strCmd, string a_strMatch, out float a_Result );

native function RegisterEvent( int ev);
native function RegisterState(string WindowName, string state);
native function SetUIState(string State);
native function MessageBox(string Msg);
native function SMessageBox(int SystemMsgNum);
native function string GetUIState();
defaultproperties
{
}

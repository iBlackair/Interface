class UIScript extends UIEventManager
	//dynamicrecompile
	native;

var WindowHandle m_hOwnerWnd;
var bool m_bCreated;
	
// Console State
native function bool IsPKMode();

// Client To Server API
native function RequestExit();
native function RequestAuthCardKeyLogin( int uid, string value);
native function RequestSelfTarget();
native function RequestTargetCancel();
native function RequestSkillList();
native function RequestRaidRecord();
native function RequestTradeDone( bool bDone );
native function RequestStartTrade( int targetID );
native function RequestAddTradeItem( ItemID sID, INT64 num );
native function AnswerTradeRequest( bool bOK );
native function RequestSellItem( string param );
native function RequestBuyItem( string param );

native function RequestBuySeed( string param );
//native function RequestProcureCrop( string param );
native function RequestSetSeed( string param );
native function RequestSetCrop( string param );

native function RequestAttack( int ServerID, vector Loc );
native function RequestAction( int ServerID, vector Loc );
native function RequestAssist( int ServerID, vector Loc );
native function RequestTargetUser( int ServerID );
native function RequestWarehouseDeposit( string param );
native function RequestWarehouseWithdraw( string param );
native function RequestChangePetName( string Name );
native function RequestPackageSendableItemList( int targetID );
native function RequestPackageSend( string param );
native function RequestPreviewItem( string param );
native function RequestBBSBoard();
native function RequestMultiSellChoose( string param );
native function RequestRestartPoint( ERestartPointType Type );
//#ifdef BRANCH_MERGE
//branch
//native function RequestRestartPoint( ERestartPointType Type , optional int NpcItem ); //branch - NpcItem 추가
native function BR_RequestRestartPoint( int Type , optional int NpcItem ); //branch버전 유지 때문에 변수타입을 달리 할 수 밖에 없음. enum 통합 후 삭제한다.
//end of branch
//#endif
native function RequestUseItem( ItemID sID );
native function RequestDestroyItem( ItemID sID, INT64 num );
native function RequestDropItem( ItemID sID, INT64 num, Vector location );
native function RequestUnequipItem( ItemID sID, int slotBitType );
native function RequestCrystallizeItem( ItemID sID, INT64 number );
native function RequestItemList();		// Ivnetory Item request
native function RequestDuelStart( string sTargetName, int duelType );				// 결투 신청
native function RequestDuelAnswerStart( int duelType, int option, int answer );		// 결투 신청에 대한 응답. option은 결투 수락 가능 옵션의 값. 0 이면 answer는 더미.
native function RequestDuelSurrender();												// 현재 진행 중인 결투에서 항복(패배 인정).
native function RequestDispel(int ServerID, ItemID sID, int SkillLevel);							// 버프 삭제 요청

// PrivateShop
native function RequestQuitPrivateShop(string type);			// type : "sell", "buy", "sellList", "buyList"	 PrivateShopWnd.uc 참조
native function SendPrivateShopList(string type, string param);

// Party
native function int GetPartyMemberCount();
native function bool GetPartyMemberLocation( int a_PartyMemberIndex, out Vector a_Location );
native function bool GetPartyMemberLocationWithID( int a_PartyMemberSID, out Vector a_Location );


// clan
native function RequestClanMemberInfo( int type, string name );
native function RequestClanGradeList();
native function RequestClanChangeGrade( string sName, int grade );
native function RequestClanAssignPupil( string sMaster, string sPupil );
native function RequestClanDeletePupil( string sMaster, string sPupil );
native function RequestClanLeave(string ClanName, int clanType);
native function RequestClanExpelMember( int clanType, string sName );
native function RequestClanAskJoin( int ID, int clanType );
native function RequestClanDeclareWar();								// 혈맹 이름 입력창이 뜨고 거기서 이름을 넣는다
native function RequestClanDeclareWarWithUserID( int ID );				// 유저의 ID로 그 유저의 혈맹에 전쟁 선포
native function RequestClanDeclareWarWithClanName( string sName );		// 혈맹 이름으로 전쟁 선포
native function RequestClanWithdrawWar();								// 혈맹 이름 입력창이 뜨고 거기서 이름을 넣는다
native function RequestClanWithdrawWarWithClanName( string sClanName );
native function RequestClanReorganizeMember( int type, string memberName, int clanType, string targetMemberName );

native function bool RequestClanRegisterCrestByFilePath(string FilePath); //혈맹문장등록
native function RequestClanRegisterCrest();
native function RequestClanUnregisterCrest();
native function bool RequestClanRegisterEmblemByFilePath(string FilePath); //혈맹휘장등록
native function RequestClanRegisterEmblem();
native function RequestClanUnregisterEmblem();
//To register alliance crest file
native function bool RequestAllianceRegisterCrestByFilePath(string FilePath); //동맹문장등록

native function RequestClanChangeNickName( string sName, string sNickName );
native function RequestClanWarList( int page, int state );						// state 0:선포 1: 피선포
native function RequestClanAuth( int gradeID );
native function RequestEditClanAuth( int gradeID, array<int> powers );
native function RequestClanMemberAuth( int clanType, string sName );

native function RequestPCCafeCouponUse( string a_CouponKey );

native function string GetCastleName( int castleID );

native function bool	HasClanCrest();			// 혈맹 문장을 가지고 있는지를 리턴
native function bool	HasClanEmblem();		// 혈맹 휘장을 가지고 있는지를 리턴

native function RequestInviteParty( string sName );
native function RequestInviteMpcc( string Name);

// ClassInfo
native final function string GetClassType( int ClassID ); 
native final function string GetClassStr( int ClassID ); 
native function string GetClassIconName( int classID );

// UserInfo
native function bool GetPlayerInfo( out UserInfo a_UserInfo );
native function bool GetTargetInfo( out UserInfo a_UserInfo );
native function bool GetUserInfo( int userID, out UserInfo a_UserInfo );
native function bool GetPetInfo( out PetInfo a_PetInfo );
native function bool GetSkillInfo( int a_SkillID, int a_SkillLevel, out SkillInfo a_SkillInfo );
native function bool GetAccessoryItemID( out ItemID a_LEar, out ItemID a_REar, out ItemID a_LFinger, out ItemID a_RFinger );
native function int GetDecoIndex(ItemID DecoID);
native function int GetClassStep( int a_ClassID );
native function bool IsBuilderPC();

native function string GetClanName( int clanID );
native final function int GetClanNameValue(int iClanID);			// 혈맹 명성치 얻어온다

native final function INT64 GetAdena();								// 현재 인벤토리에 갖고 있는 아데나 카운트를 리턴
native final function int GetTeleportBookMarkCount();				// 현재 인벤토리에 갖고 있는 북마크 아이템 카운트를 리턴
//#ifdef BRANCH_MERGE
//branch
native final function int GetTeleportFlagCount();				// 현재 인벤토리에 갖고 있는 북마크 아이템 카운트를 리턴
//end of branch
//#endif
// Util API
native final function string MakeBuffTimeStr( int Time );
native final function string MakeTimeStr( int Time );
native final function string GetTimeString();
native final function string ConvertTimetoStr( int Time );
native final function Debug( string strMsg );
native final function bool IsKeyDown( EInputKey Key );
native final function string GetSystemString(int id);
native final function string GetSystemMessage(int id);
native final function GetSystemMsgInfo(int id, out SystemMsgData SysMsgData);		// lancelot 2006. 10. 11.
native final function string GetSystemMessageWithParamNumber(int id, int param);

native final function UIScript GetScript( string window );
native final function string MakeFullSystemMsg( string sMsg, string sArg1, optional string sArg2 );

native final function GetTextSizeDefault( string strInput, out int nWidth, out int nHeight);
native final function GetTextSize( string strInput, string sFontName, out int nWidth, out int nHeight);
native final function string DivideStringWithWidth(string strInput, int nWidth);
native final function string NextStringWithWidth(int nWidth);

native final function string MakeFullItemName(int id);
native final function string GetItemGradeString(int nCrystalType);
native final function string GetItemGradeTextureName( int nCrystalType );
native final function string MakeCostStringINT64( INT64 a_Input );
native final function string MakeCostString( string strInput );
native final function string ConvertNumToText( string strInput );
native final function string ConvertNumToTextNoAdena( string strInput );
// time(초)를 24시간 이상은 일로, 1시간 이상은 시간으로 1시간 미만은 분으로 반환하는 함수 
native final function string ConvertTimeToString(float time);	
native final function color GetNumericColor( string strCommaAdena );
native final function PlayConsoleSound(EInterfaceSoundType eType);
native final function EIMEType GetCurrentIMELang();
native final function texture GetPledgeCrestTexFromPledgeCrestID( int PledgeCrestID );
native final function texture GetAllianceCrestTexFromAllianceCrestID( int AllianceCrestID );
native final function RequestBypassToServer( string strPass );
native final function String GetUserRankString( int Rank );
native final function String GetRoutingString( int RoutingType );
native final function bool IsDebuff( ItemID cID, int SkillLevel );
native final function bool IsSongDance( ItemID cID, int SkillLevel );
native final function bool IsTriggerSkill( ItemID cID, int SkillLevel );
native final function bool CheckItemLimit( ItemID cID, INT64 Count );
native function Vector GetClickLocation();

native final function GetCurrentResolution(out int ScreenWidth, out int ScreenHeight);
native final function int GetMaxLevel();

//Chat Prefix
native function string GetChatPrefix(EChatType type);
native function bool IsSameChatPrefix(EChatType type, string InputPrefix);

// PrivateStore
native function SetPrivateShopMessage( string type, string message );		// type : "buy" or "sell"
native function string GetPrivateShopMessage( string type );				// type : "buy" or "sell"

//System Message
native final function AddSystemMessage( int Index );
native final function AddSystemMessageString(string msg);
native final function AddSystemMessageParam( string strParam );
native final function string EndSystemMessageParam( int MsgNum, bool bGetMsg );

//Restart & Quit
native final function ExecRestart();
native final function ExecQuit();

//About Server
native final function EServerAgeLimit GetServerAgeLimit();
native final function int GetServerNo();
native final function int GetServerType();

// Option API
native final function bool CanUseAudio();
native final function bool CanUseJoystick();
native final function bool CanUseHDR();
native final function bool IsEnableEngSelection();
native final function bool IsUseKeyCrypt();
native final function bool IsCheckKeyCrypt();
native final function bool IsEnableKeyCrypt();
native final function ELanguageType GetLanguage();
native final function GetResolutionList( out Array<ResolutionInfo> a_ResolutionList );
native final function GetRefreshRateList( out Array<int> a_RefreshRateList, optional int a_nWidth, optional int a_nHeight );
native final function SetResolution( int a_nResolutionIndex, int a_nRefreshRateIndex );
native final function int GetMultiSample();
native final function int GetResolutionIndex();
native final function GetShaderVersion( out int a_nPixelShaderVersion, out int a_nVertexShaderVersion );
native final function SetDefaultPosition();
native final function SetKeyCrypt( bool a_bOnOff );
native final function SetTextureDetail( int a_nTextureDetail );
native final function SetModelingDetail( int a_nModelingDetail );
native final function SetMotionDetail( int a_nMotionDetail );
native final function SetShadow( bool a_bShadow );
native final function SetBackgroundEffect( bool a_bBackgroundEffect );
native final function SetTerrainClippingRange( int a_nTerrainClippingRange );
native final function SetPawnClippingRange( int a_nPawnClippingRange );
native final function SetReflectionEffect( int a_nReflectionEffect );
native final function SetHDR( int a_nHDR );
native final function SetWeatherEffect( int a_nWeatherEffect );
native final function SetL2Shader( bool a_bShader);
native final function SetDOF( bool a_bDof);
native final function SetDepthBufferShadow( bool a_bShadow);
native final function SetShaderWaterEffect( bool a_bWater);
native final function SetRenderCharacterCount(int a_NewLimitAcotor);	// 옵션에서 "캐릭터 표시제한"셋팅 - lancelot 2007. 11. 15.
native final function SetIgnorePartyInviting(bool a_bIgnore);
native final function SetFixedDefaultCamera(bool a_bFixed);

// Common API
native final function ExecuteCommand( String a_strCmd );
native final function ExecuteCommandFromAction( String strCmd );
native final function DoAction( ItemID cID );
native final function UseSkill( ItemID cID, int itemSubType );
native final function bool IsStackableItem( int consumeType );
native final function StopMacro();

// Option API
native final function SetOptionBool( string a_strSection, string a_strName, bool a_bValue );
native final function SetOptionInt( string a_strSection, string a_strName, int a_nValue );
native final function SetOptionFloat( string a_strSection, string a_strName, float a_fValue );
native final function SetOptionString( string a_strSection, string a_strName, string a_strValue );
native final function bool GetOptionBool( string a_strSection, string a_strName );
native final function int GetOptionInt( string a_strSection, string a_strName );
native final function float GetOptionFloat( string a_strSection, string a_strName );
native final function string GetOptionString( string a_strSection, string a_strName );

// Inventory Item API
native final function INT64 GetInventoryItemCount( ItemID cID );
native final function string GetSlotTypeString( int ItemType, int SlotBitType, int ArmorType );
native final function string GetWeaponTypeString( int WeaponType );
native final function int GetPhysicalDamage( int WeaponType, int SlotBitType, int CrystalType, int Enchanted, int PhysicalDamage );
native final function int GetMagicalDamage( int WeaponType, int SlotBitType, int CrystalType, int Enchanted, int MagicalDamage );
native final function string GetAttackSpeedString( int AttackSpeed );
native final function int GetShieldDefense( int CrystalType, int Enchanted, int ShieldDefense );
native final function int GetPhysicalDefense( int CrystalType, int Enchanted, int PhysicalDefense );
native final function int GetMagicalDefense( int CrystalType, int Enchanted, int MagicalDefense );
native final function bool IsMagicalArmor( ItemID cID );
native final function string GetLottoString( int Enchanted, int Damaged);
native final function string GetRaceTicketString( int Blessed );
native final function RequestSaveInventoryOrder( array<ItemID> a_IDList, array<int> a_OrderList );

// INI file option
native final function RefreshINI( String a_INIFileName );
native final function bool GetINIBool( string section, string key, out int value, string file );
native final function bool GetINIInt( string section, string key, out int value, string file );
native final function bool GetINIFloat( string section, string key, out float value, string file );
native final function bool GetINIString( string section, string key, out string value, string file );

native final function SetINIBool( string section, string key, bool value, string file );
native final function SetINIInt( string section, string key, int value, string file );
native final function SetINIFloat( string section, string key, float value, string file );
native final function SetINIString( string section, string key, string value, string file );

// Constant API
native final function bool GetConstantInt( int a_nID, out int a_nValue );
native final function bool GetConstantString( int a_nID, out String a_strValue );
native final function bool GetConstantBool( int a_nID, out int a_bValue );
native final function bool GetConstantFloat( int a_nID, out float a_fValue );

// Audio API
native final function SetSoundVolume( float a_fVolume );
native final function SetMusicVolume( float a_fVolume );
native final function SetWavVoiceVolume( float a_fVolume );
native final function SetOggVoiceVolume( float a_fVolume );

// Tooltip API
native final function ReturnTooltipInfo( CustomTooltip Info );

// TextLink API
native final function SetItemTextLink( ItemID a_ID, String a_ItemName );

// Default Events
event OnLoad();
event OnTick();
event OnShow();
event OnHide();
event OnEvent( int a_EventID, String a_Param );
event OnEventWithParamMap(int a_EventID, ParamMap a_ParamMap);
event OnTimer( int TimerID );
event OnMinimize();
event OnEnterState( name a_PreStateName );
event OnExitState( name a_NextStateName );
event OnSendPacketWhenHiding();
//event OnFrameExpandClick( bool bIsExpand );
event OnDefaultPosition();

event OnDrawerShowFinished();
event OnDrawerHideFinished();

// state
event OnRegisterEvent();

// Keyboard events
event OnKeyDown( WindowHandle a_WindowHandle, EInputKey Key );
event OnKeyUp( WindowHandle a_WindowHandle, EInputKey Key );

// Mouse events
event OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y );
event OnLButtonUp( WindowHandle a_WindowHandle, int X, int Y );
event OnLButtonDblClick( WindowHandle a_WindowHandle, int X, int Y );
event OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y );
event OnRButtonUp( WindowHandle a_WindowHandle, int X, int Y );
event OnRButtonDblClick( WindowHandle a_WindowHandle, int X, int Y );
event OnMButtonDown( WindowHandle a_WindowHandle, int X, int Y );
event OnMButtonUp( WindowHandle a_WindowHandle, int X, int Y );
event OnMouseOver( WindowHandle a_WindowHandle );
event OnMouseOut( WindowHandle a_WindowHandle );
event OnMouseMove( WindowHandle a_WindowHandle, int X, int Y );

// Drag&Drop event
event OnDropItem( String strID, ItemInfo infItem, int x, int y );
event OnDragItemStart( String strID, ItemInfo infItem );
event OnDragItemEnd( String strID );
event OnDropItemSource( String strTarget, ItemInfo infItem );				// 아이템을 드랍했을 경우 드래그를 시작한 윈도우에 불린다.
event OnDropItemWithHandle( WindowHandle hTarget, ItemInfo infItem, int x, int y );
event OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y );	// 윈도우를 드랍했을 경우

// Button,Tab events
event OnClickButton( String strID );
event OnClickButtonWithHandle( ButtonHandle a_ButtonHandle );
event OnButtonTimer( bool bExpired );
event OnTabSplit( string sName );										// 탭윈도우에서 윈도우가 분리될때 보내진다.
event OnTabMerge( string sName );										// 탭윈도우에서 윈도우가 분리되었다가 합쳐질 때 보내진다.

// Editbox events
event OnCompleteEditBox( String strID );
event OnChangeEditBox( String strID );
event OnChatMarkedEditBox( String strID );

// ListCtrl events
event OnClickListCtrlRecord( String strID );
event OnDBClickListCtrlRecord( String strID );

// ListBox events
event OnDBClickListBoxItem( String strID, int SelectedIndex );
event OnRButtonClickListBoxItem( String strID, int SelectedIndex );

// check box events
event OnClickCheckBox( String strID );

// ItemWnd event
event OnClickItem( String strID, int index );
event OnDBClickItem( String strID, int index );
event OnRClickItem( String strID, int index );
event OnRDBClickItem( String strID, int index );
event OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int a_Index );
event OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int a_Index );
event OnSelectItemWithHandle( ItemWindowHandle a_hItemWindow, int a_Index );

// ProgressCtrl
event OnProgressTimeUp( String strID );

// combobox event
event OnComboBoxItemSelected( String strID, int index );

// AnimTexture event
event OnTextureAnimEnd( AnimTextureHandle a_AnimTextureHandle );

// PropertyController
event OnPropertyControllerResize( int a_Height );

// Html ctrl
event OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle);

// FlashCtrl event
event OnFlashCtrlMsg(FlashCtrlHandle a_FlashCtrlHandle, String a_Param);

// API for MainWnd. This is temporary measure
//native final function SetTabStatusWnd(int x, int y);	2006.8 ttmayrin
//native final function SetTabSkillWnd(int x, int y);	2006.9.27 ttmayrin
//native final function SetTabActionWnd(int x, int y);	2006.9.27 ttmayrin
//native final function SetTabQuestWnd(int x, int y);	2006.7 ttmayrin

native final function ProcessChatMessage( string chatMessage, int type, optional bool bStopMacro );

// Petition Chat - NeverDie 2006/07/18
native final function ProcessPetitionChatMessage( string a_strChatMsg );

// PartyMatch Chat - NeverDie 2006/07/04
native final function ProcessPartyMatchChatMessage(EChatType ChatType, string a_strChatMsg );

// CommandChannel Chat - ttmayrin 2006/10/10
native final function ProcessCommandChatMessage( string a_strChatMsg );
native final function ProcessCommandInterPartyChatMessage( string a_strChatMsg );

// Sound API for MenuWnd - lancelot 2006. 5. 10.
native final function PlaySound( String strSoundName);
native final function StopSound( String a_SoundName );

// MenuWnd API - lancelot 2006. 5. 11.
native final function RequestOpenMinimap();

// Slider control - lancelot 2006. 6. 13.
event OnModifyCurrentTickSliderCtrl(String strID, int iCurrentTick);

// Returns zone name with given zone ID - NeverDie 2006/06/26
native final function string GetZoneNameWithZoneID( int a_ZoneID );
native final function string GetCurrentZoneName();
native final function int GetCurrentZoneID();

// same function but using for inzone - jdh84
native final function string GetInZoneNameWithZoneID(int inzoneID);

// Returns looting method name with given looting method ID - NeverDie 2006/06/26
native final function string GetLootingMethodName( int a_LootingMethodID );
 
// Henna - lancelot 2006 .6. 29.
native final function RequestHennaItemInfo(int iHennaID);	// 문양새기기 윈도에서 염료 클릭했을때 염료정보 요청
native final function RequestHennaItemList();				// 문양새기기 - 염료정보 윈도에서 "<이전" 버튼 클릭시 이전화면으로
native final function RequestHennaEquip(int iHennaID);				// 문양새기기 - 염료정보 윈도에서 "확인" 버튼 클릭시 문신요청

native final function RequestHennaUnEquipInfo(int iHennaID);	// 문양지우기 윈도에서 문신 클릭했을때 문신정보 요청
native final function RequestHennaUnEquipList();				// 문양 지우기 윈도에서 "<이전"버튼 눌렀을때
native final function RequestHennaUnEquip(int iHennaID);		// 문양 지우기 윈도에서 "확인"버튼 눌렀을때

native final function SetChatMessage( String a_Message, optional bool IsAppend );

native final function Actor GetPlayerActor();
native final function Vector GetPlayerPosition();
native final function Actor GetCharacterSelectionActor(int a_CharIndex);

// Replay - lancelot 2006. 7. 10.
native final function GetFileList(out Array<string> FileList, string strDir, string strExtention);
native final function GetDirList(out Array<string> DirList, string strDir);
native final function BeginReplay(string strFileName, bool bLoadCameraInst, bool bLoadChatData);
native final function EraseReplayFile(string strFileName);
// BenchMark- lancelot 2006. 7. 18.
native final function BeginPlay();
native final function BeginBenchMark();

// Skill Train - lancelot 2006. 8. 1.
// 스킬 목록창에서 스킬 정보요청
native final function RequestAcquireSkillInfo(int iID, int iLevel, int iType);
// 스킬정보 창에서 스킬 배우기 요청
native final function RequestAcquireSkill(int iID, int iLevel, int iType);
native final function RequestAcquireSkillSubClan(int iID, int iLevel, int iType, int iSubClan);

//인챈트 정보 요청
native final function RequestExEnchantSkillInfo(int iID, int iLevel);
//인챈트 세부정보 요청
native final function RequestExEnchantSkillInfoDetail(int type, int iID, int iLevel);
// 인챈트 요청
native final function RequestExEnchantSkill(int type, int iID, int iLevel);

// ObserverMode
native final function RequestObserverModeEnd();

native final function WindowHandle GetHandle( String a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID );	//Not used anymore
native final function WindowHandle FindHandle( String a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID );	//For UIEditor, ttmayrin

native final function AnimTextureHandle GetAnimTextureHandle( String a_ControlID );
native final function BarHandle GetBarHandle( String a_ControlID );
native final function ButtonHandle GetButtonHandle( String a_ControlID );
native final function ChatWindowHandle GetChatWindowHandle( String a_ControlID );
native final function CheckBoxHandle GetCheckBoxHandle( String a_ControlID );
native final function ComboBoxHandle GetComboBoxHandle( String a_ControlID );
native final function DrawPanelHandle GetDrawPanelHandle( String a_ControlID );
native final function EditBoxHandle GetEditBoxHandle( String a_ControlID );
native final function MultiEditBoxHandle GetMultiEditBoxHandle( String a_ControlID );
native final function HtmlHandle GetHtmlHandle( String a_ControlID );
native final function ItemWindowHandle GetItemWindowHandle( String a_ControlID );
native final function ListBoxHandle GetListBoxHandle( String a_ControlID );
native final function ListCtrlHandle GetListCtrlHandle( String a_ControlID );
native final function MinimapCtrlHandle GetMinimapCtrlHandle( String a_ControlID );
native final function NameCtrlHandle GetNameCtrlHandle( String a_ControlID );
native final function ProgressCtrlHandle GetProgressCtrlHandle( String a_ControlID );
native final function PropertyControllerHandle GetPropertyControllerHandle( String a_ControlID );
native final function RadarMapCtrlHandle GetRadarMapCtrlHandle( String a_ControlID );
native final function SliderCtrlHandle GetSliderCtrlHandle( String a_ControlID );
native final function StatusBarHandle GetStatusBarHandle( String a_ControlID );
native final function StatusIconHandle GetStatusIconHandle( String a_ControlID );
native final function TabHandle GetTabHandle( String a_ControlID );
native final function TextBoxHandle GetTextBoxHandle( String a_ControlID );
native final function TextListBoxHandle GetTextListBoxHandle( String a_ControlID );
native final function TextureHandle GetTextureHandle( String a_ControlID );
native final function TreeHandle GetTreeHandle( String a_ControlID );
native final function VideoPlayerCtrlHandle GetVideoPlayerCtrlHandle( String a_ControlID );
native final function WindowHandle GetWindowHandle( String a_ControlID );
native final function CharacterViewportWindowHandle GetCharacterViewportWindowHandle( String a_ControlID );
native final function SceneCameraCtrlHandle GetSceneCameraCtrlHandle( String a_ControlID );
native final function SceneCameraCtrlHandle GetSceneNpcCtrlHandle( String a_ControlID );
native final function SceneCameraCtrlHandle GetScenePcCtrlHandle( String a_ControlID );
native final function SceneCameraCtrlHandle GetSceneScreenCtrlHandle( String a_ControlID );
native final function SceneCameraCtrlHandle GetSceneMusicCtrlHandle( String a_ControlID );

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// FishViewport
native final function RequestFishRanking();
native final function InitFishViewportWnd(bool Event);
native final function FishFinalAction();

//manor
native final function RequestProcureCropList(string param);
native final function int GetManorCount();
native final function int GetManorIDInManorList(int index);
native final function string GetManorNameInManorList(int index);

native final function ToggleMsnWindow();

// minimap
native final function bool GetQuestLocation(Vector Location);

// LoginMenuWnd
native final function ShowMessageInLogin(string Message);
native final function InitCreditState();

//////////////////////////////////////////////////////////////////////////////////////////////////
// UIEdit
native final function String GetInterfaceDir();
native final function String GetXMLControlString( EXMLControlType type );
native final function EXMLControlType GetXMLControlIndex( String type );
native final function ShowVirtualWindowBackground( bool bShow );
native final function ShowExampleAnimation( bool bShow );

//Tracker
native final function GetTrackerAttachedWindowList( array<WindowHandle> a_WindowList );
native final function WindowHandle GetTrackerAttachedWindow();
native final function ClearTracker();
native final function DeleteAttachedWindow();
native final function ExecuteAlign( ETrackerAlignType Type );
native final function ShowEnableTrackerBox( bool bShow );

// Lobby
native final function CreateNewCharacter();
native final function GotoLogin();
native final function StartGame(int SelectedCharacter);
native final function RequestCharacterSelect(int index);
native function bool GetSelectedCharacterInfo(int index, out UserInfo a_UserInfo);
native final function RequestRestoreCharacter(int index);
native final function RequestDeleteCharacter(int index);
native final function ResetCharacterPosition();
native function bool IsScheduledToDeleteCharacter(int index);
native function bool IsDisciplineCharacter(int index);
native final function SetSelectedCharacter(int index);

// CharacterCreate
native final function RequestCreateCharacter(string Name, int Race, int Job, int Sex, int HairType, int HairColor, int FaceType);
native final function RequestPrevState();
native final function SetDefaultCharacter();

native final function ClearDefaultCharacterInfo();
native final function SpawnDefaultCharacter(int index);
native final function ShowAllDefaultCharacter();
native final function SetCurrentMakingRace(int race);
native final function ExecLobbyEvent(string EventName, optional bool bReverse);
native function string GetClassDescription(int index);
native final function ShowOnlyOneDefaultCharacter(int index);
native final function SetCharacterStyle(int index, int HairType, int HairColor, int FaceType);
native final function DefaultCharacterTurn(int index, float Ratio);
native final function DefaultCharacterStop(int index);
native function bool CheckNameLength(string Name);
native function bool CheckValidName(string Name);
native function int CharacterCreateGetClassType(int Race, int Job, int sex);

// 영지정보관련
native final function RequestAllCastleInfo();
native final function RequestAllFortressInfo();
native final function RequestAllAgitInfo();
native final function RequestFortressSiegeInfo();
native final function RequestFortressMapInfo(int FortressID);

// 지하콜로세움PVP 관련
native final function RequestPVPMatchRecord();


native final function int ChatNotificationFilter( out string message, string keyword0, string keyword1, string keyword2 );

// 닉네임&닉컬러 변경
native final function RequestChangeNicknameNColor(int ColorIndex, string Nickname, ItemID ID);
native final function int GetMaxNicknameColorIndexCnt();
native final function color GetNicknameColorWithIndex(int ColorIndex);

// Premium Item 
native final function RequestWithDrawPremiumItem(int index, INT64 amount);

// Cratae cube - lancelot 2008. 6. 16.
native final function RequestStartShowCrataeCubeRank();
native final function RequestStopShowCrataeCubeRank();

// 영지전 - lancelot 2008. 8. 22.
native final function RequestJoinDominionWar(int DominionID, int Clan, int Join, int JoinID);
native final function RequestDominionInfo();
native final function texture GetDominionFlagIconTex(int DominionID);

// lancelto 2008. 8. 23.
native final function color GetChatColorByType(int type);

// 재매입 추가 - jin 2009.03.18
native function RequestRefundItem( string param );

// 우편 시스템 추가 - elsacred 09.03.19
native final function RequestSendPost(string receivedPerson, int safeMail, string title, string contents, array<RequestItem> itemIDList, INT64 adena);
native final function RequestRequestReceivedPostList();
native final function RequestDeleteReceivedPost(array<int> deleteMailList);
native final function RequestRequestReceivedPost(int mailID);
native final function RequestReceivePost(int mailID);
native final function RequestRejectPost(int mailID);
native final function RequestRequestSentPostList();
native final function RequestDeleteSentPost(array<int> deleteMailList);
native final function RequestRequestSentPost(int mailID);
native final function RequestCancelSentPost(int mailID);
native final function RequestPostItemList();

// 진정 개선 - jin 2009.03.30.
native final function RequestShowNewUserPetition();
native final function RequestShowStepTwo(int categoryId);
native final function RequestShowStepThree(int categoryId);
native final function bool GetUseNewPetitionBool();

// 재매입 통합 - by jin 2009.05.11
native final function RequestBuySellUIClose();
native final function string GetGameStateName();

// For halloween event - lancelot 2009. 10. 7
native function RequestBR_EventRankerList(int iEventID, int iDay, int iRanking); //branch sr : HalloweenEvent

// Weather Editor Tool - by elsacred 2009.07.31
//#ifdef L2_WEATHER_SYSTEM
native final function RequestCreateRainEffect(int imode, int iEmitterposition);
native final function RequestDeleteRainEffect();
native final function RequestSetWeatherEffect(int itype);
native final function RequestSetRainWeight(float fmul);
native final function RequestSetRainEmitterParticleNum(float fmul);
native final function RequestSetRainSpeed(float fmul);
native final function RequestSetRainMeshScale(vector mul);

native final function RequestCreateSnowEffect(int imode, int iEmitterposition);
native final function RequestDeleteSnowEffect();
native final function RequestSetSnowWeight(float fmul);
native final function RequestSetSnowEmitterParticleNum(float fmul);
native final function RequestSetSnowSpeed(float fmul);
native final function RequestSetSnowMeshScale(vector mul);

native final function RequestChangeParticleEmitter(string emitterName);
native final function RequestChangeDiamondMesh(string meshName);
//#endif
// [private market] - by jin 2009.08.18.
native final function ClearAllPrivateMarketInfo();
native final function RefreshPrivateMarketInfo();
native final function RequestMoveToMerchant(int merchantId);

// To access file system for getting file list. jdh84 2009. 10.13
native final function array<FileNameInfo> GetFilesInfoList(string filePath, array<string> arrFilExt);
native final function array<DriveInfo> GetDrivesInfoList();

// couple action - lancelot 2009. 10. 14.
native final function AnswerCoupleAction(int ActionID, int bOk, int requestUserID);

// To get Special directory path -jdh84. 2009.10.19
native final function string GetMydocumentPath(); 
native final function string GetDesktopPath();
native final function string GetMyComputerPath(); //작동안됨
// This is for font testing
//native final function int FontGetLineGap();
//native final function FontSetLineGap( int gap );

//To Modify party looting scheme
native final function RequestPartyLootingModify(int scheme);
native final function RequestPartyLootingModifyAgreement(int agree);

//To know my membership type
native final function RequestAskMemberShip();

native final function RequestAddExpandQuestAlarm(int questId);

native final function RadioButtonHandle GetRadioButtonHandle( String a_ControlID );

// To Make webpage linkage - jdh84. 2010. 1. 4
native final function OpenGivenURL( String URL);
native final function OpenL2Home();

// For YCbCr Effect - elsacred 2010.1.13
//#ifdef POSTEFFECT_EDIT
native final function RequestSetYCbCrConversionEffect(bool enable);
native final function RequestSetYCbCrVal(float fixCbCr, int playType, float yCOR1, float cbCOR1, float crCOR1, float yCOR2, float cbCOR2, float crCOR2, float YCbCrConsumingTime);

native final function RequestSetHSVConversionEffect(bool enable);
native final function RequestSetHSVVal(float fixHS, int playType, float hCOR1, float sCOR1, float vCOR1, float hCOR2, float sCOR2, float vCOR2, float HSVConsumingTime);

native final function RequestSetRGBConversionEffect(bool enable);
native final function RequestSetRGBVal(int playType, float rCOR1, float gCOR1, float bCOR1, float rCOR2, float gCOR2, float bCOR2, float RGBConsumingTime);
native final function RequestSetPostEffect(bool enable, int postEffectID);
//#endif
native final function RequestPartyMatchWaitList(int a_Page, int a_MinLevel, int a_MaxLevel, int role, String Name);


//For motion blur - jdh84
native final function SetMotionBlurUse(bool bIsUse);
native final function SetMotionBlurAlpha(byte alphavalue);

//toggle recording
native final function ToggleReplayRec();

// For NPC Zoom Camera mode
native final function RequestFinishNPCZoomCamera();

// For HDR Render effect
native final function SetHDRRenderVal(float FinalCoef, float GrayLum, float ClampMin, float ClampMax);
native final function SetUseHDRRenderEffect(bool UseHDREffect);

//#ifdef BRANCH_MERGE
//////////////////////////////////////////////////////////////////////////////////////////////////
//branch !! Edited by Overseas Branch : Enyheid

// CashShop API : 
native function RequestBR_GamePoint();		// Cash Item for Russia request
native function RequestBR_ProductList();		// Cash Item for Russia request
native function RequestBR_ProductInfo(int iProductID);
native function RequestBR_BuyProduct(int iProductID, int iAmount);
native function RequestBR_RecentProductList();

//native function RequestBR_EventRankerList(int iEventID, int iDay, int iRanking); //branch sr : HalloweenEvent
native function RequestBR_MinigameLoadScores(); //branch sr
native function RequestBR_MinigameInsertScore(int iScore); //branch sr

native function ShowCashChargeWebSite();
native function IsUsingPrimeShop();
native function int BR_GetShowEventUI();

// Util
native final function string BR_ConvertTimeToStr(int time, int bOnlyDay);
native final function int BR_GetDayType(int time, int type);
//end of branch !! Edited by Overseas Branch : Enyheid
//////////////////////////////////////////////////////////////////////////////////////////////////
//#endif

native final function string GetFormattedTimeStrMMHH(int hour, int minute);		//CT26P4_0323

// NEW_GOODS_INVENTORY : 상품 인벤토리 - 2010.11.3 winkey
native final function RequestGoodsInventoryItemList();					// 상품 인벤토리 아이템 리스트 받기
native final function RequestGoodsInventoryItemDesc( int index );		// 서랍창 정보 받기
native final function RequestUseGoodsInventoryItem( int index );		// 상품 받기
native final function string GetGoodsIconName( int index );				// 상품아이콘 pathname 얻기
native final function bool IsUseGoodsInvnentory();

// SECONDARY_AUTH : 2차 비밀번호 - 2010.11.6 winkey
native final function RequestSecondaryAuthCreate( string password );
native final function RequestSecondaryAuthVerify( string password );
native final function RequestSecondaryAuthModify( string password, string newPassword );
native final function bool IsUseSecondaryAuth();

native final function GetShortcutString(int shortcutNum, out ShortcutCommandItem commandItem);
defaultproperties
{
}
